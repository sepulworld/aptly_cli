require "aptly_cli/version"
require "aptly_load"
require "httmultiparty"
require "json"

module AptlyCli
  class AptlyPublish

    include HTTMultiParty

    # Load aptly-cli.conf and establish base_uri
    config = AptlyCli::AptlyLoad.new.configure_with("/etc/aptly-cli.conf")
    base_uri "http://#{config[:server]}:#{config[:port]}/api"

    def publish_list()
      uri = "/publish"
      self.class.get(uri)
    end

    def publish_repo(name, publish_options={})
      uri = "/publish"
      @options = { :body => { 'SourceKind' => "#{publish_options[:sourcekind]}", 'Sources' => ['Name' => "#{name}"]}.to_json, headers: {'Content-Type'=>'application/json'}}

      self.class.post(uri, @options) 
    end

  end
end
