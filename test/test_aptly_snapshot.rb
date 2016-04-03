require 'minitest_helper.rb'
require 'minitest/autorun'

require 'aptly_cli'

describe AptlyCli::AptlySnapshot do
  it 'must include httparty methods' do
    AptlyCli::AptlySnapshot.must_include HTTMultiParty
  end

  describe 'API Delete Snapshot' do
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }
    let(:publish_api) { AptlyCli::AptlyPublish.new }

    def test_snapshot_force_delete
      snapshot_api.snapshot_create(
        'testrepo_snap_to_delete',
        'testrepo',
        'testrepo snapshot to delete')
      assert_includes snapshot_api.snapshot_delete(
        'testrepo_snap_to_delete', force = 1).code.to_s, '200'
    end

    def test_snapshot_non_force_delete_with_published_snapshot
      snapshot_api.snapshot_create(
        'testrepo_snap_to_delete_that_wont', 'testrepo',
        'testrepo snapshot to delete that wont delete')
      publish_api.publish_repo(
        'testrepo_snap_to_delete_that_wont',
        sourcekind: 'snapshot', distribution: 'precise',
        architectures: ['amd64'],
        skip: true)
      assert_includes snapshot_api.snapshot_delete(
        'testrepo_snap_to_delete_that_wont').code.to_s, '409'
    end

    #def test_that_deleting_snapshot_that_is_published_conflicts
      #assert_equal ([{"error" => "unable to drop: snapshot is published","meta" => "Operation aborted"}]).to_s, snapshot_api.snapshot_delete(name = "rocksoftware300").to_s
    #end

    #def test_that_deleting_snapshot_that_doesnt_exist_errors
      #assert_equal ([{"error" => "snapshot with name rocksoftware200 not found","meta" => "Operation aborted"}]).to_s, snapshot_api.snapshot_delete(name = "rocksoftware200").to_s
    #end

    #def test_that_snapshot_delete_returns_200
      #assert_equal ('200'), snapshot_api.snapshot_delete(name = "rocksoftware25").code.to_s
    #end
  end

  describe 'API Create and List Snapshot' do
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }

    def test_snapshot_create
      snapshot_api.snapshot_delete(
        'testrepo_snap', force = 1)
      assert_includes snapshot_api.snapshot_create(
        'testrepo_snap', 
        'testrepo',
        'the best again').to_s,
        '"Name"=>"testrepo_snap", "CreatedAt"=>'
    end

    def test_that_snapshot_list_returns_results
      snapshot_api.snapshot_delete(
        'testrepo_snap', force = 1)
      snapshot_api.snapshot_create(
        'testrepo_snap',
        'testrepo',
        'the best again')
      assert_includes snapshot_api.snapshot_list(
        'name').to_s,
        '"Name"=>"testrepo_snap"'
    end
  end

  describe 'API Update Snapshot' do
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }
#  def test_snapshot_update_name
#    assert_equal ({"Name" => "rocksoftware24_new_name_baby","CreatedAt" => "2015-04-09T15:33:25.381621145Z","Description" => "Checkout my new name"}).to_s, snapshot_api.snapshot_update(name = 'rocksoftware24', name_update = 'rocksoftware24_new_name_baby', description = 'Checkout my new name').to_s
#  end
  
#  def test_failed_snapshot_show_snapshot_doesnt_exist
#    assert_equal ([{"error" => "snapshot with name rocksoftware50_not_here not found","meta" => "Operation aborted"}]).to_s, snapshot_api.snapshot_update(name = "rocksoftware50_not_here", name_update = "rocksoftware50_new_name_baby", description = "I am not a snapshot presently").to_s 
#  end
  
#  def test_failed_snapshot_show_snapshot_returns_404
#    assert_equal ('404'), snapshot_api.snapshot_update(name = "rocksoftware50_not_here", name_update = "rocksoftware50_new_name_baby", description = "I am not a snapshot presently").code.to_s
#  end

  end

  describe 'API Show Snapshot' do
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }
  end

  describe 'API Search Snapshot' do
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }
#  def test_snapshot_search_for_all_with_details
#    assert_includes snapshot_api.snapshot_search(name = "rocksoftware300", search_options = { :format => 'details' }).to_s, "c7e177319723a901e69cfb84ab6082b61acf84e138d4af0f9f497936b60af915".to_s
#  end

#  def test_snapshot_search_for_all_with_no_details
#    assert_equal ("[\"Pi386 xsp 2.11.0.0-git-master-04062013 fb4f20e019c99800\", \"Pamd64 geoipupdate 2.0.0 c7b4081a761741bb\", \"Pamd64 mongodb-mms-monitoring-agent 2.4.0.101-1 fc25ab7d8b9d2158\", \"Pamd64 redis-server 2.8.3 fde8566b85f0a1\", \"Pamd64 voltdb-php-client 1.2 7f4eed5217e92df0\", \"Pi386 geoipupdate 2.0.0 249f3976bd06cce4\", \"Pi386 mongodb-mms-monitoring-agent 2.4.0.101-1 bf58165444e70af6\", \"Pi386 redis-server 2.8.3 324bb47c72149fae\"]").to_s, snapshot_api.snapshot_search(name = "rocksoftware302").to_s
#  end

#  def test_snapshot_search_for_specific_package
#    assert_equal ("[\"Pi386 mongodb-mms-monitoring-agent 2.4.0.101-1 bf58165444e70af6\", \"Pamd64 mongodb-mms-monitoring-agent 2.4.0.101-1 fc25ab7d8b9d2158\"]").to_s, snapshot_api.snapshot_search(name = "rocksoftware302", search_options = { :q => 'mongodb-mms-monitoring-agent' }).to_s
#  end

  end

  describe 'API Diff Snapshot' do
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }
  end
end
