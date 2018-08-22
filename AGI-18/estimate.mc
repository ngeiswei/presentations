/* For Beta distributions */
load(distrib);

/* Pior */
p(k):=2^(-k);

/* Likelihood of the unexplained data */
r(v,c):=2^(-v^(1-c));

/* Likelihood of the explained data */
l(m,n):=beta(m+1, n+1);

/* Weight given
   k : Kolmogorov complexity
   v : remaining data size
   c : compressability parameter
   m : true positives
   n : false positives
*/
w(k,v,c,m,n):=p(k)*r(v,c)*l(m,n);

/* General parameters */
c:1.0;

/* Parameters for model 1 */
k1:10.0;
m1:40.0;
n1:60.0;
v1:0.0;

/* Parameters for model 2 */
k2:13.0;
m2:7.0;
n2:1.0;
v2:m1+n1-m2-n2;

/* Weight for model 1 */
w1:w(k1, v1, c, m1, n1);

/* Weight for model 2 */
w2:w(k2, v2, c, m2, n2);

/* Normalized weights */
nw1:w1/(w1+w2);
nw2:w2/(w1+w2);

/* Defined mixed pdf */
mixed_pdf(x) := nw1 * pdf_beta(x, m1+1, n1+1) + nw2 * pdf_beta(x, m2+1, n2+1);

/* Plot beta1 */
/* plot2d(pdf_beta(x, m1+1, n1+1), [x, 0, 1]); */

/* Plot beta2 */
/* plot2d(pdf_beta(x, m2+1, n2+1), [x, 0, 1]); */

/* Plot mixed pdf */
plot2d(mixed_pdf(x), [x, 0, 1]);
