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
    repo_api.repo_create({:name => 'powerhouse', :comment => 'This is a test repo called powerhouse', :DefaultDistribution => 'main', :DefaultComponent => 'updates'})
  end

 end

describe "API Show Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }

  before do
    VCR.insert_cassette 'repo_api', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  it "records the fixture for showing repo" do
    repo_api.repo_show(name = 'powerhouse')
  end
  
  it "records the fixture for showing repo that doesn't exist" do
    repo_api.repo_show(name = 'nothinghere')
  end

 end

describe "API Package Query Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }

  before do
    VCR.insert_cassette 'repo_api', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end
  
  it "records the fixture for repo package show" do
    repo_api.repo_package_query({:name => 'stable-repo'})
   end
  
  it "records the fixture for repo package search" do
    repo_api.repo_package_query({:name => 'stable-repo', :query => 'voltdb-php-client'})
  end

  it "records the fixture for repo package search with dependencies" do
    repo_api.repo_package_query({:name => 'stable-repo', :withDeps => 1})
   end
  
   it "records the fixture for repo package search with format details on" do
     repo_api.repo_package_query({:name => 'stable-repo', :format => 'details'})
   end

 end
  
describe "API Edit Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }
  let(:repo_api2) { AptlyCli::AptlyRepo.new }

  before do
    VCR.insert_cassette 'repo_api', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  before do
    VCR.insert_cassette 'repo_api2', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end


  it "records the fixture for repo edit comment" do
    repo_api.repo_edit(name = 'powerhouse', { :Comment => 'This repo holds some solid packages' })
  end
 
  it "records the fixture for repo edit DefaultDistribution" do
    repo_api2.repo_edit(name = 'powerhouse', { :DefaultDistribution => 'binary' })
  end

 end

describe "API List Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }

  before do
    VCR.insert_cassette 'repo_api', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end
  
  it "records the fixture for repo list" do
    repo_api.repo_list()
  end

 end
  
describe "API Delete Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }

  before do
    VCR.insert_cassette 'repo_api', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  it "records the fixture for repo force delete" do
    repo_api.repo_delete({:name => 'rocksoftware', :force => true})
  end
 
  it "records the fixture for repo force delete, with packages" do
    repo_api.repo_delete({:name => 'rocksoftware22', :force => true})
  end

 end

describe "API Upload to Repo" do

  let(:repo_api) { AptlyCli::AptlyRepo.new }

  before do
    VCR.insert_cassette 'repo_api', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end
 
  it "records the fixture for repo upload file" do
    repo_api.repo_upload(name = 'rocksoftware22', dir = 'rockpackages')
  end
 
  it "records the fixture for repo upload file, force and noReplace" do
    repo_api.repo_upload(name = 'rocksoftware22', dir = 'rockpackages', file = nil, noRemove = 1, forceReplace = 1)
  end

 end

end
