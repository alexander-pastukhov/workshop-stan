data {
  int<lower=1> N;
  int<lower=1> ConditionsN;
  int<lower=1> ParticipantsN;
  
  array[N] int<lower=0, upper=1> Left;
  array[N] int<lower=1, upper=ConditionsN> Condition;
  array[N] int<lower=1, upper=ParticipantsN> Participant;
}

transformed data {
  array[N] int IsB;
  for(i in 1:N) IsB[i] = Condition[i] - 1; // 0 for condition A, 1 for condition B
}

parameters {
  real mu_A;                           // group-level average for condition A
  real<lower=0> sigma_participant;     // variability of population
  vector[ParticipantsN] z_participant; // z-scores for individual participants
  real b;                              // group-level difference between conditions A and B
}

transformed parameters {
  vector[N] p;
  {
    // condition a for individual participants
    vector[ParticipantsN] a = mu_A + sigma_participant * z_participant;
    for(i in 1:N) {
      p[i] = inv_logit(a[Participant[i]] + b * IsB[i]);
    }
  }
}

model {
  Left ~ bernoulli(p);

  mu_A ~ normal(0, 1);
  sigma_participant ~ exponential(1);
  z_participant ~ normal(0, 1);
  b ~ normal(0, 1);
}

generated quantities {
  vector[2] pLeft; // group-level estimates
  pLeft[1] = inv_logit(mu_A);
  pLeft[2] = inv_logit(mu_A + b);
  
  real beta_pLeft = pLeft[2] - pLeft[1]; // difference in units of probability
}
