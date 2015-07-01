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
```

Add passport to your user model (user.rb)

```ruby
has_one :passport, as: :identity, class_name: "DoorkeeperSsoClient::Passport"
```

Ensure you link user model with passport on omniauth callback

```ruby
def assign_from_omniauth(auth)
  self.passport = DoorkeeperSsoClient::Passport.find_by_uid(auth["extra"]["passport_id"])
  ...
```

Mount engine for Pingback functionality

```ruby
MyApp::Application.routes.draw do
  mount DoorkeeperSsoClient::Engine => "/doorkeeper_sso_client"
```


If you use devise, you can log out users when their passport is invalid
You must add your main scope (eg :user) to the devise_group(:sso) in application_controller.rb

```ruby
  devise_group :sso, contains: [:user]
```

After every before_filter :authenticate_user!, run validate_passport!

```ruby
  before_filter :authenticate_user!
  before_filter :validate_passport!
```

## Maintained by
  - John - [john@flexnode.com](mailto:john@flexnode.com)

## Related stuff
  - [Doorkeeper Sso](https://github.com/flexnode/doorkeeper_sso) - Doorkeeper Sso Server gem
