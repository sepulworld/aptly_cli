require_relative 'minitest_helper'

class TestAptlyCli < Minitest::Unit::TestCase 

  def test_that_it_has_a_version_number
    refute_nil ::AptlyCli::VERSION
  end

  def test_that_config_loads
    assert_equal ({"server" => "127.0.0.2", "port" => 8083}), AptlyCli::AptlyLoad.configure( opts = { "server" => "127.0.0.2", "port" => 8083 })
  end

end
