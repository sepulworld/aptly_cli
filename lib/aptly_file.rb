require 'aptly_cli/version'
require 'aptly_command'
require 'aptly_load'
require 'httmultiparty'

module AptlyCli
  # Uploading file into Aptly
  class AptlyFile < AptlyCommand
    attr_accessor :file_uri, :package, :local_file_path

    def file_dir
      uri = '/files'
      self.class.get uri
    end

    def file_get(file_uri)
      uri = if file_uri == '/'
              '/files'
            else
              '/files/' + file_uri
            end
      self.class.get uri
    end

    def file_delete(file_uri)
      uri = '/files' + file_uri
      self.class.delete uri
    end

    def file_post(post_options = {})
      api_file_uri = '/files' + post_options[:file_uri].to_s
      self.class.post(api_file_uri,
                      query: {
                        package: post_options[:package],
                        file: File.new(post_options[:local_file]) })
    end
  end
end
