#!/bin/sh

IF_EXT="eth0"
IF_INT="eth1"
IPT="/sbin/iptables"

# Drop all chain's and rules
$IPT -F
$IPT -X
$IPT -t nat -F
$IPT -t nat -X
$IPT -t mangle -F
$IPT -t mangle -X

# Set deny default rule
$IPT -P INPUT DROP
$IPT -P OUTPUT DROP
$IPT -P FORWARD DROP

# Allow all from Lo interface
$IPT -A INPUT -i lo -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
$IPT -A OUTPUT -o lo -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT

# Allow local network access SSH
$IPT -A INPUT -i $IF_INT -d 192.168.200.10 -p tcp --dport 2211 -j ACCEPT

# postfix.akb.bnkv
$IPT -A INPUT -i $IF_INT -s 192.168.200.2,192.168.200.4 -d 192.168.200.10 -p tcp --dport 5050 -j ACCEPT
# reuters.akb.bnkv
$IPT -A INPUT -i $IF_INT -s 192.168.200.2,192.168.200.4 -d 192.168.200.10 -p tcp --dport 5051 -j ACCEPT
# gate.office.akb.bnkv
$IPT -A INPUT -i $IF_INT -s 192.168.200.2,192.168.200.4 -d 192.168.200.10 -p tcp --dport 5052 -j ACCEPT
# gate.mail.akb.bnkv
$IPT -A INPUT -i $IF_INT -s 192.168.200.2,192.168.200.4 -d 192.168.200.10 -p tcp --dport 5053 -j ACCEPT
# web.akb.bnkv
$IPT -A INPUT -i $IF_INT -s 192.168.200.2,192.168.200.4 -d 192.168.200.10 -p tcp --dport 5054 -j ACCEPT
# multicarta.akb.bnkv
$IPT -A INPUT -i $IF_INT -s 192.168.200.2,192.168.200.4 -d 192.168.200.10 -p tcp --dport 5055 -j ACCEPT
# e-stok.akb.bnkv
$IPT -A INPUT -i $IF_INT -s 192.168.200.2,192.168.200.4 -d 192.168.200.10 -p tcp --dport 5056 -j ACCEPT
# ids.yakunin.net.ru
$IPT -A INPUT -i $IF_INT -s 192.168.200.2,192.168.200.4 -d 192.168.200.10 -p tcp --dport 5057 -j ACCEPT
# support.yakunin.net.ru
$IPT -A INPUT -i $IF_INT -s 192.168.200.2,192.168.200.4 -d 192.168.200.10 -p tcp --dport 5058 -j ACCEPT

# ALLOW WEB STATISTIC TO ADMINISTRATOR
$IPT -A INPUT -i $IF_INT -s 192.168.200.2,192.168.200.4 -d 192.168.200.10 -p tcp --dport 80 -j ACCEPT

# Allow local network ICMP pakages
$IPT -A INPUT -i $IF_INT -s 192.168.200.0/24 -d 192.168.200.10 -p ICMP -j ACCEPT

# Allow output all from CORE to local network

$IPT -A INPUT -d 192.168.200.10 -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A OUTPUT -o $IF_INT -s 192.168.200.10 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

#$IPT -A OUTPUT -o $IF_INT -s 192.168.200.10 -m state --state ESTABLISHED,RELATED -j ACCEPT