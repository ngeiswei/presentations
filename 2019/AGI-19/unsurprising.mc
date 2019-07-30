/* Maxima file. Under emacs type

M-x maxima

then

M-x maxima-send-buffer

to produce the graph */

/* For Beta distributions */
load(distrib);

/* Empirical PDF */
emp_a:280.0;
emp_b:280.0;
empirical(x):=pdf_beta(x, emp_a, emp_b);

/* Estimate PDF */
est_a1:10.0;
est_b1:30.0;
est_a2:100.0;
est_b2:100.0;
est_a3:80.0;
est_b3:30.0;
estimate(x):=(pdf_beta(x, est_a1, est_b1)+pdf_beta(x, est_a2, est_b2)+pdf_beta(x, est_a3, est_b3))/3.0;

/* Plot */
plot2d([empirical, estimate] , [probability, 0, 1], [title, "Empirical vs Estimate PDF - Unsurprising"]);
