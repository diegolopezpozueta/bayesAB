% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bayesTest.R
\name{bayesTest}
\alias{bayesTest}
\title{Fit a Bayesian model to A/B test data.}
\usage{
bayesTest(A_data, B_data, priors, n_samples = 1e+05,
  distribution = c("bernoulli", "normal", "lognormal", "poisson",
  "exponential", "uniform", "bernoulliC", "poissonC"))
}
\arguments{
\item{A_data}{Vector of collected samples from recipe A}

\item{B_data}{Vector of collected samples from recipe B}

\item{priors}{Named vector or named list providing priors as required by the specified distribution:
\itemize{
          \item     For 'bernoulli' distribution \code{list("alpha" = val1, "beta" = val2)}
          \item     For 'normal' distribution \code{c("m0" = val1, "k0" = val2, "s_sq0" = val3, "v0" = val4)}
          \item     For 'lognormal' distribution \code{list("m0" = val1, "k0" = val2, "s_sq0" = val3, "v0" = val4)}
          \item     For 'poisson' distribution \code{c("shape" = val1, "rate" = val2)}
          \item     For 'exponential' distribution \code{list("shape" = val1, "rate" = val2)}
          \item     For 'uniform' distribution \code{c("xm" = val1, "alpha" = val2)}
          \item     For 'bernoulliC' distribution: same prior definitions as 'bernoulli'
          \item     For 'poissonC' distribution: same prior definitions as 'poisson'
          }}

\item{n_samples}{Number of posterior samples to draw. Should be large enough for the distribution to converge. 1e5 is a good rule of thumb. 
Not used for closed form tests.}

\item{distribution}{Distribution of underlying A/B test data.}
}
\value{
A \code{bayesTest} object of the appropriate distribution class.
}
\description{
This function fits a Bayesian model to your A/B testing sample data. See \bold{Details} for more information on usage.
}
\details{
\code{bayesTest} is the main driver function of the \bold{bayesAB} package. The input takes two vectors of data,
corresponding to recipe A and recipe B of an A/B test. Order does not matter, except for interpretability of the final
plots and intervals/point estimates. The Bayesian model for each distribution uses conjugate priors which must 
be specified at the time of invoking the function. Currently, there are \emph{eight} supported distributions for the underlying data:

\itemize{

\item Bernoulli: If your data is well modeled by 1s and 0s, according to a specific probability \code{p} of a 1 occuring
   \itemize{\item For example, click-through-rate /conversions for a page
            \item Data \bold{must} be in a \{0, 1\} format where 1 corresponds to a 'success' as per the Bernoulli distribution
            \item Uses a conjugate \code{Beta} distribution for the parameter \bold{p} in the Bernoulli distribution
            \item \code{alpha} and \code{beta} must be set for a prior distribution over \bold{p}
            \itemize{\item alpha = 1, beta = 1 can be used as a diffuse or uniform prior}}
            
\item Normal: If your data is well modeled by the normal distribution, with parameters \eqn{\mu}, \eqn{\sigma^2} controlling mean and variance
of the underlying distribution
   \itemize{\item Data \emph{can} be negative if it makes sense for your experiment
            \item Uses a conjugate \code{Normal} distribution for the parameter \bold{\eqn{\mu}} in the Normal Distribution
            \item Uses a conjugate \code{Inverse Gamma} distribution for the parameter \bold{\eqn{\sigma^2}} in the Normal Ditribution
            \item \code{m0}, \code{k0}, \code{s_sq0}, and \code{v0} must be set for prior 
            distributions over \bold{\eqn{\mu}, \eqn{\sigma^2}} in accordance with the parameters of the conjugate prior distributions:
            \itemize{\item \eqn{\mu} ~ Normal(m0, k0) \item \eqn{\sigma^2} ~ InvGamma(s_sq0, v0)}}
            
\item LogNormal: If your data is well modeled by the log-normal distribution, with parameters \eqn{\mu}, \eqn{\sigma^2} as the \bold{parameters}
of the corresponding log-normal distribution (log of data is ~ N(\eqn{\mu}, \eqn{\sigma^2}))
   \itemize{\item Support for a log-normal distribution is stricly positive
            \item The Bayesian model requires same conjugate priors on \eqn{\mu}, \eqn{\sigma^2} as for the Normal Distribution priors}
            
\item Poisson: If your data is well modeled by the Poisson distribution, with parameter \eqn{\lambda} controlling the average number of events
per interval.
   \itemize{\item For example, pageviews per session
            \item Data \emph{must} be strictly integral or 0.
            \item Uses a conjugate \code{Gamma} distribution for the parameter \bold{\eqn{\lambda}} in the Poisson Distribution
            \item \code{shape} and \code{rate} must be set for prior distribution over \eqn{\lambda}}
            
\item Exponential: If your data is well modeled by the Exponential distribution, with parameter \eqn{\lambda} controlling the 
rate of decay.
   \itemize{\item For example, time spent on a page or customers' LTV
            \item Data \emph{must} be strictly >= 0
            \item Uses a conjugate \code{Gamma} distribution for the parameter \bold{\eqn{\lambda}} in the Exponential Distribution
            \item \code{shape} and \code{rate} must be set for prior distribution over \eqn{\lambda}}
            
\item Uniform: If your data is well modeled by the Uniform distribution, with parameter \eqn{\theta} controlling the \emph{max} value.
   \itemize{\item bayesAB has only implemented Uniform(0, \eqn{\theta}) forms
            \item For example, estimating max/total inventory size from individually numbered snapshots
            \item Data \emph{must} be strictly > 0
            \item Uses a conjugate \code{Pareto} distribution for the parameter \bold{\eqn{\theta}} in the Uniform(0, \eqn{\theta}) Distribution
            \item \code{xm} and \code{alpha} must be set for prior distribution over \eqn{\theta}}
            
\item BernoulliC: Closed form (computational) calculation of the 'bernoulli' bayesTest. Same priors are required.
\item PoissonC: Closed form(computational) calculation of the 'poisson' bayesTest. Same priors are required.
}
}
\note{
For 'closed form' tests, you do not get a distribution over the posterior, but simply P(A > B) for the parameter in question.
}
\examples{
A_binom <- rbinom(100, 1, .5)
B_binom <- rbinom(100, 1, .6)

A_norm <- rnorm(100, 6, 1.5)
B_norm <- rnorm(100, 5, 2.5)

AB1 <- bayesTest(A_binom, B_binom, priors = c('alpha' = 1, 'beta' = 1), distribution = 'bernoulli')
AB2 <- bayesTest(A_norm, B_norm, 
                priors = c('m0' = 5, 'k0' = 1, 's_sq0' = 3, 'v0' = 1), distribution = 'normal')

print(AB1)
summary(AB1)
plot(AB1)

print(AB2)
summary(AB2)
plot(AB2)

# Create a new variable that is the probability multiiplied 
# by the normally distributed variable (expected value of something)
AB3 <- combine(AB1, AB2, f = `*`, params = c('Probability', 'Mu'), newName = 'Expectation')

print(AB3)
summary(AB3)
plot(AB3)

}

