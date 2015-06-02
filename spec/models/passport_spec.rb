require 'rails_helper'

RSpec.describe DoorkeeperSsoClient::Passport, :type => :model do
  let(:user) { Fabricate(:user) }

  describe "associations" do
    it { is_expected.to belong_to(:identity) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_uniqueness_of(:uid) }
  end

end