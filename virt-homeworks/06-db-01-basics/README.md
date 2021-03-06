# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде

> NoSQL БД, к прим. MongoDB. Json для неё - нативный способ хранения данных.

- Склады и автомобильные дороги для логистической компании

> Графовые БД. Так как удобно на ребрах заполнять лэйблы с всякими маршрутами и тд.

- Генеалогические деревья

> Реляционные ДБ, гарантирует связанность данных, чтобы при удалении какая-то связь родственников не выпала и не оказалось "разорванного" генеалогического древа.

- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации

> Для хранения кеша лучше подходят NoSQL базы, т.к. работают быстро. Для этой цели часто используют Memcached.

- Отношения клиент-покупка для интернет-магазина

> Реляционная БД. За годы они хорошо зарекомендовали себя в сфере eCommerce. В личном проекте использовал MariaDB, полностью удовлетворяет потребностям.

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)

> По CAP теореме - AP, т.к. асинхронная запись не может дать гарантию консистентности данных.
> По PACELC теореме вероятно PA/EL, т.к. задержки в один час скорей всего будет достаточно чтобы устранить небольшие сетевые проблемы.

- При сетевых сбоях, система может разделиться на 2 раздельных кластера

> По CAP теореме - AP, т.к. если система функционирует, разделённая на 2 части, она так же не может быть консистентной.
> По PACELC теореме вероятно PA/EL: явно не описано как именно система должна работать при разделении, но предположу что имеется в виду "разделиться на 2 части и остаться доступной" - в таком случае то же логично делать упор на доступность.

- Система может не прислать корректный ответ или сбросить соединение

> По CAP теореме - CP, т.к. условие доступности требует, чтобы запрос всегда завершался корректным ответом.
> По PACELC теореме вероятно PC/EC, судя по описанию доступность не так важна, то есть остаётся согласованность.

## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

> Думаю что нет. ACID ориентирован на целостность данных, а BASE на их доступность.

## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?

> Видимо речь идёт о Redis. Минусы выбора Redis в качествев Pub/Sub системы:
 * Может медленно работать, если настроить персистентность
 * Без персистентности, можно потерять данные при сбое сервера или перезапуске сервиса
 * Настройка кластеризации может быть нетривиальна и треует особого внимания

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
