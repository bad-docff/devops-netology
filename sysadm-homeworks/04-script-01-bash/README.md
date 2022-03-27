### Как сдавать задания

Привет! 

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы.

---


# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательные задания

1. Есть скрипт:
	```bash
	a=1
	b=2
	c=a+b
	d=$a+$b
	e=$(($a+$b))
	```
	* Какие значения переменным c,d,e будут присвоены?
	* Почему?

	> $c=a+b, потому что записали строку a+b
	> $d=1+2, тоже самое, только вместо переменных взяли значение
	> $e=3, тут уже сложили. Магия скобок.

1. На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
	```bash
	while ((1==1)
	do
	curl https://localhost:4757
	if (($? != 0))
	then
	date >> curl.log
	fi
	done
	```

	```bash
	#!/usr/bin/env bash
	while ((1==1))
	do
	curl https://localhost:4757
	if (($? != 0))
	then
	date >> curl.log   
	else
	exit 0
	fi
	sleep 5
	done
	```

1. Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.

	```bash
	#!/usr/bin/env bash
	array_int=(0 1 2 3 4)
	array_hosts=(192.168.0.1 173.194.222.113 87.250.250.242)

	for i in ${array_int[@]}
	do
		for j in ${!array_hosts[@]}
		do
			curl -m 10 http://${array_hosts[$j]}
			if (($? == 0))
			then
				date >> ipstat.log
				echo ${array_hosts[$j]} is OK by TCP 80 >> ipstat.log
			else
				date >> ipstat.log
				echo ${array_hosts[$j]} is DOWN by TCP 80 >> ipstat.log
			fi
		done
		sleep 5
	done
	cat ipstat.log
	```

1. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается

	```bash
	#!/usr/bin/env bash
	array_hosts=(192.168.0.1 173.194.222.113 87.250.250.242)

	while ((1==1))
	do
		for j in ${!array_hosts[@]}
		do
			curl -m 10 http://${array_hosts[$j]} 
			if (($? == 0))
			then
				date >> ipstat.log
				echo ${array_hosts[$j]} is OK by TCP 80 >> ipstat.log
			else
				date >> ipstat.log
				echo ${array_hosts[$j]} is DOWN by TCP 80 >> ipstat.log
				cat ipstat.log
				echo See log in file ipstat.log
				echo See error in file ipstat.log
				exit 1
			fi
		done
		sleep 5

	done
	cat ipstat.log
	```

 ---