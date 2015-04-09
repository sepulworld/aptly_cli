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
    snapshot_api.snapshot_list(sort = "name")
  end
  
  it "records the fixture for creating snapshots" do
    snapshot_api.snapshot_create(name = "rocksoftware23_snap", repo = "rocksoftware", description = "the best again")
  end

  it "records the fixture for creating snapshots from references" do
    snapshot_api.snapshot_create_ref(name = "rocksoftware23_snap_refs", descrption = "snapshot with reference", sourcesnapshots = ["rocksoftware22_snap"])
  end

  it "records the fixture for updating a snapshot with a new name and description" do
    snapshot_api.snapshot_update(name = "rocksoftware24", name_update = "rocksoftware24_new_name_baby", description = "Checkout my new name")
  end

  it "records the fixture for updating a snapshot that doesn't exist" do
    snapshot_api.snapshot_update(name = "rocksoftware50_not_here", name_update = "rocksoftware50_new_name_baby", description = "I am not a snapshot presently")
  end

  def test_that_snapshot_list_returns_results
    assert_equal ([{"Name"=>"rocksoftware22_snap", "CreatedAt"=>"2015-03-31T16:10:46.792655706Z", "Description"=>"Snapshot from local repo [rocksoftware22]"}]).to_s, snapshot_api.snapshot_list(sort = 'name').to_s
  end

  def test_snapshot_creation
  end

 end

end
