# Домашнее задание к занятию "10.02. Системы мониторинга"

## Обязательные задания

1. Опишите основные плюсы и минусы pull и push систем мониторинга.

Плюсы PULL:

  - Проще Контролировать достоверность и объем данных. При извлечении данных мы можем быть уверены в подлинности данных, так как сам сервер инициирует соединение. Порт, на котором доступны данные метрик, всегда прослушивается, тогда как в системах push-based используются временные соединения, которые исчезают и появляются очень быстро.
  - Проще шифровать трафик. Можно поставить обратный прокси-сервер TLS перед обычным HTTP-сервером, который обслуживает метрики, и мы могли бы использовать что-то вроде letsencrypt, чтобы автоматически получить сертификат, если это общедоступная система или сертификат от частного центра сертификации, которому доверяют все в нашей интрасети.
  - Проще извлекать данные по требованию (и отлаживать).Наличие метода pull поверх TCP (HTTP) означает, что очень легко извлекать данные по требованию и отлаживать проблемы. Это дает возможность легко различать ошибки на стороне клиента и на стороне сервера. В методе PUSH если бы мы не получали никаких метрик, то это означало бы одно из двух: с сетью что то не так или с клиентом что то не так. С помощью метода push (TCP/HTTP) мы можем проверить разницу между ними, перейдя с помощью веб-браузера к IP-адресу и порту, где мы можем найти данные метрик. Если мы получили сброс TCP-соединения, то это означает, что сеть в порядке, но с клиентом что-то не так. Если мы вообще не получили никакого ответа, это означает, что с сетью что-то не так.


Плюсы PUSH:

  - Проще реализовать репликацию в разные точки приема. Поскольку все инициируется самим клиентом, становится проще реплицировать один и тот же трафик на разные серверы. Нам просто нужно передать его на один целевой IP-адрес.
  - Легко моделировать короткоживущие пакетные задания.
  - Потенциально может быть более эффективным. Методы PUSH обычно используют UDP, в то время как методы PULL основаны на TCP (HTTP). Это означает, что мы потенциально можем пушить метрики более эффективно, чем пулить их.

2. Какие из ниже перечисленных систем относятся к push модели, а какие к pull? А может есть гибридные?

    - Prometheus - PULL
    - TICK - PULL
    - Zabbix - PUSH and PULL
    - VictoriaMetrics - PUSH and PULL
    - Nagios - PUSH and PULL

3. Склонируйте себе [репозиторий](https://github.com/influxdata/sandbox/tree/master) и запустите TICK-стэк, 
используя технологии docker и docker-compose.

В виде решения на это упражнение приведите выводы команд с вашего компьютера (виртуальной машины):

    - curl http://localhost:8086/ping
    - curl http://localhost:8888
    - curl http://localhost:9092/kapacitor/v1/ping

      ```bash
      docff@docff-Aspire-A315-41:~/netology/hw/10-monitoring-02-systems/sandbox$ curl http://localhost:8086/pingcurl 
      404 page not found
      docff@docff-Aspire-A315-41:~/netology/hw/10-monitoring-02-systems/sandbox$ curl http://localhost:8888
      <!DOCTYPE html><html><head><meta http-equiv="Content-type" content="text/html; charset=utf-8"><title>Chronograf</title><link rel="icon shortcut" href="/favicon.fa749080.ico"><link rel="stylesheet" href="/src.9cea3e4e.css"></head><body> <div id="react-root" data-basepath=""></div> <script src="/src.a969287c.js"></script> </body></html>docff@docff-Aspire-A315-41:~/netology/hw/10-monitoring-02-systems/sandbox$ curl http://localhost:9092/kapacitor/v1/ping
      docff@docff-Aspire-A315-41:~/netology/hw/10-monitoring-02-systems/sandbox$ curl http://localhost:9092/kapacitor/v1/ping
      ```

А также скриншот веб-интерфейса ПО chronograf (`http://localhost:8888`). 

  > [localhost:8888](./extfiles/localhost8888.png)

P.S.: если при запуске некоторые контейнеры будут падать с ошибкой - проставьте им режим `Z`, например
`./data:/var/lib:Z`

4. Перейдите в веб-интерфейс Chronograf (`http://localhost:8888`) и откройте вкладку `Data explorer`.

    - Нажмите на кнопку `Add a query`
    - Изучите вывод интерфейса и выберите БД `telegraf.autogen`
    - В `measurments` выберите mem->host->telegraf_container_id , а в `fields` выберите used_percent. 
    Внизу появится график утилизации оперативной памяти в контейнере telegraf.
    - Вверху вы можете увидеть запрос, аналогичный SQL-синтаксису. 
    Поэкспериментируйте с запросом, попробуйте изменить группировку и интервал наблюдений.

Для выполнения задания приведите скриншот с отображением метрик утилизации места на диске 
(disk->host->telegraf_container_id) из веб-интерфейса.

  > [diskBytes](./extfiles/diskBytes.png)

5. Изучите список [telegraf inputs](https://github.com/influxdata/telegraf/tree/master/plugins/inputs). 
Добавьте в конфигурацию telegraf следующий плагин - [docker](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/docker):
```
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
```

Дополнительно вам может потребоваться донастройка контейнера telegraf в `docker-compose.yml` дополнительного volume и 
режима privileged:
```
  telegraf:
    image: telegraf:1.4.0
    privileged: true
    volumes:
      - ./etc/telegraf.conf:/etc/telegraf/telegraf.conf:Z
      - /var/run/docker.sock:/var/run/docker.sock:Z
    links:
      - influxdb
    ports:
      - "8092:8092/udp"
      - "8094:8094"
      - "8125:8125/udp"
```

После настройке перезапустите telegraf, обновите веб интерфейс и приведите скриншотом список `measurments` в 
веб-интерфейсе базы telegraf.autogen . Там должны появиться метрики, связанные с docker.

  > [telegraf.autogen](./extfiles/telegraf.autogen.png)

Факультативно можете изучить какие метрики собирает telegraf после выполнения данного задания.

---

