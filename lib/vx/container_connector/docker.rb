require 'docker'
require 'logger'
require 'vx/common/spawn'
require 'net/ssh'

module Vx
  module ContainerConnector

    class Docker

      autoload :Spawner, File.expand_path("../docker/spawner", __FILE__)

      include Vx::Common::Spawn
      include ContainerConnector::Retriable

      attr_reader :user, :password, :init, :image, :remote_dir, :logger

      @@default_container_options = {}
      @@default_ssh_port          = 22
      @@host_to_connect_override  = nil

      class << self
        def default_container_options
          @@default_container_options
        end

        def default_ssh_port(val = nil)
          @@default_ssh_port = val if val
          @@default_ssh_port
        end

        def host_to_connect_override(val = nil)
          @@host_to_connect_override = val if val
          @@host_to_connect_override
        end
      end

      def initialize(options = {})
        @user       = options[:user]       || "vexor"
        @password   = options[:password]   || "vexor"
        @init       = options[:init]       || %w{ /sbin/init --startup-event dockerboot }
        @image      = options[:image]      || "dmexe/precise"
        @remote_dir = options[:remote_dir] || "/home/#{user}"
        @logger     = options[:logger]     || ::Logger.new(STDOUT)
      end

      def start(&block)
        start_container do |container|
          open_ssh_session(container, &block)
        end
      end

      def container_options
        self.class.default_container_options.merge(
          'Cmd'       => init,
          'Image'     => image,
        )
      end

      private

        def open_ssh_session(container)
          host = self.class.host_to_connect_override || container.json['NetworkSettings']['IPAddress']

          ssh_options = {
            password:      password,
            port:          self.class.default_ssh_port,
            paranoid:      false,
            forward_agent: false
          }
          logger.info "open ssh session to #{user}@#{host}"
          with_retries ::Net::SSH::AuthenticationFailed, limit: 3, sleep: 3 do
            open_ssh(host, user, ssh_options) do |ssh|
              logger.info "ssh session opened"
              yield Spawner.new(container, ssh, remote_dir)
            end
          end
        end

        def start_container(&block)
          container = ::Docker::Container.create container_options

          with_retries ::Docker::Error::NotFoundError, limit: 3, sleep: 3 do
            container.start
          end

          begin
            logger.info "start container #{container.id}"
            sleep 3
            yield container
          ensure
            container.kill
            logger.info "kill container #{container.id}"
          end
        end


    end
  end
end
