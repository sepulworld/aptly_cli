require 'minitest_helper.rb'
require 'minitest/autorun'

require 'aptly_cli'

module AptlyCli
  class AptlyCommand
    def ask(_prompt)
      'zane'
    end

    def password(_prompt)
      'secret'
    end
  end
end

describe AptlyCli::AptlyCommand do
  it 'has a default config' do
    config = AptlyCli::AptlyLoad.new.configure_with('/no/config')
    cmd = AptlyCli::AptlyCommand.new(config)
    cmd.config[:proto].must_equal 'http'
    cmd.config[:server].must_equal '127.0.0.1'
    cmd.config[:port].must_equal 8082
  end

  it 'accepts empty options and no config changes' do
    options = Options.new
    config = AptlyCli::AptlyLoad.new.configure_with('/no/config')
    cmd = AptlyCli::AptlyCommand.new(config, options)
    cmd.config[:proto].must_equal 'http'
    cmd.config[:server].must_equal '127.0.0.1'
    cmd.config[:port].must_equal 8082
  end

  it 'can take options and updates its config accordingly' do
    options = Options.new
    options.server = 'my-server'
    options.port = 9000
    options.username = 'me'
    options.password = 'secret'
    options.debug = true
    config = AptlyCli::AptlyLoad.new.configure_with('/no/config')
    cmd = AptlyCli::AptlyCommand.new(config, options)
    cmd.config[:server].must_equal 'my-server'
    cmd.config[:port].must_equal 9000
    cmd.config[:username].must_equal 'me'
    cmd.config[:password].must_equal 'secret'
    cmd.config[:debug].must_equal true
  end

  it 'can process an option with \'${PROMPT}\' in it' do
    options = Options.new
    options.username = '${PROMPT}'
    config = AptlyCli::AptlyLoad.new.configure_with('/no/config')
    cmd = AptlyCli::AptlyCommand.new(config, options)
    cmd.config[:username].must_equal 'zane'
  end

  it 'can process an option with \'${PROMPT_PASSWORD}\' in it' do
    options = Options.new
    options.username = '${PROMPT_PASSWORD}'
    config = AptlyCli::AptlyLoad.new.configure_with('/no/config')
    cmd = AptlyCli::AptlyCommand.new(config, options)
    cmd.config[:username].must_equal 'secret'
  end
end
