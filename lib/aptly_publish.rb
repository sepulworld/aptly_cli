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
          repo_with_component, component = k.split("/")
          repos_to_publish << {"Name" => "#{repo_with_component}", "Component" => "#{component}"}
        else
          repos_to_publish << {"Name" => "#{k}"}
        end
      end
      
      return repos_to_publish
    end

    def publish_repo(names, publish_options={})
      uri = "/publish/"
      repos_json = self.parse_names(names).to_json

      # Need to figure out how to pass repos_json into @options[:body][:Sources] properly.  Research HTTParty needed
      @options = { :body    => { 'SourceKind' => "#{publish_options[:sourcekind]}",
                                 'Sources' => ["Name" => "rocksoftware300","Component" => "precise3"]}.to_json,
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

      # Need to figure out proper merge, test in irb
      #if publish_options.has_key?(:distribution)
      #  @options[:body].merge!({:Distribution => "#{publish_options[:distribution]}"}.to_json)
      #end
      
      #if publish_options.has_key?(:label)
      #  @options[:body] = {Label: "#{publish_options[:label]}" }
      #end
      
      #if publish_options.has_key?(:origin)
      #  @options[:body] = {Origin: "#{publish_options[:origin]}" }
      #end
      
      #if publish_options.has_key?(:forceoverwrite)
      #  @options[:body] = {ForceOverwrite: "#{publish_options[:forceoverwrite]}" }
      #end
      
      #if publish_options.has_key?(:architectures)
      #  @options[:body] = {Architectures: "[#{publish_options[:architectures]}]" }
      #end

      #if publish_options.has_key?(:signing)
      #  @options[:body] = {Signing: "[#{publish_options[:signing]}]" }
      #end
      
      self.class.post(uri, @options)

    end

  end
end
