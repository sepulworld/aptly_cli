require 'minitest_helper.rb'
require "minitest/autorun"

require "aptly_cli"

describe AptlyCli::AptlyFile do
 
  it "must work" do
   "Yay!".must_be_instance_of String
  end

  it "must include httparty methods" do
    AptlyCli::AptlyFile.must_include HTTMultiParty
  end

  it "must have a default server API URL endpoint defined" do
    AptlyCli::AptlyLoad.new.config[:server].must_equal '127.0.0.1'
  end
  
  it "must have a default server API port defined" do
    AptlyCli::AptlyLoad.new.config[:port].must_equal 8082
  end
end

describe "API GET and DELETE files" do

  let(:file_get_delete) { AptlyCli::AptlyFile.new }

  before do
    VCR.insert_cassette 'file_get_delete', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  it "records the fixture for files GET" do
    AptlyCli::AptlyFile.get('/api/files')
  end

  it "records the fixture for directory of debs GET" do
    AptlyCli::AptlyFile.get('/api/files/redis')
  end
  
  it "records the fixture for directory of debs that doesn't exist" do
    AptlyCli::AptlyFile.get('/api/files/nothinghere')
  end
  
  
  it "records the fixture for deleting an uploaded deb" do
    AptlyCli::AptlyFile.delete('/api/files/redis/redis-server_2.8.3_i386-cc1.deb')
  end

end


describe "API POST package files" do

  let(:api_file) { AptlyCli::AptlyFile.new('/api/files/test', 'test_1.0_amd64.deb','test/fixtures/test_1.0_amd64.deb') }

  before do
    VCR.insert_cassette 'api_file', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end
  
  it "must have a file_post method" do
    api_file.must_respond_to :file_post
  end
  
  it "must have a file_get method" do
    api_file.must_respond_to :file_get
  end

  it "must have a file_delete method" do
    api_file.must_respond_to :file_delete
  end

  it "must parse the api response from JSON to Hash" do
    api_file.file_get.must_be_instance_of Hash
  end

  it "must perform the request and get the data" do
    api_file.file_post({'file_uri' => '/api/files/test', :deb => 'test_1.0_amd64.deb', :file => 'test/fixtures/test_1.0_amd64.deb' }).must_equal '[test/test_1.0_amd64.deb]'
  end

  it "records the fixture for directory of debs POST" do
    AptlyCli::AptlyFile.post('/api/files/test', :query => { :deb => 'test_1.0_amd64', :file => File.new('test/fixtures/test_1.0_amd64.deb')} )
  end

end

