module DoorkeeperSsoClient
  module Warden
    module Hooks
      # This is a helpful `Warden::Manager.after_fetch` hook for Alpha and Beta.
      # Whenever Carol is fetched out of the session, we also verify her resource.
      #
      # Usage:
      #
      #   SSO::Client::Warden::Hooks::AfterFetch.activate scope: :vip
      #
      class AfterFetch
        include DoorkeeperSso::Client::Logging

        attr_reader :resource, :warden, :options
        delegate :request, to: :warden
        delegate :params, to: :request

        def self.activate(warden_options)
          ::Warden::Manager.after_fetch(warden_options) do |resource, warden, options|
            self.new(resource, warden, options).call
          end
        end

        def initialize(resource, warden, options)
          @resource, @warden, @options = resource, warden, options
        end

        def call
          return unless resource.is_a?(Session)
          verify

        rescue ::Timeout::Error
          error { 'SSO Server timed out. Continuing with last known authentication/authorization...' }
          Operations.failure :server_request_timed_out

        rescue => exception
          raise exception
          Operations.failure :client_exception_caught
        end

        private

        def verifier
          ::DoorkeeperSsoClient::PassportVerifier.new resource_id: resource.id, resource_state: resource.state, resource_secret: resource.secret, user_ip: ip, user_agent: agent, device_id: device_id
        end

        def verification
          @verification ||= verifier.call
        end

        def verification_code
          verification.code
        end

        def verification_object
          verification.object
        end

        def verify
          debug { "Validating Passport #{resource.id.inspect} of logged in #{resource.user.class} in scope #{warden_scope.inspect}" }

          case verification_code
          when :server_unreachable                    then server_unreachable!
          when :server_response_not_parseable         then server_response_not_parseable!
          when :server_response_missing_success_flag  then server_response_missing_success_flag!
          when :resource_valid                        then resource_valid!
          when :resource_valid_and_modified           then resource_valid_and_modified!(verification.object)
          when :resource_invalid                      then resource_invalid!
          else                                             unexpected_server_response_status!
          end
        end

        def resource_valid_and_modified!(modified_resource)
          debug { 'Valid resource, but state changed' }
          resource.verified!
          resource.modified!
          resource.user = modified_resource.user
          resource.state = modified_resource.state
          Operations.success :valid_and_modified
        end

        def resource_valid!
          debug { 'Valid resource, no changes' }
          resource.verified!
          Operations.success :valid
        end

        def resource_invalid!
          info { 'Your Passport is not valid any more.' }
          warden.logout warden_scope
          Operations.failure :invalid
        end

        def server_unreachable!
          error { "SSO Server responded with an unexpected HTTP status code (#{verification_code.inspect} instead of 200). #{verification_object.inspect}" }
          Operations.failure :server_unreachable
        end

        def server_response_missing_success_flag!
          error { 'SSO Server response did not include the expected success flag.' }
          Operations.failure :server_response_missing_success_flag
        end

        def unexpected_server_response_status!
          error { "SSO Server response did not include a known resource status code. #{verification_code.inspect}" }
          Operations.failure :unexpected_server_response_status
        end

        def server_response_not_parseable!
          error { 'SSO Server response could not be parsed at all.' }
          Operations.failure :server_response_not_parseable
        end

        # TODO: Use ActionDispatch remote IP or you might get the Load Balancer's IP instead :(
        def ip
          request.ip
        end

        def agent
          request.user_agent
        end

        def device_id
          params['device_id']
        end

        def warden_scope
          options[:scope]
        end

      end
    end
  end
end
