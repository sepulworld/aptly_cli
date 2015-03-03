require_relative 'minitest_helper'
require 'aptly_cli'

class TestAptlyCli < Minitest::Unit::TestCase 

  attr_reader :test_aptly_load

  def setup
    @test_aptly_load = AptlyCli::AptlyLoad.new
  end

  def test_that_it_has_a_version_number
    refute_nil ::AptlyCli::VERSION
  end

  def test_that_config_loads
    assert_equal ({:server => "127.0.0.2", :port => 8083}), @test_aptly_load.configure(opts = {:server => "127.0.0.2", :port => 8083 })
  end
  
  def test_that_config_loads_from_yaml
    assert_equal ({:server => "127.0.0.1", :port => 8084}), @test_aptly_load.configure_with('test/fixtures/aptly-cli.yaml')
  end

  def test_that_config_loads_defaults_if_bad_yaml
    assert_equal ({:server => "127.0.0.1", :port => 8082}), @test_aptly_load.configure_with('test/fixtures/aptly-cli_invalid.yaml')
  end
  
  def test_that_config_loads_defaults_if_no_yaml
    assert_equal ({:server => "127.0.0.1", :port => 8082}), @test_aptly_load.configure_with('test/fixtures/aptly-cli_no_yaml.yaml')
  end
end
