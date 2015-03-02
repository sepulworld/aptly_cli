require 'aptly_cli/version'
require 'yaml'
require 'logger'

class AptlyLoad

  def initialize
    @log = Logger.new(STDOUT)
    @log.level = Logger::WARN
  
    # Configuration defaults
    @config = {
                :server => "127.0.0.1",
                :port => 8081
              }

    @valid_config_keys = @config.keys
  end

  # Configure through hash
  def configure(opts = {})
    opts.each {|k,v| config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
  end

  # Configure through yaml file
  def configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      @log.warn("YAML configuration file couldn't be found. Using defaults.") 
      return @config
    rescue Psych::SyntaxError
      @log.warn("YAML configuration file contains invalid syntax. Using defaults.")
      return @config 
    end
    
    configure(config)
  end

  def config
    @config
  end
end
