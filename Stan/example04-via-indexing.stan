data {
  int<lower=1> N;
  int<lower=1> ConditionsN;
  int<lower=1> ParticipantsN;
  
  array[N] int<lower=0, upper=1> Left;
  array[N] int<lower=1, upper=ConditionsN> Condition;
  array[N] int<lower=1, upper=ParticipantsN> Participant;
}

parameters {
  vector[ConditionsN] mu_left;        // group-average for each condition
  real<lower=0> sigma_participant;     // variability of population
  vector[ParticipantsN] z_participant; // z-scores for individual participants
}

transformed parameters {
  vector[N] p;
  for(i in 1:N) {
    p[i] = inv_logit(mu_left[Condition[i]] + sigma_participant * z_participant[Participant[i]]);
  }
}

model {
  Left ~ bernoulli(p);
  
  mu_left ~ normal(0, 1);
  sigma_participant ~ exponential(1);
  z_participant ~ normal(0, 1);
}

generated quantities {
  vector[2] pLeft = inv_logit(mu_left); // group-level estimates
  real beta_p = pLeft[2] - pLeft[1]; // difference in units of probability
}
