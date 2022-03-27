# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```
 > В ответ получил:
```
route-views>show ip route 94.251.41.120 /32
                                        ^
% Invalid input detected at '^' marker.

route-views>show ip route 94.251.41.120    
Routing entry for 94.251.0.0/17
  Known via "bgp 6447", distance 20, metric 0
  Tag 3356, type external
  Last update from 4.68.4.46 4w1d ago
  Routing Descriptor Blocks:
  * 4.68.4.46, from 4.68.4.46, 4w1d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 3356
      MPLS label: none
```
 > При bgp:
```
route-views>show bgp 94.251.41.120     
BGP routing table entry for 94.251.0.0/17, version 1278243812
Paths: (24 available, best #11, table default)
  Not advertised to any peer
  Refresh Epoch 3
  3303 20485 21127, (aggregated by 21127 10.7.54.252)
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external, atomic-aggregate
      Community: 3303:1004 3303:1006 3303:1030 3303:3056 20485:10054 20485:65102
      path 7FE0F4BB35F8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 1299 20485 21127, (aggregated by 21127 10.7.54.252)
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external, atomic-aggregate
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE0C63B8C68 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 6762 20485 21127, (aggregated by 21127 10.7.54.252)
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin IGP, localpref 100, valid, external, atomic-aggregate
      Community: 2516:1030 7660:9003
      path 7FE028A7DA68 RPKI State not found
 --More-- 
```

2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

```
root@vagrant:~# ip link add dummy0 type dummy
root@vagrant:~# sudo ip addr add 10.0.29.0/24 dev dummy0
root@vagrant:~# sudo ip link set dummy0 up
root@vagrant:~# ip address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 85294sec preferred_lft 85294sec
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link
       valid_lft forever preferred_lft forever
3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 1e:f5:d1:7a:7c:b5 brd ff:ff:ff:ff:ff:ff
    inet 10.0.29.0/24 scope global dummy0
       valid_lft forever preferred_lft forever
    inet6 fe80::1cf5:d1ff:fe7a:7cb5/64 scope link
       valid_lft forever preferred_lft forever
```
```
root@vagrant:~# ip route add 8.8.8.0/24 via 10.0.2.1
root@vagrant:~# ip route add 8.16.28.0/24 via 10.0.29.0
root@vagrant:~# ip route
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
8.8.8.0/24 via 10.0.2.1 dev eth0
8.16.28.0/24 via 10.0.29.0 dev dummy0
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
10.0.29.0/24 dev dummy0 proto kernel scope link src 10.0.29.0
```
3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

```
root@vagrant:~# ss -tpan
State     Recv-Q    Send-Q        Local Address:Port         Peer Address:Port     Process
LISTEN    0         4096          127.0.0.53%lo:53                0.0.0.0:*         users:(("systemd-resolve",pid=570,fd=13))
LISTEN    0         128                 0.0.0.0:22                0.0.0.0:*         users:(("sshd",pid=857,fd=3))
LISTEN    0         4096                0.0.0.0:111               0.0.0.0:*         users:(("rpcbind",pid=569,fd=4),("systemd",pid=1,fd=35))
ESTAB     0         0                 10.0.2.15:22               10.0.2.2:58010     users:(("sshd",pid=1148,fd=4),("sshd",pid=1111,fd=4))
LISTEN    0         128                    [::]:22                   [::]:*         users:(("sshd",pid=857,fd=4))
LISTEN    0         4096                   [::]:111                  [::]:*         users:(("rpcbind",pid=569,fd=6),("systemd",pid=1,fd=37))
```
> 22 - TCP,UDP - под SSH соединение, использует его sshd - is the OpenSSH server process 53 - TCP,UDP - под DNS, systemd-resolve 111 - TCP,UDP - под RPC - The rpcbind utility is a server that converts RPC program numbers into universal addresses

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

```
root@vagrant:~# ss -upan
State     Recv-Q    Send-Q         Local Address:Port         Peer Address:Port    Process
UNCONN    0         0              127.0.0.53%lo:53                0.0.0.0:*        users:(("systemd-resolve",pid=570,fd=12))
UNCONN    0         0             10.0.2.15%eth0:68                0.0.0.0:*        users:(("systemd-network",pid=402,fd=19))
UNCONN    0         0                    0.0.0.0:111               0.0.0.0:*        users:(("rpcbind",pid=569,fd=5),("systemd",pid=1,fd=36))
UNCONN    0         0                       [::]:111                  [::]:*        users:(("rpcbind",pid=569,fd=7),("systemd",pid=1,fd=38))
```

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.

 > [L3](L3.png)
 ---
