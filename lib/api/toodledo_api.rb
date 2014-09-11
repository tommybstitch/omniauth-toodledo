module Fatsecret
  class Api <  OmniAuth::Strategies::Toodledo
    option :client_options, {
      :scheme       => :query_string,
      :http_method  => :get
    }
  
    def api_call consumer_key, consumer_secret, params, auth_token="", auth_secret=""
      request = build_request(consumer_key, consumer_secret, auth_token, auth_secret)
      request_params = uri(params)
      request.get "http://platform.fatsecret.com/rest/server.api?#{ request_params }"
    end

    def uri params
      normalize = OAuth::Helper.normalize(params)
    end

    def build_request consumer_key, consumer_secret, auth_token, auth_secret
      fatsecret = Fatsecret::Api.new :fatsecret, consumer_key, consumer_secret
      access_token = OAuth::AccessToken.new fatsecret.consumer, auth_token, auth_secret
    end
  end
end