## IPTABLES Теория

Необходимо включить перенаправление пакетов на уровне ядра:

sysctl -w net.ipv4.ip.forward=1
echo "net.ipv4.ip_forward = 1" >> /etc/sysctrl.conf
