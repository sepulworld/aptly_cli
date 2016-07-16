require_relative 'minitest_helper'
require 'aptly_cli'

module AptlyCli
  class AptlyLoad
    def ask(_prompt)
      'secret'
    end
  end
end

class TestAptlyCli < Minitest::Test
  attr_reader :test_aptly_load

  def setup
    @test_aptly_load = AptlyCli::AptlyLoad.new
  end

  def test_that_it_has_a_version_number
    refute_nil ::AptlyCli::VERSION
  end

  def test_that_config_loads
    assert_equal ({ server: '127.0.0.2', port: 8083, proto: 'http' }),
      @test_aptly_load.configure({ server: '127.0.0.2', port: 8083 })
  end

  def test_that_config_loads_from_yaml
    assert_equal ({ server: '127.0.0.1', port: 8084, proto: 'http' }),
      @test_aptly_load.configure_with('test/fixtures/aptly-cli.yaml')
  end

  def test_that_config_loads_defaults_if_bad_yaml
    out, err = capture_subprocess_io do
      @test_aptly_load.configure_with('test/fixtures/aptly-cli_invalid.yaml')
    end
    assert_includes out, ('WARN -- : YAML configuration file contains invalid '\
    'syntax. Using defaults')
  end

  def test_that_config_loads_defaults_if_no_yaml
    out, err = capture_subprocess_io do
      @test_aptly_load.configure_with('test/fixtures/aptly-cli_no_yaml.yaml')
    end
    assert_includes out, ('WARN -- : YAML configuration file couldn\'t '\
    'be found at')
  end
end
