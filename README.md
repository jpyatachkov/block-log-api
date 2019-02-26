# Block Log backend

## Развертывание для разработки

Создать в корне проекта файл `.env` с содержимым

```dotenv
DATABASE_USER=
DATABASE_PASSWORD=
```

и указать в нем валидные данные для подключения к PostgreSQL.

```bash
rake db:create
rake db:migrate
rspec
```
