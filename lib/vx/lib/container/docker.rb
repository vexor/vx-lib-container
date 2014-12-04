require 'docker'
require 'excon'
require 'net/ssh'
require 'vx/lib/shell'

module Vx
  module Lib
    module Container

      class Docker

        autoload :Spawner, File.expand_path("../docker/spawner", __FILE__)

        include Lib::Shell
        include Lib::Container::Retriable
        include Lib::Container::Instrument

        attr_reader :user, :password, :init, :image, :remote_dir, :memory, :memory_swap

        def initialize(options = {})
          @user        = options[:user]        || "vexor"
          @password    = options[:password]    || "vexor"
          @init        = options[:init]        || %w{ /sbin/my_init }
          @image       = options[:image]       || "ubuntu"
          @memory      = options[:memory].to_i
          @memory_swap = options[:memory_swap].to_i
        end

        def start(&block)
          start_container do |container|
            open_ssh_session(container, &block)
          end
        end

        def create_container_options
          @create_container_options ||= {
            'Cmd'        => init,
            'Image'      => image,
            'Memory'     => memory,
            'MemorySwap' => memory_swap
          }
        end

        private

          def open_ssh_session(container)
            host = container.json['NetworkSettings']['IPAddress']

            ssh_options = {
              password:      password,
              port:          22,
              paranoid:      false,
              forward_agent: false
            }

            instrumentation = {
              container_type: "docker",
              container:      container.json,
              ssh_options:    ssh_options.merge(host: host, user: user)
            }

            with_retries ::Net::SSH::AuthenticationFailed, Errno::ECONNREFUSED, Errno::ETIMEDOUT, limit: 20, sleep: 1 do
              ssh = instrument("start_ssh_session", instrumentation) do
                ::Net::SSH.start host, user, ssh_options
              end
              yield Spawner.new(container, ssh)
            end
          end

          def start_container(&block)
            container = instrument("create", container_type: "docker", container_options: create_container_options) do
              ::Docker::Container.create create_container_options
            end

            instrumentation = {
              container_type:    "docker",
              container:         container.json,
              container_options: start_container_options,
            }

            instrument("start", instrumentation) do
              container.start start_container_options
            end

            begin
              yield container
            ensure
              instrument("kill", instrumentation) do
                container.kill
                container.remove
              end
            end
          end

      end
    end
  end
end
