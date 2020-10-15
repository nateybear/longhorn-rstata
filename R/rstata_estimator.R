# this is a class representation of estimators that just stores a point estimate, covariance matrix, and alpha level.
# from there you can reproduce the p-values and confidence intervals like stata
rstata_estimator <- function(model, vcov, level) {
    model$vcov <- vcov
    model$level <- level
  structure(
    model,
    class = c("rstata_estimator", class(model))
  )
}

vcov.rstata_estimator <- function(m) m$vcov
