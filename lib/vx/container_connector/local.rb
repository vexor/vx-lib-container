require 'tempfile'
require 'fileutils'
require 'logger'

module Vx
  module ContainerConnector

    class Local

      autoload :Spawner, File.expand_path("../local/spawner", __FILE__)

      attr_reader :work_dir, :logger

      def initialize(options = {})
        @work_dir = options[:work_dir] || default_work_dir
        @work_dir = File.expand_path(@work_dir)
        @logger   = options[:logger] || Logger.new(STDOUT)
      end

      def start(&block)
        FileUtils.rm_rf(work_dir)
        FileUtils.mkdir_p(work_dir)

        spawner = Spawner.new(work_dir)
        logger.info "inside #{work_dir}"
        yield spawner
      end

      private

        def default_work_dir
          "#{Dir.tmpdir}/.local_connector"
        end

    end

  end
end
