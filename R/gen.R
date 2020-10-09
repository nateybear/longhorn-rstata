#' @export
#' @title
#' Generate
#' @description
#' Create new variables to add to your dataset
#' @details
#' Add the list of variables in `...` to your dataset. Please include names for all your variables, i.e. `gen(pe_motheduc = b_(motheduc))` rather than `gen(b_motheduc)`. Nothing prevents you from doing that, but the generated variables will have nonsensical names.
#' @param ... multiple new variables to add to dataset
#' @example
#' # generate the partial effects of a model with interactions
#' use(htv)
#' regr(educ ~ motheduc * fatheduc)
#' gen(pe_motheduc = b_(motheduc) + fatheduc * b_(`motheduc:fatheduc`))
#' summary(pe_motheduc)
gen <- function(...) {
  .attach(
    dataset = cbind(.get("dataset"), ...),
    data_name = .get("data_name")
  )
}
