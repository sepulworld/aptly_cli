require "aptly_cli/version"
require "aptly_load"
require "httmultiparty"

module AptlyCli
  class AptlyRepo
  
    include HTTMultiParty
    #attr_accessor :file_uri, :package, :local_file_path

    # Load aptly-cli.conf and establish base_uri
    config = AptlyCli::AptlyLoad.new.configure_with("/etc/aptly-cli.conf")
    base_uri "http://#{config[:server]}:#{config[:port]}/api"

    #def initialize(file_uri=nil, package=nil, local_file_path=nil)
    #end

    def repo_create(repo_options = {:name => nil, :comment => nil, :DefaultDistribution => nil, :DefaultComponent => nil})
      uri = "/repos"
      
      self.class.post(uri, :body => {"Name": "#{repo_options[:name]}", }.to_json, :headers => { 'Content-Type' => 'application/json' }) 
    end

    def repo_show(repo_options = {:name => nil})
      if file_uri == "/"
        uri = "/repos"
      else
        uri = "/repos" + repo_options[:name] 
      end
      
      self.class.get uri 
    end

    def file_delete(file_uri)
      uri = "/files" + file_uri
      self.class.delete uri 
    end

    def file_post(post_options = {:name => nil, :comment})
      api_file_uri = "/files" + post_options[:file_uri].to_s
      self.class.post(api_file_uri, :body => {"Name":  :headers => { 'Content-Type' => 'application/json' })
    end
    
  end
end
