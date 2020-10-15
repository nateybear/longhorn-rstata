# this is a class representation of estimators that just stores a point estimate, covariance matrix, and alpha level.
# from there you can reproduce the p-values and confidence intervals like stata
rstata_estimator <- function(estimates, vcov, level) {
  structure(
    list(
      estimates = estimates,
      vcov = vcov,
      level = level
    ),
    class = "rstata_estimator"
  )
}

coef.rstata_estimator <- function(m) m$estimates
vcov.rstata_estimator <- function(m) m$vcov
