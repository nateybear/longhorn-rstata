(function() {
    for (package in c("pryr", "sandwich", "foreign")) {
        if (!require(package, character.only = T)) {
            install.packages(package)
            require(package, character.only = T)
        }
    }
})()

#' testnl
#'
#' @param model the result of a call to lm
#' @param ...  one or more non-linear expressions
#'
#' @details Jointly tests that the (non-linear) expressions in ... are all equal to zero.
#' Use a variable name to refer to the coefficient associate with
#' that variable, for instance \code{testnl(model, 2*age)} to test that
#' twice the coefficient associated with age is equal to zero.
#' Separate multiple expressions by commas, i.e. \code{testnl(model, 2*age, motheduc^2)}.
#' For "weird" variable names, surround in backticks (see example).
#'
#' @examples
#' # use the HTV.dta set from class
#' require(foreign)
#' htv = read.dta(file.choose())
#'
#' # fit a model with interations for illustration
#' model = lm(educ ~ motheduc*fatheduc)
#'
#' # first, test that motheduc = fatheduc
#' testnl(model, motheduc - fatheduc)
#'
#' # then do a full f test (`motheduc:fatheduc` is the interaction term)
#' testnl(model, motheduc, fatheduc, `motheduc:fatheduc`)
#'
#' # if you want to test the intercept, it's called (Intercept)
#' testnl(model, sqrt(`(Intercept)`))
testnl <- function(model, ...) {
    eval_env = parent.frame()
    vars = names(coef(model))

    # plug in coef estimates into symbolic expression
    plug_in <- function(e) {
        subs <- function(x) {
            if (is.name(x) && (deparse(x) %in% vars)) {
                coef(model)[deparse(x)]
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
        g = matrix(numeric(0), nrow = length(fs), ncol = length(vars))
        for (i in 1:length(fs)) {
            f = fs[[i]]
            g[i,] = sapply(vars, function(v) plug_in(D(f, v)))
        }
        g
    }

    fs = dots(...)
    X = point_estimate(fs)

    # use delta method to get covariance matrix of our functions
    grad = gradient(fs)
    V = grad %*% vcovHC(model, type = "HC1") %*% t(grad)


    chisq_stat = X %*% solve(V) %*% t(X)
    df = length(fs)
    pval = 1 - pchisq(chisq_stat, df)

    printf <- function(...) cat(sprintf(...))
    for (i in 1:length(fs)) {
        printf("(%d) %s = 0\n\testimate: %.2f\n\n", i, deparse(fs[[i]]), X[1,i])
    }
    printf("\n\t\tchi2(%d) = %.2f\n", df, chisq_stat)
    printf("\t\tProb > chi2 = %.4f\n", pval)
}
