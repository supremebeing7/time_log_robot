require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/emoji'
require 'minitest/reporters'
require 'yaml'
require 'active_support'
# require 'pry-rescue/minitest'
require 'httparty'

Dir[File.expand_path "lib/**/*.rb"].each{|file| require_relative file }

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

