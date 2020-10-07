#' @title
#' Run a regression
#'
#' @description
#' Run a regression and store it globally like in Stata. Aims to support as many
#' features as Stata does (robust standard errors, clustering, confidence levels...)
#'
#' @details
#' TODO: add more description to this. It will need to be one of the heavy lifters.
#' TODO: create a class for this that extends lm functionality
#'
#' @param formula a formula using variables from the loaded dataset
#'
#' @example
#' use(datasets::mtcars)
#' regr(mpg ~ wt + disp*cyl)
#'
#' @export
regr <- function(formula) { # TODO accept arguments for robust/cluster and
  model <- stats::lm(formula, data = .data())
  assign("model", model, envir = .rstata_env)
  print(summary(model)) # TODO quick and dirty, use class behavior

  invisible(NULL)
}

#' @title
#' Extract Coefficient Point Estimates
#' @details
#' After fitting model using regr, use this to extract point estimates of the
#' coefficients like in Stata.
#' @example
#' use(datasets::mtcars)
#' regr(mpg ~ wt)
#' print(b_(wt))
#'
#'
#' @export
b_ <- function(v) stats::coef(.model())[deparse(substitute(v))]
