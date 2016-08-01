require 'docker'
require 'excon'
require 'timeout'
require 'net/ssh'
require 'vx/lib/shell'

module Vx
  module Lib
    module Container

      class Docker

        autoload :Spawner, File.expand_path("../docker/spawner", __FILE__)

        include Lib::Shell
        include Lib::Container::Retriable

        attr_reader :user, :password, :init, :image, :remote_dir,
                    :memory, :memory_swap,
                    :cpu_percent, :shm_size

        def initialize(options = {})
          @user           = options[:user]        || "vexor"
          @password       = options[:password]    || "vexor"
          @init           = options[:init]        || %w{ /sbin/my_init }
          @image          = options[:image]       || "quay.io/dmexe/trusty:2.0.18.3"
          @cpu_percent    = options[:cpu_percent] || 90
          @shm_size       = options[:shm_size]    || 268435456
          @memory         = options[:memory].to_i
          @memory_swap    = options[:memory_swap].to_i
          @container_opts = options[:container_opts] || {}
        end

        def start(&block)
          start_container do |container|
            open_ssh_session(container, &block)
          end
        end

        def create_container_options
          @create_container_options ||= {
            'Image'      => image,
            'CpuPercent' => cpu_percent,
            'ShmSize'    => shm_size,
            # 'Memory'     => memory,
            # 'MemorySwap' => memory_swap,
            'Cmd'        => init,
          }
        end

        def image?(image_name = image)
          full_image_name(image_name).tap do |name|
            ::Docker::Image.all.each do |image|
              return true if image.info["RepoTags"].include?(name)
            end
            return false
          end
        end

        private

          def full_image_name(name)
            name.split(/\:/).tap do |parts|
              parts[1] ||= "latest"
            end.join(':')
          end

          def open_ssh_session(container)
            host = container.json['NetworkSettings']['IPAddress']

            ssh_options = {
              password:      password,
              port:          22,
              paranoid:      false,
              forward_agent: false,
              timeout:       3,
            }

            ssh = with_retries ::Net::SSH::AuthenticationFailed, ::Errno::ECONNREFUSED, ::Errno::ETIMEDOUT, ::Timeout::Error, limit: 5, sleep: 3 do
              ::Net::SSH.start host, user, ssh_options
            end

            re = yield Spawner.new(container, ssh)
            ssh.shutdown!
            re
          end

          def start_container(&block)
            container =
              with_retries ::Excon::Errors::SocketError, ::Docker::Error::TimeoutError, limit: 5, sleep: 3 do
              byebug
                ::Docker::Container.create create_container_options.merge(@container_opts)
              end

            container.start

            begin
              yield container
            ensure
              container.kill
              container.remove
            end
          end

      end
    end
  end
end
