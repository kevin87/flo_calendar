# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "flo_calendar/version"

Gem::Specification.new do |s|
  s.name        = "flo_calendar"
  s.version     = FloCalendar::VERSION
  s.authors     = ["Kevin"]
  s.email       = ["kevin@flochip.com"]
  s.summary     = %q{A simple 12 months view Rails 3 calendar}
  s.description = %q{A simple 12 months view Rails 3 calendar}

  s.rubyforge_project = "flo_calendar"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('rails', '>= 3.0')
end
