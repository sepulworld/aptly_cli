require 'aptly_cli/version'
require 'yaml'
require 'logger'

module AptlyCli
  # Load aptly-cli configuration
  class AptlyLoad
    def config
      @config
    end

    def initialize
      @log = Logger.new(STDOUT)
      @log.level = Logger::WARN

      # Configuration defaults
      @config = {
        proto: 'http',
        server: '127.0.0.1',
        port: 8082
      }

      @valid_config_keys = @config.keys
    end

    # Configure through hash
    def configure(opts = {})
      opts.each do |k, v|
        config[k.to_sym] = v if @valid_config_keys.include? k.to_sym
      end
    end

    # Configure through yaml file
    def configure_with(path_to_yaml_file)
      begin
        config = YAML.load(IO.read(path_to_yaml_file))
      rescue Errno::ENOENT
        @log.warn(
          'YAML configuration file couldn\'t be found at /etc/aptly-cli.conf. Using defaults.')
        return @config
      rescue Psych::SyntaxError
        @log.warn(
          'YAML configuration file contains invalid syntax. Using defaults.')
        return @config
      end
      configure(config)
    end
  end
end
