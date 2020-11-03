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
#' @param model either an lm (assuming homoscedasticity) or a model created with rstata_lm (preferred).
#' @param ...  one or more (possibly non-linear) expressions. Variable names refer to the associated parameters of the model.
#'
#' @examples
#' # fit a model with interations for illustration
#' model <- rstata_lm(mpg ~ hp*disp, data = datasets::mtcars)
#'
#' # first, test that hp = disp
#' testnl(model, hp - disp)
#'
#' # then do a full f test (`hp:disp` is the interaction term)
#' testnl(model, hp, disp, `hp:disp`)
#'
#' # if you want to test the intercept, it's called (Intercept)
#' testnl(model, sqrt(`(Intercept)`))
#' @export
testnl <- function(model, ...) {
  fs <- pryr::dots(...)

  X <- point_estimate(model, fs, parent.frame())
  V <- vcov_estimate(model, fs, parent.frame())

  chisq_stat <- X %*% solve(V) %*% t(X)
  df <- length(fs)
  pval <- 1 - stats::pchisq(chisq_stat, df)

  for (i in 1:length(fs)) {
    printf("(%d) %s = 0", i, deparse(fs[[i]]))
  }
  printf("\n\t\tchi2(%d) = %.2f\n", df, chisq_stat)
  printf("\t\tProb > chi2 = %.4f\n", pval)
}
