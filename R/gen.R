#' @export
gen <- function(...) {
  .attach(
    dataset = cbind(.get("dataset"), ...),
    data_name = .get("data_name")
  )
}
