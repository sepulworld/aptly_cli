# AptlyCli

[![Build Status](https://travis-ci.org/sepulworld/aptly_cli.svg)](https://travis-ci.org/sepulworld/aptly_cli)

A command line interace to execute Aptly commands againts remote Aptly API servers.  Aptly-cli will allow you to interact with the file, repo, snapshot, publish, packages, graph and version API endpoints of your Aptly server.

## Installation

Add this line to your application's Gemfile:

```ruby gem 'aptly_cli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aptly_cli

## Usage

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
###     aptly-cli package [options]

functions, fixtures, tests done.  Need to add to bin/aptly-cli and document

###     aptly-cli graph [options]

TODO

###     aptly-cli version

TODO

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/aptly_cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
