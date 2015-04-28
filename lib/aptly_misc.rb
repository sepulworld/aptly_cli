require "aptly_cli/version"
require "aptly_load"
require "httmultiparty"
require "json"

module AptlyCli
  class AptlyMisc

    include HTTMultiParty

    # Load aptly-cli.conf and establish base_uri
    config = AptlyCli::AptlyLoad.new.configure_with("/etc/aptly-cli.conf")
    base_uri "http://#{config[:server]}:#{config[:port]}/api"

    def get_graph(extension)
      uri = "/graph.#{extension}"
      self.class.get(uri)
    end

    def get_version()
      uri = "/version"
      self.class.get(uri)
    end

  end
end
