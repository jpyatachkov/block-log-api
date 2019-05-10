# Block Log backend

## Развертывание для разработки

Создать в корне проекта файл `.env` с содержимым

```dotenv
DATABASE_HOST=
DATABASE_USER=
DATABASE_PASSWORD=

ACTIVE_JOB_URL=redis://@localhost:6379/0
REDIS_TOKEN_URL=redis://@localhost:6379/1

SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_DOMAIN=gmail.com
SMTP_USERNAME=mail@gmail.com
SMTP_PASSWORD=password
SMTP_AUTH=plain
SMTP_ENABLE_STARTTLS_AUTO=true

CONFIRM_TOKEN_LIFETIME=3600

ACTION_MAILER_HOST=
```

и указать в нем валидные данные для подключения к PostgreSQL.

**ВНИМАНИЕ!** Не указывать `DATABASE_URL` - если это сделать, то переменные `DATABASE_HOST`, `DATABASE_USER`,
`DATABASE_PASSWORD` **будут проигнорированы**!

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
DATABASE_NAME=
DATABASE_USER=
DATABASE_PASSWORD=
DATABASE_URL=postgresql://[user[:password]@][netloc][:port][/dbname]

REDIS_PASSWORD=password
ACTIVE_JOB_URL=redis://:password@localhost:6379/0
REDIS_TOKEN_URL=redis://:password@localhost:6379/1

SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_DOMAIN=gmail.com
SMTP_USERNAME=mail@gmail.com
SMTP_PASSWORD=password
SMTP_AUTH=plain
SMTP_ENABLE_STARTTLS_AUTO=true

CONFIRM_TOKEN_LIFETIME=3600

ACTION_MAILER_HOST=url адрес сайта
```

(значение `DATABASE_URL` - пример формата, который понимает PostgreSQL).

`DATABASE_NAME` - имя БД,

`DATABASE_USER` - это имя пользователя, из-под которого создается БД,

`DATABASE_PASSWORD` - пароль пользователя,

`DATABASE_URL` - URL для подключения к БД, который должен содержать значения `DATABASE_USER` и `DATABASE_PASSWORD`.

`SMTP*` - настройка для отправки писем с помощью ActionMailer (`ACTION_MAILER_HOST` - адрес сайта для генерации адреса подтверждения email)

`CONFIRM_TOKEN_LIFETIME` - время жизни токенов для подтверждения email в redis (в секундах)

`REDIS_PASSWORD` - пароль для redis, можно без юзера

`ACTIVE_JOB_URL` - хранилище используемое для отправки писем для sideqik

`REDIS_TOKEN_URL` - хранилище токенов для подтверждения email


 Для запуска приложения в docker контейнере необходимо выполнить следующие комманды:
 
 ```bash
 docker-compose run api bundle exec rake db:create && bundle exec rake db:migrate
 ```

Просмотр логов

```bash
docker-compose logs -f api
```

### JWT

Для корректной работы JWT нужно поместить `master.key` в директорию `config`. Он примонтируется к контейнеру
с приложением автоматически.

### HTTPS

Предлагается использовать Let's Encrypt. Подразумевается, что сертификат сгенерирован **для домена api.blocklog.ru**
и на целевой машине **лежит директория /etc/letsencrypt**, которая и монтируется к compose.
