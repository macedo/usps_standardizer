# -*- encoding : utf-8 -*-
require 'mechanize'

module USPSStandardizer

  #TODO: Change from 'mechanize' to 'net/hhtp'
  #TODO: Implement 'timeout'

  class ZipLookup

    attr_accessor :address, :state, :city, :zipcode

    def initialize(options = {}, mechanize = Mechanize.new)
      @address, @state, @city, @zipcode, @county = '', '', '', '', ''
      @mechanize = mechanize
      options.each do |name, value|
        send("#{name}=", value)
      end
    end

    def std_address

      if(cache and response = cache[redis_key(@address)])
        address, city, state, county, zipcode = response.split('::')
        return {:address => address, :city => city, :state => state, :county => county, :zipcode => zipcode}
      end

      return {} unless (content = get_std_address_content)

      content.gsub!(/\t|\n|\r/, '')

      content.scan %r{<span class=\"address1 range\">([^<]*)}
      @r_address = $1.gsub(/^ | $/, '')

      content.scan %r{<span class=\"city range\">([^<]*)}
      @r_city = $1.gsub(/^ | $/, '')

      content.scan %r{<span class=\"state range\">([^<]*)}
      @r_state = $1.gsub(/^ | $/, '')

      content.scan %r{<span class=\"zip\" style=\"\">([^<]*)}
      @r_zipcode = $1.gsub(/^ | $/, '')

      content.scan %r{<dt>County</dt><dd>([^<]*)}
      @r_county = ($1.empty?) ? '' : $1.gsub(/^ | $/, '')


      results = {:address => @r_address, :city => @r_city, :state => @r_state, :county => @r_county, :zipcode => @r_zipcode}
      if cache
        cache[redis_key(@address)] = "#{@r_address}::#{@r_city}::#{@r_state}::#{@r_county}::#{@r_zipcode}"
      end
      results
    end

    private

    def get_std_address_content
      url = "https://tools.usps.com/go/ZipLookupResultsAction!input.action?resultMode=0&companyName=&address1=#{@address}&address2=&city=#{@city}&state=#{@state}&urbanCode=&postalCode=&zip=#{@zipcode}"
      @mechanize.get url

      return false unless @mechanize.page.search('div#error-box').empty?
      return false unless @mechanize.page.search('div#result-list ul li').count == 1
      @mechanize.page.search('div#result-list ul li:first').to_html
    end

    def cache
      USPSStandardizer.cache
    end

    private
    def redis_key(address)
      address.downcase.gsub(' ', '_')
    end
  end
end