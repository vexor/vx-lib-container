Bundler.require(:test)

ENV['VX_ENV']     = 'test'
ENV['DOCKER_URL'] = "tcp://localhost:4243"

require File.expand_path '../../lib/vx/container_connector', __FILE__
require 'rspec/autorun'

Dir[File.expand_path("../..", __FILE__) + "/spec/support/**/*.rb"].each {|f| require f}


RSpec.configure do |config|
  config.mock_with :rr
end
