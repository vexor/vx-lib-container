module Vx
  module ContainerConnector
    module Instrument

      def instrument(name, payload, &block)
        name = "#{name}.container_connector.vx"

        if ENV['VX_CONTAINER_CONNECTOR_DEBUG']
          $stdout.puts " --> #{name}: #{payload}"
        end

        if inst = ContainerConnector.instrumenter
          inst.instrument(name, payload, &block)
        else
          yield if block_given?
        end
      end

    end
  end
end
