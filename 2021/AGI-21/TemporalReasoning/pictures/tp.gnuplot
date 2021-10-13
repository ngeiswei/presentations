set terminal png giant size 800 200

unset logscale x
set datafile separator ","
set title "Temporal Predicates"
set xlabel "Time"
unset ytics
plot [-2:10][1:8] "tp.csv" using 1:2 title "P" with steps lc rgb "red", "tp.csv" using 1:3 title "Q" with steps lc rgb "blue", "tp.csv" using 1:4 title "Lead Q" with steps lc rgb "brown"
