require 'vx/lib/shell'

module Vx ; module Lib ; module Container ;

  class Docker

    Spawner = Struct.new(:container, :ssh) do

      include Lib::Shell
      include Lib::Container::Upload

      def exec(script, options = {}, &logger)
        sh(:ssh, ssh).exec upload(script, "~/build.sh", mode: '0755', &logger), options
        sh(:ssh, ssh).exec("~/build.sh", options, &logger)
      end

      def work_dir
        "~/"
      end

      def id
        container.id
      end

      def properties
        container.json
      end

    end
  end

end ; end ; end
