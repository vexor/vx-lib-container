require File.expand_path("../container/version", __FILE__)
require File.expand_path("../container/errors",  __FILE__)

module Vx
  module Lib
    module Container

      autoload :Local,      File.expand_path("../container/local",            __FILE__)
      autoload :Docker,     File.expand_path("../container/docker",           __FILE__)
      autoload :Retriable,  File.expand_path("../container/mixin/retriable",  __FILE__)
      autoload :Instrument, File.expand_path("../container/mixin/instrument", __FILE__)
      autoload :Upload,     File.expand_path("../container/mixin/upload",     __FILE__)

      extend self

      attr_accessor :instrumenter

      def lookup(name, options = {})
        case name.to_sym
        when :docker
          Container::Docker.new options
        when :local
          Container::Local.new options
        else
          raise NotFoundConnector.new("No available connector for #{name.inspect} found")
        end
      end

    end

  end
end
