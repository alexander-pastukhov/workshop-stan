data {
  int<lower=1> N;
  
  array[N] real Direction;
  array[N] real Response;
  array[N] int<lower=1> Trial;
}

parameters {
  real Wprev;
  real<lower=0> lambda;
  
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu;
  
  for(i in 1:N) {
    if (Trial[i] == 1) {
      mu[i] = Direction[i];
    } else {
      real prior_relevance = exp(-((Response[i-1] - Direction[i])^2) / (2 * lambda^2));
      mu[i] = Direction[i] + Wprev * prior_relevance * (Response[i-1] - Direction[i]);
    }
  }
}

model {
  Response ~ normal(mu, sigma);

  Wprev ~ normal(0, 0.25);
  lambda ~ exponential(1); // more optimal is to sample two_lambda_squared directly and then compute lambda
  sigma ~ exponential(1);
}
