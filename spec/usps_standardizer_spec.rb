require "spec_helper"

describe USPSStandardizer do

  it "has a version" do
    USPSStandardizer::Version::STRING.should match(/^\d+\.\d+\.\d+$/)
  end

  describe "configuration" do
    context "cache" do
      it " should be nil as default" do
        USPSStandardizer::Configuration.cache.should == nil
      end
    end
    context "cache prefix" do
      it "should be usps: as default" do
        USPSStandardizer::Configuration.cache_prefix.should == 'usps:'
      end
    end
    context "timeout" do
      it "should be 5 seconds as default" do
        USPSStandardizer::Configuration.timeout.should == 5
      end
    end
  end

  it "standards an address on usps website" do
    result = USPSStandardizer.lookup_for(:address => '6216 eddington drive', :state => 'oh', :city => 'middletown', :zipcode => '45044')
    result[:address].should == '6216 EDDINGTON ST'
    result[:state].should == 'OH'
    result[:city].should == 'LIBERTY TOWNSHIP'
  end

end

