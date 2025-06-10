#!/usr/bin/env sh

BASEPATH=/usr/share/nginx/speedtest
F_DATA=${BASEPATH}/data.csv
F_DATE=$(date -u +%Y%m)
GREP_DATE=$(date -u +%Y-%m)
F_PNG=${BASEPATH}/${F_DATE}.png
T_PNG="Speedtest $(date -u +'%B %Y')"

if [ ! -f ${F_DATA} ]; then
    /usr/bin/speedtest-cli --csv-header --csv-delimiter ";" > ${F_DATA}
fi

/usr/bin/speedtest-cli --csv --csv-delimiter ";" >> ${F_DATA}

cat << EOF | gnuplot
set terminal png nocrop enhanced font "/usr/share/fonts/liberation/LiberationSans-Regular.ttf" 8 size 1600,1000
set datafile separator ";"
set xlabel "date"
set ylabel "speed [bit/s]"
#set yrange [0:]
set y2tics
set ytics nomirror
#set y2range [0:]
set y2label "speed [ms]"
set style fill solid 1.00 border -1
set pointsize 0.5
set datafile missing '-'
set xtics border in scale 1,0.5 nomirror rotate by -45 offset character 0,0,0
set title "${T_PNG}"
#set logscale y 10
set style rect fc lt -1 fs solid 0.15 noborder
set object rect from graph 0, 25*10**6 to graph 1, 40*10**6
set output "`echo ${F_PNG}`"

plot "<(head -n1 ${F_DATA};cat ${F_DATA} | grep ${GREP_DATE})" \
	   using 7:xtic(4) ti col with lines, \
	"" using 8:xtic(4) ti col with lines, \
	"" using 6:xtic(4) ti col with lines axis x1y2, \
	   100*10**6 ti  "50 MBit/s" with points, \
	   225*10**6 ti "200 MBit/s" with points, \
	   250*10**6 ti "200 MBit/s" with points, \
	   300*10**6 ti "250 MBit/s" with points
EOF
