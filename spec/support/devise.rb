module ControllerMacros
  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = Fabricate(:user)
    user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
    sign_in user
  end
end


RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
end
