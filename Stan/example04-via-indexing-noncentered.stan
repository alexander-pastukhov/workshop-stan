data {
  int<lower=1> N;
  int<lower=1> AttentionN;
  int<lower=1> ParticipantsN;
  
  array[N] int<lower=1> Ntotal;
  array[N] int<lower=0> Ncorrect;
  array[N] int<lower=1, upper=AttentionN> Attention;
  array[N] int<lower=1, upper=ParticipantsN> Participant;
}

parameters {
  vector[AttentionN] mu_a;           // group-level average for poor attention condition
  real<lower=0> sigma_Participant;   // variability of population
  vector[ParticipantsN] z;      // poor attention condition for individual participants
  real b_A;                          // group-level difference between attention conditions
}

transformed parameters {
  // poor attention condition for individual participants
  matrix[AttentionN, ParticipantsN] a;
  for(iA in 1:AttentionN){
    for(iP in 1:ParticipantsN){
      a[iA, iP] = mu_a[iA] + sigma_Participant * z[iP];
    }
  }
      
  vector[N] p;
  for(i in 1:N) p[i] = inv_logit(a[Attention[i], Participant[i]]);
}

model {
  Ncorrect ~ binomial(Ntotal, p);

  mu_a ~ normal(logit(0.75), 1);
  sigma_Participant ~ exponential(1);
  z ~ normal(0, 1);
}

generated quantities {
  // probability of correct response at group level
  vector[2] pCorrect = inv_logit(mu_a);

  // difference between conditions in probability space  
  real dA = pCorrect[2] - pCorrect[1];
}
