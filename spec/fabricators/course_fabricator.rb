Fabricator(:course) do
  title Faker::Lorem.sentence
  description Faker::Lorem.paragraph
  user_id nil
end
