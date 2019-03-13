# Block Log backend

## Развертывание для разработки

Создать в корне проекта файл `.env` с содержимым

```dotenv
DATABASE_HOST=
DATABASE_USER=
DATABASE_PASSWORD=
```

и указать в нем валидные данные для подключения к PostgreSQL.

```bash
rake db:create
rake db:migrate
rspec
```

**Примечание**

Для корректной работы JWT нужно поместить `master.key` в директорию `config`.

## Развертывание в Docker

**Docker-compsoe**

 Для запуска приложения в docker контейнере необходимо выполнить следующие комманды:
 
 ```bash
 docker-compose run block-log-api bundle exec rake db:create
 docker-compose run block-log-api bundle exec rake db:migrate
 docker-compose up --build
 ```

 Необходимо установить в docker-compose.yml 
 DATABASE_USER: 
 DATABASE_PASSWORD: 