module Vx
  module ContainerConnector

    class Docker

      class Spawner
        attr_reader :container, :ssh, :work_dir

        def initialize(container, ssh, work_dir)
          @container  = container
          @ssh        = ssh
          @work_dir   = work_dir
        end

        def spawn(*args, &logger)
          env     = args.first.is_a?(Hash) ? args.shift : {}
          options = args.last.is_a?(Hash)  ? args.pop   : {}
          cmd     = args

          options.merge!(chdir: work_dir, pty: true)

          ssh.spawn(env, cmd, options, &logger)
        end

        def id
          container.id
        end

      end
    end
  end
end
