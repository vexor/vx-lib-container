require 'vx/lib/shell'

module Vx
  module Lib
    module Container

      class Docker

        Spawner = Struct.new(:container, :ssh) do
          include Vx::Lib::Shell

          def exec(stdin, &logger)
            sh(:ssh, ssh).exec(stdin: StringIO.new(stdin), &logger)
          end

          def id
            container.id
          end

        end
      end
    end
  end
end
