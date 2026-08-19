data {
  int<lower=1> N;
  int<lower=1> SeminarsN;
  int<lower=1> SemestersN;
  
  array[N] int<lower=0> AttendanceN;
  array[N] int<lower=1, upper=SeminarsN> Seminar;
  array[N] int<lower=1, upper=SemestersN> Semester;
}

parameters {
  // vector<lower=0>[SemestersN] lambda;
  real a_A_W;
  vector[SeminarsN - 1] b_Seminar;
  real b_Semester;
}

transformed parameters {
  matrix[SeminarsN, SemestersN] lambda;
  for(iSeminar in 1:SeminarsN) {
    for(iSemester in 1:SemestersN) {
      if (iSeminar == 1) {
        lambda[iSeminar, iSemester] = exp(a_A_W + b_Semester * (iSemester - 1));
      } else {
        lambda[iSeminar, iSemester] = exp(a_A_W + b_Seminar[iSeminar - 1] + b_Semester * (iSemester - 1));
      }
    }
  }
}

model {
  for(i in 1:N) AttendanceN[i] ~ poisson(lambda[Seminar[i], Semester[i]]);
  
  a_A_W ~ normal(log(15), 0.5);
  b_Seminar ~ normal(0, 1);
  b_Semester ~ normal(0, 1);
}

generated quantities {
  vector[N] log_lik;
  for(i in 1:N) log_lik[i] = poisson_lpmf(AttendanceN[i] | lambda[Seminar[i], Semester[i]]);
}
