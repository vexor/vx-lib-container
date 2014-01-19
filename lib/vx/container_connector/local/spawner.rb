require 'vx/common/spawn'

module Vx
  module ContainerConnector

    class Local
      class Spawner
        include Vx::Common::Spawn

        attr_reader :work_dir

        def initialize(work_dir)
          @work_dir = work_dir
        end

        def spawn(*args, &logger)
          env     = args.first.is_a?(Hash) ? args.shift : {}
          options = args.last.is_a?(Hash)  ? args.pop   : {}
          cmd     = args

          options.merge!(chdir: work_dir)

          super(env, cmd, options, &logger)
        end

        def id
          'local'
        end

      end
    end
  end
end
