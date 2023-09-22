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