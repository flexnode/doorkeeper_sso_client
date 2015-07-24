require 'mongoid'

module DoorkeeperSsoClient
  module Mixins
    module Mongoid
      module Passport
        extend ActiveSupport::Concern

        include ::Mongoid::Document
        include ::Mongoid::Timestamps
        include ::DoorkeeperSsoClient::Mixins::PassportBase

        included do
          field :identity_id, type: Integer
          field :identity_type, type: String
          field :secret, type: String
          field :state, type: String
          field :chip, type: String
          field :verified, type: Boolean, default: false
          field :modified, type: Boolean, default: false
          field :created_at, type: DateTime
          field :updated_at, type: DateTime
          field :uid, type: String
          field :token, type: String
          field :refresh_token, type: String
          field :token_expiry, type: DateTime
          field :revoked_at, type: DateTime
          field :revoke_reason, type: String
          field :last_login_at, type: DateTime
        end

        module ClassMethods
          def find_by_uid(uid)
            passport = where(uid: uid).first
          end
        end # ClassMethods
      end # Passport
    end # Mongoid
  end # Mixins
end # DoorkeeperSsoClient
