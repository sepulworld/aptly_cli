require 'aptly_cli/version'
require 'aptly_command'
require 'aptly_load'
require 'httparty'

module AptlyCli
  # Uploading file into Aptly
  class AptlyFile < AptlyCommand
    attr_accessor :file_uri, :package, :local_file_path

    def file_dir
      uri = '/files'
      response = get uri
      response.parsed_response
    end

    def file_get(file_uri)
      uri = if file_uri == '/'
              '/files'
            else
              '/files/' + file_uri
            end
      response = get uri
      response.parsed_response
    end

    def file_delete(file_uri)
      uri = '/files' + file_uri
      response = delete uri
      response.parsed_response
    end

    def file_post(post_options = {})
      api_file_uri = '/files' + post_options[:file_uri].to_s
      response = post(api_file_uri,
                      body: {
                        package: post_options[:package],
                        file: File.new(post_options[:local_file])
                      })
      response.parsed_response
    end
  end
end
