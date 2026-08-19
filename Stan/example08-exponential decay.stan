data {
  int<lower=1> N;
  
  array[N] real D;
  array[N] real S;
}

parameters {
  real a;
  real b;
  
  real<lower=0, upper=1> Hstart;
  real<lower=0> tau_H;
  
  real rate;
}

transformed parameters {
  vector[N] shape;
  {
    real crnt_H; // visible within scope, but NOT present in posterior samples
    for(i in 1:N){
      // habituation level
      if (i == 1) {
        crnt_H = Hstart;
      } else {
        crnt_H += (crnt_H - S[i-1]) * exp(-D[i-1]/tau_H);        
      }
      
      if (S[i] == 1) {
        shape[i] = exp(a + b * crnt_H);
      } else {
        // habituation for the other percept mirrors the current one
        shape[i] = exp(a + b * (1 - crnt_H)); 
      }
    }
  }
}

model {
  D ~ gamma(shape, rate);
  
  a ~ normal(log(2), 0.5);
  b ~ normal(0, 1);
  
  Hstart ~ beta(3, 3);
  tau_H ~ exponential(1);
  
  rate ~ exponential(1);
}
