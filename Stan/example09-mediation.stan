data {
  int<lower=1> N;
  
  array[N] int<lower=0> Outcome; // count
  array[N] real Predictor;
  array[N] int<lower=0, upper=1> Mediator; // binary 
}

parameters {
  // model for full effect of the predictor
  real a_f;
  real bP_f;
  
  // model for the direct effect of the predictor
  real a_d;
  real bP_d;
  real bM_d;
}

transformed parameters {
  vector[N] lambda_f = exp(a_f + bP_f * to_vector(Predictor));
  vector[N] lambda_d = exp(a_d + bP_d * to_vector(Predictor) + bM_d * to_vector(Mediator));
}

model {
  // full effect model
  Outcome ~ poisson(lambda_f);
  
  a_f ~ normal(log(12), 1);
  bP_f ~ normal(0, 1);
  
  // direct effect model
  Outcome ~ poisson(lambda_d);
  a_d ~ normal(log(12), 1);
  bP_d ~ normal(0, 1);
  bM_d ~ normal(0, 1);
}

generated quantities {
  // mediated effect
  real bP_m = bP_f - bP_d;
  
  // log-likelihoods for both models
  vector[N] log_lik_f;
  vector[N] log_lik_d;
  for(i in 1:N) {
    log_lik_f[i] = poisson_lpmf(Outcome[i] | lambda_f[i]);
    log_lik_d[i] = poisson_lpmf(Outcome[i] | lambda_d[i]);
  }
}
