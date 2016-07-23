require 'minitest_helper.rb'
require 'minitest/autorun'
require 'aptly_cli'

describe AptlyCli::AptlyRepo do
  it 'must include httparty methods' do
    AptlyCli::AptlyRepo.must_include HTTMultiParty
  end

  describe 'API Upload to Repo' do
    config = AptlyCli::AptlyLoad.new.configure_with('/no/config')
    let(:repo_api) { AptlyCli::AptlyRepo.new(config) }
    let(:file_api) { AptlyCli::AptlyFile.new(config) }

    def test_repo_upload
      file_api.file_post(file_uri: '/testdir',
                         package: 'testdir/fixtures/test_1.0_amd64.deb',
                         local_file: 'test/fixtures/test_1.0_amd64.deb')
      assert_includes repo_api.repo_upload(
        name: 'testrepo',
        dir: 'testdir/',
        file: 'test_1.0_amd64.deb').to_s,
        '{"FailedFiles"=>[], "Report"=>{"Warnings"=>[], "Added"=>'\
        '["geoipupdate_2.0.0_amd64 added"], "Removed"=>[]}}'
    end
  end

  describe 'API Create Repo' do
    config = AptlyCli::AptlyLoad.new.configure_with('/no/config')
    let(:repo_api) { AptlyCli::AptlyRepo.new(config) }

    def test_repo_creation
      repo_api.repo_delete(name: 'testrepocreate',
                           force: true)
      assert_includes repo_api.repo_create(name: 'testrepocreate',
                           comment: 'testing repo creation',
                           DefaultDistribution: 'precisecreatetest',
                           DefaultComponent: nil).to_s,
                           '{"Name"=>"testrepocreate", "Comment"=>"testing repo creation", '\
                           '"DefaultDistribution"=>"precisecreatetest", "DefaultComponent"=>""}'
    end
  end

  describe 'API Show Repo' do
    config = AptlyCli::AptlyLoad.new.configure_with('/no/config')
    let(:repo_api) { AptlyCli::AptlyRepo.new(config) }

    def test_repo_show
      repo_api.repo_delete(name: 'testrepotoshow',
                           force: true)
      repo_api.repo_create(name: 'testrepotoshow',
                           comment: 'testing repo show',
                           DefaultDistribution: 'preciseshowtest',
                           DefaultComponent: nil)
      assert_includes repo_api.repo_show('testrepotoshow').to_s,
        '{"Name"=>"testrepotoshow", "Comment"=>"testing repo show", '\
        '"DefaultDistribution"=>"preciseshowtest", "DefaultComponent"=>""}'
    ensure
      assert_equal '200', repo_api.repo_show(nil).code.to_s
    end
  end

  describe 'API Package Query Repo' do
    config = AptlyCli::AptlyLoad.new.configure_with('/no/config')
    let(:repo_api) { AptlyCli::AptlyRepo.new(config) }
    let(:file_api) { AptlyCli::AptlyFile.new(config) }

    def test_package_query_with_no_name
      assert_raises ArgumentError do
        repo_api.repo_package_query(query: 'geoipupdate')
      end
    end

    def test_package_query_with_name
      repo_api.repo_delete(name: 'testrepotoquery',
                           force: true)
      file_api.file_post(file_uri: '/testdir2',
                         package: 'testdir2/fixtures/geoipupdate_2.0.0_amd64.deb',
                         local_file: 'test/fixtures/test_1.0_amd64.deb')
      repo_api.repo_create(name: 'testrepotoquery',
                           comment: 'testing repo query with name',
                           DefaultDistribution: 'precisequerytest',
                           DefaultComponent: nil)
      repo_api.repo_upload(
        name: 'testrepotoquery',
        dir: 'testdir2/',
        file: 'test_1.0_amd64.deb')
      assert_includes repo_api.repo_package_query(name: 'testrepotoquery',
                                                  query: 'geoipupdate').to_s,
                                                  '["Pamd64 geoipupdate 2.0.0'
    end
  end
  
  describe 'API List Repo' do
    config = AptlyCli::AptlyLoad.new.configure_with('/no/config')
    let(:repo_api) { AptlyCli::AptlyRepo.new(config) }

    def test_list_repo_http_response
      assert_equal repo_api.repo_list.code.to_s, '200'
    end
  end
  
  describe 'API Edit Repo' do
    config = AptlyCli::AptlyLoad.new.configure_with('/no/config')
    let(:repo_api) { AptlyCli::AptlyRepo.new(config) }

    def test_repo_edit_default_distribution
      repo_api.repo_delete(name: 'testrepotoedit',
                           force: true)
      repo_api.repo_create(name: 'testrepoedit',
                           comment: 'testing repo edit distro name',
                           DefaultDistribution: 'preciseedittest',
                           DefaultComponent: nil)

      assert_includes repo_api.repo_edit(
        'testrepoedit',
        DefaultDistribution: 'preciseeditdistnew').to_s,
        '{"Name"=>"testrepoedit", "Comment"=>"testing repo edit distro name", '\
        '"DefaultDistribution"=>"preciseeditdistnew", '\
        '"DefaultComponent"=>""}'
    end
  end

  describe 'API Delete Repo' do
    config = AptlyCli::AptlyLoad.new.configure_with('/no/config')
    let(:repo_api) { AptlyCli::AptlyRepo.new(config) }

    def test_repo_delete
      repo_api.repo_create(name: 'testrepodelete',
                           comment: 'testing repo deletion',
                           DefaultDistribution: 'precisedeletetest',
                           DefaultComponent: nil)
      assert_includes repo_api.repo_delete(name: 'testrepodelete',
                           force: true).to_s, '{}'
    end
  end

  describe 'API Upload to Repo, failure scenario' do
    config = AptlyCli::AptlyLoad.new.configure_with('/no/config')
    let(:repo_api_fail) { AptlyCli::AptlyRepo.new(config) }
    let(:data) { repo_api_fail.repo_upload({ name: 'testrepo',
                                           dir: 'rockpackages',
                                           file: 'test_package_not_here',
                                           noremove: true })}

    def test_repo_upload_fail_response
      assert_equal "[\"Unable to process /aptly/upload/"\
        "rockpackages/test_package_not_here: stat "\
        "/aptly/upload/rockpackages/test_package_not_here: "\
        "no such file or directory\"]",
        data['Report']['Warnings'].to_s
    end
  end

end
