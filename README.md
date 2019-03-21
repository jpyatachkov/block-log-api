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

**Docker-compose**

Создать в корне проекта файл `.env` с содержимым

```dotenv
DATABASE_USER=
DATABASE_PASSWORD=
DATABASE_URL=postgresql://[user[:password]@][netloc][:port][/dbname]
```

(значение `DATABASE_URL` - пример формата, который понимает PostgreSQL).

`DATABASE_USER` - это имя пользователя, из-под которого создается БД,
`DATABASE_PASSWORD` - пароль пользователя,
`DATABASE_URL` - URL для подключения к БД, который должен содержать значения `DATABASE_USER` и `DATABASE_PASSWORD`.

 Для запуска приложения в docker контейнере необходимо выполнить следующие комманды:
 
 ```bash
 docker-compose run api bundle exec rake db:create && bundle exec rake db:migrate
 ```

Просмотр логов

```bash
docker-compose logs -f api
```

### HTTPS

Предлагается использовать Let's Encrypt. Подразумевается, что сертификат сгенерирован **для домена api.blocklog.ru**
и на целевой машине **лежит директория /etc/letsencrypt**, которая и монтируется к compose.
