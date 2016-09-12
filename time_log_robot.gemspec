# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'time_log_robot/version'

Gem::Specification.new do |spec|
  spec.name          = 'time_log_robot'
  spec.version       = TimeLogRobot::VERSION
  spec.authors       = ['Mark J. Lehman']
  spec.email         = ['markopolo@gmail.com']
  spec.description   = %q{Automate time logging from tools like Toggl to project management software such as JIRA}
  spec.summary       = %q{Automate work time logging}
  spec.homepage      = 'https://github.com/supremebeing7/time_log_robot'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.5'
  spec.add_development_dependency 'minitest', '~> 5.8'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.5'

  spec.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.6'
  spec.add_runtime_dependency 'commander', '~> 4.1', '>= 4.1.6'
  spec.add_runtime_dependency 'httparty', '~> 0.13', '>= 0.13.0'
  spec.add_runtime_dependency 'json', '1.8.1'
end
