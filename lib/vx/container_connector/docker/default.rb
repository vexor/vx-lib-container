module Vx
  module ContainerConnector

    class Docker

      class Default

        class << self

          def ssh_host
            if testing?
              'localhost'
            else
              nil
            end
          end

          def ssh_port
            if testing?
              2122
            else
              nil
            end
          end

          def create_container_options
            if testing?
              { "ExposedPorts" => { "22/tcp" => {} } }
            else
              {}
            end
          end

          def start_container_options
            if testing?
              { "PortBindings" => { "22/tcp" => [{ "HostPort" => "2022" }] } }
            else
              {}
            end
          end

          def testing?
            ENV['VX_ENV'] == 'test'
          end

        end

      end

    end
  end
end
