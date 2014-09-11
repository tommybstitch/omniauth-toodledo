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

      uid { raw_info["user"]["id"] }

      info do
        {
          :email    => raw_info["user"]["email"],
          :name     => raw_info["user"]["display_name"],
          :nickname => raw_info["user"]["username"],
          :image    => raw_info["user"]["avatar"]
        }
      end

      extra { raw_info }

      def raw_info
        @raw_info ||= access_token.get("http://api.toodledo.com/3/account/get.php").body.to_json
      end

    end
  end
end