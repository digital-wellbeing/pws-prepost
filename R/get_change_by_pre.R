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