require 'yaml'

module Cronenberg
  class Config
    REQUIRED_VALUES = {
      names: [:host, :user, :password],
      env_vars: ['VCENTER_SERVER', 'VCENTER_USER', 'VCENTER_PASSWORD'],
    }

    attr_reader :host, :user, :password, :datacenter, :insecure, :port, :ssl

    DEFAULT_CONFIG_LOCATION = File.join(Dir.home, '.vcenter.conf')

    def initialize(config_file_location=nil)
      settings = process_environment_variables || process_config_file(config_file_location || DEFAULT_CONFIG_LOCATION)
      if settings.nil?
        raise 'You must provide credentials in either environment variables or a config file.'
      else
        settings = settings.delete_if { |k, v| v.nil? }
        missing = REQUIRED_VALUES[:names] - settings.keys
        unless missing.empty?
          message = 'To use this module you must provide the following missing settings:'
          missing.each do |var|
            message += " #{var}"
          end
          raise message
        end
        @host = settings[:host]
        @user = settings[:user]
        @password = settings[:password]
        @datacenter = settings[:datacenter_name]
        @insecure = settings[:insecure].nil? ? false : settings[:insecure]
        @ssl = settings[:ssl].nil? ? true : settings[:ssl]
        @port = settings[:port]
      end

    end

    def process_environment_variables
      required = REQUIRED_VALUES[:env_vars]
      missing = required - ENV.keys
      if missing.size < required.size
        {
          host: ENV['VCENTER_SERVER'],
          user: ENV['VCENTER_USER'],
          password: ENV['VCENTER_PASSWORD'],
          datacenter_name: ENV['VCENTER_DATACENTER'],
          insecure: ENV['VCENTER_INSECURE'],
          port: ENV['VCENTER_PORT'],
          ssl: ENV['VCENTER_SSL'],
        }
      else
        nil
      end
    end



    def process_config_file(file_path)
      file_present = File.file?(file_path)
      unless file_present
        nil
      else
        begin
          configuration = YAML.load_file(file_path)
        rescue Psych::SyntaxError => e
          raise "Your configuration file at #{file_path} is invalid. The error from the YAML parser is:\n #{e.message}"
        end
        vsphere_config = configuration['vcenter']

        raise "Invalid configuration file, missing vcenter key." unless vsphere_config.keys.first == 'vcenter' 

        required = REQUIRED_VALUES[:names].map { |var| var.to_s }
        missing = required - vsphere_config.keys
        if missing.size < required.size
          {
            host: vsphere_config['host'],
            user: vsphere_config['user'],
            password: vsphere_config['password'],
            datacenter_name: vsphere_config['datacenter'],
            insecure: vsphere_config['insecure'],
            port: vsphere_config['port'],
            ssl: vsphere_config['ssl'],
          }
        else
          nil
        end
      end
    end
  end
end
