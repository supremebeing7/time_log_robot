require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/reporters'
require 'yaml'
require 'httparty'

Dir[File.expand_path "lib/**/*.rb"].each{|file| require_relative file }

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

