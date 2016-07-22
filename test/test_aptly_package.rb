require 'minitest_helper.rb'
require "minitest/autorun"

require 'aptly_cli'

describe AptlyCli::AptlyPackage do
  it "must include httparty methods" do
    AptlyCli::AptlyPackage.must_include HTTMultiParty
  end

  describe "API List Package" do
    config = AptlyCli::AptlyLoad.new.configure_with(nil)
    let(:package_api) { AptlyCli::AptlyPackage.new(config) }

    def test_package_show
      assert_equal '404', package_api.package_show(
        'Pamd64%20boguspackage%202.0.0%2087f1591307e50817').code.to_s
    end
  end
end
