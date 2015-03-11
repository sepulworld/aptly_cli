require "aptly_cli/version"
require "aptly_load"
require "httmultiparty"

module AptlyCli
  class AptlyFile
  
    include HTTMultiParty
    attr_accessor :file_uri, :deb, :local_file_path

    # Load aptly-cli.conf and establish base_uri
    config = AptlyCli::AptlyLoad.new.configure_with("/etc/aptly-cli.conf")
    base_uri "http://#{config[:server]}:#{config[:port]}"

    def initialize(file_uri=nil, deb=nil, local_file_path=nil)
      @file_uri = file_uri
      @deb = deb
      @local_file_path = local_file_path
    end

    def file_get(file_uri)
      self.class.get "#{file_uri}"
    end

    def file_delete(file_uri)
      self.class.delete "#{file_uri}"
    end

    def file_post(post_options = {})
      self.class.post(post_options[:file_uri], :query => { :deb => post_options[:deb], :file => File.new(post_options[:local_file])} )
    end
    
  end
end
