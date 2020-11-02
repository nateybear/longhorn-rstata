# NOTE these functions should not be exported. They compute point estimates and variance matrices
# for functions of the parameters of a model. It is flexible enough that these should be used throughout
# the package in place of different methods in each function.


# returns a row vector of a list of symbolic expressions evaluated at the estimated parameters
point_estimate <- function(model, fs, eval_env) {
  matrix(sapply(fs, plug_in, model, eval_env), nrow = 1)
}

# returns a covariance matrix of the symbolic expressions using the delta method
# NOTE that this is an exact result for linear functions, so don't need a separate method for test and testnl!
vcov_estimate <- function(model, fs, eval_env) {
  vars <- names(stats::coef(model))
  # compute a q X k gradient matrix evaluated at beta_hat
  gradient <- function(fs) {
    g <- matrix(numeric(0), nrow = length(fs), ncol = length(vars))
    for (i in 1:length(fs)) {
      f <- fs[[i]]
      g[i, ] <- sapply(vars, function(v) plug_in(stats::D(f, v), model, eval_env))
    }
    g
  }

  grad <- gradient(fs)
  grad %*% stats::vcov(model) %*% t(grad)
}


# plug in coef estimates into a symbolic expression. This way you can write
# "age ^ 2" in a function call and we can
# 1) take the exact (a.k.a. symbolic) derivative
# 2) interpret age to mean "the point estimate of the parameter associated with age"
#
# This function does the second task.
plug_in <- function(expr, model, eval_env) {
  vars <- names(stats::coef(model))
  subs <- function(x) {
    if (is.name(x) && (deparse(x) %in% vars)) {
      stats::coef(model)[deparse(x)]
    } else if (is.call(x)) {
      as.call(lapply(x, subs))
    } else {
      x
    }
  }
  eval(subs(expr), eval_env)
}
