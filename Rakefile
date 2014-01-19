require 'rubygems'
require 'bundler'
Bundler.require
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "run travis build"
task :travis do
  exec "bundle exec rake SPEC_OPTS='--format documentation -t ~docker --order=rand'"
end
