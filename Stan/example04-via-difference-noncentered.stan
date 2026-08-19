data {
  int<lower=1> N;
  int<lower=1> AttentionN;
  int<lower=1> ParticipantsN;
  
  array[N] int<lower=1> Ntotal;
  array[N] int<lower=0> Ncorrect;
  array[N] int<lower=1, upper=AttentionN> Attention;
  array[N] int<lower=1, upper=ParticipantsN> Participant;
}

transformed data {
  array[N] int IsFull;
  // alternative via for loop
  for(i in 1:N) IsFull[i] = Attention[i] - 1; // Or Attention[i] == 2
}

parameters {
  real mu_a_poor;                    // group-level average for poor attention condition
  real<lower=0> sigma_Participant;   // variability of population
  vector[ParticipantsN] z_poor;      // poor attention condition for individual participants
  real b_A;                          // group-level difference between attention conditions
}

transformed parameters {
  // poor attention condition for individual participants
  vector[ParticipantsN] a_poor = mu_a_poor + sigma_Participant * z_poor;
      
  vector[N] p;
  for(i in 1:N) p[i] = inv_logit(a_poor[Participant[i]] + b_A * IsFull[i]);
}

model {
  Ncorrect ~ binomial(Ntotal, p);

  mu_a_poor ~ normal(logit(0.75), 1);
  sigma_Participant ~ exponential(1);
  z_poor ~ normal(0, 1);
  b_A ~ normal(0, 1);
}

generated quantities {
  // probability of correct response at group level
  vector[2] pCorrect;
  pCorrect[1] = inv_logit(mu_a_poor);
  pCorrect[2] = inv_logit(mu_a_poor + b_A);

  // difference between conditions in probability space  
  real dA = pCorrect[2] - pCorrect[1];
}
