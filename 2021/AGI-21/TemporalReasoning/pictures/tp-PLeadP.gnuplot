set terminal png giant size 800 200

unset logscale x
set datafile separator ","
set title "Temporal Predicate Lead"
set xlabel "Time"
unset ytics
plot [-2:10][3:8] "tp-PLeadP.csv" using 1:2 title "P" with steps lc rgb "red", "tp-PLeadP.csv" using 1:3 title "Lead P" with steps lc rgb "brown"
