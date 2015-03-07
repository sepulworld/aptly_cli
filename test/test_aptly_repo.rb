require 'minitest_helper.rb'
require "minitest/autorun"

require "aptly_cli"

describe AptlyCli::AptlyRepo do
 
  it "must work" do
   "Yay!".must_be_instance_of String
  end

  it "must include httparty methods" do
    AptlyCli::AptlyRepo.must_include HTTMultiParty
  end

  it "must have a default server API URL endpoint defined" do
    AptlyCli::AptlyLoad.new.config[:server].must_equal '127.0.0.1'
  end
  
  it "must have a default server API port defined" do
    AptlyCli::AptlyLoad.new.config[:port].must_equal 8082
  end
end

describe "API files" do

  before do
    VCR.insert_cassette 'deb_files', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  it "records the fixture for files GET" do
    AptlyCli::AptlyRepo.get('/api/files')
  end

  it "records the fixture for directory of debs GET" do
    AptlyCli::AptlyRepo.get('/api/files/redis')
  end
  
  it "records the fixture for directory of debs that doesn't exist" do
    AptlyCli::AptlyRepo.get('/api/files/nothinghere')
  end
  
  it "records the fixture for directory of debs POST" do
    AptlyCli::AptlyRepo.post('/api/files/test', :query => { :deb => 'test_1.0_amd64', :file => File.new('test/fixtures/test_1.0_amd64.deb')} )
  end
  
  it "records the fixture for deleting an uploaded deb" do
    AptlyCli::AptlyRepo.delete('/api/files/redis/redis-server_2.8.3_i386-cc1.deb')
  end

end
