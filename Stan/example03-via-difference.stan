data {
  int<lower=1> N;
  int<lower=1> AttentionN;
  
  array[N] int<lower=0, upper=1> Correct;
  array[N] int<lower=1, upper=AttentionN> Attention;
}

transformed data {
  array[N] int IsFull;
  // alternative via for loop
  for(i in 1:N) IsFull[i] = Attention[i] - 1; // Or Attention[i] == 2
}

parameters {
  real a_poor;
  real b_A;
}

transformed parameters {
  vector[N] p;
  for(i in 1:N) {
    // logit link, i.e., logit(p[i]) = a_poor + b_A * IsFull[i]
    p[i] = inv_logit(a_poor + b_A * IsFull[i]);
  }

}

model {
  Correct ~ bernoulli(p);

  a_poor ~ normal(logit(0.75), 0.5);
  b_A ~ normal(0, 1);
}

generated quantities {
  // probability of correct response
  vector[2] pCorrect;
  pCorrect[1] = inv_logit(a_poor);
  pCorrect[2] = inv_logit(a_poor + b_A);

  // difference between conditions in probability space  
  real dA = pCorrect[2] - pCorrect[1];
}
