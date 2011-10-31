# -*- encoding : utf-8 -*-
require 'sanitize'
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
      content.squeeze!(" ").strip!

      raw_matches = content.scan(%r{<td headers="\w+" height="34" valign="top" class="main" style="background:url\(images/table_gray\.gif\); padding:5px 10px;">(.*?)>Mailing Industry Information</a>}mi)

      raw_matches.inject({}) do |results, raw_match|
        if raw_match[0] =~ /mailingIndustryPopup2\(([^\)]*)/i
          @r_county = $1.split(',')[1].gsub(/'/, '')
        end

        @r_address, city_state_zipcode = Sanitize.clean(raw_match[0],
                                                     :remove_contents => true,
                                                     :elements => %w[br]
                                      ).strip.split('<br>')
        if city_state_zipcode.sub_nonascii(' ').squeeze!(' ') =~ /^(.*)\s+(\w\w)\s(\d{5})(-\d{4})?/i
          @r_city, @r_state, @r_zipcode = $1, $2, $3
        end

        results = {:address => @r_address, :city => @r_city, :state => @r_state, :county => @r_county, :zipcode => @r_zipcode}
        if cache
          cache[redis_key(@address)] = "#{@r_address}::#{@r_city}::#{@r_state}::#{@r_county}::#{@r_zipcode}"
        end
        results
      end
    end

    private

    def get_std_address_content
      search_form = @mechanize.get('http://zip4.usps.com/zip4/').forms.first

      search_form.address2 = @address
      search_form.city = @city
      search_form.state = @state

      @mechanize.submit(search_form, search_form.buttons.first)

      return false unless @mechanize.page.search('p.mainRed').empty?
      @mechanize.page.body
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

String.class_eval do
  def sub_nonascii(replacement)
    chars = self.split("")
    self.slice!(0..self.size)
    chars.each do |char|
      if char.ord < 33 || char.ord > 127
        self.concat(replacement)
      else
        self.concat(char)
      end
    end
  self.to_s
  end
end

