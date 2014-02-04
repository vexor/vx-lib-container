require 'tempfile'
require 'fileutils'
require 'logger'

module Vx
  module ContainerConnector

    class Local

      include Instrument

      autoload :Spawner, File.expand_path("../local/spawner", __FILE__)

      attr_reader :work_dir

      def initialize(options = {})
        @work_dir = options[:work_dir] || default_work_dir
        @work_dir = File.expand_path(@work_dir)
      end

      def start(&block)
        instrument( "start_container", container_type: 'local', container: { work_dir: work_dir }) do
          FileUtils.rm_rf(work_dir)
          FileUtils.mkdir_p(work_dir)
        end

        spawner = Spawner.new(work_dir)

        yield spawner
      end

      private

        def default_work_dir
          "#{Dir.tmpdir}/.vx_local_connector"
        end

    end

  end
end
