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
      
      self.class.post(uri, :body=> '"Name": "#{repo_options[:name]}"'.to_json, :headers=>{'Content-Type'=>'application/json'}) 
    end

    def repo_show(name)
      if name == nil
        uri = "/repos"
      else
        uri = "/repos/" + name 
      end
      
      self.class.get uri 
    end
    
    def repo_packages(name)
      if name == nil
        raise ArgumentError.new('Must pass a repository name')
      else
        uri = "/repos/" + name + "/packages"
      end

      self.class.get uri
    end

    def repo_packages_query(repo_options = {:name => nil, :query => nil})
      if repo_options[:name] == nil
        raise ArgumentError.new('Must pass a repository name')
      elsif repo_options[:query] == nil
        raise ArgumentError.new('Must pass a package query')
      else
        uri = "/repos/" + repo_options[:name] + "/packages?=" + repo_options[:query]
      end

      self.class.get uri 
    end
  end
end
