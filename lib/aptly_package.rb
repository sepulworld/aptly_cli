require 'aptly_cli/version'
require 'aptly_command'
require 'aptly_load'
require 'httmultiparty'
require 'json'

module AptlyCli
  # Aptly Package API
  class AptlyPackage < AptlyCommand
    include HTTMultiParty

    def package_show(package_key)
      uri = "/packages/#{package_key}"
      self.class.get(uri)
    end
  end
end
