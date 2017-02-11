require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rdoc/task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Rake::RDocTask.new do |rd|
 rd.rdoc_files.include("lib/**/*.rb")
 rd.rdoc_dir = "rdoc"
end
