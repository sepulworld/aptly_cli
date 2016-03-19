require 'aptly_cli/version'
require 'aptly_load'
require 'httmultiparty'
require 'json'

module AptlyCli
  # :nodoc:
  class AptlyPublish
    include HTTMultiParty

    # Load aptly-cli.conf and establish base_uri
    config = AptlyCli::AptlyLoad.new.configure_with('/etc/aptly-cli.conf')
    base_uri "http://#{config[:server]}:#{config[:port]}/api"

    if config[:username]
      if config[:password]
        basic_auth config[:username].to_s, config[:password].to_s
      end
    end

    debug_output $stdout if config[:debug] == true

    @@available_gpg_options = [:skip, :batch, :gpgKey, :keyring, :secretKeyring,
                              :passphrase, :passphraseFile]
    @@available_options_for_repo   = [:distribution, :label, :origin,
                                     :forceoverwrite, :architectures]
    @@available_options_for_update = [:prefix, :distribution, :forceoverwrite]

    def publish_drop(publish_options={})
      uri = '/publish'

      uri += if publish_options[:prefix]
               "/#{publish_options[:prefix]}"
             else
               '/:.'
             end

      uri += "/#{publish_options[:distribution]}"
      uri += '?force=1' if publish_options[:force] == true
      self.class.delete(uri)
    end

    def publish_list
      uri = '/publish'
      self.class.get(uri)
    end

    def parse_names(names, label_type)
      repos_to_publish = []
      names = [names] if names.is_a? String
      names.each do |k|
        if k.include? '/'
          repo, component = k.split('/')
          repos_to_publish << { label_type.to_s => component,
                                'Component' => repo }
        else
          repos_to_publish << { label_type.to_s => k }
        end
      end
    end

    def parse_gpg_options(available_gpg_options, publish_options)
      gpg_options = {}
      available_gpg_options.each do |option|
        next unless publish_options.key?(option)
        unless publish_options[option].nil?
          gpg_options.merge!(option.capitalize.to_s =>
                             publish_options[option])
        end
      end
    end

    def build_body(available_options_for_func, publish_options, body)
      available_options_for_func.each do |option|
        if publish_options.key?(option)
          body[option.capitalize] = publish_options[option]
        end
      end
    end

    def publish_repo(names, publish_options={})
      uri = '/publish'
      label_type = 'Name'
      repos = parse_names(names, label_type)
      gpg_options = parse_gpg_options(@@available_gpg_options,
                                      publish_options)
      @body = {}
      @body[:SourceKind] = publish_options[:sourcekind]
      @body[:Sources] = repos
      build_body(@@available_options_for_repo, publish_options, @body)
      @body[:Signing] = gpg_options unless gpg_options.empty?

      uri += "/#{publish_options[:prefix]}" if publish_options[:prefix]

      @body_json = @body.to_json

      self.class.post(uri, headers: { 'Content-Type' => 'application/json' },
                           body: @body_json)
    end

    def publish_update(snapshots=[], publish_options={})
      uri = '/publish'
      label_type = 'Snapshots'
      gpg_options = parse_gpg_options(@@available_gpg_options, publish_options)
      @body = {}
      unless snapshots.nil?
        snapshots = parse_names(snapshots, label_type)
        @body[:Snapshots] = snapshots
      end

      @body[:Signing] = gpg_options unless gpg_options.empty?
      build_body(@@available_options_for_update, publish_options, @body)

      uri += if publish_options[:prefix]
               "/#{publish_options[:prefix]}"
             else
               '/'
             end

      uri += "/#{publish_options[:distribution]}"

      @body_json = @body.to_json
      self.class.put(uri, headers: { 'Content-Type' => 'application/json' },
                          body: @body_json)
    end
  end
end
