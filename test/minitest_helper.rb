require 'coveralls'
require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter,
  ]
)

SimpleCov.start do
  add_filter '/\.bundle/'
end

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'aptly_cli'
require 'minitest/autorun'

class Options
  attr_accessor :server, :port, :username, :password, :debug
end
