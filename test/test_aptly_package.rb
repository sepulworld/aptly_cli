require 'minitest_helper.rb'
require "minitest/autorun"

require "aptly_cli"

describe AptlyCli::AptlyPackage do
 
  it "must include httparty methods" do
    AptlyCli::AptlyPackage.must_include HTTMultiParty
  end

describe "API List Package" do

  let(:package_api) { AptlyCli::AptlyPackage.new }

  before do
    VCR.insert_cassette 'package_api', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  it "records the fixture for showing packages" do
    package_api.package_show(package_key = "Pi386%20mongodb-mms-monitoring-agent%202.4.0.101-1%20bf58165444e70af6")
  end

 end

end
