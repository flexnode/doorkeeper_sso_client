require 'rails_helper'

#  DoorkeeperSsoClient::Mixins::ControllerHelpers automatically included into Devise::Controller::Helpers

RSpec.describe "DoorkeeperSsoClient::Mixins::ControllerHelpers", :type => :controller do
    controller(ApplicationController) do
      devise_group :sso, contains: [:user]

      before_filter :authenticate_user!
      before_filter :validate_passport!

      def index
        render nothing: :true
      end
    end

    let(:user) { Fabricate(:user) }
    let(:passport) { Fabricate(:passport, identity: user) }

    describe "before_filter#validate_passport!" do
      context "when user is logged in" do
        before(:each) do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          sign_in user
          get :index
        end

        context "with valid passport" do

          it "remain signed in" do
            expect(controller.user_signed_in?).to be_truthy
          end
        end
      end

      context "when user is logged out" do
        let(:passport) { Fabricate(:passport, identity: user, revoked_at: Time.now, revoke_reason: :logout ) }

        it "log out user" do
          expect(controller.user_signed_in?).to be_falsey
        end

      end
    end
end