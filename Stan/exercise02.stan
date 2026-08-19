data {
  int<lower=1> N;
  array[N] real Height;
}
parameters {
  real mu;
  real<lower=0> sigma;
}
model {
  Height ~ normal(mu, sigma);   
  
  mu ~ normal(178, 5);
  sigma ~ exponential(1);
}
