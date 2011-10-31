# -*- encoding : utf-8 -*-
require 'mechanize'

#TODO: Improve documentation
module USPSStandardizer
  autoload :Version, "usps_standardizer/version"
  autoload :ZipLookup, "usps_standardizer/zip_lookup"
  autoload :Configuration, "usps_standardizer/configuration"
  autoload :Cache, "usps_standardizer/cache"

  class << self

    def lookup_for(options, mechanize = Mechanize.new)
      z = ZipLookup.new(options, mechanize)
      z.std_address
    end

    def cache
      if @cache.nil? and store = Configuration.cache
        @cache = Cache.new(store, Configuration.cache_prefix)
      end
      @cache
    end

  end

end

