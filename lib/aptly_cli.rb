require "aptly_cli/version"
require "httmultiparty"

module AptlyCli

  Dir[File.dirname(__FILE__) + '/*.rb'].each do |file|
    require file
  end
end
