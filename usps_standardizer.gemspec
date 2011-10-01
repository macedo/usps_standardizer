# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "usps_standardizer/version"

Gem::Specification.new do |s|
  s.name        = "usps_standardizer"
  s.version     = UspsStandardizer::VERSION::STRING
  s.authors     = ["Rafael Macedo"]
  s.email       = ["macedo.rafaelfernandes@gmail.com"]
  s.homepage    = "http://github.com/rafaelmacedo/usps_standardizer"
  s.summary     = %q{TODO: Write a gem summary}
  s.description = s.summary


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end

