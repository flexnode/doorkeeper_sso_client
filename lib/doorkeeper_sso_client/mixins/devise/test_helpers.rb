module DoorkeeperSsoClient
  module Mixins
    module Devise
      module TestHelpers
        extend ActiveSupport::Concern

        def sign_out(resource_or_scope=nil)
          @controller.sign_out(resource_or_scope)
          super
        end
      end # TestHelpers
    end
  end # Mixins
end # DoorkeeperSsoClient
