require "aptly_cli/version"
require "aptly_load"
require "httmultiparty"

module AptlyCli
  class AptlyRepo
  
    include HTTMultiParty
    
    # Load aptly-cli.conf and establish base_uri
    config = AptlyCli::AptlyLoad.new.configure_with("/etc/aptly-cli.conf")
    base_uri "http://#{config[:server]}:#{config[:port]}/api"

    def repo_create(repo_options = {:name => nil, :comment => nil, :DefaultDistribution => nil, :DefaultComponent => nil})
      uri = "/repos"
      name = repo_options[:name]
      comment = repo_options[:comment]
      default_distribution = repo_options[:DefaultDistribution]
      default_component = repo_options[:DefaultComponent]
      
      self.class.post(uri, :query => { 'Name' => name, 'Comment' => comment, 'DefaultDistribution' => default_distribution, 'DefaultComponent' => default_component }.to_json, :headers => {'Content-Type'=>'application/json'}) 
    end

    def repo_delete(name, force = nil)
      # Delete repo function.  Pass '1' for second variable to force delete repo 
      uri = "/repos/" + name
      
      if force == 1
        uri = uri + "?force=1"
      end

      self.class.delete(uri)
    end

    def repo_edit(name, repo_options = { k => v })
      repo_option = String.new
      repo_value = String.new 
      
      if name == nil
        raise ArgumentError.new('Must pass a repository name')
      else
        uri = "/repos/" + name
      end

      repo_options.each do |k, v|
        repo_option = k
        repo_value = v
      end

      self.class.put(uri, :query => { repo_option => repo_value }.to_json, :headers => {'Content-Type'=>'application/json'})
    end

    def repo_list()
      uri = "/repos"
      
      self.class.get(uri)
    end
    
    def repo_package_query(repo_options = {:name => nil, :query => nil, :withdeps => nil, :format => nil})
      if repo_options[:name] == nil
        raise ArgumentError.new('Must pass a repository name')
      else
        uri = "/repos/" + repo_options[:name] + "/packages"
      end

      if repo_options[:query]
        uri = uri + "?q=" + repo_options[:query]
        if repo_options[:withdeps] or repo_options[:format]
          puts "When specifiying specific package query, other options are invalid."
        end 
      elsif repo_options[:format]
        uri = uri + "?format=#{repo_options[:format]}"
      elsif repo_options[:withdeps]
        uri = uri + "?withDeps=1"
      end

      self.class.get uri 
    end

    def repo_show(name)
      if name == nil
        uri = "/repos"
      else
        uri = "/repos/" + name 
      end
      
      self.class.get uri 
    end

    def repo_upload(name, dir, file = nil, noRemove = nil, forceReplace = nil)
      if file == nil 
        uri = "/repos/#{name}/file/#{dir}"
      else
        uri = "/repos/#{name}/file/#{dir}/#{file}"
      end

      if forceReplace == 1
        uri = uri + "?forceReplace=1"
      end
      
      if noRemove == 1
        uri = uri + "?noRemove=1"
      end

      self.class.post(uri)
    end 

  end
end
