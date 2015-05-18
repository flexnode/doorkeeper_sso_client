Fabricator(:user) do
  first_name Faker::Name.name
  email Faker::Internet.email
end
