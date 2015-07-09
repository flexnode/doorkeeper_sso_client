::DoorkeeperSsoClient::Config.configure do |config|
  config[:oauth_client_id] = 123
  config[:oauth_client_secret] = 'abc'
  config[:base_uri] = 'http://sso_server.com'
end
