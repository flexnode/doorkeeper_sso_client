Fabricator(:user) do
  first_name { FFaker::Name.first_name }
  last_name { FFaker::Name.last_name }
  password  { 'password' }
  name { |attrs| [attrs[:first_name], attrs[:last_name]].join(" ") }
  email { FFaker::Internet.email }
  passports { [ Fabricate('DoorkeeperSsoClient::Passport') ] }
end
