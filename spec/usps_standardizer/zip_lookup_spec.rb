require "spec_helper"

describe USPSStandardizer::ZipLookup do
  let(:content) { File.read(File.dirname(__FILE__) + "/../fixtures/content.html") }

  describe "std_address" do
    it "return {} if invalid address" do
      subject.stub(:get_std_address_content).and_return(false)
      subject.std_address.should be_empty
    end
    it "return a standardized address" do
      subject.stub(:get_std_address_content).and_return(content)
      a = subject.std_address
      a.should be_instance_of(Hash)
      a.should_not be_empty
    end
  end
end

