/* Maxima file. Under emacs type

M-x maxima

then

M-x maxima-send-buffer

to produce the graphs.

Optionally, open gimp, add an alpha channel in the layer toolbar, and
replace color by transparent in "Colors->Color to Alpha..." menu.

*/

/* For Beta distributions */
load(distrib);

/* Beta distributions */
bayesian_prior(x):=pdf_beta(x, 1.0, 1.0);
jeffreys_prior(x):=pdf_beta(x, 0.5, 0.5);
observations_2(x):=pdf_beta(x, 2.0, 2.0);
observations_10(x):=pdf_beta(x, 4.0, 8.0);
observations_50(x):=pdf_beta(x, 14.0, 37.0);

/* Plot */
/*
*/
plot2d([bayesian_prior],
       [probability, 0, 1],
       [y, 0, 7],
       [ylabel, "density"],
       [title, "Bayesian prior"],
       [png_file, "~/OpenCog/presentations/2020/AGI-20/images/bayesian_prior.png"]);

plot2d([jeffreys_prior],
       [probability, 0, 1],
       [y, 0, 7],
       [ylabel, "density"],
       [title, "Jeffreys prior"],
       [png_file, "~/OpenCog/presentations/2020/AGI-20/images/jeffreys_prior.png"]);

plot2d([observations_2],
       [probability, 0, 1],
       [y, 0, 7],
       [ylabel, "density"],
       [title, "2 observations"],
       [png_file, "~/OpenCog/presentations/2020/AGI-20/images/observations_2.png"]);

plot2d([observations_10],
       [probability, 0, 1],
       [y, 0, 7],
       [ylabel, "density"],
       [title, "10 observations"],
       [png_file, "~/OpenCog/presentations/2020/AGI-20/images/observations_10.png"]);

plot2d([observations_50],
       [probability, 0, 1],
       [y, 0, 7],
       [ylabel, "density"],
       [title, "50 observations"],
       [png_file, "~/OpenCog/presentations/2020/AGI-20/images/observations_50.png"]);
