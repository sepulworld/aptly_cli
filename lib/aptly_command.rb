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

    @config.each do |k, v|
      if v == '${PROMPT}'
        @config[k.to_sym] = ask("Enter a value for #{k}:")
      elsif v == '${PROMPT_PASSWORD}'
        @config[k.to_sym] = password("Enter a value for #{k}:")
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
