set terminal png giant size 800 600

g(x)=0.7*exp(-(x+1)**2)
h(x)=exp(-(x+3)**4)
k(x)=0.8*exp(-(x+1)**2)+0.2*exp(-(x)**4)

f(x)=g(x)+h(x)

#plot [-4:0] [0:1.2] f(x) title 'target f' with linespoints
#plot [-4:0] f(x) title 'target f' with linespoints, g(x) title 'candidate g' with linespoints
#plot [-4:0] f(x) title 'target f' with linespoints, g(x) title 'candidate g' with linespoints, h(x) title 'candidate h' with linespoints
plot [-4:0] f(x) title 'target f' with linespoints, g(x) title 'candidate g' with linespoints, h(x) title 'candidate h' with linespoints, k(x) title 'candidate k' with linespoints

