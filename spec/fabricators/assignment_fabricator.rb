Fabricator(:assignment) do
  text Faker::Lorem.paragraph
  course_id  nil
  user_id    nil
end
