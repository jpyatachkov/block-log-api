Fabricator(:user) do
  user_password = Faker::Internet.password

  username Faker::Internet.username
  password user_password
  password_confirmation user_password
  first_name Faker::Name.first_name
  last_name Faker::Name.last_name
end
