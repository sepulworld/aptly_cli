class AptlyCommand
  def initialize(config, options = nil)
    @config = config
    options ||= Options.new

    if options.server
      @config[:server] = options.server
    end

    if options.username
      @config[:username] = options.username
    end

    if options.password
      @config[:password] = options.password
    end

    if options.debug
      @config[:debug] = options.debug
    end

    @config.each do |k, v|
      if v == '${PROMPT}'
        @config[k.to_sym] = ask("Enter a value for #{k}:")
      elsif v == '${PROMPT_PASSWORD}'
        @config[k.to_sym] = password("Enter a value for #{k}:")
      elsif v == '${KEYRING}'
        require 'keyring'

        keyring = Keyring.new
        value = keyring.get_password(@config[:server], @config[:username])

        unless value
          # Prompt for password...
          value = password("Enter a value for #{k}:")

          # ... and store in keyring
          keyring.set_password(@config[:server], @config[:username], value)
        end

        @config[k.to_sym] = value
      end
    end

    base_uri = "#{@config[:proto]}://#{@config[:server]}:#{@config[:port]}/api"
    self.class.base_uri base_uri

    if @config[:username]
      if @config[:password]
        self.class.basic_auth @config[:username].to_s, @config[:password].to_s
      end
    end
    debug_output $stdout if @config[:debug] == true
  end
end
