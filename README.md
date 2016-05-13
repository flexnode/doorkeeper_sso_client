## DoorkeeperSsoClient

Client gem for SSO Server gem @ https://github.com/flexnode/doorkeeper_sso

**Current state of development:** Alpha at best!


# Dependencies
  - Ruby 1.9 and above
  - Rails 3.2 and above
  - Postgres


## Getting Started


Install project gem

```ruby
  gem 'doorkeeper_sso_client'
```

Import migrations and run them

```ruby
rake doorkeeper_sso_client:install:migrations
rake db:migrate
```

Create an initializer inside config/initializers (doorkeeper_sso_client.rb)

```ruby
::DoorkeeperSsoClient::Config.configure do |config|
  config[:oauth_client_id] = 123
  config[:oauth_client_secret] = 'abc'
  config[:base_uri] = 'http://localhost'
end

# List of Overridable defaults
default :sessions_path, '/sso/sessions'
default :oauth_login_path, '/auth/doorkeeper_sso'
```

Add passport to your user model (user.rb)

```ruby
has_many :passports, as: :identity, class_name: "DoorkeeperSsoClient::Passport"
```

Ensure you link user model with passport on omniauth callback (user.rb)

```ruby
def assign_from_omniauth(auth)
  self.passports << DoorkeeperSsoClient::Passport.find_by_uid(auth["extra"]["passport_id"])
  ...
```

Mount engine for Pingback functionality

```ruby
MyApp::Application.routes.draw do
  mount DoorkeeperSsoClient::Engine => "/doorkeeper_sso_client"
```

### Devise

If you use [Devise](https://github.com/plataformatec/devise), you can automatically log out users when their passport is invalid. Run activate sso on your main scope (eg :user) inside application_controller.rb It will automatically run validate_passport! whenever authenticate_user! is run

```ruby
  include DoorkeeperSsoClient::Mixins::Devise::ControllerHelpers

  activate_sso :user
```

Note : You can override authenticate_user! if you want customized behavior

#### Devise Omniauthable

Using [Devise](https://github.com/plataformatec/devise), you can also leverage on the ```:omniauthable``` module. First, configure [Doorkeeper SSO](https://github.com/flexnode/doorkeeper_sso) as an Omniauth provider inside config/initializers (omniauth.rb)

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
 provider :doorkeeper_sso, 'comsumer-key', 'consumer-secret',
           name: "my_sso_provider",
           client_options: { :site => 'https://sso-provider-url' }
end
```

Enable ```:omniauthable``` on the model, and create method to handle the callbacks.

```ruby
class Admin < ActiveRecord::Base
  devise :omniauthable, :omniauth_providers => [:my_sso_provider]
  ...
  
  def from_omniauth(auth)
    admin = find_or_initialize_by(provider: auth["provider"], uid: auth["uid"].to_s) do |new_admin|
      new_admin.provider = auth["provider"]
      new_admin.uid = auth["uid"]
      new_admin.first_name = auth["info"]["first_name"]
      new_admin.last_name = auth["info"]["last_name"]
      new_admin.email = auth["info"]["email"]
      new_admin.token = auth["credentials"]["token"]
    end
    admin.passports << DoorkeeperSsoClient::Passport.find_by_uid(auth["extra"]["passport_id"])
    
    admin.save ? admin : nil
  end
end
```

Create callback controller app/controllers (omniauth_callbacks_controller.rb)

```ruby
class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def my_sso_provider
    admin = Admin.from_omniauth(request.env["omniauth.auth"])
    if admin
      sign_in_and_redirect admin, notice: "Signed in!", :event => :authentication
    else
      redirect_to new_admin_session_path, notice: "Sorry but you are not allowed to enter. Please contact administrator."
    end
  end

end
```

Create ```devise_for``` routes in config/routes.rb

```ruby
Rails.application.routes.draw do
  devise_for :admins,
              controllers: {omniauth_callbacks: "omniauth_callbacks"},
              only: [:omniauth_callbacks, :omniauth_authorize]
```

Override ```oauth_login_path``` option in config/initializers (doorkeeper_sso_client.rb)

```ruby
...
default :oauth_login_path, '/admins/auth/my_sso_provider'
```


## Testing

Tests may start failing because the Devise::Test helpers do not account for passport inside of the session.
Please add DoorkeeperSsoClient's TestHelpers into your spec/support/devise.rb file

```ruby
RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  # Override test helpers
  config.include DoorkeeperSsoClient::Mixins::Devise::TestHelpers, :type => :controller
```

You must also ensure that all your controller tests set the passport_id inside the session. Eg

```ruby
RSpec.describe "ControllerTestExample", :type => :controller do

  let(:passport) { Fabricate('DoorkeeperSsoClient::Passport', identity: Fabricate(:user)) }
  let(:user) { passport.identity }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET index" do
    it { get :index, nil, {'passport_id' => passport.uid} }
  end
```

## Maintained by
  - John - [john@flexnode.com](mailto:john@flexnode.com)

## Related stuff
  - [Doorkeeper Sso](https://github.com/flexnode/doorkeeper_sso) - Doorkeeper Sso Server gem
