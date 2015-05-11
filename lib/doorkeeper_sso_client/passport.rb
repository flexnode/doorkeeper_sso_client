module DoorkeeperSsoClient
  class Passport

    attr_reader :id, :secret, :chip
    attr_accessor :state, :user

    def initialize(options = {})
      options = ActionController::Parameters.new(options)
      options.require(:id, :secret, :state, :user)
      options.permit(:chip)

      options.each { |k,v| instance_variable_set("@#{k}",v) }
    end

    def verified!
      @verified = true
    end

    def verified?
      @verified == true
    end

    def unverified?
      !verified?
    end

    def modified!
      @modified = true
    end

    def modified?
      @modified == true
    end

    def unmodified?
      !modified?
    end

    def delta
      { state: state, user: user }
    end

  end

end
