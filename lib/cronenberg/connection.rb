require 'rbvmomi'
require 'cronenberg/config'

module Cronenberg
  class Cronenberg::Connection
    attr_reader :vim, :host, :user, :insecure, :ssl
    def config
      @@config = Cronenberg::Config.new
    end

    def initialize(credentials_override=nil)
      config
      credentials_builtin = {
        host: @@config.host,
        user: @@config.user,
        password: @@config.password,
        insecure: @@config.insecure,
        ssl: @@config.ssl,
      }
      credentials_builtin[:port] = config.port if config.port

      credentials = credentials_override || credentials_builtin

			begin
				@vim = RbVmomi::VIM.connect credentials
			rescue SocketError => e
				raise  "Unable to access vSphere. Check you have correctly passed in the server location via config file or environment variable. See README for further details. The error message from the API wrapper was: #{e.message}"
			end

        @host = credentials[:host]
        @user = credentials[:user]
        @insecure = credentials[:insecure]
        @ssl = credentials[:ssl]

    end
  end
end
