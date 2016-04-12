require 'aptly_cli/version'
require 'aptly_load'
require 'httmultiparty'
require 'json'

module AptlyCli
  # Aplty class to work with Repo API
  class AptlyRepo
    include HTTMultiParty
    # Load aptly-cli.conf and establish base_uri
    @config = AptlyCli::AptlyLoad.new.configure_with('/etc/aptly-cli.conf')
    base_uri "http://#{@config[:server]}:#{@config[:port]}/api"

    if @config[:username]
      if @config[:password]
        basic_auth @config[:username].to_s, @config[:password].to_s
      end
    end
    debug_output $stdout if @config[:debug] == true

    def repo_create(repo_options = { name: nil,
                                     comment: nil,
                                     DefaultDistribution: nil,
                                     DefaultComponent: nil })
      uri = '/repos'
      name = repo_options[:name]
      comment = repo_options[:comment]
      default_distribution = repo_options[:DefaultDistribution]
      default_component = repo_options[:DefaultComponent]
      self.class.post(uri,
                      query:
                      { 'Name' => name, 'Comment' => comment,
                        'DefaultDistribution' => default_distribution,
                        'DefaultComponent' => default_component }.to_json,
                      headers: { 'Content-Type' => 'application/json' })
    end

    def repo_delete(repo_options = { name: nil, force: nil })
      uri = '/repos/' + repo_options[:name]
      uri += '?force=1' if repo_options[:force] == true
      self.class.delete(uri)
    end

    def repo_edit(name, repo_options = { k => v })
      repo_option = ''
      repo_value = ''
      uri = '/repos/' + name unless name.nil?
      repo_options.each do |k, v|
        repo_option = k
        repo_value = v
      end

      self.class.put(uri, query: { repo_option => repo_value }.to_json,
                          headers: { 'Content-Type' => 'application/json' })
    end

    def repo_list
      uri = '/repos'
      self.class.get(uri)
    end

    def repo_package_query(repo_options = { name: nil, query: nil,
                                            with_deps: false,
                                            format: nil })
      if repo_options[:name].nil?
        raise ArgumentError.new('Must pass a repository name')
      else
        uri = '/repos/' + repo_options[:name] + '/packages'
      end
      uri += if repo_options[:query]
               "?q=#{repo_options[:query]}"
             elsif repo_options[:format]
               "?format=#{repo_options[:format]}"
             elsif repo_options[:with_deps]
               '?withDeps=1'
             else
               ''
             end
      self.class.get uri
    end

    def repo_show(name)
      uri = if name.nil?
              '/repos'
            else
              '/repos/' + name
            end
      self.class.get uri
    end

    def repo_upload(repo_options = { name: nil, dir: nil, file: nil,
                                     noremove: false, forcereplace: false })
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
      end

      json_response = JSON.parse(response.body)

      unless json_response['FailedFiles'].empty?
        begin
        rescue StandardError => e
          puts "Files that failed to upload... #{json_response['FailedFiles']}"
          puts e
        end
      end

      unless json_response['Report']['Warnings'].empty?
        begin
        rescue StandardError => e
          puts "File upload warning message[s]...\
               #{json_response['Report']['Warnings']}"
          puts e
        end
      end
      return response
    end
  end
end
