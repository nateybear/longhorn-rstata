# These functions shall not be exported.

.rstata_env <- new.env()

.no_data_err <- "There is no loaded dataset. Please use load() first."
.no_model_err <- "There is no regression model in the environment. Please use regr() first."
.generic_err <- function(var) sprintf("Variable %s has not been set. Please consult the documentation for usage.", var)

.errMsgs <- list(
  model = .no_model_err,
  dataset = .no_data_err,
  data_name = .no_data_err
)

.get <- function(var, silent = FALSE, fallback = NULL) {
  if (exists(var, envir = .rstata_env)) {
    get(var, envir = .rstata_env)
  } else if (!silent && is.null(fallback)) {
    errMsg <- ifelse(var %in% names(.errMsgs), .errMsgs[[var]], .generic_err(var))
    stop(errMsg)
  } else {
    fallback
  }
}

.set <- function(varname, value) assign(varname, value, envir = .rstata_env)

# safe way to attach new dataset
.attach <- function(dataset, data_name, clearModel = FALSE) {
  # if there is old dataset, detach it and keep things tidy
  old_data <- .get("data_name", silent = TRUE)
  if (!is.null(old_data)) {
    detach(old_data, character.only = TRUE)
  }

  # attach new dataset to environment
  attach(dataset, name = data_name)

  # if we switched datasets then remove the old regr model from environment
  if (clearModel && exists("model", envir = .rstata_env)) {
    rm("model", envir = .rstata_env)
  }

  # set the new environment variables
  .set("dataset", dataset)
  .set("data_name", data_name)
}

printf <- function(...) cat(sprintf(...))
