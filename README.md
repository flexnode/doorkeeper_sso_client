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


If you use [Devise](https://github.com/plataformatec/devise), you can automatically log out users when their passport is invalid. Run activate sso on your main scope (eg :user) inside application_controller.rb It will automatically run validate_passport! whenever authenticate_user! is run

```ruby
  include DoorkeeperSsoClient::Mixins::Devise::ControllerHelpers

  activate_sso :user
```

To manually run validate_passport! use the option below

Options
  :skip_devise_hook => true

Before every before_filter :authenticate_user!, you can run validate_passport!

```ruby
  include DoorkeeperSsoClient::Mixins::Devise::ControllerHelpers
  activate_sso :user, :skip_devise_hook => true

  before_filter :validate_passport!
  before_filter :authenticate_user!
```

## Maintained by
  - John - [john@flexnode.com](mailto:john@flexnode.com)

## Related stuff
  - [Doorkeeper Sso](https://github.com/flexnode/doorkeeper_sso) - Doorkeeper Sso Server gem
