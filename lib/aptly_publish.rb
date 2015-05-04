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

    def publish_drop(prefix, distribution, force=nil)
      uri = "/publish/#{prefix}/#{distribution}"

      if force == 1
        uri = uri + "?force=1"
      end
      
      self.class.delete(uri)
    end

    def publish_list()
      uri = "/publish"
      self.class.get(uri)
    end

    def publish_repo(name, publish_options={})
      #TODO support publishing list of Sources
      uri = "/publish/"
      @options = { :body => { 'SourceKind' => "#{publish_options[:sourcekind]}", 
                              'Sources' => ['Name' => "#{name}"]}.to_json, 
                   :headers => {'Content-Type'=>'application/json'}}
      
      if publish_options[:prefix]
        uri = uri + publish_options[:prefix]
      end

      if publish_options[:sourcekind] == "snapshot"
        uri = uri + '/snapshots'
      elsif publish_options[:sourcekind] == "local"
        uri = uri + '/repos'
      else
        raise ArgumentError.new('Must pass a repository name')
      end
      
      if publish_options.has_key?(:distribution)
        @options[:body] = {Distribution: "#{publish_options[:distribution]}" }
      end
      
      if publish_options.has_key?(:label)
        @options[:body] = {Label: "#{publish_options[:label]}" }
      end
      
      if publish_options.has_key?(:origin)
        @options[:body] = {Origin: "#{publish_options[:origin]}" }
      end
      
      if publish_options.has_key?(:forceoverwrite)
        @options[:body] = {ForceOverwrite: "#{publish_options[:forceoverwrite]}" }
      end
      
      if publish_options.has_key?(:architectures)
        @options[:body] = {Architectures: "[#{publish_options[:architectures]}]" }
      end

      if publish_options.has_key?(:signing)
        @options[:body] = {Signing: "[#{publish_options[:signing]}]" }
      end

      self.class.post(uri, @options) 

    end

  end
end
