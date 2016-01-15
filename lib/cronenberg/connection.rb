require 'rbvmomi'
require 'cronenberg/config'

module Cronenberg
  class Cronenberg::Connection
    attr_reader :vim, :host, :user, :insecure, :ssl

    CONFIG = Cronenberg::Config.new

    def initialize(credentials_override=nil)
      credentials_builtin = {
        host: CONFIG.host,
        user: CONFIG.user,
        password: CONFIG.password,
        insecure: CONFIG.insecure,
        ssl: CONFIG.ssl,
      }
      credentials_builtin[:port] = CONFIG.port if CONFIG.port

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
