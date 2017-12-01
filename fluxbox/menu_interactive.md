1. Скопируй файл .ovpn в директорию /etc/openvpn/
2. Создай подменю в основном файле конфигурации: /etc/X11/fluxbox/fluxbox-menu

```
[submenu] (VPN) {}
[exec] (MADI Disconnect)  {sudo /usr/bin/madi-openvpn}
[end]
```

3. Создай файл по пути который указан в меню, (/usr/bin/madi-openvpn)
4. При необходимости поменяй поисковую фарзу для sed.

```
#!/bin/bash
VPN=`ps aux | grep madi.ovpn | grep -v grep | awk {'print $2'} | wc -l`

if [ ${VPN} == 1 ]; then
	echo "Stopping"
	VPNPID=`ps aux | grep madi.ovpn | grep -v grep | awk {'print $2'}`
	kill -9 ${VPNPID}
	sed -i 's/.*MADI Disconnect.*/\x5Bexec\x5D \x28MADI Connect\x29 \x7Bsudo \x2Fusr\x2Fbin\x2Fmadi-openvpn\x7D/' /etc/X11/fluxbox/fluxbox-menu
else
	echo "Starting"
	openvpn /etc/openvpn/madi.ovpn > /dev/null 2>&1 &
	sed -i 's/.*MADI Connect.*/\x5Bexec\x5D \x28MADI Disconnect\x29  \x7Bsudo \x2Fusr\x2Fbin\x2Fmadi-openvpn\x7D/' /etc/X11/fluxbox/fluxbox-menu 
fi
```

5. Пользуемся. При подлючении пункт меню автоматически будет менять звание.
