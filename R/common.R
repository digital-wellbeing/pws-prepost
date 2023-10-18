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
