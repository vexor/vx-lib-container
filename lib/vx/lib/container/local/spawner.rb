require 'vx/lib/shell'
require 'stringio'

module Vx
  module Lib
    module Container

      class Local
        Spawner = Struct.new(:work_dir) do
          include Lib::Shell
          include Lib::Container::Upload

          def exec(script, options = {}, &logger)
            Dir.chdir work_dir do
              sh.exec upload(script, "~/build.sh", mode: '0755'), options.merge(home: work_dir)
              sh.exec("~/build.sh", options.merge(home: work_dir), &logger)
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
