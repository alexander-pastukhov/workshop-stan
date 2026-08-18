# You should program your statistical models in Stan. It is easier than you think, and I'll show you how!
Workshop @ ECVP 2026 by [Alexander (Sasha) Pastukhov](https://alexander-pastukhov.github.io/)

See Quarto notebooks for R and Jupyter notebooks for Python code. All Stan code is in "Stan" folder.

## Installing Stan

To work with Stan, you will need to install 

* library [CmdStanR](https://mc-stan.org/cmdstanr/) for R or [CmdStanPy](https://mc-stan.org/cmdstanpy/) for Python.
* [cmdstan](https://mc-stan.org/docs/cmdstan-guide/installation.html) compiler for Stan code.
* [toolchain](https://mc-stan.org/docs/cmdstan-guide/installation.html#cpp-toolchain) for compilation (relevant for Windows users).


### R

On Windows, you will first need to install [rtools](https://cran.r-project.org/bin/windows/Rtools/). Then, follow the [installation instructions](https://mc-stan.org/cmdstanr/#installation) for the **CmdStanR** library.

```r
install.packages("cmdstanr", repos = c('https://stan-dev.r-universe.dev', getOption("repos")))
```

and for installing [CmdStan](https://mc-stan.org/cmdstanr/articles/cmdstanr.html#installing-cmdstan) itself via 
```r
cmdstanr::install_cmdstan(cores = 2)
```

### Python

Follow the [installation instructions]https://mc-stan.org/cmdstanpy/installation.html) for the **CmdStanPy** library.
The easiest way is to install into a Conda environment:

```bash
conda create -n stan -c conda-forge cmdstanpy cxx-compiler make
conda activate stan
```
