$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aptly_cli'

require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'

#VCR config
VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/dish_cassettes'
  c.hook_into :webmock
end
