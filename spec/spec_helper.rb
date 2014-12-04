Bundler.require(:test)

#ENV['VX_ENV']     = 'test'
#ENV['DOCKER_URL'] = "tcp://localhost:2375"

require File.expand_path '../../lib/vx/lib/container', __FILE__
require 'rspec/autorun'

Dir[File.expand_path("../..", __FILE__) + "/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
end
