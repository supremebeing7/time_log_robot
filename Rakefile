require 'rake/testtask'
require 'bundler/gem_tasks'

desc 'Run in IRB for debugging'
task :console do
  require 'irb'
  require 'irb/completion'
  require 'pp'
  require 'yaml'
  require 'active_support'
  require 'httparty'
  Dir[File.expand_path "lib/**/*.rb"].each{|file| require_relative file }
  ARGV.clear
  IRB.start
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
end