# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "usps_standardizer/version"

Gem::Specification.new do |s|
  s.name        = "usps_standardizer"
  s.version     = USPSStandardizer::Version::STRING
  s.authors     = ["Rafael Macedo"]
  s.email       = ["macedo.rafaelfernandes@gmail.com"]
  s.homepage    = "http://github.com/rafaelmacedo/usps_standardizer"
  s.summary     = "Ruby class to standardize U.S. postal addresses by referencing the U.S. Postal Service's web site"
  s.description = s.summary


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "mechanize", "~> 2.0.1"
  s.add_dependency "sanitize", "~> 2.0.3"
  s.add_development_dependency "rspec", "~> 2.6.0"
end

