# AptlyCli

[![Build Status](https://travis-ci.org/sepulworld/aptly_cli.svg)](https://travis-ci.org/sepulworld/aptly_cli)
[![Gem Version](https://badge.fury.io/rb/aptly_cli.svg)](http://badge.fury.io/rb/aptly_cli)
[![Coverage Status](https://coveralls.io/repos/github/sepulworld/aptly_cli/badge.svg?branch=master)](https://coveralls.io/github/sepulworld/aptly_cli?branch=master)

A command line interace to execute [Aptly](http://aptly.info) commands againts remote Aptly API servers.  Aptly-cli will allow you to interact with the file, repo, snapshot, publish, packages, graph and version API endpoints of your Aptly server.


## Installation

Add this line to your application's Gemfile:

    $ ruby gem 'aptly_cli'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aptly_cli
    

Create a configuration file with aptly server and port, /etc/aptly-cli.conf (YAML syntax):

```yaml
---
:proto: http
:server: 127.0.0.1
:port: 8082
:debug: false
```

If you use Basic Authentication to protect your API, add username and password:

```yaml
:username: api-user
:password: api-password
```

Also make sure that your config file isn't world readable (```chmod o-rw /etc/aptly-cli.conf```)

If a configuration file is not found the defaults in the example configuration file above will be used

## Usage - available aptly-cli commands

    aptly-cli --help

    file_delete        Deletes all files in upload directory and directory itself. Or delete just a file
    file_list          List all directories that contain uploaded files
    file_upload        Parameter --directory is upload directory name. Directory would be created if it doesn’t exist.
    graph              Download a graph of repository layout.  Current options are "svg" and "png"
    help               Display global or [command] help documentation
    publish_drop       Delete published repository, clean up files in published directory.
    publish_list       List published repositories.
    publish_repo       Publish local repository or snapshot under specified prefix. Storage might be passed in prefix as well, e.g. s3:packages/. To supply empty prefix, just remove last part (POST /api/publish/:prefix/<:repos>or<:snapshots>
    publish_update     Update published repository. If local repository has been published, published repository would be updated to match local repository contents. If snapshots have been been published, it is possible to switch each component to new snapshot
    repo_create        Create a new repository, requires --name
    repo_delete        Delete a local repository, requires --name
    repo_edit          Edit a local repository metadata, requires --name
    repo_list          Show list of currently available local repositories
    repo_package_query List all packages in local repository or perform search on repository contents and return result., requires --name
    repo_show          Returns basic information about local repository
    repo_upload        Import packages from files (uploaded using File Upload API) to the local repository. If directory specified, aptly would discover package files automatically.Adding same package to local repository is not an error. By default aptly would try to remove every successfully processed file and directory :dir (if it becomes empty after import).
    snapshot_create    Create snapshot of current local repository :name contents as new snapshot with name :snapname
    snapshot_delete    Delete snapshot. Snapshot can’t be deleted if it is published. aptly would refuse to delete snapshot if it has been used as source to create other snapshots, but that could be overridden with force parameter
    snapshot_diff      Calculate difference between two snapshots --name (left) and --withsnapshot (right).
    snapshot_list      Return list of all snapshots created in the system
    snapshot_search    List all packages in snapshot or perform search on snapshot contents and return result
    snapshot_show      Get information about snapshot by name
    snapshot_update    Update snapshot’s description or name
    version            Display aptly server 
    
### To see more options for each command

    aptly-cli <command> --help


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Ruby Minitest are impleneted using Docker container for functional tests

Rake tasks available:

```bash
rake build              # Build aptly_cli-<version>.gem into the pkg directory
rake docker_build       # Docker build image
rake docker_list_aptly  # List Docker Aptly running containers
rake docker_run         # Start Aptly Docker container on port 8082
rake docker_stop        # Stop running Aptly Docker containers
rake install            # Build and install aptly_cli-<version>.gem into system gems
rake install:local      # Build and install aptly_cli-<version>.gem into system gems without network access
rake test               # Run tests
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/aptly_cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
