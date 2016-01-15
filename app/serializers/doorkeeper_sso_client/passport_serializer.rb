module DoorkeeperSsoClient
  class PassportSerializer < ActiveModel::Serializer
    attributes :mobile_token, :session_id, :email, :first_name, :last_name, :uid

    def session_id
      object.uid
    end

    def email
      object.identity.email
    end

    def first_name
      object.identity.first_name
    end

    def last_name
      object.identity.last_name
    end

    def uid
      object.identity.uid
    end

  end
end
