# Домашнее задание к занятию "10.01. Зачем и что нужно мониторить"

## Обязательные задания

## Задание 1
>Вас пригласили настроить мониторинг на проект. На онбординге вам рассказали, что проект представляет из себя платформу для вычислений с выдачей текстовых отчетов, которые сохраняются на диск. Взаимодействие с платформой осуществляется по протоколу http. Также вам отметили, что вычисления загружают ЦПУ. Какой минимальный набор метрик вы выведите в мониторинг и почему?

- Количество http соединений - если где-то соединения зависают, то со временем это может привести к недоступности платформы.
- CPUla - средняя нагрузка на ЦПУ, максимальная закгрузка может привести к зависанию.
- inodes - если отчеты пишутся в большое количество маленьких файлов
- свободное место на диске - так как оно может закончиться
- RAM - Следить, если процесс повиснет.


## Задание 2
>Менеджер продукта посмотрев на ваши метрики сказал, что ему непонятно что такое RAM/inodes/CPUla. Также он сказал, что хочет понимать, насколько мы выполняем свои обязанности перед клиентами и какое качество обслуживания. Что вы можете ему предложить?

- Объяснить, что : RAM - это объем оперативной памяти хоста, indoes - кол-во файловых дескрипторов, которые хранят информацию о файлах системыи, CPUla - загрузка процессора
Предлложить SLO - 99%, дополнительные метрики - метрики по времени на формирование отчетов в среднем и в пиковых значениях, чтобы определить наибольшую нагрузку, статиктику по неудачно сформированным отчетам, доступность сервиса.

Так же можно на дашборде подписать метрики человеко - удобным языком, неплохо будет провести некоторый экскурс по системе, для поднятия уровня знаний в команде. Чтобы все кто обращался к дашборду понимали хотя бы на начальном уровне какие метрики критичны для сервиса.


## Задание 3
>Вашей DevOps команде в этом году не выделили финансирование на построение системы сбора логов. Разработчики в свою очередь хотят видеть все ошибки, которые выдают их приложения. Какое решение вы можете предпринять в этой ситуации, чтобы разработчики получали ошибки приложения?

- Я бы рассмотрел возможность внедрения grafana, prometheus, node exporter

Данная связка позволит настроить гибкий монитоинг, может так же применить alert manager для получения алертов удобным способом.

## Задание 4
>Вы, как опытный SRE, сделали мониторинг, куда вывели отображения выполнения SLA=99% по http кодам ответов. Вычисляете этот параметр по следующей формуле: summ_2xx_requests/summ_all_requests. Данный параметр не поднимается выше 70%, но при этом в вашей системе нет кодов ответа 5xx и 4xx. Где у вас ошибка?

- В расчете SLA, кроме кодов 2xx должны учитываться коды 3xx (коды перенаправления) и 1xx (информационные коды)
Формула должна выглядеть так - (summ_1xx_requests + summ_2xx_requests + summ_3xx_requests)/(summ_all_requests)

---

<details>

  <summary>Дополнительное задание (со звездочкой*) - необязательно к выполнению</summary>

Вы устроились на работу в стартап. На данный момент у вас нет возможности развернуть полноценную систему 
мониторинга, и вы решили самостоятельно написать простой python3-скрипт для сбора основных метрик сервера. Вы, как 
опытный системный-администратор, знаете, что системная информация сервера лежит в директории `/proc`. 
Также, вы знаете, что в системе Linux есть  планировщик задач cron, который может запускать задачи по расписанию.

Суммировав все, вы спроектировали приложение, которое:
- является python3 скриптом
- собирает метрики из папки `/proc`
- складывает метрики в файл 'YY-MM-DD-awesome-monitoring.log' в директорию /var/log 
(YY - год, MM - месяц, DD - день)
- каждый сбор метрик складывается в виде json-строки, в виде:
  + timestamp (временная метка, int, unixtimestamp)
  + metric_1 (метрика 1)
  + metric_2 (метрика 2)
  
     ...
     
  + metric_N (метрика N)
  
- сбор метрик происходит каждую 1 минуту по cron-расписанию

Для успешного выполнения задания нужно привести:

а) работающий код python3-скрипта,

б) конфигурацию cron-расписания,

в) пример верно сформированного 'YY-MM-DD-awesome-monitoring.log', имеющий не менее 5 записей,

P.S.: количество собираемых метрик должно быть не менее 4-х.
P.P.S.: по желанию можно себя не ограничивать только сбором метрик из `/proc`.

</details>
---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
