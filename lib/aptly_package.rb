require "aptly_cli/version"
require "aptly_load"
require "httmultiparty"
require "json"

module AptlyCli
  class AptlyPackage

    include HTTMultiParty

    # Load aptly-cli.conf and establish base_uri
    config = AptlyCli::AptlyLoad.new.configure_with("/etc/aptly-cli.conf")
    base_uri "http://#{config[:server]}:#{config[:port]}/api"

    if config[:debug] == true
      debug_output $stdout
    end

    def package_show(package_key)
      uri = "/packages/#{package_key}"
      self.class.get(uri)
    end

  end
end
