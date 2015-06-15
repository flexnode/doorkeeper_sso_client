require 'rails_helper'

RSpec.describe ::DoorkeeperSsoClient::Config do

  before(:each) do
    ::DoorkeeperSsoClient::Config.reset
  end

  pending "no config" do
    it { expect(::DoorkeeperSsoClient::Config.oauth_client_id).to raise_error }
  end

  context "with config" do

    before(:each) do
      ::DoorkeeperSsoClient::Config.reset
      ::DoorkeeperSsoClient::Config.configure do |config|
        config[:oauth_client_id] = 123
        config[:oauth_client_secret] = 'abc'
        config[:base_uri] = 'http://localhost'
      end
    end

    describe "stores config" do
      it { expect(::DoorkeeperSsoClient::Config.oauth_client_id).to eq 123 }
      it { expect(::DoorkeeperSsoClient::Config.oauth_client_secret).to eq 'abc' }
      it { expect(::DoorkeeperSsoClient::Config.base_uri).to eq 'http://localhost' }
    end

    describe "have default values" do
      it { expect(::DoorkeeperSsoClient::Config.sessions_path).to eq '/sso/sessions' }
      it { expect(::DoorkeeperSsoClient::Config.passport_verification_timeout_ms).to eq 200 }
    end
  end
end