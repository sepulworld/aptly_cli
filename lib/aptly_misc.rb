require 'aptly_cli/version'
require 'aptly_command'
require 'aptly_load'
require 'httparty'
require 'json'

module AptlyCli
  # Misc Aptly Class
  class AptlyMisc < AptlyCommand
    include HTTParty

    def get_graph(extension)
      uri = "/graph.#{extension}"
      get(uri)
    end

    def get_version
      uri = '/version'
      response = get(uri)
      response.parsed_response
    end
  end
end
