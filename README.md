# AptlyCli

[![Build Status](https://travis-ci.org/sepulworld/aptly_cli.svg)](https://travis-ci.org/sepulworld/aptly_cli)
[![Gem Version](https://badge.fury.io/rb/aptly_cli.svg)](http://badge.fury.io/rb/aptly_cli)

A command line interace to execute Aptly commands againts remote Aptly API servers.  Aptly-cli will allow you to interact with the file, repo, snapshot, publish, packages, graph and version API endpoints of your Aptly server.

## Installation

Add this line to your application's Gemfile:

    $ ruby gem 'aptly_cli'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aptly_cli
    

Create a configuration file with aptly server and port, /etc/aptly-cli.conf (YAML syntax):

    ---
    :server: 127.0.0.1
    :port: 8082

If a configuration file is not found the defaults in the example configuration file above will be used

## Usage

###     aptly-cli version

  NAME:

    version

  SYNOPSIS:

    aptly-cli version

  DESCRIPTION:

    Display aptly server version

  EXAMPLES:

    # description
    aptly-cli version


###    aptly-cli file_list [options]
  
  NAME:

    file_list

  SYNOPSIS:

    aptly-cli file_list [options]

  DESCRIPTION:

List all directories that contain uploaded files

  EXAMPLES:

    # List all directories for file uploads
    aptly-cli file_list
    # List all files in redis directory
    aptly-cli file_list --directory redis

  OPTIONS:

    --directory DIRECTORY
        Directory to list on server

###    aptly-cli file_upload [options]
 
  NAME:

    file_upload

  SYNOPSIS:

    aptly-cli file_upload [options]

  DESCRIPTION:

    File upload

  EXAMPLES:

    # upload file package.deb to apt server inside directory /aptlyserver_directory/
    aptly-cli file_upload --upload /local/copy/of/package.deb --directory /aptlyserver_directory/

  OPTIONS:

    --directory DIRECTORY
        Directory to load packages into

    --upload UPLOAD
        Package(s) to upload

###     aptly-cli file_delete [options]

  NAME:

    file_delete

  SYNOPSIS:

    aptly-cli file_delete [options]

  DESCRIPTION:

    File delete

  EXAMPLES:

    # Delete package redis-server found in redis upload directory
    aptly-cli file_delete --target /redis/redis-server_2.8.3_i386-cc1.deb

  OPTIONS:

    --target TARGET
        Path to directory or specific package to delete

###     aptly-cli repo_create [options]

  NAME:

    repo_create

  SYNOPSIS:

    aptly-cli repo_create [options]

  DESCRIPTION:

    Create a new repository, requires --name
    
  EXAMPLES:

    # creat repo
    aptly-cli repo_create --name megatronsoftware
    # creat repo with distribution set to 'trusty'
    aptly-cli repo_create --name megatronsoftware --default_distribution trusty

  OPTIONS:

    --name NAME
        Local repository name, required

    --comment COMMENT
        Text describing local repository for the user

    --default_distribution DISTRIBUTION
        Default distribution when publishing from this local repo


    --default_component COMPONENT
        Default component when publishing from this local repo

###     aptly-cli repo_delete [options]

  NAME:

    repo_delete

  SYNOPSIS:

    aptly-cli repo_delete [options]

  DESCRIPTION:

    Delete a local repository, requires --name

  EXAMPLES:

    # description
    aptly-cli repo_delete --name megatronsoftware

  OPTIONS:

    --name NAME
        Local repository name, required

    --force
    
###     aptly-cli repo_edit [options]

  NAME:

    repo_edit

  SYNOPSIS:

    aptly-cli repo_edit [options]

  DESCRIPTION:

    Edit a local repository metadata, requires --name

  EXAMPLES:

    # description
    aptly-cli repo_edit --name megatronsoftware --default_distribution trusty

  OPTIONS:

    --name NAME
        Local repository name, required

    --comment COMMENT
        Edit repository comment

    --default_distribution DISTRIBUTION
        Edit DefaultDistribution for repo

    --default_component COMPONENT
        Edit DefaultComponent for repo
        
###     aptly-cli repo_list [options]

  NAME:

    repo_list

  SYNOPSIS:

    aptly-cli repo_list [options]

  DESCRIPTION:

    Show list of currently available local repositories

  EXAMPLES:

    # description
    aptly-cli repo_list
    

###     aptly-cli repo_package_query [options]

  NAME:

    repo_package_query

  SYNOPSIS:

    aptly-cli repo_package_query [options]

  DESCRIPTION:

    List all packages or search on repo contents, requires --name

  EXAMPLES:

    # description
    aptly-cli repo_package_query --name megatronsoftware -query geoipupdate

  OPTIONS:

    --name NAME
        Local repository name, required

    --query QUERY
        Package to query

    --with_deps
        Return results with dependencies

    --format FORMAT
        Format type to return, compact by default. "details" is an option
        
###     aptly-cli repo_show [options]

  NAME:

    repo_show

  SYNOPSIS:

    aptly-cli repo_show [options]

  DESCRIPTION:

    Returns basic information about local repository, require --name

  EXAMPLES:

    # description
    aptly-cli repo_show --name megatronsoftware

  OPTIONS:

    --name NAME
        Local repository name, required

###     aptly-cli repo_upload [options]

  NAME:

    repo_upload

  SYNOPSIS:

    aptly-cli repo_upload [options]

  DESCRIPTION:

    Import packages from files

  EXAMPLES:

    # description
    aptly-cli repo_upload --name rocksoftware --dir rockpackages --noremove

  OPTIONS:

    --name NAME
        Local repository name, required

    --dir DIR
        Directory where packages are stored via File API

    --file FILE
        Specific file to upload, if not provided the entire directory of files will be uploaded

    --noremove
        Flag to not remove any files that were uploaded via File API after repo upload

    --forcereplace
        flag to replace file(s) already in the repo
        
###     aptly-cli snapshot_create [options]

  NAME:

    snapshot_create

  SYNOPSIS:

    aptly-cli snapshot_create [options]

  DESCRIPTION:

    Create snapshot, require --name

  EXAMPLES:

    # Creating new snapshot megasoftware22-snap from megasoftware22 repo
    aptly-cli snapshot_create --name megasoftware22-snap --repo meagsoftware22

  OPTIONS:

    --name NAME
        Name of new snapshot, required

    --repo REPO
        Name of repo to snapshot

    --description DESCRIPTION
        Set description for snapshot
        
###     aptly-cli snapshot_delete [options]

  NAME:

    snapshot_delete

  SYNOPSIS:

    aptly-cli snapshot_delete [options]

  DESCRIPTION:

    Delete snapshot, require --name

  EXAMPLES:

    # Deleting the snapshot megasoftware22
    aptly-cli snapshot_delete --name megatronsoftware22

    # Deleting the snapshot megasoftware22 with force option
    aptly-cli snapshot_delete --name megatronsoftware22 --force

  OPTIONS:

    --name NAME
        Local snapshot name, required

    --force
        Force

###     aptly-cli snapshot_diff [options]

  NAME:

    snapshot_diff

  SYNOPSIS:

    aptly-cli snapshot_diff [options]

  DESCRIPTION:

    Calculate difference between two snapshots, require --name, require --withsnapshot

  EXAMPLES:

    # Show difference between megatronsoftware and rocksoftware snapshots
    aptly-cli snapshot_diff --name megatronsoftware --withsnapshot rocksoftware

  OPTIONS:

    --name NAME
        Local snapshot name (left)

    --withsnapshot WITHSNAPSHOT
        Snapshot to diff against (right)
        
###     aptly-cli snapshot_list [options]

  NAME:

    snapshot_list

  SYNOPSIS:

    aptly-cli snapshot_list [options]

  DESCRIPTION:

    Return list of all snapshots created in the system

  EXAMPLES:

    # Return list of all snapshots created in the system
    aptly-cli snapshot_list

    # Return list sorted by time
    aptly-cli snapshot_list --sort time

  OPTIONS:

    --sort
        Set sort by
        
###     aptly-cli snapshot_search [options]

  NAME:

    snapshot_search

  SYNOPSIS:

    aptly-cli snapshot_search [options]

  DESCRIPTION:

    List all packages in snapshot or perform search

  EXAMPLES:

    # List all packages in snapshot megasoftware22-snap
    aptly-cli snapshot_search --name megasoftware22-snap

    # List all packages in snapshot megasoftware22-snap with format set to details
    aptly-cli snapshot_search --name megasoftware22-snap --format details

    # Search for package called nginx in snapshot megasoftware22-snap
    aptly-cli snapshot_search --name megasoftware22-snap --query nginx

  OPTIONS:

    --name NAME
        Name of snapshot to search, required

    --query QUERY
        Specific package to query

    --withdeps
        Include package dependencies

    --format FORMAT
        Format the respone of the snapshot search results, compact by default.

###     aptly-cli snapshot_show [options]

  NAME:

    snapshot_show

  SYNOPSIS:

    aptly-cli snapshot_show [options]

  DESCRIPTION:

    Get information about snapshot by name., require --name

  EXAMPLES:

    # Show snapshot information for repo named megatronsoftware
    aptly-cli snapshot_show --name megatronsoftware

  OPTIONS:

    --name NAME
        Local snapshot name, required

###     aptly-cli snapshot_update [options]

  NAME:

    snapshot_update

  SYNOPSIS:

    aptly-cli snapshot_update [options]

  DESCRIPTION:

    Update snapshot’s description or name, require --name

  EXAMPLES:

    # Updating the snapshot megasoftware22 to a new name
    aptly-cli snapshot_update --name megasoftware22 --new_name meagsoftware12-12-13

  OPTIONS:

    --name NAME
        Local snapshot name, required

    --new_name NEWNAME
        New name for the snapshot

    --description DESCRIPTION
        Update description for snapshot
        
###     aptly-cli graph [options]

  NAME:

    graph

  SYNOPSIS:

    aptly-cli graph [options]

  DESCRIPTION:

    Download an svg or png graph of repository layout

  EXAMPLES:

    # description
    aptly-cli graph png > ~/repo_graph.png

  OPTIONS:

    --type GRAPH_TYPE
        Type of graph to download, present options are png or svg

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/aptly_cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
