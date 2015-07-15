module DoorkeeperSsoClient
  module Mixins
    module Devise
      module ControllerHelpers
        extend ActiveSupport::Concern

        module ClassMethods
          def activate_sso(scope, options = {})
            class_eval <<-METHODS, __FILE__, __LINE__ + 1
              def validate_passport!
                if #{scope}_signed_in? and !current_#{scope}.passports.find_by_uid(session['passport_id']).try(:active?)
                  sign_out(current_#{scope})
                end
                return true
              end

              def after_sign_out_path_for(resource_or_scope)
                return File.join( DoorkeeperSsoClient::Config.base_uri, "logout?app_id=" + DoorkeeperSsoClient::Config.oauth_client_id.to_s ) if scope_match? resource_or_scope, :#{scope}
                super
              end

              def after_sign_in_path_for(resource_or_scope)
                if scope_match? resource_or_scope, :#{scope}
                  request.env['omniauth.origin'] || super
                else
                  super
                end
              end

              def sign_out(resource_or_scope=nil)
                if scope_match? resource_or_scope, :#{scope}
                  session['passport_id'] = nil
                end
                super
              end

              def sign_out_all_scopes(lock=true)
                session['passport_id'] = nil
                super
              end

              def scope_match?(resource_or_scope, scope_sym)
                scope = ::Devise::Mapping.find_scope!(resource_or_scope)
                return scope == scope_sym
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
