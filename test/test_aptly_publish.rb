require 'minitest_helper.rb'
require 'minitest/autorun'

require 'aptly_cli'

describe AptlyCli::AptlyPublish do

  it 'must include httparty methods' do
    AptlyCli::AptlyPublish.must_include HTTMultiParty
  end

describe 'API List Publish' do
   let(:publish_api) { AptlyCli::AptlyPublish.new }

end

describe 'API Publish Repo' do
   let(:publish_api) { AptlyCli::AptlyPublish.new }

end

  describe 'API Drop Repo' do
       let(:publish_api) { AptlyCli::AptlyPublish.new }
  
  end

  describe 'API Update Publish Point' do
    let(:publish_api) { AptlyCli::AptlyPublish.new }

    #def test_publish_update_name
    #  assert_equal ({ 'Architectures' => ['amd64', 'i386'],
    #                 'Distribution' => 'precise',
    #                 'Label' => '', 'Origin' => '',
    #                 'Prefix' => '.', 'SourceKind' => 'snapshot',
    #                 'Sources' => [{ 'Component' => 'main', 'Name' => 'rocksoftware22_snap' }],
    #                 'Storage' => '' }).to_s,
    #               publish_api.publish_update(
    #                 nil,
    #                 publish_options = { distribution: 'precise',
    #                                     forceoverwrite: true }).to_s
    #end
  end
end
