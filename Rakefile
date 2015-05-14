begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
Bundler::GemHelper.install_tasks

require 'rake'

require 'rake'
APP_RAKEFILE = File.expand_path("../spec/test_app/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'
require "rspec/core/rake_task"

task :default => :spec

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'DoorkeeperSsoClient'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
