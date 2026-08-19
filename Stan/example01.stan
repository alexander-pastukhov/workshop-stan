data {
  int<lower=1> N; // Number of data points. It is integer (int) and <lower=1> means that we expect at least one data point.
  array[N] int<lower=0, upper=1> Correct; // N responses, each is either correct (1) or erroneous (0). Hence, it is an integer with values ranging between 0 and 1.
}
parameters {
  real<lower=0, upper=1> p; // Bernoulli distribution has just one parameter, p - proportion of 1 responses, its support is 0 to 1.
}
model {
  Correct ~ bernoulli(p);   // Sampling data from the Bernoulli distribution
  p ~ beta(8, 3);           // Sampling parameter p from the Beta distribution, assuming weakly regularizing priors centered at ~75%
}
