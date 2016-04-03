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
        'testrepo_snap_to_delete', 1).code.to_s, '200'
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

    def test_that_deleting_snapshot_that_doesnt_exist_errors
      assert_equal [{ 'error' => 'snapshot with name rocksoftware200 not found',
                      'meta' => 'Operation aborted' }].to_s,
                   snapshot_api.snapshot_delete('rocksoftware200').to_s
    end

    def test_that_snapshot_delete_returns_200
      snapshot_api.snapshot_create(
        'testrepo_snap_that_will_delete', 'testrepo',
        'this snapshot better delete')
      assert_equal '200', snapshot_api.snapshot_delete(
        'testrepo_snap_that_will_delete').code.to_s
    end
  end

  describe 'API Create and List Snapshot' do
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }

    def test_snapshot_create
      snapshot_api.snapshot_delete(
        'testrepo_snap', 1)
      assert_includes snapshot_api.snapshot_create(
        'testrepo_snap',
        'testrepo',
        'the best again').to_s,
                      '"Name"=>"testrepo_snap", "CreatedAt"=>'
    end

    def test_that_snapshot_list_returns_results
      snapshot_api.snapshot_delete(
        'testrepo_snap', 1)
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

    def test_snapshot_update_name
      snapshot_api.snapshot_delete('testrepo_snap_update_test', 1)
      snapshot_api.snapshot_delete('testrepo_snap_update_test_new_name', 1)
      snapshot_api.snapshot_create('testrepo_snap_update_test',
                                   'testrepo', 'testing snap update')
      assert_includes snapshot_api.snapshot_update(
        'testrepo_snap_update_test',
        'testrepo_snap_update_test_new_name',
        'Checkout my new name').to_s,
                      '"Name"=>"testrepo_snap_update_test_new_name", "CreatedAt"'
    end

    def test_failed_snapshot_show_snapshot_doesnt_exist
      assert_equal [{
        'error' => 'snapshot with name rocksoftware50_not_here not found',
        'meta' => 'Operation aborted' }].to_s,
                   snapshot_api.snapshot_update(
                     'rocksoftware50_not_here',
                     'rocksoftware50_new_name_baby',
                     'I am not a snapshot presently').to_s
    end

    def test_failed_snapshot_show_snapshot_returns_404
      assert_equal '404', snapshot_api.snapshot_update(
        'rocksoftware50_not_here',
        'rocksoftware50_new_name_baby',
        'I am not a snapshot presently').code.to_s
    end
  end

  describe 'API Search Snapshot' do
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }

    def test_snapshot_search_for_all_with_details
      snapshot_api.snapshot_create(
        'testrepo_snap_for_search_test',
        'testrepo',
        'testing snap for search')
      assert_equal '200', snapshot_api.snapshot_search(
        'testrepo_snap_for_search_test',
        format: 'details').code.to_s
    end

    def test_snapshot_search_for_specific_package
      assert_includes snapshot_api.snapshot_search(
        'testrepo_snap_for_search_test',
        q: 'zeitgeist').to_s, '["Pall zeitgeist 0.9.0-1'
    end
  end

  describe 'API Diff Snapshot' do
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }
  end

  describe 'API Show Snapshot' do
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }
  end
end
