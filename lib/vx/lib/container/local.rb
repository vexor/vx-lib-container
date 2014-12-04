require 'tempfile'
require 'fileutils'

module Vx
  module Lib
    module Container

      class Local

        include Instrument

        autoload :Spawner, File.expand_path("../local/spawner", __FILE__)

        attr_reader :work_dir

        def initialize(options = {})
          @work_dir = options[:work_dir] || default_work_dir
          @work_dir = File.expand_path(@work_dir)
        end

        def start(&block)
          instrument( "create", container_type: 'local', container: { work_dir: work_dir }) do
            FileUtils.rm_rf(work_dir)
            FileUtils.mkdir_p(work_dir)
          end

          begin
            spawner = Spawner.new(work_dir)
            yield spawner
          ensure
            instrument( "kill", container_type: 'local', container: { work_dir: work_dir }) do
              FileUtils.mkdir_p(work_dir)
            end
          end
        end

        private

          def default_work_dir
            "#{::Dir.tmpdir}/vx_lib_container_#{::Process.pid}"
          end

      end

    end

  end
end
