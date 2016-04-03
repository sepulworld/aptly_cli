require 'minitest_helper.rb'
require "minitest/autorun"

require "aptly_cli"

describe AptlyCli::AptlyPackage do
 
  it "must include httparty methods" do
    AptlyCli::AptlyPackage.must_include HTTMultiParty
  end

describe "API List Package" do

  let(:package_api) { AptlyCli::AptlyPackage.new }

 end

end
