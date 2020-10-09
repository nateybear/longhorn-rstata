#' @title
#' Load a dataset for use with rstata
#'
#'
#' @details
#' Load either a specified dataset or browse your computer for a .dta file
#'
#' @param dataset optional, attach a dataframe already in your R workspace
#'
#' @example
#' # suggested usage: browse to a .dta file and use
#' \dontrun{
#' use()
#' }
#'
#' # alternative usage: re-use a dataframe already in R
#' use(datasets::mtcars)
#' @export
use <- function(dataset = NULL) {

  # let user choose dataset if we need to and pick a name for the dataset
  if (is.null(dataset)) {
    fname <- file.choose()
    dataset <- foreign::read.dta(fname)
    data_name <- path_to_name(fname)
  } else {
    data_name <- deparse(substitute(dataset))
  }

  .attach(dataset, data_name = data_name, clearModel = TRUE)

  # helpful reminders
  printf("Using data %s. It is attached in your workspace, try typing \"summary(%s)\".\n", data_name, names(dataset)[1])
  printf("Choose %s from the dropdown in the Environment tab to view the data.\n", data_name)
}


# helper to name our datasets. don't export.
path_to_name <- function(path) {
  path <- normalizePath(path, "/")
  split_path <- unlist(strsplit(path, "/"))
  data_set <- split_path[length(split_path)]
  unlist(strsplit(data_set, "([.]DTA)|([.]dta)"))[1]
}
