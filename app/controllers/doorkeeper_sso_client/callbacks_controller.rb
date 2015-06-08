require_dependency "doorkeeper_sso_client/application_controller"

module DoorkeeperSsoClient
  class CallbacksController < DoorkeeperSsoClient::ApplicationController

    def create
      if passport = ::DoorkeeperSsoClient::Passport.find_by_uid(passport_info["id"])
        passport.update_from_pingback(passport_info)
      end
      head :no_content
    end

  protected
    def passport_info
      params["object"]
    end

  end
end
