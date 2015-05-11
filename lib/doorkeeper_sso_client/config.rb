module DoorkeeperSsoClient
  # Temporary hardcoded config module
  module Config
    class << self
      def oauth_client_id
        'rGBTeeZTzTN72KtmdPzms8h53gFx29EB2lE3jseW'
      end

      def oauth_client_secret
        'RFw8gp8WnuSlLdgQC5yuEKJO1mYEx7xGLzCaTrgJ'
      end

      def passport_verification_timeout_ms
        100
      end
    end
  end
end
