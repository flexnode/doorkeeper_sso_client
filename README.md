## DoorkeeperSsoClient

Client gem for SSO Server gem @ https://github.com/flexnode/doorkeeper_sso

**Current state of development:** Alpha at best!


# Dependencies
  - Ruby 1.9
  - Rails 3.2
  - Postgres


## Getting Started


Install project gem

```ruby
  gem doorkeeper_sso_client
```


Create an initializer inside config/initializers (doorkeeper_sso_client.rb)

```ruby
::DoorkeeperSsoClient::Config.configure do |config|
  config[:oauth_client_id] = 123
  config[:oauth_client_secret] = 'abc'
  config[:base_uri] = 'http://localhost'
end
```


## Maintained by
  - John - [john@flexnode.com](mailto:john@flexnode.com)

## Related stuff
  - [Doorkeeper Sso](https://github.com/flexnode/doorkeeper_sso) - Doorkeeper Sso Server gem
