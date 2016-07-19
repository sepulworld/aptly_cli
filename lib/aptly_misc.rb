require 'aptly_cli/version'
require 'aptly_command'
require 'aptly_load'
require 'httmultiparty'
require 'json'

module AptlyCli
  # Misc Aptly Class
  class AptlyMisc < AptlyCommand
    include HTTMultiParty

    def get_graph(extension)
      uri = "/graph.#{extension}"
      self.class.get(uri)
    end

    def get_version
      uri = '/version'
      self.class.get(uri)
    end
  end
end
