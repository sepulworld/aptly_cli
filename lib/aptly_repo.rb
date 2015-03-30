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
      
      self.class.post(uri, :query=>"\{'Name': '#{repo_options[:name]}'\}".to_json, :headers=>{'Content-Type'=>'application/json'}) 
    end

    def repo_show(name)
      if name == nil
        uri = "/repos"
      else
        uri = "/repos/" + name 
      end
      
      self.class.get uri 
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
  end
end
