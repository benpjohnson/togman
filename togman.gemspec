# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "togman"
  s.version     = 0.4
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Benjamin Johnson"]
  s.email       = ["ben@benpjohnson.com"]
  s.homepage    = "http://benpjohnson.com"
  s.summary     = "Transfer time from Toggl to Mantis"
  s.description = ""

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency('patron', '>= 0.4.16')
  s.add_dependency('json', '>= 1.6.1')
  s.add_dependency('savon', '>= 0.9.7')
  s.add_dependency('highline', '>= 1.6.2')

  s.files        = Dir.glob("{bin,lib}/**/*")
  s.executables  = 'togman'
  s.default_executable = 'bin/togman'
  s.require_path = 'lib'
end
