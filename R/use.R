#' @title
#' Load a dataset for use with rstata
#'
#'
#'@details
#' Load either a specified dataset or browse your computer for a .dta file
#'
#' @param dataset optional, attach a dataframe already in your R workspace
#'
#' @examples
#' # suggested usage: browse to a .dta file and use
#' \dontrun{use()}
#'
#' # alternative usage: re-use a dataframe already in R
#' use(datasets::mtcars)
#'
#' @export
use <- function(dataset=NULL) {
    if (is.null(dataset)) {
        dataset <- foreign::read.dta(file.choose())
    }
    assign("data", dataset, envir = .rstata_env)
}
