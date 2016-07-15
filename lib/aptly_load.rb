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

      @valid_config_keys = @config.keys + [:username, :password, :debug]
    end

    # Configure through hash
    def configure(opts = {})
      opts.each do |k, v|
        if v == '${PROMPT}'
          @config[k.to_sym] = ask("Enter a value for #{k}:")
        elsif v == '${PROMPT_PASSWORD}'
          @config[k.to_sym] = password("Enter a value for #{k}:")
        elsif @valid_config_keys.include? k.to_sym
          @config[k.to_sym] = v
        end
      end
      @config
    end

    # Configure through yaml file
    def configure_with(path_to_yaml_file)
      begin
        config = YAML.load(IO.read(path_to_yaml_file))
      rescue Errno::ENOENT
        @log.warn(
          "YAML configuration file couldn\'t be found at " \
           "#{path_to_yaml_file}. Using defaults.")
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
