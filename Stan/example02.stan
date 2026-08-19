data {
  int<lower=1> N;
  array[N] real<lower=0, upper=1> Pleft;
}

parameters {
  real<lower=0, upper=1> p;
  real<lower=0> sigma;
}

model {
  Pleft ~ beta_proportion(p, 1 / sigma);
  
  p ~ beta(3, 3);
  sigma ~ exponential(1);
}
