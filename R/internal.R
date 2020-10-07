# These functions shall not be exported.

.rstata_env = new.env()

.model_check <- function() {
    if (!exists("model", envir = .rstata_env)) {
        stop("There is not regression model in the environment.\nPlease use regr() first.")
    }
}

.model <- function() {
    .model_check()
    get("model", envir = .rstata_env)
}

.data_check <- function() {
    if (!exists("data", envir = .rstata_env)) {
        stop("There is no loaded dataset.\nPlease use load() first.")
    }
}

.data <- function() {
    .data_check()
    get("data", envir = .rstata_env)
}
