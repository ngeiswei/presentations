# Render gnuplots
cd pictures; gnuplot tp.gnuplot > tp.png; cd ..

# Render LaTeX presentation
for i in {1..2}; do pdflatex AGI-21-TemporalReasoning.tex; done
