# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.
```yaml
version: '3.1'

services:

  db:
    image: postgres:12-bullseye
    restart: always
    environment:
      POSTGRES_DB: "netology-db"
      POSTGRES_USER: "netology-db"
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
    ports:
      - 8080:8080
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

```
CREATE USER "test-admin-user" WITH PASSWORD 'test-admin-user';

create database test_db;

CREATE TABLE orders  (id SERIAL CONSTRAINT id_pk PRIMARY KEY ,  наименование character varying(100) ,  цена INT);
CREATE TABLE clients  (id SERIAL CONSTRAINT id_cl_pk PRIMARY KEY ,  фамилия character varying(100) ,  "страна проживания" character varying(100) , заказ int REFERENCES orders (id));
CREATE INDEX idx_country ON clients("страна проживания");

GRANT ALL ON All Tables In Schema public TO "test-simple-user";

CREATE USER "test-simple-user" WITH PASSWORD 'test-simple-user';

GRANT UPDATE, SELECT, insert, delete ON All Tables In Schema public TO "test-simple-user";

SELECT datname FROM pg_database WHERE datistemplate = false;
postgres
pgdb
test_db

SELECT table_catalog, table_schema, table_name, column_name, column_default, is_nullable, data_type FROM information_schema.columns WHERE table_name in ('clients', 'orders');
| table\_catalog | table\_schema | table\_name | column\_name | column\_default | is\_nullable | data\_type |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| test\_db | public | orders | id | nextval\('orders\_id\_seq'::regclass\) | NO | integer |
| test\_db | public | orders | наименование | NULL | YES | character varying |
| test\_db | public | orders | цена | NULL | YES | integer |
| test\_db | public | clients | id | nextval\('clients\_id\_seq'::regclass\) | NO | integer |
| test\_db | public | clients | фамилия | NULL | YES | character varying |
| test\_db | public | clients | страна проживания | NULL | YES | character varying |
| test\_db | public | clients | заказ | NULL | YES | integer |

SELECT table_name, grantee, privilege_type FROM information_schema.role_table_grants WHERE table_name in ('clients', 'orders');
| table\_name | grantee | privilege\_type |
| :--- | :--- | :--- |
| orders | pguser | INSERT |
| orders | pguser | SELECT |
| orders | pguser | UPDATE |
| orders | pguser | DELETE |
| orders | pguser | TRUNCATE |
| orders | pguser | REFERENCES |
| orders | pguser | TRIGGER |
| orders | test-admin-user | INSERT |
| orders | test-admin-user | SELECT |
| orders | test-admin-user | UPDATE |
| orders | test-admin-user | DELETE |
| orders | test-admin-user | TRUNCATE |
| orders | test-admin-user | REFERENCES |
| orders | test-admin-user | TRIGGER |
| orders | test-simple-user | INSERT |
| orders | test-simple-user | SELECT |
| orders | test-simple-user | UPDATE |
| orders | test-simple-user | DELETE |
| orders | test-simple-user | TRUNCATE |
| orders | test-simple-user | REFERENCES |
| orders | test-simple-user | TRIGGER |
| clients | pguser | INSERT |
| clients | pguser | SELECT |
| clients | pguser | UPDATE |
| clients | pguser | DELETE |
| clients | pguser | TRUNCATE |
| clients | pguser | REFERENCES |
| clients | pguser | TRIGGER |

```
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

```
INSERT INTO orders ("наименование", "цена") VALUES ('Шоколад', 10),
                                                   ('Принтер', 3000),
                                                   ('Книга', 500),
                                                  ('Монитор', 7000),
                                                   ('Гитара', 4000);

INSERT INTO clients ("фамилия", "страна проживания") VALUES ('Иванов Иван Иванович', 'USA'),
                                                           ('Петров Петр Петрович', 'Canada'),
                                                           ('Иоганн Себастьян Бах', 'Japan'),
                                                           ('Ронни Джеймс Дио', 'Russia'),
                                                           ('Ritchie Blackmore', 'Russia');

SELECT COUNT(*) FROM orders;
| count |
| :--- |
| 5 |

SELECT COUNT(*) FROM clients;
| count |
| :--- |
| 5 |

```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

```
update clients set заказ = 3 where фамилия = 'Иванов Иван Иванович';
update clients set заказ = 4 where фамилия = 'Петров Петр Петрович';
update clients set заказ = 5 where фамилия = 'Иоганн Себастьян Бах';

select cl.фамилия, o.наименование from clients cl join orders o on o.id = cl.заказ;
| фамилия | наименование |
| :--- | :--- |
| Иванов Иван Иванович | Книга |
| Петров Петр Петрович | Монитор |
| Иоганн Себастьян Бах | Гитара |

```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```
explain select cl.фамилия, o.наименование from clients cl join orders o on o.id = cl.заказ;
| QUERY PLAN |
| :--- |
| Hash Join  \(cost=17.20..29.36 rows=170 width=436\) |
|   Hash Cond: \(cl."заказ" = o.id\) |
|   -&gt;  Seq Scan on clients cl  \(cost=0.00..11.70 rows=170 width=222\) |
|   -&gt;  Hash  \(cost=13.20..13.20 rows=320 width=222\) |
|         -&gt;  Seq Scan on orders o  \(cost=0.00..13.20 rows=320 width=222\) |


Seq Scan - последовательное, блок за блоком, чтение данных таблицы.
cost - это некое понятие, призванное оценить затратность операции. Первое значение 0.00 — затраты на получение первой строки. Второе — 11.70 — затраты на получение всех строк.
rows — приблизительное количество возвращаемых строк при выполнении операции Seq Scan. Это значение возвращает планировщик.
width — средний размер одной строки в байтах.
```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

```
pg_dump -U pguser -W test_db > test_db.dump

psql -U pguser -W test_db < test_db.dump
```
---
