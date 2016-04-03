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

end


describe "API POST package files" do

  let(:api_file) { AptlyCli::AptlyFile.new('/test', 'test_1.0_amd64.deb', 'test/fixtures/test_1.0_amd64.deb') }
  let(:data_for_not_found) { api_file.file_get('test_package_not_here') }

  it "must have a file_post method" do
    api_file.must_respond_to :file_post
  end
  
  it "must have a file_get method" do
    api_file.must_respond_to :file_get
  end

  it "must have a file_delete method" do
    api_file.must_respond_to :file_delete
  end

  it "must parse the api response from JSON to Array" do
    api_file.file_get('test').must_be_instance_of Array 
  end

  it "must parse the api response from JSON to Array" do
    api_file.file_get('test_package_not_here').must_be_instance_of Array
  end

  it "must perform the request and get the data" do
    api_file.file_post(post_options = {:file_uri => '/test', :package => 'test/fixtures/test_1.0_amd64.deb', :local_file => 'test/fixtures/test_1.0_amd64.deb' }).must_equal ["test/test_1.0_amd64.deb"]
  end

  def test_failed_file_not_found
    assert_equal ('[{"error"=>"lstat /aptly/upload/test_package_not_here: no such file or directory", "meta"=>"Operation aborted"}]'), data_for_not_found.to_s
  end

end

