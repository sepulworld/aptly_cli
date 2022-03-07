module AptlyCli
  class HttpError < StandardError; end
  class HttpNotFoundError < HttpError; end
  class HttpInternalServerError < HttpError; end

  class AptlyCommand
    include HTTParty

    attr_accessor :config
    def initialize(config, options = nil)
      @config = config
      options ||= Options.new

      if options.server
        @config[:server] = options.server
      end

      if options.port
        @config[:port] = options.port
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
          keychain_item_name = 'Aptly API server at ' + \
                               @config[:server] + ':' + @config[:port].to_s
          value = keyring.get_password(keychain_item_name, @config[:username])

          unless value
            # Prompt for password...
            value = password("Enter a value for #{k}:")

            # ... and store in keyring
            keyring.set_password(keychain_item_name, @config[:username], value)
          end

          @config[k.to_sym] = value
        end
      end

      base_uri = "#{@config[:proto]}://#{@config[:server]}:#{@config[:port]}" \
                 '/api'
      self.class.base_uri base_uri

      if @config[:username]
        if @config[:password]
          self.class.basic_auth @config[:username].to_s, @config[:password].to_s
        end
      end

      self.class.debug_output @config[:debug] ? $stdout : nil
    end

    def delete(path, options = {})
      response = self.class.delete(path, options)
      process_response(response)
    end

    def get(path, options = {})
      response = self.class.get(path, options)
      process_response(response)
    end

    def post(path, options = {})
      response = self.class.post(path, options)
      process_response(response)
    end

    def put(path, options = {})
      response = self.class.put(path, options)
      process_response(response)
    end

    def process_response(response)
      json_response = JSON.parse response.body

      raise "[Server] #{json_response['error']}" unless !json_response.is_a?(Hash) || json_response.dig('error').nil?

      raise HttpNotFoundError, "[HTTP Not Found Error] JSON response:\n#{json_response}" if response.code == 404
      raise HttpInternalServerError, "[HTTP Internal Server Error] JSON response:\n#{json_response}" if response.code == 500

      response
    rescue JSON::ParserError
      raise HttpNotFoundError, "[HTTP Not Found Error] Response:\n#{response.body}" if response.code == 404
      raise HttpInternalServerError, "[HTTP Internal Server Error] Response:\n#{response.body}" if response.code == 500

      response
    end
  end
end
