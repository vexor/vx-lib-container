require 'docker'
require 'excon'

module Vx
  module ContainerConnector

    class Docker

      autoload :Spawner, File.expand_path("../docker/spawner", __FILE__)

      include ContainerConnector::Retriable
      include Instrument

      attr_reader :user, :init, :image, :chdir, :memory, :memory_swap

      def initialize(options = {})
        @user        = options[:user]        || "root"
        @init        = options[:init]        || "/sbin/init"
        @image       = options[:image]       || "ubuntu"
        @chdir       = options[:chdir]       || '/'
        @memory      = options[:memory].to_i
        @memory_swap = options[:memory_swap].to_i
      end

      def start
        start_container do |container|
          yield Spawner.new(container, user: user, chdir: chdir)
        end
      end

      def create_container_options
        {
          'Cmd'         => init,
          'Image'       => image,
          'Memory'      => memory,
          'MemorySwap'  => memory_swap,
        }
      end

      def start_container_options
        {}
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
              container.remove
            end
          end
        end

    end
  end
end
