require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'aptly_cli'
require 'minitest/autorun'

class Options
  attr_accessor :server, :username, :password
end
