require 'vx/lib/spawn'

module Vx
  module ContainerConnector

    class Local
      class Spawner
        include Vx::Lib::Spawn

        def spawn(command, options = {})
          options = options.merge!(pty: true)
          super(command, options) { |re| yield re }
        end

        def id
          'local'
        end

      end
    end
  end
end
