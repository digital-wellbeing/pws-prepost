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
