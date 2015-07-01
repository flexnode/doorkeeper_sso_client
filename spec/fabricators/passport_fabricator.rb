Fabricator('DoorkeeperSsoClient::Passport') do
  uid { SecureRandom.uuid }
  secret { SecureRandom.uuid }
  token  { SecureRandom.urlsafe_base64(64) }
end
