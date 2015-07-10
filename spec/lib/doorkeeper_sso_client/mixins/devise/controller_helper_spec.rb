require 'rails_helper'

#  DoorkeeperSsoClient::Mixins::ControllerHelpers automatically included into Devise::Controller::Helpers

RSpec.describe "DoorkeeperSsoClient::Mixins::Devise::ControllerHelpers DeviseHook", :type => :controller do
  controller(ApplicationController) do
    include DoorkeeperSsoClient::Mixins::Devise::ControllerHelpers

    activate_sso :user
    before_filter :authenticate_user!

    def index
      render nothing: :true
    end
  end

  let(:passport) { Fabricate('DoorkeeperSsoClient::Passport', identity: Fabricate(:user)) }
  let(:user) { passport.identity }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    get :index
  end

  describe "::activate_sso" do

    context "with valid passport" do
      it "remain signed in" do
        expect(controller.user_signed_in?).to be_truthy
      end
    end

    context "with invalid passport" do
      let(:passport) { Fabricate('DoorkeeperSsoClient::Passport', identity: Fabricate(:user), revoked_at: Time.now, revoke_reason: :logout ) }
      it "automatically signed out" do
        expect(controller.user_signed_in?).to be_falsey
      end

      it "redirects to Omniauth strategy" do
        expect(response).to redirect_to("http://test.host/auth/doorkeeper_sso")
      end

      it "stores origin location" do
        expect(controller.stored_location_for(:user)).to eq "/anonymous"
      end
    end
  end


  describe "#after_sign_out_path_for" do
    # Will redirect to sso server to completely logout user
    it { expect(controller.after_sign_out_path_for(:user)).to eq "http://sso_server.com/logout?app_id=123" }
  end


  describe "#after_sign_in_path_for" do
    # Will redirect to request.env['omniauth.origin']
    context "has omniauth.origin" do
      before(:each) do
        mock_env = @request.env.merge 'omniauth.origin' => "http://localhost/profile"
        allow(@request).to receive(:env).and_return(mock_env)
      end

      it { expect(controller.after_sign_in_path_for(:user)).to eq "http://localhost/profile" }
    end

    describe "omniauth.origin env missing" do
      it { expect(controller.after_sign_in_path_for(:user)).to eq "/anonymous" }
    end
  end

end



RSpec.describe "DoorkeeperSsoClient::Mixins::Devise::ControllerHelpers SkipDeviseHook", :type => :controller do
  controller(ApplicationController) do
    include DoorkeeperSsoClient::Mixins::Devise::ControllerHelpers

    activate_sso :user, :skip_devise_hook => true
    before_filter :authenticate_user!

    def index
      render nothing: :true
    end
  end

  let(:passport) { Fabricate('DoorkeeperSsoClient::Passport', identity: Fabricate(:user)) }
  let(:user) { passport.identity }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    get :index
  end

  describe "#validate_passport!" do
    context "with valid passport" do
      it "remain signed in" do
        expect(controller.user_signed_in?).to be_truthy
      end
    end

    context "with invalid passport" do
      let(:passport) { Fabricate('DoorkeeperSsoClient::Passport', identity: Fabricate(:user), revoked_at: Time.now, revoke_reason: :logout ) }
      it "remain signed in" do
        expect(controller.user_signed_in?).to be_truthy
      end

      it "sign out when manually validate_passport!" do
        controller.validate_passport!
        expect(controller.user_signed_in?).to be_falsey
      end
    end
  end
end