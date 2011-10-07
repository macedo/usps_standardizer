# -*- encoding : utf-8 -*-
require 'mechanize'
module USPSStandardizer
  autoload :Version, "usps_standardizer/version"
  autoload :ZipLookup, "usps_standardizer/zip_lookup"

  def self.lookup_for(options, mechanize = Mechanize.new)
    z = USPSStandardizer::ZipLookup.new(options, mechanize)
    z.std_address
  end

end

