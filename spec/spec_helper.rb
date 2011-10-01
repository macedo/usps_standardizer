ENV["BUNDLE_GEMFILE"] = File.dirname(__FILE__) + "/../Gemfile"


require "bundler/setup"
Bundler.setup

require "usps_standardizer"

