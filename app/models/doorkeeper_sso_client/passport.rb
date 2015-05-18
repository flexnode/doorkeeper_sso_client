module DoorkeeperSsoClient
  class Passport < ActiveRecord::Base
    belongs_to :identity, polymorphic: true

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
