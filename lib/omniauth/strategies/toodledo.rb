require 'omniauth/strategies/oauth2'
require 'base64'
require 'openssl'
require 'rack/utils'
require 'uri'

module OmniAuth
  module Strategies
    class Toodledo < OmniAuth::Strategies::OAuth2

      option :name, :toodledo

      option :client_options, {
        :site          => 'https://api.toodledo.com',
        :authorize_url => '/3/account/authorize.php',
        :token_url     => '/3/account/token.php'
      }

      uid { raw_info["userid"] }
      
      info do
        {
          :email    => raw_info["email"],
          :name     => raw_info["alias"],
          :nickname => raw_info["alias"]
        }
      end
      

      extra { raw_info }
      
      def raw_info
        @raw_info ||= JSON.parse(access_token.get("http://api.toodledo.com/3/account/get.php").body)
        
        Rails.logger.info "*************"
        Rails.logger.info @raw_info
        Rails.logger.info @raw_info.class
      end
    end
  end
end