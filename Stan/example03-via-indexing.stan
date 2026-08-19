data {
  int<lower=1> N;
  int<lower=1> AttentionN;
  
  array[N] int<lower=0, upper=1> Correct;
  array[N] int<lower=1, upper=AttentionN> Attention;
}

parameters {
  vector<lower=0, upper=1>[AttentionN] pCorrect;
}

transformed parameters {
  vector[N] p;
  for(i in 1:N) p[i] = pCorrect[Attention[i]];
}

model {
  Correct ~ bernoulli(p);

  pCorrect ~ beta_proportion(0.75, 5);
}

generated quantities {
  // difference between conditions in probability space  
  real dA = pCorrect[2] - pCorrect[1];
}
