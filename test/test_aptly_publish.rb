require 'minitest_helper.rb'
require 'minitest/autorun'

require 'aptly_cli'

describe AptlyCli::AptlyPublish do
  it 'must include httparty methods' do
    AptlyCli::AptlyPublish.must_include HTTMultiParty
  end

  describe 'API List Publish' do
    let(:publish_api) { AptlyCli::AptlyPublish.new }
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }

    def test_publish_list
      publish_api.publish_drop(distribution: 'publishlisttest1', force: 1)
      publish_api.publish_drop(distribution: 'publishlisttest2', force: 1)
      snapshot_api.snapshot_delete('testrepo_snap_to_list_pub_1', 1)
      snapshot_api.snapshot_create('testrepo_snap_to_list_pub_1', 'testrepo',
                                   'testrepo snapshot to create and drop publish 1')
      snapshot_api.snapshot_delete('testrepo_snap_to_list_pub_2', 1)
      snapshot_api.snapshot_create('testrepo_snap_to_list_pub_2', 'testrepo',
                                   'testrepo snapshot to create and drop publish 2')
      publish_api.publish_repo(
        ['main/testrepo_snap_to_list_pub_1'],
        sourcekind: 'snapshot', distribution: 'publishlisttest1',
        architectures: %w(amd64 i386),
        skip: true)
      publish_api.publish_repo(
        ['main/testrepo_snap_to_list_pub_2'],
        sourcekind: 'snapshot', distribution: 'publishlisttest2',
        architectures: %w(amd64 i386),
        skip: true)
      assert_includes publish_api.publish_list.to_s,
                      '"Distribution"=>"publishlisttest1"'
      assert_includes publish_api.publish_list.to_s,
                      '"Distribution"=>"publishlisttest2"'
    end
  end

  describe 'API Drop Publish' do
    let(:publish_api) { AptlyCli::AptlyPublish.new }
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }

    def test_publish_drop
      publish_api.publish_drop(distribution: 'precisetestdrop', force: 1)
      snapshot_api.snapshot_delete('testrepo_snap_to_drop_pub_1', 1)
      snapshot_api.snapshot_create('testrepo_snap_to_drop_pub_1', 'testrepo',
                                   'testrepo snapshot to create and drop publish')
      publish_api.publish_repo(
        ['main/testrepo_snap_to_drop_pub_1'],
        sourcekind: 'snapshot', distribution: 'precisetestdrop',
        architectures: %w(amd64 i386),
        skip: true).to_s
      assert_equal '200',
                   publish_api.publish_drop(distribution: 'precisetestdrop', force: 1).code.to_s
    end
  end

  describe 'API Publish Repo' do
    let(:publish_api) { AptlyCli::AptlyPublish.new }
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }

    def test_publish_snapshot
      snapshot_api.snapshot_delete('testrepo_snap_to_publish', 1)
      publish_api.publish_drop(distribution: 'precisetest', force: 1)
      snapshot_api.snapshot_create('testrepo_snap_to_publish', 'testrepo',
                                   'testrepo snapshot to delete')
      assert_includes publish_api.publish_repo(
        ['testrepo_snap_to_publish'],
        sourcekind: 'snapshot', distribution: 'precisetest',
        architectures: ['amd64'],
        component: 'main',
        skip: true).to_s,
                      '{"Architectures"=>["amd64"], "Distribution"=>"precisetest",'
    end
  end

  describe 'API Update Publish Point' do
    let(:publish_api) { AptlyCli::AptlyPublish.new }
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new }

    def test_publish_single_repo
      publish_api.publish_drop(distribution: 'precisetest3', force: 1)
      snapshot_api.snapshot_delete('testrepo_single_snap_to_pub', 1)
      snapshot_api.snapshot_create('testrepo_single_snap_to_pub', 'testrepo',
                                   'testrepo single snapshot to publish')
      assert_equal ({ 'Architectures' => %w(amd64 i386),
                      'Distribution' => 'precisetest3',
                      'Label' => '', 'Origin' => '',
                      'Prefix' => '.', 'SkipContents' => 'false',
                      'SourceKind' => 'snapshot',
                      'Sources' => [{ 'Component' => 'main',
                                       'Name' => 'testrepo_single_snap_to_pub' }],
                      'Storage' => '' }).to_s,
                   publish_api.publish_repo(
                     ['main/testrepo_single_snap_to_pub'],
                     sourcekind: 'snapshot', distribution: 'precisetest3',
                     architectures: %w(amd64 i386),
                     skip: true).to_s
    end

    def test_publish_update_success_multiple_repos
      publish_api.publish_drop(distribution: 'precisetest2', force: 1)
      snapshot_api.snapshot_delete('testrepo_snap_to_update_pub_1', 1)
      snapshot_api.snapshot_create('testrepo_snap_to_update_pub_1', 'testrepo',
                                   'testrepo snapshot to change name')
      snapshot_api.snapshot_delete('testrepo_snap_to_update_pub_2', 1)
      snapshot_api.snapshot_create('testrepo_snap_to_update_pub_2', 'testrepo20',
                                   'testrepo snapshot to change name')
      publish_api.publish_repo(
        ['main/testrepo_snap_to_update_pub_1', 'main2/testrepo_snap_to_update_pub_2'],
        sourcekind: 'snapshot', distribution: 'precisetest2',
        architectures: ['amd64'],
        skip: true)
      assert_includes publish_api.publish_update(
        snapshots: { testrepo_snap_to_update_pub_1: 'main', testrepo_snap_to_update_pub_2: 'main2' },
        distribution: 'precisetest2',
        forceoverwrite: true, skip: true).to_s,
                      '{"Component"=>"main", "Name"=>"testrepo_snap_to_update_pub_1"'.to_s
    end

    def test_publish_update_success_multiple_repos_2
      publish_api.publish_drop(distribution: 'precisetest2', force: 1)
      snapshot_api.snapshot_delete('testrepo_snap_to_update_pub_1', 1)
      snapshot_api.snapshot_create('testrepo_snap_to_update_pub_1', 'testrepo',
                                   'testrepo snapshot to change name')
      snapshot_api.snapshot_delete('testrepo_snap_to_update_pub_2', 1)
      snapshot_api.snapshot_create('testrepo_snap_to_update_pub_2', 'testrepo20',
                                   'testrepo snapshot to change name')
      publish_api.publish_repo(
        ['main/testrepo_snap_to_update_pub_1', 'main2/testrepo_snap_to_update_pub_2'],
        sourcekind: 'snapshot', distribution: 'precisetest2',
        architectures: ['amd64'],
        skip: true)
      assert_includes publish_api.publish_update(
        snapshots: { testrepo_snap_to_update_pub_1: 'main', testrepo_snap_to_update_pub_2: 'main2' },
        distribution: 'precisetest2',
        forceoverwrite: true, skip: true).to_s,
                      '{"Component"=>"main2", "Name"=>"testrepo_snap_to_update_pub_2"'.to_s
    end
  end
end
