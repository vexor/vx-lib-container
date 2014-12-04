require 'vx/lib/shell'

module Vx ; module Lib ; module Container ;

  class Docker

    Spawner = Struct.new(:container, :ssh) do

      include Lib::Shell
      include Lib::Container::Upload

      def exec(script, &logger)
        sh(:ssh, ssh).exec upload(script, "~/build.sh", mode: '0755', &logger)
        sh(:ssh, ssh).exec("~/build.sh", &logger)
      end

      def id
        container.id
      end

    end
  end

end ; end ; end
