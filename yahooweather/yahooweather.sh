# setup
RUNDIR=/Users/bit_jammer/Development/geektool/yahooweather
MADRIDWEATHER=http://es.tiempo.yahoo.com/espa%C3%B1a/comunidad-de-madrid/madrid-766273/

#rm -f $RUNDIR/yahooweather.png $RUNDIR/termic $RUNDIR/wind $RUNDIR/humnidity $RUNDIR/sun*
rm -f $RUNDIR/termic $RUNDIR/wind $RUNDIR/humnidity $RUNDIR/sun*

cd $RUNDIR

curl -s $MADRIDWEATHER > output.html
#
# search for the png
#
line=`cat output.html | grep 'class="current-weather"' | cut -d'(' -f2 | cut -d')' -f1 | sed "s/'//g"`
# echo step1: $line
# line=${line##*http}
# echo step2: $line
# line=${line%%\',*}
# echo step3: $line
# line=`echo http$line`
# echo step4: $line
#wget -O $RUNDIR/yahooweather.png --quiet $line
/opt/local/bin/wget -O $RUNDIR/yahooweather.png --quiet $line

#
# search for the information provided in text mode
#
sourceline=`cat output.html | grep Sensación`
line=${sourceline#*Sensación}
line=${line#*temp-c\">}
line=${line%&deg;C*}
echo "Sensación térmica de $line º"  > $RUNDIR/termic

line=${sourceline##*Viento}
line=${line#*temp-c\">}
line=${line%%<*}
echo "Vientos de $line" > $RUNDIR/wind

line=${sourceline##*Humedad}
line=${line#*detail-text\">}
line=${line%%<*}
echo "Humedad relativa del $line%" > $RUNDIR/humidity

line=${sourceline##*Salida del sol}
line=${line#*detail-text\">}
sunrise=${line%%<*}

line=${sourceline##*Puesta del sol}
line=${line#*detail-text\">}
sunset=${line%%<*}
echo "Salida del sol $sunrise y puesta $sunset" > $RUNDIR/sun
