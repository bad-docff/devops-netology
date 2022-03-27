# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
    > Ответ: ifconfig

    > ip -c -br link

    ```bash
    vagrant@devops-vm:~$ ifconfig -a
    eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
            inet6 fe80::a00:27ff:fe73:60cf  prefixlen 64  scopeid 0x20<link>
            ether 08:00:27:73:60:cf  txqueuelen 1000  (Ethernet)
            RX packets 828  bytes 282718 (282.7 KB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 636  bytes 80004 (80.0 KB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
            inet 127.0.0.1  netmask 255.0.0.0
            inet6 ::1  prefixlen 128  scopeid 0x10<host>
            loop  txqueuelen 1000  (Local Loopback)
            RX packets 30  bytes 2504 (2.5 KB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 30  bytes 2504 (2.5 KB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    vagrant@devops-vm:~$ ifconfig
    eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
            inet6 fe80::a00:27ff:fe73:60cf  prefixlen 64  scopeid 0x20<link>
            ether 08:00:27:73:60:cf  txqueuelen 1000  (Ethernet)
            RX packets 844  bytes 283828 (283.8 KB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 646  bytes 81280 (81.2 KB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
            inet 127.0.0.1  netmask 255.0.0.0
            inet6 ::1  prefixlen 128  scopeid 0x10<host>
            loop  txqueuelen 1000  (Local Loopback)
            RX packets 30  bytes 2504 (2.5 KB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 30  bytes 2504 (2.5 KB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    vagrant@devops-vm:~$ ip -c -br link
    lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
    eth0             UP             08:00:27:73:60:cf <BROADCAST,MULTICAST,UP,LOWER_UP> 
    vagrant@devops-vm:~$ 

    ```
    > В windows: `ipconfig /all`

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

    > Ответ: LLDP – протокол для обмена информацией между соседними устройствами, позволяет определить к какому порту коммутатора подключен сервер.
    
    ```bash
    apt install lldpd
    systemctl enable lldpd && systemctl start lldpd
    ```

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

    > Ответ: `VLAN` – виртуальное разделение коммутатора.
    ```bash
    apt install vlan
    ```
    ```bash
    vi /etc/network/interfacesauto
        vlan1400
        iface vlan1400 inet static
            address 192.168.1.1        
            netmask 255.255.255.0        
            vlan_raw_device eth0       
        auto eth0.1400
        iface eth0.1400 inet static        
        address 192.168.1.1        
        netmask 255.255.255.0        
        vlan_raw_device eth0
    ```

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

    > Ответ: bonding и teaming. 

    ```
    Опции для балансировки нагрузки:

    mode=0 (balance-rr)
    Последовательно кидает пакеты, с первого по последний интерфейс.

    mode=1 (active-backup)
    Один из интерфейсов активен. Если активный интерфейс выходит из строя (link down и т.д.),
    другой интерфейс заменяет активный. Не требует дополнительной настройки коммутатора

    mode=2 (balance-xor)
    Передачи распределяются между интерфейсами на основе формулы
    ((MAC-адрес источника) XOR (MAC-адрес получателя)) % число интерфейсов.
    Один и тот же интерфейс работает с определённым получателем. Режим даёт балансировку нагрузки и отказоустойчивость.

    mode=3 (broadcast)
    Все пакеты на все интерфейсы

    mode=4 (802.3ad)
    Link Agregation — IEEE 802.3ad, требует от коммутатора настройки.

    mode=5 (balance-tlb)
    Входящие пакеты принимаются только активным сетевым интерфейсом, исходящий распределяется
    в зависимости от текущей загрузки каждого интерфейса. Не требует настройки коммутатора.

    mode=6 (balance-alb)
    Тоже самое что 5, только входящий трафик тоже распределяется между интерфейсами. Не требует
    настройки коммутатора, но интерфейсы должны уметь изменять MAC.

    У тиминга примерно то же самое:

    Automatic (Recommended) — это не самостоятельный тип настройки. Этот тип выбирает между
    Transmit Load Balancing (TLB) или 802.3ad Dynamic:

    Если все порты присоединены к коммутатору, который поддерживает IEEE 802.3ad LACP, и все порты установили связь
    с коммутатором по LACP, тогда будет выбран режим 802.3ad Dynamic.

    Если коммутатор не поддерживает LACP или если один из портов в team, не установил связь с
    коммутатором по LACP, то будет выбран режим TLB.

    Network Fault Tolerance Only (NFT) — в режиме NFT от двух до восьми портов объединены вместе.
    Однако только один порт (primary port) используется для приема и передачи данных. Остальные порты
    находятся в режиме standby. Если основной порт выходит из строя, то другой порт заменяет его.
    Этот режим работает во всех остальных типах NIC teaming.

    Network Fault Tolerance Only with Preference Order Network — аналогичен типу NFT. Единственное
    отличие заключается в том, что этот тип позволяет административно назначить порядок в котором порты будут становиться основными.

    Switch-assisted Load Balancing with Fault Tolerance (SLB) — позволяет балансировать нагрузку для входящего
    и исходящего трафика. SLB работает только при условии, что коммутатор поддерживает какой-то вариант агрегирования
    портов (EtherChannel, MultiLink Trunking, статическое агрегирование без использования протоколов и др.).
    Этот вариант требует чтобы все сетевые интерфейсы сервера были подключены к одному коммутатору.

    802.3ad Dynamic with Fault Tolerance — идентичен типу SLB, но коммутатор должен поддерживать LACP.
    На портах коммутатора, к которым подключены сетевые интерфейсы сервера, должен быть включен LACP.

    Transmit Load Balancing with Fault Tolerance (TLB) — позволяет серверу балансировать исходящий трафик.
    TLB не зависит от коммутатора и позволяет портам в team быть подключенными к разным коммутаторам в одной и той же сети.
    Входящий трафик не балансируется. Основной (primary) порт в team отвечает за получение входящего трафика. В случае выхода
    из строя основного порта, механизм NFT отвечает за то что будет выбран другой порт на эту роль.

    Transmit Load Balancing with Fault Tolerance and Preference Order — аналогичен типу TLB. Единственное отличие
    заключается в том, что этот тип позволяет административно назначить порядок в котором порты будут становиться основными.
    ```

    > Пример конфига /etc/network/interfaces для бондинга:

    ```bash
    auto bond0

    iface bond0 inet static
    address 10.31.1.5
    netmask 255.255.255.0
    network 10.31.1.0
    gateway 10.31.1.254
    bond-slaves eth0 eth1
    bond-mode active-backup
    bond-miimon 100
    bond-downdelay 200
    bond-updelay 200

    ```

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

    > Ответ: Сколько IP адресов в сети с маской /29 : `8`

    > Сколько /29 подсетей можно получить из сети с маской /24: `32`

    Примеры подсетей с маской /29, полученных из сети 10.10.10.0/24:
    ```bash
    10.10.10.0/29
    10.10.10.8/29
    10.10.10.16/29
    ```

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

    > Ответ:  `100.64.0.0/26`

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

    > Ответ: arp -a в win. В Linux arp.

    ```bash
    ip link set arp off dev eth0 ; ip link set arp on dev eth0
    ```
    ```bash
    arp -i eth1 -d 10.0.0.1
    ```


 ---
