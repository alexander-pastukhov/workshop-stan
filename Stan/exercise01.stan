data {
  int<lower=1> N;
  array[N] int<lower=0> PresentN;
}
parameters {
  real<lower=0> lambda;
}
model {
  PresentN ~ poisson(lambda);   
  lambda ~ lognormal(2.5, 0.3);
}
