require 'aptly_cli/version'
require 'aptly_command'
require 'aptly_load'
require 'httparty'
require 'json'
require 'uri'

module AptlyCli
  # Aptly class to work with Repo API
  class AptlyRepo < AptlyCommand
    include HTTParty

    def repo_create(repo_options = { name: nil,
                                     comment: nil,
                                     DefaultDistribution: nil,
                                     DefaultComponent: nil })
      raise ArgumentError, 'Repository name is required' if repo_options[:name].nil? || repo_options[:name].empty?

      uri = '/repos'
      name = repo_options[:name]
      comment = repo_options[:comment]
      default_distribution = repo_options[:DefaultDistribution]
      default_component = repo_options[:DefaultComponent]
      post(uri,
                      :body => 
                      { 'Name' => name, 'Comment' => comment,
                        'DefaultDistribution' => default_distribution,
                        'DefaultComponent' => default_component }.to_json,
                      :headers => { 'Content-Type' => 'application/json' })
    end

    def repo_delete(repo_options = { name: nil, force: nil })
      raise ArgumentError, 'Repository name is required' if repo_options[:name].nil? || repo_options[:name].empty?

      uri = '/repos/' + repo_options[:name]
      uri += '?force=1' if repo_options[:force] == true
      delete(uri)
    end

    def repo_edit(name, repo_options)
      raise ArgumentError, 'Repository name is required' if name.nil? || name.empty?

      uri = "/repos/#{name}"

      put(uri, :body => repo_options.to_json,
                          :headers => { 'Content-Type' => 'application/json' })
    end

    def repo_list
      uri = '/repos'
      get(uri)
    end

    def repo_package_add(repo_options, packages)
      raise ArgumentError, 'Repository name is required' if repo_options[:name].nil? || repo_options[:name].empty?

      uri = '/repos/' + repo_options[:name] + '/packages'
      post(
        uri,
        :body => { PackageRefs: packages }.to_json,
        :headers => { 'Content-Type' => 'application/json' }
      )
    end

    def repo_package_delete(repo_options, packages)
      raise ArgumentError, 'Repository name is required' if repo_options[:name].nil? || repo_options[:name].empty?

      uri = '/repos/' + repo_options[:name] + '/packages'
      delete(
        uri,
        :body => { PackageRefs: packages }.to_json,
        :headers => { 'Content-Type' => 'application/json' }
      )
    end

    def repo_package_query(repo_options = { name: nil, query: nil,
                                            with_deps: false,
                                            format: nil })
      raise ArgumentError, 'Repository name is required' if repo_options[:name].nil? || repo_options[:name].empty?

      uri = '/repos/' + repo_options[:name] + '/packages'

      qs_hash = {}
      qs_hash['q'] = repo_options[:query] if repo_options[:query]
      qs_hash['format'] = repo_options[:format] if repo_options[:format]
      qs_hash['withDeps'] = 1 if repo_options[:with_deps]
      uri += '?' + URI.encode_www_form(qs_hash) if qs_hash
      get uri
    end

    def repo_show(name)
      uri = if name.nil?
              '/repos'
            else
              '/repos/' + name
            end
      get uri
    end

    def repo_upload(repo_options = { name: nil, dir: nil, file: nil,
                                     noremove: false, forcereplace: false })
      raise ArgumentError, 'Repository name is required' if repo_options[:name].nil? || repo_options[:name].empty?

      name = repo_options[:name]
      dir  = repo_options[:dir]
      file = repo_options[:file]
      noremove = repo_options[:noremove]
      forcereplace = repo_options[:forcereplace]
      uri = if file.nil?
              "/repos/#{name}/file/#{dir}"
            else
              "/repos/#{name}/file/#{dir}/#{file}"
            end

      uri += '?forceReplace=1' if forcereplace == true
      uri += '?noRemove=1' if noremove == true
      response = self.class.post(uri)

      case response.code
      when 404
        puts 'repository with such name does not exist'
        return response
      end

      json_response = JSON.parse(response.body)

      unless json_response['FailedFiles'].empty?
        puts "Files that failed to upload... #{json_response['FailedFiles']}"
      end

      unless json_response['Report']['Warnings'].empty?
        puts "File upload warning message[s]...\
             #{json_response['Report']['Warnings']}"
      end

      return response
    end
  end
end
