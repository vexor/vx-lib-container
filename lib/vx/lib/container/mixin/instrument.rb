module Vx
  module Lib
    module Container
      module Instrument

        def instrument(name, payload, &block)
          name = "#{name}.container.lib.vx"

          if ENV['DEBUG']
            $stdout.puts " --> #{name}: #{payload}"
          end

          if inst = Container.instrumenter
            inst.instrument(name, payload, &block)
          else
            yield if block_given?
          end
        end
      end

    end
  end
end
