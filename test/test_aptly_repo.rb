require 'minitest_helper.rb'
require "minitest/autorun"

require "aptly_cli"

describe AptlyCli::AptlyRepo do
 
  it "must include httparty methods" do
    AptlyCli::AptlyRepo.must_include HTTMultiParty
  end

describe "API Create Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }

  before do
    VCR.insert_cassette 'repo_api', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  it "records the fixture for repo creation, with name, comment, distribution, and component" do
    repo_api.repo_create({:name => 'powerhouse', :comment => 'This is a test repo called powerhouse', :default_distribution => 'main', :default_component => 'updates'})
  end

  it "records the fixture for showing repo" do
    repo_api.repo_show({:name => 'powerhouse'})
  end
  
  it "records the fixture for showing repo that doesn't exist" do
    repo_api.repo_show({:name => 'nothinghere'})
  end
  
  it "records the fixture for repo package show" do
    repo_api.repo_show_packages({:name => 'powerhouse'})
  end
  
  it "records the fixture for repo package search" do
    repo_api.repo_show_packages({:name => 'powerhouse', :query => 'powerhouse_package'})
  end

  it "records the fixture for repo package search with dependencies" do
    repo_api.repo_show_packages({:name => 'powerhouse', :query => 'powerhouse_package', :withDeps => 1})
  end
  
  it "records the fixture for repo package search with format details on" do
    repo_api.repo_show_packages({:name => 'powerhouse', :format => 'details'})
  end
  
  it "records the fixture for repo edit comment" do
    repo_api.repo_edit({:name => 'powerhouse', :comment => 'This repo holds some solid packages'})
  end
  
  it "records the fixture for repo edit DefaultDistribution" do
    repo_api.repo_edit({:name => 'powerhouse', :default_distribution => 'binary'})
  end
  
  it "records the fixture for repo edit DefautlComponent" do
    repo_api.repo_edit({:name => 'powerhouse', :default_component => 'security'})
  end

  it "records the fixture for repo list" do
    repo_api.repo_list()
  end
  
  it "records the fixture for repo delete" do
    repo_api.repo_delete({:name => 'powerhouse'})
  end
  
  it "records the fixture for repo delete with force flag" do
    repo_api.repo_delete({:name => 'test', :force => 1})
  end

  ### Left off at Add Packages from uploaded file/dir
end

