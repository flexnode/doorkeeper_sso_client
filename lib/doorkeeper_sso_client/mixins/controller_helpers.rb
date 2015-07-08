module DoorkeeperSsoClient
  module Mixins
    module ControllerHelpers
      extend ActiveSupport::Concern

      module ClassMethods
        def activate_sso(scope, options = {})

          class_eval <<-METHODS, __FILE__, __LINE__ + 1
            def validate_passport!
              if #{scope}_signed_in?
                sign_out(current_#{scope}) unless current_#{scope}.passport.try(:active?)
              end
              return true
            end
          METHODS

          unless options[:skip_devise_hook]
            class_eval <<-METHODS, __FILE__, __LINE__ + 1
              def authenticate_#{scope}!
                store_location_for(:#{scope}, stored_location_for(:#{scope}) || request.original_url)
                validate_passport!
                redirect_to DoorkeeperSsoClient::Config.oauth_login_path unless #{scope}_signed_in?
              end
            METHODS
          end
        end
      end
    end
  end
end
