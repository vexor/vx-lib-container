require File.expand_path("../container_connector/version", __FILE__)
require File.expand_path("../container_connector/errors",  __FILE__)

module Vx
  module ContainerConnector

    autoload :Local,      File.expand_path("../container_connector/local",            __FILE__)
    autoload :Docker,     File.expand_path("../container_connector/docker",           __FILE__)
    autoload :Retriable,  File.expand_path("../container_connector/mixin/retriable",  __FILE__)
    autoload :Instrument, File.expand_path("../container_connector/mixin/instrument", __FILE__)

    extend self

    attr_accessor :instrumenter

    def lookup(name, options = {})
      case name.to_sym
      when :docker
        Docker.new options
      when :local
        Local.new options
      else
        raise NotFoundConnector.new("No available connector for #{name.inspect} found")
      end
    end

  end
end
