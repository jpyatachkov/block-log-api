# WARNING!
# Provide SECRET_PASSWORD env variable value before run rake db:seed!

alexander = User.first_or_create first_name: 'Александр',
                                 last_name: 'Барулев',
                                 username: 'a.barulev',
                                 email: 'a.barulev@mail.ru',
                                 password: ENV['SECRET_PASSWORD'],
                                 password_confirmation: ENV['SECRET_PASSWORD']
maxim = User.first_or_create first_name: 'Максим',
                             last_name: 'Колотовкин',
                             username: 'm.kolotovkin',
                             email: 'm.kolotovkin@mail.ru',
                             password: ENV['SECRET_PASSWORD'],
                             password_confirmation: ENV['SECRET_PASSWORD']
User.create first_name: 'Кирилл',
            last_name: 'Кучеров',
            username: 'k.kucherov',
            email: 'k.kucherov@mail.ru',
            password: ENV['SECRET_PASSWORD'],
            password_confirmation: ENV['SECRET_PASSWORD']

creator_ids = [alexander.id, maxim.id]

100.times do
  current_user_id = creator_ids.sample(1).first

  course = Course.create title: Faker::Lorem.sentence,
                         description: Faker::Lorem.paragraph,
                         user_id: current_user_id

  Faker::Number.between(7, 19).times do
    Assignment.create text: Faker::Lorem.paragraph,
                      course_id: course.id,
                      user_id: current_user_id
  end
end
