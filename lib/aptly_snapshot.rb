require "aptly_cli/version"
require "aptly_load"
require "httmultiparty"
require "json"

module AptlyCli
  class AptlySnapshot

    include HTTMultiParty

    # Load aptly-cli.conf and establish base_uri
    config = AptlyCli::AptlyLoad.new.configure_with("/etc/aptly-cli.conf")
    base_uri "http://#{config[:server]}:#{config[:port]}/api"

    def snapshot_list(sort=nil)
      uri = "/snapshots"

      if sort 
        uri = uri + "?sort=#{sort}"
      end

      self.class.get(uri)
    end

  end
end
