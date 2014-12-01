require 'tempfile'
require 'fileutils'
require 'logger'

module Vx
  module ContainerConnector

    class Local

      include Instrument

      autoload :Spawner, File.expand_path("../local/spawner", __FILE__)

      def start(&block)
        instrument( "start_container", container_type: 'local' )

        spawner = Spawner.new

        yield spawner
      end

    end

  end
end
