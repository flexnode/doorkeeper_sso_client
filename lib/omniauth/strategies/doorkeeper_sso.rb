require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class DoorkeeperSso < OmniAuth::Strategies::OAuth2
      option :name, :doorkeeper_sso
      option :client_options, {
        site: 'https://sso.example.com',
        authorize_path: '/oauth/authorize',
        sso_sessions_path: '/sso/sessions',
        user_info_path: nil
      }

      option :fields, [:email, :name, :first_name, :last_name]
      option :uid_field, :id

      uid do
        user_info[options.uid_field.to_s]
      end

      info do
        options.fields.inject({}) do |hash, field|
          hash[field] = user_info[field.to_s]
          hash
        end
      end

      extra do
        {
          :passport_id     => passport_info["id"],
          :passport_secret => passport_info["secret"]
        }
      end

      def user_info
        @user_info ||=  if options.client_options.user_info_path
                          access_token.get(options.client_options.user_info_path).parsed["response"]
                        else
                          passport_info["owner"]
                        end
      end

      def passport_info
        params = { ip: request.ip, agent: request.user_agent }
        @passport_info ||= access_token.post(options.client_options.sso_sessions_path, params: params).parsed
      end

      def call_app!
        create_passport
        session[:passport_id] = env['omniauth.auth']['extra']['passport_id']
        super
      end

    protected
      def create_passport
        ::DoorkeeperSsoClient::Passport.create_from_omniauth(env['omniauth.auth'])
      end

    end
  end
end
