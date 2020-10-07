#' @export
gen <- function(...) {
  d <- .data()
  d <- cbind(d, ...)

  data_name <- .get("data_name")

  detach(data_name, character.only = TRUE)
  attach(d, name = data_name)
  assign("data", d, envir = .rstata_env)
}
