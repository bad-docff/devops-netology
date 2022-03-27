# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательные задания

1. Есть скрипт:
	```python
    #!/usr/bin/env python3
	a = 1
	b = '2'
	c = a + b
	```
	* Какое значение будет присвоено переменной c?
	* Как получить для переменной c значение 12?
	* Как получить для переменной c значение 3?
	
	```python
	TypeError: unsupported operand type(s) for +: 'int' and 'str'
	c = str(a) + b
	c = a + int(b)
	```

1. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

	```python
    #!/usr/bin/env python3

    import os

	bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
	result_os = os.popen(' && '.join(bash_command)).read()
    is_change = False
	for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(prepare_result)
            break

	```
    ```python3
    #!/usr/bin/env python3

    import os

    repo_path = "~/netology/sysadm-homeworks"
    bash_command = ["cd " + repo_path, "git status"]
    is_change = False
    modified_files = []

    result_os = os.popen(' && '.join(bash_command)).read()

    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            modified_files.append(result.replace('\tmodified:   ', ''))

    print('Repository path: {repo_path}\n'.format(repo_path=repo_path))
    print('\n'.join(modified_files))
    ```

1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

```python
#!/usr/bin/env python3

import sys
import os
from subprocess import PIPE, Popen

# destruct script args
script_name, dir_apth = sys.argv

# check if directory is a git repo
bash_is_repo_command = ["cd " + dir_apth, "git branch"] 
p = Popen(' && '.join(bash_is_repo_command), shell=True, stdout=PIPE, stderr=PIPE)
p.communicate()

if p.returncode != 0:
    print('Directory: {dir_apth} is not a GIT repo.'.format(dir_apth=dir_apth))
    exit()

# check modified files
bash_command = ["cd " + dir_apth, "git status"]
is_change = False
modified_files = []

result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
    if result.find('modified') != -1:
        modified_files.append(result.replace('\tmodified:   ', ''))

print('Repository path: {dir_apth}\n'.format(dir_apth=dir_apth))
print('\n'.join(modified_files))
```

1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.

```python
#!/usr/bin/env python3

import socket
import json

file_name = 'hosts.json'
names = ['drive.google.com', 'mail.google.com', 'google.com']

try:
    with open(file_name) as json_file:
        file_data = json.load(json_file)
except IOError:
    file_data = {}


for name_ip in names:
    # get ip by host name_ip
    ip_address = socket.gethostbyname(name_ip)
    # compare IPs
    if name_ip in file_data:
        previous_ip = file_data[name_ip]
        if previous_ip != ip_address:
            print('[ERROR] {name_ip} IP mismatch: {previous_ip} {ip_address}'.format(name_ip=name_ip, previous_ip=previous_ip, ip_address=ip_address))

    print('{name_ip} - {ip_address}'.format(name_ip=name_ip, ip_address=ip_address))
    # save to file data
    file_data[name_ip] = ip_address

# write to file
with open(file_name, 'w') as outfile:
    json.dump(file_data, outfile)
```

---
