module DoorkeeperSsoClient
  module Mixins
    module PassportBase
      extend ActiveSupport::Concern

      included do
        belongs_to :identity, polymorphic: true
        validates :uid, presence: true, uniqueness: true

        before_save :ensure_mobile_token
      end

      module ClassMethods
        def create_from_omniauth(auth_hash)
          uid = { uid: auth_hash["extra"]["passport_id"] }
          passport = where(uid).first || new(uid)
          passport.update_attributes!(
            secret: auth_hash["extra"]["passport_secret"],
            token: auth_hash["credentials"]["token"],
            refresh_token: auth_hash["credentials"]["refresh_token"],
            token_expiry:  auth_hash["credentials"]["expiry"],
            revoked_at: nil,
            revoke_reason: nil,
            last_login_at: Time.current,
            client_uid: auth_hash["extra"]["client_id"]
          )
        end
      end # ClassMethods

      def update_from_pingback(pingback_hash)
        update_attributes!(
          revoked_at: pingback_hash["revoked_at"],
          revoke_reason: pingback_hash["revoke_reason"],
          last_login_at: pingback_hash["activity_at"]
        )
      end

      def verified!
        update_attribute(:verified, true)
      end

      def unverified?
        !verified?
      end

      def modified!
        update_attribute(:modified, true)
      end

      def unmodified?
        !modified?
      end

      def delta
        { state: state, user: user }
      end

      def active?
        revoked_at.blank?
      end

     private
      def ensure_mobile_token
        self.mobile_token ||= SecureRandom.hex
      end

    end # Passport
  end # Mixins
end # DoorkeeperSsoClient
