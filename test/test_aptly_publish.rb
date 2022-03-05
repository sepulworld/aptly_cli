require 'minitest_helper.rb'
require 'minitest/autorun'

require 'aptly_cli'

describe AptlyCli::AptlyPublish do
  it 'must include httparty methods' do
    AptlyCli::AptlyPublish.must_include HTTParty
  end

  describe 'API List Publish' do
    config = AptlyCli::AptlyLoad.new.configure_with(nil)
    let(:publish_api) { AptlyCli::AptlyPublish.new(config) }
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new(config) }

    def test_publish_list
      allow_http_error { publish_api.publish_drop(distribution: 'publishlisttest1', force: 1) }
      allow_http_error { publish_api.publish_drop(distribution: 'publishlisttest2', force: 1) }
      allow_http_not_found_error { snapshot_api.snapshot_delete('testrepo_snap_to_list_pub_1', 1) }
      allow_http_not_found_error { snapshot_api.snapshot_create('testrepo_snap_to_list_pub_1', 'testrepo',
                                   'testrepo snapshot to create and drop publish 1') }
      allow_http_not_found_error { snapshot_api.snapshot_delete('testrepo_snap_to_list_pub_2', 1) }
      allow_http_not_found_error { snapshot_api.snapshot_create('testrepo_snap_to_list_pub_2', 'testrepo',
                                   'testrepo snapshot to create and drop publish 2') }
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
      assert_includes publish_api.publish_list.parsed_response.to_s,
                      '"Distribution"=>"publishlisttest1"'
      assert_includes publish_api.publish_list.parsed_response.to_s,
                      '"Distribution"=>"publishlisttest2"'
    end
  end

  describe 'API Drop Publish' do
    config = AptlyCli::AptlyLoad.new.configure_with(nil)
    let(:publish_api) { AptlyCli::AptlyPublish.new(config) }
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new(config) }

    def test_publish_drop
      allow_http_error { publish_api.publish_drop(distribution: 'precisetestdrop', force: 1) }

      allow_http_not_found_error { snapshot_api.snapshot_delete('testrepo_snap_to_drop_pub_1', 1) }
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
    config = AptlyCli::AptlyLoad.new.configure_with(nil)
    let(:publish_api) { AptlyCli::AptlyPublish.new(config) }
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new(config) }

    def test_publish_snapshot
      allow_http_not_found_error { snapshot_api.snapshot_delete('testrepo_snap_to_publish', 1) }
      allow_http_error { publish_api.publish_drop(distribution: 'precisetest', force: 1) }

      snapshot_api.snapshot_create('testrepo_snap_to_publish', 'testrepo',
                                   'testrepo snapshot to delete')
      assert_includes publish_api.publish_repo(
        ['testrepo_snap_to_publish'],
        sourcekind: 'snapshot', distribution: 'precisetest',
        architectures: ['amd64'],
        component: 'main',
        skip: true).parsed_response.to_s,
                      '{"Architectures"=>["amd64"], "Distribution"=>"precisetest",'
    end
  end

  describe 'API Update Publish Point' do
    config = AptlyCli::AptlyLoad.new.configure_with(nil)
    let(:publish_api) { AptlyCli::AptlyPublish.new(config) }
    let(:snapshot_api) { AptlyCli::AptlySnapshot.new(config) }

    def test_publish_single_repo
      allow_http_error { publish_api.publish_drop(distribution: 'precisetest3', force: 1) }

      allow_http_not_found_error { snapshot_api.snapshot_delete('testrepo_single_snap_to_pub', 1) }
      snapshot_api.snapshot_create('testrepo_single_snap_to_pub', 'testrepo',
                                   'testrepo single snapshot to publish')
      assert_equal ({ 'Architectures' => %w(amd64 i386),
                      'Distribution' => 'precisetest3',
                      'Label' => '', 'Origin' => '',
                      'Prefix' => '.', 'SkipContents' => false,
                      'SourceKind' => 'snapshot',
                      'Sources' => [{ 'Component' => 'main',
                                       'Name' => 'testrepo_single_snap_to_pub' }],
                                       'Storage' => '' }).to_s,
                   publish_api.publish_repo(
                     ['main/testrepo_single_snap_to_pub'],
                     sourcekind: 'snapshot', distribution: 'precisetest3',
                     architectures: %w(amd64 i386),
                     skip: true).parsed_response.to_s
    end

    def test_publish_update_success_multiple_repos
      allow_http_error { publish_api.publish_drop(distribution: 'precisetest2', force: 1) }

      allow_http_not_found_error { snapshot_api.snapshot_delete('testrepo_snap_to_update_pub_1', 1) }
      snapshot_api.snapshot_create('testrepo_snap_to_update_pub_1', 'testrepo',
                                   'testrepo snapshot to change name')
      allow_http_not_found_error { snapshot_api.snapshot_delete('testrepo_snap_to_update_pub_2', 1) }
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
        forceoverwrite: true, skip: true).parsed_response.to_s,
                      '{"Component"=>"main", "Name"=>"testrepo_snap_to_update_pub_1"'.to_s
    end

    def test_publish_update_success_multiple_repos_2
      allow_http_error { publish_api.publish_drop(distribution: 'precisetest2', force: 1) }

      allow_http_not_found_error { snapshot_api.snapshot_delete('testrepo_snap_to_update_pub_1', 1) }
      snapshot_api.snapshot_create('testrepo_snap_to_update_pub_1', 'testrepo',
                                   'testrepo snapshot to change name')
      allow_http_not_found_error { snapshot_api.snapshot_delete('testrepo_snap_to_update_pub_2', 1) }
      snapshot_api.snapshot_create('testrepo_snap_to_update_pub_2', 'testrepo20',
                                   'testrepo snapshot to change name')
      publish_api.publish_repo(
        ['main/testrepo_snap_to_update_pub_1', 'main2/testrepo_snap_to_update_pub_2'],
        snapshots: { testrepo_snap_to_update_pub_1: 'main',
                     testrepo_snap_to_update_pub_2: 'main2' },
        prefix: 'testrepo_snap_to_update_pub_prefix',
        sourcekind: 'snapshot', distribution: 'precisetest2',
        architectures: ['amd64'],
        skip: true)
      assert_includes publish_api.publish_update(
        snapshots: { testrepo_snap_to_update_pub_1: 'main', testrepo_snap_to_update_pub_2: 'main2' },
        prefix: 'testrepo_snap_to_update_pub_prefix',
        distribution: 'precisetest2',
        forceoverwrite: true, skip: true).to_s,
                      '{"Component":"main2","Name":"testrepo_snap_to_update_pub_2"'.to_s
      resp = publish_api.publish_drop(
        prefix: 'testrepo_snap_to_update_pub_prefix',
        distribution: 'precisetest2',
      )
      assert_equal resp.code, 200
      assert_equal resp.parsed_response.to_s, "{}"
    end
  end
end
