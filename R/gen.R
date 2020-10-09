#' @export
gen <- function(...) {
  dataset <- .get("dataset")
  dataset <- cbind(dataset, ...)

  .attach(dataset, data_name = .get("data_name"))
}
