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
  devise_for :users, only: [:omniauth_callbacks, :omniauth_authorize]

  mount DoorkeeperSsoClient::Engine => "/doorkeeper_sso_client"
```


If you use [Devise](https://github.com/plataformatec/devise), you can automatically log out users when their passport is invalid. Run activate sso on your main scope (eg :user) inside application_controller.rb It will automatically run validate_passport! whenever authenticate_user! is run

```ruby
  include DoorkeeperSsoClient::Mixins::Devise::ControllerHelpers

  activate_sso :user
```

Note : You can override authenticate_user! if you want customized behavior

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
