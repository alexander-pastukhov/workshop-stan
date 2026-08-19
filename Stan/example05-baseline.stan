data {
  int<lower=1> N;
  int<lower=1> SeminarsN;
  int<lower=1> SemestersN;
  
  array[N] int<lower=0> AttendanceN;
  array[N] int<lower=1, upper=SeminarsN> Seminar;
  array[N] int<lower=1, upper=SemestersN> Semester;
}

parameters {
  real<lower=0> lambda;
}

model {
  AttendanceN ~ poisson(lambda);
  
  lambda ~ lognormal(2.5, 0.3);
}

generated quantities {
  vector[N] log_lik;
  for(i in 1:N) log_lik[i] = poisson_lpmf(AttendanceN[i] | lambda);
}
