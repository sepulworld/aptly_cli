# AptlyCli

[![Build Status](https://travis-ci.org/sepulworld/aptly_cli.svg)](https://travis-ci.org/sepulworld/aptly_cli)

A command line interace to execute Aptly commands againts a remote Aptly API server.  Aptly-cli will allow you to interact with the repo, snapshot, publish, packages, graph and version API endpoints of your Aptly server.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aptly_cli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aptly_cli

## Usage

###    aptly-cli file [options]

  DESCRIPTION:

All uploaded files are stored under <rootDir>/upload directory (see configuration). This directory would be created automatically if it doesn’t
exist. Uploaded files are grouped by directories to support concurrent uploads from multiple package sources. Local repos add API can operate on
directory (adding all files from directory) or on individual package files. By default, all successfully added package files would be removed.

  EXAMPLES:

    # List of directories or files
    aptly-cli file --list /api/files

    # Upload file to a directory
    aptly-cli file --upload /tmp/redis/test_1.0_amd64.deb --dest_uri /api/files/redis/

    # Delete file or directory
    aptly-cli file --delete /api/files/redis/test_1.0_amd64.deb

  OPTIONS:

    --list URI_FILE_PATH
        URI path to list files

    --upload LOCAL_FILE_PATH/PACKAGE
        Path to package to upload

    --dest_uri URI_FILE_PATH
        URI path to directory to upload into

    --delete URI_FILE_PATH/PACKAGE
        URI path to directory to delete or specific package

###     aptly-cli repo [options]

TODO

###     aptly-cli snapshot [options]

TODO

###     aptly-cli publish [options]

TODO

###     aptly-cli package [options]

TODO

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
