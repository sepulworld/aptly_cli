require 'minitest_helper'

class TestAptlyCli < Minitest::Unit::TestCase 
  def test_that_it_has_a_version_number
    refute_nil ::AptlyCli::VERSION
  end

end
