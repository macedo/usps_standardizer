require "spec_helper"

describe USPSStandardizer do

  it "has a version" do
    USPSStandardizer::Version::STRING.should match(/^\d+\.\d+\.\d+$/)
  end

  it "standards an address on usps website" do
    result = USPSStandardizer.lookup_for(:address => '6216 eddington drive', :state => 'oh', :city => 'middletown')
    result[:address].should == '6216 EDDINGTON ST'
    result[:state].should == 'OH'
    result[:city].should == 'LIBERTY TOWNSHIP'
  end

end

