require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class DoorkeeperSso < OmniAuth::Strategies::OAuth2
      option :name, :doorkeeper_sso
      option :client_options, {
        site: 'https://sso.example.com',
        authorize_path: '/oauth/authorize',
        sso_sessions_path: '/sso/sessions'
      }

      option :fields, [:email, :name, :first_name, :last_name]
      option :uid_field, :id

      uid do
        user_info[options.uid_field.to_s]
      end

      info do
        hash = {
                  sso:
                      {
                        :id => session_info["id"],
                        :secret => session_info["secret"]
                      }
               }

        options.fields.each do |field|
          hash[field] = user_info[field.to_s]
        end
        hash
      end

      def user_info
        @user_info ||= access_token.get('/client_api/1/profile').parsed["response"]
      end

      def session_info
        params = { ip: request.ip, agent: request.user_agent }
        @session_info ||= access_token.post(options.client_options.sso_sessions_path, params: params).parsed
      end
    end
  end
end
