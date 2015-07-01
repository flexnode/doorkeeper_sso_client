module DoorkeeperSsoClient
  class Engine < ::Rails::Engine
    isolate_namespace DoorkeeperSsoClient

    # New test framework integration
    config.generators do |g|
      g.test_framework  :rspec,
                        :fixtures => true,
                        :view_specs => false,
                        :helper_specs => false,
                        :routing_specs => false,
                        :controller_specs => true,
                        :request_specs => false
      g.fixture_replacement :fabrication
    end

    config.before_initialize do
      if Object.const_defined?("Devise")
        ::Devise::Controllers::Helpers.send(:include, DoorkeeperSsoClient::Mixins::ControllerHelpers)
      end
    end
  end
end
