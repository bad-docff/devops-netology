
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

```
IaaC позволяет добиться ускорение производства и вывода продукта на рынок.
Это связано с тем что описав коректно инраструктуру один раз, мы в последуещем ускоряем процесс предоставления инфраструктуры для разработки,тестирования и масштабирования по мере необходимости.
При IaaC гарантируется стабильность среды, устранение дрейфа конфигураций.
Т.е. при использовании данного подхода мы исключаем физическое вмешательство инженера напрямую на сервер, а если мы вносим правки в конфигурацию, то обновление конфигурации происходит происходит на всех серверах.
Так же к преимуществам IaaC относится более быстрая и эффективная разработка.
Т.е описав одну конфигурацию, мы по шаблону так сказать, настраивам все сервера, не настраивая каждый сервер по отдельности. Так же мы ускоряем процесс предоставления "песочниц". Разработчики могут быстро подготовить среды непрерывной интеграции /непрерывного развёртывания (CI/CD).

-Основополагающим- принципом является - Идемпотентность - этот принцип гарантирует нам, что при повторном выполнении операции мы получим результат идентичный предидущему и всем последующим выполнениям.
```

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

```
- Чем Ansible выгодно отличается от других систем управление конфигурациями?: Низкий порог входа, а так же доступность так сказать в освоении python + yaml.

- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?: предполагаю, что push, мы не ждем пока сервера запросят конфигурацию, они ее получают сразу после отправки, так же с управляющего хоста проще отследить по логам. (в теории)
```

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

```bash
docff@pop-os:/mnt/external-hdd/Переподготовка/devops-netology/virt-homeworks/05-virt-02-iaac/
src/vagrant$ virtualbox --help
Oracle VM VirtualBox VM Selector v6.1.30_Ubuntu
(C) 2005-2022 Oracle Corporation
All rights reserved.

No special options.

If you are looking for --startvm and related options, you need to use VirtualBoxVM.

---

docff@pop-os:/mnt/external-hdd/Переподготовка/devops-netology/virt-homeworks/05-virt-02-iaac/
src/vagrant$ vagrant version 
Installed Version: 2.2.14

Vagrant was unable to check for the latest version of Vagrant.
Please check manually at https://www.vagrantup.com

---

docff@pop-os:/mnt/external-hdd/Переподготовка/devops-netology/virt-homeworks/05-virt-02-iaac/
src/vagrant$ ansible --version
[WARNING]: Ansible is being run in a world writable directory (/mnt/external-
hdd/Переподготовка/devops-netology/virt-homeworks/05-virt-02-iaac/src/vagrant), ignoring it
as an ansible.cfg source. For more information see
https://docs.ansible.com/ansible/devel/reference_appendices/config.html#cfg-in-world-
writable-dir
ansible 2.10.8
  config file = None
  configured module search path = ['/home/docff/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.9.7 (default, Sep 10 2021, 14:59:43) [GCC 11.2.0]
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```

```bash
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
2db29710123e: Pull complete 
Digest: sha256:975f4b14f326b05db86e16de00144f9c12257553bba9484fed41f9b6f2257800
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

vagrant@server1:~$ 
```
