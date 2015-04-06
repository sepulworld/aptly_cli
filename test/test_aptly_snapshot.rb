require 'minitest_helper.rb'
require "minitest/autorun"

require "aptly_cli"

describe AptlyCli::AptlySnapshot do
 
  it "must include httparty methods" do
    AptlyCli::AptlySnapshot.must_include HTTMultiParty
  end

describe "API List Snapshot" do

  let(:snapshot_api) { AptlyCli::AptlySnapshot.new }

  before do
    VCR.insert_cassette 'snapshot_api', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  it "records the fixture for listing snapshots" do
    snapshot_api.snapshot_list(sort = 'name')
  end

  def test_that_snapshot_list_returns_results
    assert_equal ([{"Name"=>"rocksoftware22_snap", "CreatedAt"=>"2015-03-31T16:10:46.792655706Z", "Description"=>"Snapshot from local repo [rocksoftware22]"}]).to_s, snapshot_api.snapshot_list(sort = 'name').to_s
  end
  
 end

end
