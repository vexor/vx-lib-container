require File.expand_path '../../lib/vx/container_connector', __FILE__

Bundler.require(:test)
require 'rspec/autorun'

Dir[File.expand_path("../..", __FILE__) + "/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rr

  config.before(:suite) do
=begin
    Vx::ContainerConnector::Docker.default_container_options.merge!(
      'PortSpecs' => ['2022:22']
    )
    Vx::ContainerConnector::Docker.default_ssh_port 2223
    Vx::ContainerConnector::Docker.host_to_connect_override 'localhost'
=end
  end
end
