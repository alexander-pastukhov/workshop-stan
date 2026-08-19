data {
  int<lower=1> N;
  
  array[N] int<lower=0> Nbias;
  array[N] int<lower=1> Ntotal;
  array[N] real Tbias;
  array[N] real Tprobe;
}

transformed data {
  vector[N] Tlate;
  for(i in 1:N) {
    if (Tbias[i] >Tprobe[i]) {
      Tlate[i] = Tbias[i];
    } else {
      Tlate[i] = Tprobe[i];
    }
  }
}

parameters {
  real a;
  real b;
  real<lower=0> tau_bias;
  real<lower=0> tau_probe;
}

transformed parameters {
  vector[N] p;
  for(i in 1:N) {
    p[i] = inv_logit(a + b * exp( (Tlate[i] - Tbias[i]) / tau_bias - (Tlate[i] - Tprobe[i]) / tau_probe));
  }
}

model {
  Nbias ~ binomial(Ntotal, p);
  
  a ~ normal(0, 1);
  b ~ normal(0, 1);
  tau_bias ~ exponential(0.1);
  tau_probe ~ exponential(0.1);
}
