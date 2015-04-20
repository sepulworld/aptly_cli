require 'minitest_helper.rb'
require "minitest/autorun"

require "aptly_cli"

describe AptlyCli::AptlyPublish do
 
  it "must include httparty methods" do
    AptlyCli::AptlyPublish.must_include HTTMultiParty
  end

describe "API List Publish" do

  let(:publish_api) { AptlyCli::AptlyPublish.new }

  before do
    VCR.insert_cassette 'publish_api', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  it "records the fixture for listing publish points" do
    publish_api.publish_list()
  end
  
 end

end
