require File.expand_path('../lib/admit_one/version',  __FILE__)

Gem::Specification.new do |s|
  s.name        = "admit_one"
  s.version     = AdmitOne::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jonathan S. Garvin"]
  s.email       = ["jon@5valleys.com"]
  s.homepage    = "https://github.com/jsgarvin/admit_one"
  s.summary     = %q{Race resistant lock file manager.}
  s.description = %q{Ruby lock file manager that is highly resistant, if not outright immune, to race conditions.}

  s.rubyforge_project = "admit_one"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]
end
