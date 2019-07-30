/* Maxima file. Under emacs type

M-x maxima

then

M-x maxima-send-buffer

to produce the graph */

/* For Beta distributions */
load(distrib);

/* Empirical PDF */
emp_a:120.0;
emp_b:280.0;
empirical(x):=pdf_beta(x, emp_a, emp_b);

/* Estimate PDF */
est_a:30.0;
est_b:30.0;
estimate(x):=pdf_beta(x, est_a, est_b);

/* Plot */
plot2d([empirical, estimate] , [probability, 0, 1], [title, "Empirical vs Estimate PDF - Surprising"]);
