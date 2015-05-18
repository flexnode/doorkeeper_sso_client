require 'rails_helper'

RSpec.describe DoorkeeperSsoClient::Passport, :type => :model do
  let(:user) { Fabricate(:user) }

  describe "associations" do
    it { is_expected.to belong_to(:identity) }
  end
end