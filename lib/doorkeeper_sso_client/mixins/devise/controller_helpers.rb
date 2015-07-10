module DoorkeeperSsoClient
  module Mixins
    module Devise
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

              def after_sign_out_path_for(resource_or_scope)
                scope = ::Devise::Mapping.find_scope!(resource_or_scope)
                if scope == :#{scope}
                 return File.join( DoorkeeperSsoClient::Config.base_uri, "logout?app_id=" + DoorkeeperSsoClient::Config.oauth_client_id.to_s )
                end
                super
              end

              def after_sign_in_path_for(resource_or_scope)
                scope = ::Devise::Mapping.find_scope!(resource_or_scope)
                if scope == :#{scope}
                  request.env['omniauth.origin'] || super
                else
                  super
                end
              end
            METHODS

            unless options[:skip_devise_hook]
              class_eval <<-METHODS, __FILE__, __LINE__ + 1
                def authenticate_#{scope}!
                  store_location_for(:#{scope}, request.original_url)
                  validate_passport!
                  redirect_to DoorkeeperSsoClient::Config.oauth_login_path unless #{scope}_signed_in?
                end
              METHODS
            end
          end
        end
      end # ControllerHelpers
    end
  end # Mixins
end # DoorkeeperSsoClient
