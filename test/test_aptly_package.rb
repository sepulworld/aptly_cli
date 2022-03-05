require 'minitest_helper.rb'
require "minitest/autorun"

require 'aptly_cli'

describe AptlyCli::AptlyPackage do
  it "must include httparty methods" do
    AptlyCli::AptlyPackage.must_include HTTParty
  end

  describe "API List Package" do
    config = AptlyCli::AptlyLoad.new.configure_with(nil)
    let(:package_api) { AptlyCli::AptlyPackage.new(config) }

    def test_package_show
      assert_raises AptlyCli::HttpNotFoundError do
        package_api.package_show('Pamd64%20boguspackage%202.0.0%2087f1591307e50817')
      end
    end
  end
end
