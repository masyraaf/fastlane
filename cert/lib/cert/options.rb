require 'fastlane_core'
require 'credentials_manager'

module Cert
  class Options
    def self.available_options
      user = CredentialsManager::AppfileConfig.try_fetch_value(:apple_dev_portal_id)
      user ||= CredentialsManager::AppfileConfig.try_fetch_value(:apple_id)

      [
        FastlaneCore::ConfigItem.new(key: :development,
                                     env_name: "CERT_DEVELOPMENT",
                                     description: "Create a development certificate instead of a distribution one",
                                     is_string: false,
                                     default_value: false),
        FastlaneCore::ConfigItem.new(key: :force,
                                     env_name: "CERT_FORCE",
                                     description: "Create a certificate even if an existing certificate exists",
                                     is_string: false,
                                     default_value: false),
        FastlaneCore::ConfigItem.new(key: :username,
                                     short_option: "-u",
                                     env_name: "CERT_USERNAME",
                                     description: "Your Apple ID Username",
                                     default_value: user),
        FastlaneCore::ConfigItem.new(key: :team_id,
                                     short_option: "-b",
                                     env_name: "CERT_TEAM_ID",
                                     default_value: CredentialsManager::AppfileConfig.try_fetch_value(:team_id),
                                     description: "The ID of your team if you're in multiple teams",
                                     optional: true,
                                     verify_block: proc do |value|
                                       ENV["FASTLANE_TEAM_ID"] = value
                                     end),
        FastlaneCore::ConfigItem.new(key: :team_name,
                                     short_option: "-l",
                                     env_name: "CERT_TEAM_NAME",
                                     description: "The name of your team if you're in multiple teams",
                                     optional: true,
                                     default_value: CredentialsManager::AppfileConfig.try_fetch_value(:team_name),
                                     verify_block: proc do |value|
                                       ENV["FASTLANE_TEAM_NAME"] = value
                                     end),
        FastlaneCore::ConfigItem.new(key: :output_path,
                                     short_option: "-o",
                                     env_name: "CERT_OUTPUT_PATH",
                                     description: "The path to a directory in which all certificates and private keys should be stored",
                                     default_value: "."),
        FastlaneCore::ConfigItem.new(key: :keychain_path,
                                     short_option: "-k",
                                     env_name: "CERT_KEYCHAIN_PATH",
                                     description: "Path to a custom keychain",
                                     default_value: Dir["#{Dir.home}/Library/Keychains/login.keychain"].last,
                                     verify_block: proc do |value|
                                       value = File.expand_path(value)
                                       UI.user_error!("Keychain not found at path '#{value}'") unless File.exist?(value)
                                     end)
      ]
    end
  end
end
