#' @title
#' Load a dataset for use with rstata
#'
#'
#' @details
#' Load either a specified dataset or browse your computer for a .dta file
#'
#' @param dataset optional, attach a dataframe already in your R workspace
#'
#' @examples
#' # suggested usage: browse to a .dta file and use
#' \dontrun{
#' use()
#' }
#'
#' # alternative usage: re-use a dataframe already in R
#' use(datasets::mtcars)
#' @export
use <- function(dataset = NULL) {

  # if we have any old data laying around, detach so we keep the workspace tidy.
  if (.check("data_name", silent = TRUE)) {
    old_data <- .get("data_name")
    try(
      {
        # put inside of a try b/c it's fine if it fails--don't search too hard :)
        detach(old_data, character.only = TRUE)
        printf("Detached old data %s.\n\n", old_data)
      },
      silent = TRUE
    )
  }

  # let user choose dataset if we need to and pick a name for the dataset
  if (is.null(dataset)) {
    fname <- file.choose()
    dataset <- foreign::read.dta(fname)
    data_name <- path_to_name(fname)
  } else {
    data_name <- deparse(substitute(dataset))
  }

  # attach so that user can refer to variables directly
  # N.B. this goes before the assign calls below, if for some
  # reason it fails don't put garbage in the .rstata_env
  attach(dataset, name = data_name)

  # if we're attaching a new dataset then we should remove the model
  if (.check("model", silent = TRUE)) {
    rm("model", envir = .rstata_env)
  }

  # actually set the new environment variables
  assign("data", dataset, envir = .rstata_env)
  assign("data_name", data_name, envir = .rstata_env)

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
