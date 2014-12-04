require 'vx/lib/shell'
require 'stringio'

module Vx
  module Lib
    module Container

      class Local
        Spawner = Struct.new(:work_dir) do
          include Vx::Lib::Shell

          def exec(stdin, &logger)
            Dir.chdir work_dir do
              sh.exec(stdin: StringIO.new(stdin), &logger)
            end
          end

          def id
            work_dir
          end

        end
      end
    end
  end
end
