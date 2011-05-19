require "admit_one/version"

Gem::Specification.new do |s|
  s.name        = "admit_one"
  s.version     = AdmitOne::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jonathan S. Garvin"]
  s.email       = ["jon@5valleys.com"]
  s.homepage    = "https://github.com/jsgarvin/admit_one"
  s.summary     = %q{Lock file manager.}
  s.description = %q{Lock file manager that is immune to race conditions.}

  s.rubyforge_project = "admit_one"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]
end