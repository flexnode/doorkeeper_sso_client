module DoorkeeperSsoClient
  module Mixins
    module ControllerHelpers
      extend ActiveSupport::Concern

      module ClassMethods
        def activate_sso(scope, options = {})
          devise_group :sso, contains: [scope]

          unless options[:skip_devise_hook]
            class_eval <<-METHODS, __FILE__, __LINE__ + 1
              def authenticate_#{scope}!
                validate_passport!
                super
              end
            METHODS
          end
        end
      end

      def validate_passport!
        if sso_signed_in?
          sign_out(current_sso) unless current_sso.passport.try(:active?)
        end
        return true
      end

    end
  end
end
