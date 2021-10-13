# Render gnuplots
cd pictures
gnuplot tp.gnuplot > tp.png
gnuplot tp-PQ.gnuplot > tp-PQ.png
gnuplot tp-PLagP.gnuplot > tp-PLagP.png
gnuplot tp-PLeadP.gnuplot > tp-PLeadP.png
cd ..

# Render LaTeX presentation
for i in {1..2}; do pdflatex AGI-21-TemporalReasoning.tex; done
