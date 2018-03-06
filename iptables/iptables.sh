#!/bin/bash

# Объявляем все сетевые интерфейсы
IF_EXT="ens192"
IF_INT="ens224"

# Задаем сети и исполнямые файлы в переменные для удобства.
INT_NET="10.150.0.0/24"
EXT_NET="193.106.94.74"
IPT="/sbin/iptables"

# Сбрасываем все установелнные до начала работы правила и очищаем таблицы NAT
$IPT -F
$IPT -X
$IPT -t nat -F
$IPT -t nat -X
$IPT -t mangle -F
$IPT -t mangle -X

# Задаем политики по-умолчанию. Изначально все запрещено, разрешаем только то что необходимо. 
$IPT -P INPUT DROP
$IPT -P OUTPUT DROP
$IPT -P FORWARD DROP

# Зазрешаем трафик на лоубэек интерфейсе. 
$IPT -A INPUT -i lo -s 127.0.0.1 -d 127.0.0.1 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Разрешаем подлючаться к хосту по SSH
$IPT -A INPUT -p tcp --dport 22 -j ACCEPT

# Разрешаем все пакеты внтури локальной сети
$IPT -A INPUT -i $IF_INT -s $INT_NET -d $INT_NET -p all -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Разрешаем все виды эхо-запросов, в будущем лучше ограничить данный параметр только необходимыми пакетами.
$IPT -A INPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Разрешаем все уже установленные соединения, разрешаются только установленные не новые.
$IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Перенаправляем порты на локальную машину или открваем рейндж портов.
$IPT -t nat -A PREROUTING -p tcp -d $EXT_NET --dport 80 -j DNAT --to-destination 10.150.0.2:80
$IPT -t nat -A PREROUTING -d $EXT_NET -p tcp -m multiport --dports 5000:5100 -j DNAT --to-destination 10.150.0.2:5000-5100

# Включаем трансляцию NAT для адресов локальной сети.
$IPT -t nat -A POSTROUTING -o $IF_EXT -s $INT_NET -j MASQUERADE

# Разрезаем весь трафик перенаправленный по NAT
$IPT -A FORWARD -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Разрешаем все исходящие от нас соединения.
$IPT -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
