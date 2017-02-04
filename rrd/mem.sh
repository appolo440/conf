#!/bin/sh

cd `dirname $0`

if [ -f mem.rrd ];
then

mem_total=`free | grep Mem: | awk {'print $2'}`
mem_used=`free | grep Mem: | awk {'print $3'}`
mem_free=`free | grep Mem: | awk {'print $4'}`
mem_buf=`free | grep Mem: | awk {'print $6'}`
mem_cached=`free | grep Mem: | awk {'print $7'}`

echo ${mem_total}
echo ${mem_used}
echo ${mem_cached}
echo ${mem_free}
echo ${mem_buf}

/usr/bin/rrdtool update mem.rrd N:${mem_total}:${mem_used}:${mem_cached}:${mem_free}:${mem_buf}
/usr/bin/rrdtool graph /var/www/stat/mem.png --width 600 --height 320 --start -7d --end now --title "MEMORY USAGE"	\
DEF:d1=mem.rrd:d1:AVERAGE	\
DEF:d2=mem.rrd:d2:AVERAGE	\
DEF:d3=mem.rrd:d3:AVERAGE	\
DEF:d4=mem.rrd:d4:AVERAGE	\
DEF:d5=mem.rrd:d5:AVERAGE	\
LINE3:d1#c2e3ec:"TOTAL"		\
AREA:d1#c2e3ec				\
LINE3:d4#90bdd0:"FREE"		\
AREA:d4#90bdd0				\
LINE3:d2#53a0d6:"USED"		\
AREA:d2#53a0d6				\
LINE1:d3#093b5c:"CACHED"	\
AREA:d3#093b5c				\
LINE1:d5#000000:"BUF"

else

/usr/bin/rrdtool create mem.rrd --step 60	\
DS:d1:GAUGE:600:U:32952016	\
DS:d2:GAUGE:600:U:32952016	\
DS:d3:GAUGE:600:U:32952016	\
DS:d4:GAUGE:600:U:32952016	\
DS:d5:GAUGE:600:U:32952016	\
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