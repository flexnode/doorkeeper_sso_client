require 'doorkeeper_sso_client/mixins/devise/controller_helpers'
require 'doorkeeper_sso_client/mixins/devise/test_helpers'
require 'doorkeeper_sso_client/mixins/passport_base'

module DoorkeeperSsoClient
  module Mixins
    module Mongoid
      autoload :Passport, 'doorkeeper_sso_client/mixins/mongoid/passport'
    end
  end
end

