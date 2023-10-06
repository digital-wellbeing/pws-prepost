N_CORES <- as.numeric(Sys.getenv("N_CORES", unset = 1))
N_THREADS <- as.numeric(Sys.getenv("N_THREADS", unset = 2))
N_ITER <- as.numeric(Sys.getenv("N_ITER", unset = 2000))
N_SUBSET <- as.numeric(Sys.getenv("N_SUBSET"))

options(
  mc.cores = N_CORES,
  brms.backend = "cmdstanr",
  brms.threads = N_THREADS
)

theme_set(
  theme_linedraw(base_size = 10) +
    theme(
      strip.background = element_rect(
        fill = NA,
        color = NA
      ),
      strip.text = element_text(
        colour = "black",
        hjust = 0
      ),
      axis.text = element_text(
        size = rel(0.75)
      ),
      panel.grid = element_blank(),
      plot.tag.position = c(0, 1)
    )
)

scale_x_hours <- list(
  scale_x_continuous(
    breaks = c(0, 15/60, 0.5, 45/60, 1, 2, 3),
    labels = c(0, "15m", "30m", "45m", "1h", "2h", "3h")
  )
)
