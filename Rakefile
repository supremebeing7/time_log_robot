require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'documentation']
end

desc 'Run in IRB for debugging'
task :console do
  require 'irb'
  require 'irb/completion'
  require 'log_my_time'
  ARGV.clear
  IRB.start
end
