require 'minitest_helper.rb'
require 'minitest/autorun'
require 'aptly_cli'

describe AptlyCli::AptlyRepo do
 
  it "must include httparty methods" do
    AptlyCli::AptlyRepo.must_include HTTMultiParty
  end

describe "API Create Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }

end

describe "API Show Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }

end

describe "API Package Query Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }

end
  
describe "API Edit Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }
  let(:repo_api2) { AptlyCli::AptlyRepo.new }

end

describe "API List Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }

end
  
describe "API Delete Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }

end

describe "API Upload to Repo, failure scenario" do

  let(:repo_api_fail) { AptlyCli::AptlyRepo.new }
  let(:data) { repo_api_fail.repo_upload({:name => 'testrepo', :dir => 'rockpackages', :file => 'test_package_not_here', :noremove => true })}

  def test_repo_upload_fail_response
    assert_equal "[\"Unable to process /aptly/upload/rockpackages/test_package_not_here: stat /aptly/upload/rockpackages/test_package_not_here: no such file or directory\"]", data['Report']['Warnings'].to_s
  end

end

describe "API Upload to Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }

end

end
