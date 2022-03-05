require 'minitest_helper.rb'
require 'minitest/autorun'

require 'aptly_cli'

def post_test_file(location)
  config = AptlyCli::AptlyLoad.new.configure_with(nil)
  file_api_setup = AptlyCli::AptlyFile.new(config)
  file_api_setup.file_post(
    file_uri: location.to_s,
    package: 'test/fixtures/test_1.0_amd64.deb',
    local_file: 'test/fixtures/test_1.0_amd64.deb')
end

describe AptlyCli::AptlyFile do
  it 'must include httparty methods' do
    AptlyCli::AptlyFile.must_include HTTParty
  end

  it 'must have a default server API URL endpoint defined' do
    AptlyCli::AptlyLoad.new.config[:server].must_equal '127.0.0.1'
  end
  
  it 'must have a default server API port defined' do
    AptlyCli::AptlyLoad.new.config[:port].must_equal 8082
  end
end

describe 'API GET files' do
  config = AptlyCli::AptlyLoad.new.configure_with(nil)
  let(:file_api) { AptlyCli::AptlyFile.new(config) }
  post_test_file('/testdirfile') 
  
  def test_file_get
    assert_includes file_api.file_get('/testdirfile').to_s, 'test_1.0_amd64.deb'
  end

  def test_file_get_no_file_uri
    assert_includes file_api.file_get('/'), "testdirfile"
  ensure
    assert_includes file_api.file_dir, "testdirfile"
  end
end

describe 'API DELETE files' do
  config = AptlyCli::AptlyLoad.new.configure_with(nil)
  let(:file_api) { AptlyCli::AptlyFile.new(config) }
  post_test_file('/testdirfiledelete') 
  
  def test_file_delete
    assert_includes file_api.file_delete(
      '/testdirfiledelete/test_1.0_amd64.deb').to_s, '{}'
  end
end


describe "API POST package files" do
  config = AptlyCli::AptlyLoad.new.configure_with(nil)
  let(:api_file) { AptlyCli::AptlyFile.new(config) }

  it 'must have a file_post method' do
    api_file.must_respond_to :file_post
  end
  
  it 'must have a file_get method' do
    api_file.must_respond_to :file_get
  end

  it 'must have a file_delete method' do
    api_file.must_respond_to :file_delete
  end

  it 'must parse the api response from JSON to Array' do
    api_file.file_get('test').must_be_instance_of Array
  end

  it 'must perform the request and get the data' do
    api_file.file_post(file_uri: '/test',
                       package: 'test/fixtures/test_1.0_amd64.deb',
                       local_file: 'test/fixtures/test_1.0_amd64.deb'
                      ).must_equal ["test/test_1.0_amd64.deb"]
  end

  def test_failed_file_not_found
    assert_raises AptlyCli::HttpNotFoundError do
      api_file.file_get('test_package_not_here')
    end
  end

  def test_file_post
    assert_includes post_test_file('/testdirfilepost').to_s,
      'testdirfilepost/test_1.0_amd64.deb'
  end
end

