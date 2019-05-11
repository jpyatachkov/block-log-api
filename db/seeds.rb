# WARNING!
# Provide SECRET_PASSWORD env variable value before run rake db:seed!

User.first_or_create first_name: 'Александр',
                     last_name: 'Барулев',
                     username: 'a.barulev',
                     email: 'a.barulev@mail.ru',
                     password: ENV['SECRET_PASSWORD'],
                     password_confirmation: ENV['SECRET_PASSWORD'],
                     is_staff: true,
                     is_admin: true
User.first_or_create first_name: 'Максим',
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
