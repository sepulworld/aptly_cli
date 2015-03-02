require 'minitest_helper.rb'
require "minitest/autorun"

require "aptly_cli"

describe AptlyCli::AptlyFile do
 
  it "must work" do
   "Yay!".must_be_instance_of String
  end

  it "must include httparty methods" do
    AptlyCli::AptlyFile.must_include HTTParty
  end

  it "must have a server API URL endpoint defined" do
    #TODO
    #AptlyCli::AptlyFile.base_uri.must
  end
end
