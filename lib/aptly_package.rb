require 'aptly_cli/version'
require 'aptly_command'
require 'aptly_load'
require 'httparty'
require 'json'

module AptlyCli
  # Aptly Package API
  class AptlyPackage < AptlyCommand
    include HTTParty

    def package_show(package_key)
      uri = "/packages/#{package_key}"
      get(uri)
    end
  end
end
