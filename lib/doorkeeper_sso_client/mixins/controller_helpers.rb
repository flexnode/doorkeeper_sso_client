module DoorkeeperSsoClient
  module Mixins
    module ControllerHelpers
      extend ActiveSupport::Concern

      def validate_passport!
        if sso_signed_in?
          sign_out(current_sso) unless current_sso.passport.try(:active?)
        end
        return true
      end
    end
  end
end
