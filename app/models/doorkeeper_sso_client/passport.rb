module DoorkeeperSsoClient
  class Passport < ActiveRecord::Base
    belongs_to :identity, polymorphic: true

    validates :uid, presence: true, uniqueness: true

    def self.create_from_omniauth(auth_hash)
      create!(
        uid: auth_hash["extra"]["passport_id"],
        secret: auth_hash["extra"]["passport_secret"],
        token: auth_hash["credentials"]["token"],
        refresh_token: auth_hash["credentials"]["refresh_token"],
        token_expiry:  auth_hash["credentials"]["expiry"]
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
  end
end
