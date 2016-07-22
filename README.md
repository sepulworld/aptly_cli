# AptlyCli

[![Build Status](https://travis-ci.org/sepulworld/aptly_cli.svg)](https://travis-ci.org/sepulworld/aptly_cli)
[![Gem Version](https://badge.fury.io/rb/aptly_cli.svg)](http://badge.fury.io/rb/aptly_cli)
[![Coverage Status](https://coveralls.io/repos/github/sepulworld/aptly_cli/badge.svg?branch=master)](https://coveralls.io/github/sepulworld/aptly_cli?branch=master)

A command line interface to execute [Aptly](http://aptly.info) commands againts remote Aptly API servers.  Aptly-cli will allow you to interact with the file, repo, snapshot, publish, packages, graph and version API endpoints of your Aptly server.


## Installation

### Install Gem:

    $ gem install aptly_cli

or...

### Install and run aptly-cli from Docker:

    # Optional: If you don't pull explicitly, `docker run` will do it for you
    $ docker pull sepulworld/aptly-cli

    $ alias aptly-cli='\
      docker run \
        -v /etc/aptly-cli.conf:/etc/aptly-cli.conf \
        -it --rm --name=aptly-cli \
        sepulworld/aptly-cli'

(Depending on how your system is set up, you might have to add `sudo` in front of the above `docker` commands or add your user to the `docker` group).

If you don't do the `docker pull`, the first time you run `aptly-cli`, the `docker run` command will automatically pull [the `sepulworld/aptly-cli` image on the Docker Hub](https://hub.docker.com/r/sepulworld/aptly-cli/). Subsequent runs will use a locally cached copy of the image and will not have to download anything.

Create a configuration file with aptly server and port, `/etc/aptly-cli.conf` (YAML syntax):

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

The username and password can also be configured for prompt entry using
the following in `aptly-cli.conf`:

```yaml
:username: ${PROMPT}
:password: ${PROMPT_PASSWORD}
```

The tool will prompt for the specified values, where `${PROMPT}` results
in a regular prompt and `${PROMPT_PASSWORD}` results in a password
prompt where the input is replaced by asterisks, e.g.:

    $ aptly-cli version
      Enter a value for username:
      zane
      Enter a value for password:
      ********

Another possibility for storing passwords is `${KEYRING}`. To use this feature,
you must have the [`keyring` gem](https://github.com/jheiss/keyring) installed
and also have a system that is set up to use one of the backends that the
`keyring` gem supports, such as Mac OS X Keychain or GNOME 2 Keyring (Note:
Only Mac OS X Keychain has been tested thus far):

    $ gem install keyring

Then you can put something like this in `aptly-cli.conf`:

```yaml
:username: zane
:password: ${KEYRING}
```

The first time you run an `aptly-cli` command, you will be prompted to enter a
password.

    $ aptly-cli version
    Enter a value for password:
    ***************

The entered password will be stored in your keyring so that future uses of
`aptly-cli` can get the password from your keyring:

    $ aptly-cli version
    {"Version"=>"0.9.7"}

Also make sure that your config file isn't world readable (```chmod o-rw /etc/aptly-cli.conf```)

If a configuration file is not found, the defaults in the example
configuration file above will be used.

## Usage - available aptly-cli commands

The `--config` (`-c`) option allows specifying an alternative config file, e.g.:

    $ aptly-cli -c ~/.config/aptly-cli/aptly-cli.conf repo_list

The `--server`, `--username`, and `--password` options allow specifying
those things on the command-line and not even requiring a config file.

    $ aptly-cli --server 10.3.0.46 --username marca --password '${PROMPT_PASSWORD}' repo_list

Note that you can use `${PROMPT}`, `${PROMPT_PASSWORD}`, and `${KEYRING}` in
the values of these options, just as you can in a config file. Note that you
might have to quote them to prevent the shell from trying to expand them.

    $ aptly-cli --help
      NAME:

        aptly-cli

      DESCRIPTION:

        Aptly repository API client (https://github.com/sepulworld/aptly_cli)

      COMMANDS:

        file_delete        File delete
        file_list          List all directories
        file_upload        File upload
        graph              Download an svg or png graph of repository layout
        help               Display global or [command] help documentation
        publish_drop       Delete published repository
        publish_list       List published repositories
        publish_repo       Publish local repository or snapshot under specified prefix
        publish_update     Update published repository
        repo_create        Create a new repository, requires --name
        repo_delete        Delete a local repository, requires --name
        repo_edit          Edit a local repository metadata, requires --name
        repo_list          Show list of currently available local repositories
        repo_package_query List all packages or search on repo contents, requires --name
        repo_show          Returns basic information about local repository
        repo_upload        Import packages from files
        snapshot_create    Create snapshot, require --name
        snapshot_delete    Delete snapshot, require --name
        snapshot_diff      Calculate difference between two snapshots
        snapshot_list      Return list of all snapshots created in the system
        snapshot_search    List all packages in snapshot or perform search
        snapshot_show      Get information about snapshot by name
        snapshot_update    Update snapshot’s description or name
        version            Display aptly server version

      GLOBAL OPTIONS:

        -c, --config FILE
            Path to YAML config file

        -s, --server SERVER
            Host name or IP address of Aptly API server

        -p, --port PORT
            Port of Aptly API server
 
        --username USERNAME
            User name or '${PROMPT}'

        --password PASSWORD
            Password or '${PROMPT_PASSWORD}' or '${KEYRING}'

        --debug
            Enable debug output

        -h, --help
            Display help documentation

        -v, --version
            Display version information

        -t, --trace
            Display backtrace when an error occurs


### To see more options for each command

    $ aptly-cli <command> --help


## Development

### Measuring coverage locally

```
$ rake docker_pull
$ rake docker_run
$ bundle exec rake test
...
Coverage report generated for Unit Tests to /Users/marca/dev/git-repos/aptly_cli/coverage. 521 / 566 LOC (92.05%) covered.
[Coveralls] Outside the CI environment, not sending data.

$ open coverage/index.html
```

<img width="1426" alt="screen shot 2016-07-21 at 4 05 56 pm" src="https://cloud.githubusercontent.com/assets/305268/17042294/2f28f8f8-4f61-11e6-8a92-f0d921e36187.png">

### Rubocop syntax and style check

```bash
$ bundle exec rake rubocop
Running RuboCop...
Inspecting 24 files
WCCCWC..CCCC.CCC.WCWCCCC
...
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Ruby Minitest are implemented using a Docker container for functional tests.

Rake tasks available:

```bash
rake build                 # Build aptly_cli-<version>.gem into the pkg directory
rake clean                 # Remove any temporary products
rake clobber               # Remove any generated files
rake docker_build          # Docker build image
rake docker_list_aptly     # List Docker Aptly running containers
rake docker_pull           # Pull Docker image to Docker Hub
rake docker_push           # Push Docker image to Docker Hub
rake docker_restart        # Restart Aptly docker container
rake docker_run            # Start Aptly Docker container on port 8082
rake docker_show_logs      # Show running Aptly process Docker stdout logs
rake docker_stop           # Stop running Aptly Docker containers
rake install               # Build and install aptly_cli-<version>.gem into system gems
rake install:local         # Build and install aptly_cli-<version>.gem into system gems without network access
rake rubocop               # Run RuboCop
rake rubocop:auto_correct  # Auto-correct RuboCop offenses
rake test                  # Run tests
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/aptly_cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
