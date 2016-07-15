class AptlyCommand
  def initialize(config)
    @config = config

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
