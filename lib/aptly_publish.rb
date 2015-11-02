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

    if config[:debug] == true
      debug_output $stdout
    end

    @@available_gpg_options = [ :skip, :batch, :gpgKey, :keyring, :secretKeyring, 
                               :passphrase, :passphraseFile ]

    @@available_options_for_repo   = [ :distribution, :label, :origin, :forceoverwrite, :architectures, ]
    @@available_options_for_update = [ :prefix, :distribution, :forceoverwrite, ]

    def publish_drop(publish_options={})
      uri = "/publish"
      
      if publish_options[:prefix]
        uri = uri + "/#{publish_options[:prefix]}"
      end
      
      uri = uri + "/#{publish_options[:distribution]}"

      if publish_options[:force] == true 
        uri = uri + "?force=1"
      end
      
      self.class.delete(uri)
    end

    def publish_list()
      uri = "/publish"
      self.class.get(uri)
    end
    
    def parse_names(names, label_type)
      repos_to_publish = Array.new
      if names.is_a? String
        names = [names] 
      end

      names.each do |k|
        if k.include? "/"
          repo, component = k.split("/")
          repos_to_publish << {"#{label_type}" => component, "Component" => repo }
        else
          repos_to_publish << {"#{label_type}" => k}
        end
      end
      
      return repos_to_publish
    end
    
    def parse_gpg_options(available_gpg_options, publish_options)
      gpg_options = {}
      available_gpg_options.each do |option|
        if publish_options.has_key?(option)
          unless publish_options[option].nil?
            gpg_options.merge!("#{option.capitalize}" => "#{publish_options[option]}")
          end
        end
      end

      return gpg_options
    end
    
    def build_body(available_options_for_func, publish_options, body)
      available_options_for_func.each do |option|
        if publish_options.has_key?(option)
          body[option.capitalize] = publish_options[option]
        end
      end

      return body
    end

    def publish_repo(names, publish_options={})
      uri = "/publish"
      label_type = "Name"
      repos = self.parse_names(names, label_type)
      gpg_options = self.parse_gpg_options(@@available_gpg_options, publish_options)

      @body = {}
      @body[:SourceKind] = publish_options[:sourcekind]
      @body[:Sources] = repos
      build_body(@@available_options_for_repo, publish_options, @body)
      
      unless gpg_options.empty?
        @body[:Signing] = gpg_options
      end
      
      if publish_options[:prefix]
        uri = uri + publish_options[:prefix]
      end
     
      @body_json = @body.to_json

      self.class.post(uri, :headers => { 'Content-Type'=>'application/json' }, :body => @body_json)

    end

    def publish_update(snapshots=[], publish_options={})
      uri = "/publish"
      label_type = "Snapshots"
      gpg_options = self.parse_gpg_options(@@available_gpg_options, publish_options)
      @body = {}
      
      unless snapshots.nil?
        snapshots = self.parse_names(snapshots, label_type)
        @body[:Snapshots] = snapshots
      end

      build_body(@@available_options_for_update, publish_options, @body)
      
      if publish_options[:prefix]
        uri = uri + "/#{publish_options[:prefix]}"
      else 
        uri = uri + "/"
      end

      uri = uri + "/#{publish_options[:distribution]}"

      @body_json = @body.to_json

      self.class.put(uri, :headers => { 'Content-Type'=>'application/json' }, :body => @body_json)

    end
  end
end
