require "aptly_cli/version"
require "aptly_load"
require "httmultiparty"

module AptlyCli
  class AptlyFile
  
    # http://aptly.info/doc/api/repo/

    include HTTMultiParty

    config = AptlyCli::AptlyLoad.new.configure_with("/etc/aptly-cli.conf")

    base_uri "http://#{config[:server]}:#{config[:port]}"
    
  end
end
