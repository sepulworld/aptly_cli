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

    def snapshot_list(sort=nil)
      uri = "/snapshots"

      if sort 
        uri = uri + "?sort=#{sort}"
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

    def snapshot_update(name, name_update, description=nil)
      uri = "/snapshots/#{name}"

      begin
        self.class.put(uri, :query => { 'Name' => name_update,
                                        'Description' => description }.to_json,
                            :headers => {'Content-Type'=>'application/json'})
      rescue HTTPary::Error => e
        puts e 
      end

    end
  end
end
