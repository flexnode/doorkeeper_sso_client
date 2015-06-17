require 'rails_helper'

RSpec.describe DoorkeeperSsoClient::Config, :type => :model do
  before(:each) do
    DoorkeeperSsoClient::Config.oauth_client_id = 123
    DoorkeeperSsoClient::Config.oauth_client_secret = 'abc'
    DoorkeeperSsoClient::Config.base_uri = 'http://localhost'
  end

  describe "stores config" do
    it { expect(DoorkeeperSsoClient::Config.oauth_client_id).to eq 123 }
    it { expect(DoorkeeperSsoClient::Config.oauth_client_secret).to eq 'abc' }
    it { expect(DoorkeeperSsoClient::Config.base_uri).to eq 'http://localhost' }
  end

  describe "have default values" do
    it { expect(DoorkeeperSsoClient::Config.sessions_path).to eq '/sso/sessions' }
    it { expect(DoorkeeperSsoClient::Config.passport_verification_timeout_ms).to eq 200 }
  end

end