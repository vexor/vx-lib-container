require 'docker'
require 'excon'
require 'vx/common/spawn'
require 'net/ssh'

module Vx
  module ContainerConnector

    class Docker

      autoload :Spawner, File.expand_path("../docker/spawner", __FILE__)
      autoload :Default, File.expand_path("../docker/default", __FILE__)

      include Vx::Common::Spawn
      include ContainerConnector::Retriable
      include Instrument

      attr_reader :user, :password, :init, :image, :remote_dir

      def initialize(options = {})
        @user       = options[:user]       || "vexor"
        @password   = options[:password]   || "vexor"
        @init       = options[:init]       || %w{ /sbin/my_init }
        @image      = options[:image]      || "dmexe/vexor-trusty-full"
        @remote_dir = options[:remote_dir] || "/home/#{user}"
      end

      def start(&block)
        start_container do |container|
          open_ssh_session(container, &block)
        end
      end

      def create_container_options
        Default.create_container_options.merge(
          'Cmd'   => init,
          'Image' => image,
        )
      end

      def start_container_options
        Default.start_container_options
      end

      private

        def open_ssh_session(container)
          host = Default.ssh_host || container.json['NetworkSettings']['IPAddress']

          ssh_options = {
            password:      password,
            port:          Default.ssh_port,
            paranoid:      false,
            forward_agent: false
          }

          instrumentation = {
            container_type: "docker",
            container:      container.json,
            ssh_host:       host
          }

          with_retries ::Net::SSH::AuthenticationFailed, Errno::ECONNREFUSED, Errno::ETIMEDOUT, limit: 20, sleep: 1 do
            instrument("starting_ssh_session", instrumentation)
            open_ssh(host, user, ssh_options) do |ssh|
              yield Spawner.new(container, ssh, remote_dir)
            end
          end
        end

        def start_container(&block)
          container = instrument("create_container", container_type: "docker", container_options: create_container_options) do
            ::Docker::Container.create create_container_options
          end

          instrumentation = {
            container_type:    "docker",
            container:         container.json,
            container_options: start_container_options,
          }

          instrument("start_container", instrumentation) do
            container.start start_container_options
          end

          begin
            yield container
          ensure
            instrument("kill_container", instrumentation) do
              container.kill
            end
          end
        end

    end
  end
end
