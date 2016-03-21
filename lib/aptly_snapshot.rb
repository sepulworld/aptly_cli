require "aptly_cli/version"
require "aptly_load"
require "httmultiparty"
require "json"

module AptlyCli
  class AptlySnapshot

    include HTTMultiParty

    # Load aptly-cli.conf and establish base_uri
    config = AptlyCli::AptlyLoad.new.configure_with("/etc/aptly-cli.conf")
    base_uri "http://#{config[:server]}:#{config[:port]}/api"

    if config[:username]
      if config[:password]
        basic_auth "#{config[:username]}", "#{config[:password]}"
      end
    end

    if config[:debug] == true
      debug_output $stdout
    end

    def snapshot_delete(name, force=nil)
      uri = "/snapshots/#{name}"

      if force == true 
        uri += "?force=1"
      end

      self.class.delete(uri)
    end

    def snapshot_list(sort=nil)
      uri = "/snapshots"

      if sort 
        uri += "?sort=#{sort}"
      end

      self.class.get(uri)
    end

    def snapshot_create(name, repo, description=nil)
      # Build uri to create snapshot, requires name of snap and name of repo   
      uri = "/repos/#{repo}/" + "snapshots"
      
      self.class.post(uri, :query => { 'Name' => name, 'Description' => description }.to_json, :headers => {'Content-Type'=>'application/json'})
    end

    def snapshot_create_ref(name, description=nil, sourcesnapshots=[], packagerefs=[])
      uri = "/snapshots"

      begin
        self.class.post(uri, :query => { 'Name' => name, 
                                         'Description' => description, 
                                         'SourceSnapshots' => sourcesnapshots,
                                         'PackageRefs' => packagerefs }.to_json,
                             :headers => {'Content-Type'=>'application/json'})
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

      if search_options.has_key?(:format)
        @options[:query] = {format: "#{search_options[:format]}" }
      end

      if search_options.has_key?(:q)
        @options[:query] = {q: "Name (~ #{search_options[:q]})" }
      end

      if search_options[:withDeps] == true 
        @options[:query] = {withDeps:  "1" }
      end

      self.class.get(uri, @options)

    end

    def snapshot_show(name)
      uri = "/snapshots/#{name}"
      self.class.get(uri)
    end

    def snapshot_update(name, new_name, description=nil)
      uri = "/snapshots/#{name}"

      unless new_name.nil?
        snap_name = name
      else
        snap_name = new_name
      end

      @query = {}
      @query[:Name] = snap_name 

      unless description.nil?
        @query[:Description] = description
      end
      @query_json = @query.to_json

      begin
        self.class.put(uri, :query => @query_json, :headers => {'Content-Type'=>'application/json'})
      rescue HTTPary::Error => e
        puts e 
      end

    end
  end
end
