#' @title
#' Run a regression
#'
#' @description
#' Run a regression and store it globally like in Stata. Aims to support as many
#' features as Stata does (robust standard errors, clustering, confidence levels...)
#'
#'@details
#' TODO: add more description to this. It will need to be one of the heavy lifters.
#' TODO: create a class for this that extends lm functionality
#'
#' @param formula a formula using variables from the loaded dataset
#'
#' @examples
#' use(datasets::mtcars)
#' regr(mpg ~ wt + disp*cyl)
#'
#' @export
regr <- function(formula) { # TODO accept arguments for robust/cluster and level
    model <- stats::lm(formula, data = .data())
    assign("model", model, envir = .rstata_env)
    print(summary(model)) # TODO quick and dirty, use class behavior

    invisible(NULL)
}
