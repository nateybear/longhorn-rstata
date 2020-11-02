#' Create linear models like Stata
#'
#' @description This is an \code{lm} call that allows the caller to also specify a covariance structure for the residuals and an alpha level for tests. It's important to use this rather than the standard \code{lm} call, since the rest of the package assumes that the covariance matrix for the betas and the alpha level are attached.
#'
#' Note that the created object "subclasses" \code{lm}, so you can do anything with the returned object that you would do with a normal linear model object, such as call \code{fitted} and \code{resid}. The returned object also has its own S3 method for vcov, so functions from the stats package like \code{confint} will "work out of the box" and use the covariance matrix created here (rather than the typical homoscedastic case).
#'
#' @param ... arguments to lm (see documentation for lm)
#' @param stderr method to compute standard errors (name, string or function call). Implemented methods are
#'               "homoscedastic"
#'               "robust"
#'               cluster(group)
#'               "bootstrap"
#' @param level alpha level, either a percentage or a number between 0 and 1
#'
#' @return The lm object from R, with vcov matrix and level attached.
#' @export
#'
#' @examples
#'
#' # it works like a regular lm
#' lm1 <- rstata_lm(mpg ~ wt + cyl, data = datasets::mtcars)
#'
#' # but also lets you specify a covariance structure
#' lm2 <- rstata_lm(mpg ~ wt + cyl, data = datasets::mtcars, stderr = robust)
#'
#' # clustered standard errors are specified as a function call
#' lm3 <- rstata_lm(mpg ~ wt + cyl, data = datasets::mtcars, stderr = cluster(cyl))
#'
#' # bootstrapped errors assume 50 replications but can be changed
#' lm4 <- rstata_lm(mpg ~ wt + cyl, data = datasets::mtcars, stderr = bootstrap)
#' lm5 <- rstata_lm(mpg ~ wt + cyl, data = datasets::mtcars, stderr = bootstrap(250))
#'
rstata_lm <- function(..., stderr = "homoscedastic", level = .95) {
    model <- do.call(stats::lm, list(...))

    # normalize level
    if (level > 1) {
        level <- level / 100
    }
    model$level <- level

    # create vcov matrix
    normalize_expr <- function(n) if (is.name(n)) deparse(n) else n
    stderr <- lapply(substitute(stderr), normalize_expr)
    model$vcov <- do.call(compute_vcov, append(list(model), stderr))


    class(model) <- c("rstata_lm", class(model))
    return(model)
}


compute_vcov <- function(model, method, ...) {
    f <- list(
        homoscedastic = stats::vcov,
        robust = function(m) sandwich::vcovHC(m, type = "HC1"),
        cluster = function(m, group) {
            cluster <- stats::formula(paste0("~", group))
            sandwich::vcovCL(m, cluster = cluster)
        },
        bootstrap = function(m, R = 50) sandwich::vcovBS(m, R = R)
    )[[method]]

    args <- list(model, ...)
    return(do.call(f, args))
}

#' @export
#' @S3method vcov rstata_lm
vcov.rstata_lm <- function(object, ...) object$vcov

