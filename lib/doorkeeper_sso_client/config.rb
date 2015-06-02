module DoorkeeperSsoClient
  # Temporary hardcoded config module
  class Config
    class << self
      def oauth_client_id
        '728e16975b9e7a7ee367bb2955ea2b00c128c10af59c50078284cac4bc07f64b'
      end

      def oauth_client_secret
        '2a18753ae2e0fb642016e81ac9fcbeed1a9b9caaf44582c4cac2906a10d56b93'
      end

      def passport_verification_timeout_ms
        100
      end

      def base_uri
        'http://localhost:3002'
      end

      def sessions_path
        '/sso/sessions'
      end
    end
  end
end
