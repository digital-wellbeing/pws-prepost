library(scales)

# Format big numbers with a comma
number2 <- function(x, ...) {
  number(x, ..., big.mark = ",")
}

# Replace extreme percentages
percent2 <- function(x, accuracy = .1) {
  x <- percent(x, accuracy = accuracy)
  x <- if_else(x == "100.0%", ">99.9%", x)
  x <- if_else(x == "0.0%", "<0.1%", x)
  x
}

#
ns4 <- function(x) {
  ns(
    x,
    knots = c(0.18, 0.5, 1.3),
    Boundary.knots = c(0, 3)
  )
}

scale_x_hours <- list(
  scale_x_continuous(
    "Session duration (hours)",
    breaks = c(0, 15/60, 0.5, 45/60, 1, 2, 3, 4, 5),
    labels = c(0, "15m", "30m", "45m", "1h", "2h", "3h", "4h", "5h"),
    expand = expansion(0.01)
  )
)

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

#' Within-session change by pretest values
#'
#' @param pre the baseline mood value to calculate the change for.
#' @param label indicated the label to use for pre value.
#' @param fit the model object.
#' @param hours the range of hours to calculate the vales for
get_change_by_pre <- function(pre, label, fit, hours) {
  emm <- emmeans(
    fit,
    ~ hours + pre,
    at = list(
      hours = hours,
      pre = pre
    ),
    lmer.df = "asymp"
  )
  emmeans::contrast(
    emm,
    method = "trt.vs.ctrl",
    ref = paste0("hours0 pre", pre)
  ) |>
    confint() |>
    as.data.frame() |>
    mutate(
      hours = hours[-1],
      pre = pre,
      label = label
    )
}

#' Get trend for different random intercept values from brms.
#' @param sd integer to scale the random intercept SD by.
#' @details
#' The model object is hard coded to be `fit_b`.
#'
#' The curve is calculated over all posterior samples, and
#' summaries are based on medians and 2.5% and 97.5% percentile
#' intervals.
get_trend_bayes <- function(sd) {
  re <- VarCorr(fit_b)
  ps <- as_draws_df(
    fit_b,
    c(
      "b_Intercept",
      "b_ns4hours1",
      "b_ns4hours2",
      "b_ns4hours3",
      "b_ns4hours4",
      "sd_pid__Intercept",
      "sd_pid__ns4hours1",
      "sd_pid__ns4hours2",
      "sd_pid__ns4hours3",
      "sd_pid__ns4hours4",
      "cor_pid__Intercept__ns4hours1",
      "cor_pid__Intercept__ns4hours2",
      "cor_pid__Intercept__ns4hours3",
      "cor_pid__Intercept__ns4hours4"
    )
  ) |>
    rename(
      pid_int = sd_pid__Intercept,
      pid_slope0 = sd_pid__ns4hours1,
      pid_slope1 = sd_pid__ns4hours2,
      pid_slope2 = sd_pid__ns4hours3,
      pid_slope3 = sd_pid__ns4hours4,
      pid_cor0 = cor_pid__Intercept__ns4hours1,
      pid_cor1 = cor_pid__Intercept__ns4hours2,
      pid_cor2 = cor_pid__Intercept__ns4hours3,
      pid_cor3 = cor_pid__Intercept__ns4hours4,
      b1 = b_ns4hours1,
      b2 = b_ns4hours2,
      b3 = b_ns4hours3,
      b4 = b_ns4hours4,
    ) |>
    mutate(
      re_int = sd * pid_int,
      b0 = b_Intercept + re_int,
      re_s0 = sd * pid_cor0 * pid_slope0,
      re_s1 = sd * pid_cor1 * pid_slope1,
      re_s2 = sd * pid_cor2 * pid_slope2,
      re_s3 = sd * pid_cor3 * pid_slope3
    )
  lapply(hours, function(hour) {
    x <- ns4(
      hour
    )
    ps |>
      mutate(
        y = b0 + x[, 1] * (b1 + re_s0) + x[, 2] * (b2 + re_s1) + x[, 3] * (b3 + re_s2) + x[, 4] * (b4 + re_s3)
      ) |>
      select(y) |>
      summarize(
        estimate = median(y),
        lwr = quantile(y, 0.025),
        upr = quantile(y, 0.975)
      ) |>
      mutate(
        hours = hour,
        re_int = mean(ps$re_int)
      )
  }) |>
    bind_rows() |>
    mutate(sd = sd)
}

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
