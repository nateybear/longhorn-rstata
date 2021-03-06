# These functions shall not be exported.

.rstata_env <- new.env()

.no_data_err <- "There is no loaded dataset. Please use load() first."
.no_model_err <- "There is no regression model in the environment. Please use regr() first."
.generic_err <- function(varname) sprintf("Variable %s has not been set. Please consult the documentation for usage.", varname)

.errMsgs <- list(
  model = .no_model_err,
  dataset = .no_data_err,
  data_name = .no_data_err
)


# why almost reproduce basic R commands?
# it creates a grammar that is more comfortable to use in development,
# and behavior changes can be implemented here without any changes to
# calling conventions throughout the package.
.exists <- function(varname) exists(varname, envir = .rstata_env)
.get <- function(varname, silent = FALSE, fallback = NULL) {
  if (.exists(varname)) {
    get(varname, envir = .rstata_env)
  } else if (!silent && is.null(fallback)) {
    errMsg <- ifelse(
      varname %in% names(.errMsgs),
      .errMsgs[[varname]],
      .generic_err(varname)
    )
    stop(errMsg)
  } else {
    fallback
  }
}
.set <- function(varname, value) assign(varname, value, envir = .rstata_env)
.rm <- function(varname) {
  if (.exists(varname)) {
    rm(varname, envir = .rstata_env)
  }
}

# safe way to attach new dataset
.attach <- function(dataset, data_name, clearModel = FALSE) {
  # if there is old dataset, detach it and keep things tidy
  if (.exists("data_name")) detach(.get("data_name"), character.only = TRUE)

  # attach new dataset to environment
  attach(dataset, name = data_name)

  # if we switched datasets then remove the old regr model from environment
  if (clearModel) .rm("model")

  # set the new environment variables
  .set("dataset", dataset)
  .set("data_name", data_name)
}

printf <- function(...) cat(sprintf(...))
