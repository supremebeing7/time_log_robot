require 'bundler/gem_tasks'

desc 'Run in IRB for debugging'
task :console do
  require 'irb'
  require 'irb/completion'
  require 'time_log_robot'
  ARGV.clear
  IRB.start
end

# @TODO Uncomment when it works! - `rake test`
# require 'rake/testtask'
#
# Rake::TestTask.new do |t|
#   t.libs << 'test'
#   t.test_files = FileList['test/**/*_test.rb']
# end