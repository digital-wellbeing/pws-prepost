#' Explicitly cache model
#' 
#' A function that will save a model as an .Rds file,
#' and reload the file without having to fit the model
#' on the next run.
#' 
#' @param path string; path where the model is saved.
#' Should end with .rds.
#' @param model a model call to fit
fit_cached <- function(path, model) {
  if (file.exists(path)) {
    fit <- read_rds(path)
  } else {
    fit <- model
    write_rds(fit, path)
  }
  fit
}