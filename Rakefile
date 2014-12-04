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

namespace :remote do
  desc "run box"
  task :up do
    exec "vagrant up --provider=rackspace"
  end

  desc "destroy box"
  task :down do
    exec "vagrant destroy -f"
  end

  desc "run spec on rackspace box"
  task :spec do
    1
  end
end

