module DoorkeeperSsoClient
  class Passport < ActiveRecord::Base
    belongs_to :identity, polymorphic: true

    validates :uid, presence: true, uniqueness: true

    def self.create_from_omniauth(auth_hash)
      passport = where(uid: auth_hash["extra"]["passport_id"]).first_or_initialize
      passport.update_attributes!(
        secret: auth_hash["extra"]["passport_secret"],
        token: auth_hash["credentials"]["token"],
        refresh_token: auth_hash["credentials"]["refresh_token"],
        token_expiry:  auth_hash["credentials"]["expiry"],
        revoked_at: nil,
        revoke_reason: nil,
        last_login_at: Time.current
      )
    end

    def update_from_pingback(pingback_hash)
      update_attributes!(
        revoked_at: pingback_hash["revoked_at"],
        revoke_reason: pingback_hash["revoke_reason"],
        last_login_at: pingback_hash["activity_at"]
      )
    end

    def verified!
      update_column(:verified, true)
    end

    def unverified?
      !verified?
    end

    def modified!
      update_column(:modified, true)
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
  end
end

# == Schema Information
# Schema version: 20150603155315
#
# Table name: sso_client_passports
#
#   t.integer  "identity_id"
#   t.string   "identity_type"
#   t.string   "secret"
#   t.string   "state"
#   t.string   "chip"
#   t.string   "user"
#   t.boolean  "verified",      default: false
#   t.boolean  "modified",      default: false
#   t.datetime "created_at",                    null: false
#   t.datetime "updated_at",                    null: false
#   t.integer  "expiry"
#   t.string   "uid",                           null: false
#   t.string   "token"
#   t.string   "refresh_token"
#   t.integer  "token_expiry"
#   t.datetime "revoked_at"
#   t.string   "revoke_reason"
#   t.datetime "last_login_at"
