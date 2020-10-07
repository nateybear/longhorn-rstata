#' @title
#' Wald test of multiple hypotheses
#'
#' @description
#' Test linear and non-linear hypotheses of the coefficients of a fitted regression model.
#'
#' @details
#' Jointly tests that the (non-linear) expressions in ... are all equal to zero.
#' Use a variable name to refer to the coefficient associated with
#' that variable, for instance \code{testnl(model, 2*age)} to test that
#' twice the coefficient associated with age is equal to zero.
#' Separate multiple expressions by commas, i.e. \code{testnl(model, 2*age, motheduc^2)}.
#' For "weird" variable names, surround in backticks (see example).
#'
#' @param ...  one or more (possibly non-linear) expressions
#'
#' @examples
#' # fit a model with interations for illustration
#' use(datasets::mtcars)
#' regr(wt ~ hp * disp)
#'
#' # first, test that hp = disp
#' testnl(hp - disp)
#'
#' # then do a full f test (`hp:disp` is the interaction term)
#' testnl(hp, disp, `hp:disp`)
#'
#' # if you want to test the intercept, it's called (Intercept)
#' testnl(sqrt(`(Intercept)`))
#' @export
testnl <- function(...) {
  model <- .model()
  eval_env <- parent.frame()
  vars <- names(stats::coef(model))

  # plug in coef estimates into symbolic expression
  plug_in <- function(e) {
    subs <- function(x) {
      if (is.name(x) && (deparse(x) %in% vars)) {
        stats::coef(model)[deparse(x)]
      } else if (is.call(x)) {
        as.call(lapply(x, subs))
      } else {
        x
      }
    }
    eval(subs(e), eval_env)
  }

  # point estimate of the functions at beta_hat
  point_estimate <- function(fs) {
    matrix(sapply(fs, plug_in), nrow = 1)
  }

  # compute a q X k gradient matrix evaluated at beta_hat
  gradient <- function(fs) {
    g <- matrix(numeric(0), nrow = length(fs), ncol = length(vars))
    for (i in 1:length(fs)) {
      f <- fs[[i]]
      g[i, ] <- sapply(vars, function(v) plug_in(stats::D(f, v)))
    }
    g
  }

  fs <- pryr::dots(...)
  X <- point_estimate(fs)

  # use delta method to get covariance matrix of our functions
  grad <- gradient(fs)
  V <- grad %*% sandwich::vcovHC(model, type = "HC1") %*% t(grad)


  chisq_stat <- X %*% solve(V) %*% t(X)
  df <- length(fs)
  pval <- 1 - stats::pchisq(chisq_stat, df)

  for (i in 1:length(fs)) {
    printf("(%d) %s = 0\n\testimate: %.2f\n\n", i, deparse(fs[[i]]), X[1, i])
  }
  printf("\n\t\tchi2(%d) = %.2f\n", df, chisq_stat)
  printf("\t\tProb > chi2 = %.4f\n", pval)
}
