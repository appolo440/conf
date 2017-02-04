#!/bin/sh

cd `dirname $0`

if [ -f cpu.rrd ];
then

cpu_user=`top -b -n2 | grep Cpu | tail -n1 | awk {'print $2'}`
cpu_nice=`top -b -n2 | grep Cpu | tail -n1 | awk {'print $6'}`
cpu_sys=`top -b -n2 | grep Cpu | tail -n1 | awk {'print $4'}`
cpu_idle=`top -b -n2 | grep Cpu | tail -n1 | awk {'print $8'}`

echo ${cpu_user}
echo ${cpu_nice}
echo ${cpu_sys}
echo ${cpu_idle}

/usr/bin/rrdtool update cpu.rrd N:${cpu_user}:${cpu_nice}:${cpu_sys}:${cpu_idle}
/usr/bin/rrdtool graph /var/www/stat/cpu.png --width 600 --height 320 --start -7d --end now --title "CPU USAGE"	\
DEF:d1=cpu.rrd:d1:AVERAGE	\
DEF:d2=cpu.rrd:d2:AVERAGE	\
DEF:d3=cpu.rrd:d3:AVERAGE	\
DEF:d4=cpu.rrd:d4:AVERAGE	\
LINE1:d4#c6e6f0:"IDLE"		\
AREA:d4#c6e6f0				\
LINE1:d3#94c0cf:"NICE"		\
AREA:d3#94c0cf				\
LINE1:d2#559ed6:"SYS"		\
AREA:d2#559ed6				\
LINE1:d1#0f5d99:"USER"		\
AREA:d1#0f5d99

else

/usr/bin/rrdtool create cpu.rrd --step 60	\
DS:d1:GAUGE:120:0:100		\
DS:d2:GAUGE:120:0:100		\
DS:d3:GAUGE:120:0:100		\
DS:d4:GAUGE:120:0:100		\
RRA:AVERAGE:0.5:1:525600	\
RRA:AVERAGE:0.5:15:35040	\
RRA:AVERAGE:0.5:30:17520	\
RRA:AVERAGE:0.5:60:8760		\
RRA:MIN:0.5:1:525600		\
RRA:MIN:0.5:15:35040		\
RRA:MIN:0.5:30:17520		\
RRA:MIN:0.5:60:8760			\
RRA:MAX:0.5:1:525600		\
RRA:MAX:0.5:15:35040		\
RRA:MAX:0.5:30:17520		\
RRA:MAX:0.5:60:8760

fi
exit 0