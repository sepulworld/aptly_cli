require "aptly_cli/version"
require "aptly_load"
require "httmultiparty"

module AptlyCli
  class AptlyFile
  
    include HTTMultiParty
    attr_accessor :file_uri, :package, :local_file_path

    # Load aptly-cli.conf and establish base_uri
    config = AptlyCli::AptlyLoad.new.configure_with("/etc/aptly-cli.conf")
    base_uri "http://#{config[:server]}:#{config[:port]}/api"

    if config[:debug] == true
      debug_output $stdout
    end

    def initialize(file_uri=nil, package=nil, local_file_path=nil)
    end

    def file_dir()
      uri = "/files"
      self.class.get uri
    end

    def file_get(file_uri)
      if file_uri == "/"
        uri = "/files"
      else
        uri = "/files/" + file_uri
      end
      
      self.class.get uri 
    end

    def file_delete(file_uri)
      uri = "/files" + file_uri
      self.class.delete uri 
    end

    def file_post(post_options = {})
      api_file_uri = "/files" + post_options[:file_uri].to_s
      self.class.post(api_file_uri, :query => { :package => post_options[:package], :file => File.new(post_options[:local_file])} )
    end
    
  end
end
