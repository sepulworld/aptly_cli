require 'aptly_cli/version'
require 'aptly_command'
require 'aptly_load'
require 'httparty'
require 'json'

module AptlyCli
  # Aptly class to work with Snapshot API
  class AptlySnapshot < AptlyCommand
    include HTTParty

    def snapshot_delete(name, force=nil)
      uri = "/snapshots/#{name}"
      uri += '?force=1' if force == true
      self.class.delete(uri)
    end

    def snapshot_list(sort=nil)
      uri = '/snapshots'
      uri += "?sort=#{sort}" if sort
      self.class.get(uri)
    end

    def snapshot_create(name, repo, description=nil)
      # Build uri to create snapshot, requires name of snap and name of repo
      uri = "/repos/#{repo}/" + 'snapshots'

      self.class.post(uri, :body => 
                      { 'Name' => name,
                        'Description' => description }.to_json,
                           :headers => { 'Content-Type' => 'application/json' })
    end

    def snapshot_create_ref(name, description=nil,
                            sourcesnapshots=[], packagerefs=[])
      uri = '/snapshots'
      begin
        self.class.post(uri,
                        :body => { 'Name' => name, 'Description' => description,
                                 'SourceSnapshots' => sourcesnapshots,
                                 'PackageRefs' => packagerefs }.to_json,
                        :headers => { 'Content-Type' => 'application/json' })
      rescue HTTParty::Error => e
        return e
      end
    end

    def snapshot_diff(name, with_snapshot)
      uri = "/snapshots/#{name}/diff/#{with_snapshot}"
      self.class.get(uri)
    end

    def snapshot_search(name, search_options={})
      uri = "/snapshots/#{name}/packages"
      @options = { query: {} }

      if search_options.key?(:format)
        @options[:query] = { format: search_options[:format].to_s }
      end

      if search_options.key?(:q)
        @options[:query] = { q: "Name (~ #{search_options[:q]})" }
      end

      @options[:query] = { withDeps:  '1' } if search_options[:withDeps] == true
      self.class.get(uri, @options)
    end

    def snapshot_show(name)
      uri = "/snapshots/#{name}"
      self.class.get(uri)
    end

    def snapshot_update(name, new_name, description=nil)
      uri = "/snapshots/#{name}"
      snap_name = if new_name.nil?
                    name
                  else
                    new_name
                  end
      @query = {}
      @query[:Name] = snap_name
      @query[:Description] = description unless description.nil?
      @query_json = @query.to_json
      begin
        self.class.put(uri, :body => @query_json, :headers =>
                       { 'Content-Type' => 'application/json' })
      rescue HTTParty::Error => e
        puts e
      end
    end
  end
end
