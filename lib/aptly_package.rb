require 'aptly_cli/version'
require 'aptly_load'
require 'httmultiparty'
require 'json'

module AptlyCli
  # Aptly Package API
  class AptlyPackage
    include HTTMultiParty

    # Load aptly-cli.conf and establish base_uri
    @config = AptlyCli::AptlyLoad.new.configure_with('/etc/aptly-cli.conf')
    base_uri "#{@config[:proto]}://#{@config[:server]}:#{@config[:port]}/api"

    if @config[:username]
      if @config[:password]
        basic_auth @config[:username].to_s, @config[:password].to_s
      end
    end

    debug_output $stdout if @config[:debug] == true

    def package_show(package_key)
      uri = "/packages/#{package_key}"
      self.class.get(uri)
    end
  end
end
