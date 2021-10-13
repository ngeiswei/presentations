set terminal png giant size 800 200

unset logscale x
set datafile separator ","
set title "Temporal Predicates"
set xlabel "Time"
unset ytics
plot [-2:10][3:8] "tp-PQ.csv" using 1:2 title "P" with steps lc rgb "red", "tp-PQ.csv" using 1:3 title "Q" with steps lc rgb "blue"
