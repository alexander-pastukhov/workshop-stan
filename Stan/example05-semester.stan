data {
  int<lower=1> N;
  int<lower=1> SeminarsN;
  int<lower=1> SemestersN;
  
  array[N] int<lower=0> AttendanceN;
  array[N] int<lower=1, upper=SeminarsN> Seminar;
  array[N] int<lower=1, upper=SemestersN> Semester;
}

parameters {
  vector<lower=0>[SemestersN] lambda;
}

model {
  for(i in 1:N) AttendanceN[i] ~ poisson(lambda[Semester[i]]);
  
  lambda ~ lognormal(2.5, 0.3);
}

generated quantities {
  vector[N] log_lik;
  for(i in 1:N) log_lik[i] = poisson_lpmf(AttendanceN[i] | lambda[Semester[i]]);
}
