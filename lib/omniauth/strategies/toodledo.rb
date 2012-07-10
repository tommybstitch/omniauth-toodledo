require 'digest'
require 'multi_json'
require 'rest-client'
require 'omniauth'

module OmniAuth
  module Strategies
    class Toodledo
      include OmniAuth::Strategy

      option :fields, [:email, :password]
      option :app_id, nil
      option :app_token, nil

      attr_accessor :token

      option :client_options, {
        :authorize_path => '/2/account/token.php',
        :lookup_path => '/2/account/lookup.php',
        :account_info_path => '/2/account/get.php',
        :site => "http://api.toodledo.com",
      }

      def request_phase
        form = OmniAuth::Form.new(:title => "User Info", :url => callback_path)
        options.fields.each do |field|
          form.text_field field.to_s.capitalize.gsub("_", " "), field.to_s
        end
        form.button "Sign In"
        form.to_response
      end

      def callback_phase
        self.token = nil
        @email = request.params['email']
        password = request.params['password']
        if @email.nil? or @email.empty? or password.nil? or password.empty?
          return fail!(:no_credentials, 'No Credentials')
        end

        begin
          uid = get_user_id @email, password
          session_token = get_session_token uid, password
          self.token = get_authentication_token(password, session_token)
        rescue ::RestClient::Exception
          raise ::Timeout::Error
        end
        super
      end

      def get_json(path, params)
        query_string = params.map{
          |key, value|
          "#{key}=#{Rack::Utils.escape(value)}"
        }.join(";")
        respone = RestClient.get(
          "#{options.client_options.site}#{path}?#{query_string}"
        )
        MultiJson.decode(respone.to_s)
      end

      def get_user_id(email, password)
        params = {
          :appid => options.app_id,
          :email => email,
          :pass => password,
          :sig => sigature(email + options.app_token)
        }
        get_json("#{options.client_options.lookup_path}",
                 params)['userid']
      end

      def get_session_token(uid, password)
        params = {
          :userid => uid,
          :appid => options.app_id,
          #:vers => 21,
          #:devise => 'iphone4s',
          #:os => 51,
          :pass => password,
          :sig => sigature(uid + options.app_token)
        }
        get_json("#{options.client_options.authorize_path}", params)['token']
      end

      def get_authentication_token(password, session_token)
        sigature(sigature(password) + options.app_token + session_token)
      end

      def sigature(string)
        Digest::MD5.hexdigest(string)
      end

      def raw_info
          params = { :key => self.token }
          @raw_info ||= get_json(
            "#{options.client_options.account_info_path}",
            params
          )
      end

      uid { raw_info['userid'] }

      info do
        { :name => raw_info['alias'],
          :email => @email,
          :nickname => raw_info['alias'] }
      end

      extra { { :raw_info => raw_info } }

      credentials { { :token => self.token } }
    end
  end
end
