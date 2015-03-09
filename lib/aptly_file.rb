require "aptly_cli/version"
require "aptly_load"
require "httmultiparty"

module AptlyCli
  class AptlyFile
  
    include HTTMultiParty
    attr_accessor :file_uri, :deb, :local_file_path

    # Load aptly-cli.conf and establish base_uri
    config = AptlyCli::AptlyLoad.new.configure_with("/etc/aptly-cli.conf")
    base_uri = "http://#{config[:server]}:#{config[:port]}"

    def initialize(file_uri=None, deb=None, local_file_path=None)
      @file_uri = file_uri
      @deb = deb
      @local_file_path = local_file_path
    end

    def file_get
      self.class.get "#{@file_uri}"
    end

    def file_delete
      self.class.delete "#{@file_uri}"
    end

    def file_post
      self.class.post(@file_uri, :query => { :deb => @deb, :file => File.new(@local_file_paht)} )
    end
    
  end
end
