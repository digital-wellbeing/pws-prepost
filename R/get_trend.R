#' Get trend for different random intercept values
#' 
#' sdfsdf
#'
#' @param fit lme4 model object.
#' @param data the data.
#' @param sd integer to scale the random intercept SD by.
#' @param intercept boolean; indicates whether to include the intercept in the
#' response calculation.
#' 
#' @details
#' This only works with the model `mood ~ ns4(hours) + (1 + ns4(hours) | pid)`
get_trend <- function(
    fit,
    data,
    sd = 0,
    intercept = TRUE) {
  re <- as.data.frame(VarCorr(fit))
  pid_int <- re[2, "sdcor"]
  pid_slope0 <- re[3, "sdcor"]
  pid_slope1 <- re[4, "sdcor"]
  pid_slope2 <- re[5, "sdcor"]
  pid_slope3 <- re[6, "sdcor"]
  pid_cor0 <- re[7, "sdcor"]
  pid_cor1 <- re[8, "sdcor"]
  pid_cor2 <- re[9, "sdcor"]
  pid_cor3 <- re[10, "sdcor"]
  re_int <- sd * pid_int
  re_s0 <- sd * pid_cor0 * pid_slope0
  re_s1 <- sd * pid_cor1 * pid_slope1
  re_s2 <- sd * pid_cor2 * pid_slope2
  re_s3 <- sd * pid_cor3 * pid_slope3
  hours <- seq(0, 3, length.out = 100)
  x <- ns4(
    hours
  )
  b0 <- fixef(fit)[1] + re_int
  b <- fixef(fit)[-1]
  y <- x[, 1] * (b[1] + re_s0) + x[, 2] * (b[2] + re_s1) + x[, 3] * (b[3] + re_s2) + x[, 4] * (b[4] + re_s3)
  if (intercept) y <- y + b0
  data.frame(
    x = hours,
    y = c(y),
    re_int
  )
}