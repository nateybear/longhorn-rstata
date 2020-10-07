# These functions shall not be exported.

.rstata_env <- new.env()

.check <- function(var, errMsg = sprintf("%s does not exist", var), silent = FALSE) {
  if (!exists(var, envir = .rstata_env)) {
    if (!silent) {
      stop(errMsg)
    } else {
      FALSE
    }
  } else {
    TRUE
  }
}

.get <- function(var, silent = FALSE, checkFun = function() .check(var, silent = silent)) {
  if (checkFun()) {
    get(var, envir = .rstata_env)
  }
}

.model_check <- function() .check("model", "There is not regression model in the environment.\nPlease use regr() first.")
.model <- function() .get("model", checkFun = .model_check)

.data_check <- function() .check("data", "There is no loaded dataset.\nPlease use load() first.")
.data <- function() .get("data", checkFun = .data_check)

printf <- function(...) cat(sprintf(...))
