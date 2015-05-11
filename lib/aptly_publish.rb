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
    
    def parse_names(names)
      repos_to_publish = Array.new
      
      if names.is_a? String
        names = [names] 
      end

      names.each do |k|
        if k.include? "/"
          repo, component = k.split("/")
          repos_to_publish << {"Name" => component, "Component" => repo }
        else
          repos_to_publish << {"Name" => k}
        end
      end
      
      return repos_to_publish
    end

    def publish_repo(names, publish_options={})
      uri = "/publish"
      repos = self.parse_names(names)
      gpg_options = {} 
      @available_options     = [ :distribution, :label, :origin, :forceoverwrite, :architectures, ]
      @available_gpg_options = [ :skip, :batch, :gpgKey, :keyring, :secretKeyring, 
                                 :passphrase, :passphraseFile ]
      @body = {}
      @body[:SourceKind] = publish_options[:sourcekind]
      @body[:Sources] = repos
      
      if publish_options[:prefix]
        uri = uri + publish_options[:prefix]
      end

      @available_options.each do |option|
        if publish_options.has_key?(option)
          @body[option.capitalize] = publish_options[option]
        end
      end

      @available_gpg_options.each do |option|
        if publish_options.has_key?(option)
          unless publish_options[option].nil?
            gpg_options.merge!("#{option.capitalize}" => "#{publish_options[option]}")
          end
        end
      end

      unless gpg_options.empty?
        @body[:Signing] = gpg_options
      end
      puts @body
      @body_json = @body.to_json

      self.class.post(uri, :headers => { 'Content-Type'=>'application/json' }, :body => @body_json)

    end

  end
end
