require "spec_helper"

describe UspsStandardizer do
  it "has a version" do
    UspsStandardizer::Version::STRING.should match(/^\d+\.\d+\.\d+$/)
  end
end

