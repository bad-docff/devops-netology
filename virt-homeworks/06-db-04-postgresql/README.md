# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.


```yaml
# docker-compose-postgresql-13.yaml

version: '3.1'

services:

  db:
    image: postgres:13-bullseye
    restart: always
    environment:
      POSTGRES_DB: "netology-db"
      POSTGRES_USER: "root"
      POSTGRES_PASSWORD: "netology-db"
      PGDATA: "/var/lib/postgresql/data/pgdata"
    volumes:
      - /docker-entrypoint-initdb.d:/mnt/pg_buckup/docker-entrypoint-initdb.d
      - /var/lib/postgresql/data:/mnt/pg_buckup/var/lib/postgresql/data
      - /mnt/pg_dump:/pg_dump
    ports:
      - "5432:5432"

  adminer:
    image: adminer
    restart: always
    environment:
      ADMINER_DEFAULT_SERVER: db
      ADMINER_DESIGN: dracula
    ports:
      - 8080:8080
```

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
 > \l
- подключения к БД
 > \c dbname
- вывода списка таблиц
 > \dt
- вывода описания содержимого таблиц
 > \dS+ table_name
- выхода из psql
 > \q

## Задача 2

Используя `psql` создайте БД `test_database`.

 > create database test_database;

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

 > psql -U root -d test_database < test_dump.sql

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```sql
test_database=# analyze VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

```sql
test_database=# select avg_width from pg_stats where tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

```sql
test_database=# create table orders_1 (check ( price > 499 )) inherits ( orders );
CREATE TABLE
test_database=# create table orders_2 (check ( price <= 499 )) inherits ( orders );
CREATE TABLE
test_database=# create rule order_price_more_499 as on insert to orders where ( price > 499 ) do instead insert into orders_1 values (new.*);
CREATE RULE
test_database=# create rule order_price_less_499 as on insert to orders where ( price <= 499 ) do instead insert into orders_2 values (new.*);
CREATE RULE
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

 > Если сразу предусмотреть что заказов будет много, то можно было бы сделать разбиение таблицы изначально.

 > Как вариант можно еще рассмотреть декларативное партиционирование как еще один способ разбиения больших таблиц.


## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

 > pg_dump -U root -W test_database > /pg_dump/test_database.sql

```sql
# нужно добавить ключевое слово UNIQUE к нужному столбцу

# Name: orders; Type: TABLE; Schema: public; Owner: root


CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) UNIQUE NOT NULL,
    price integer DEFAULT 0
);
```

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
