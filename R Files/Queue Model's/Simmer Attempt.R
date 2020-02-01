
#https://r-simmer.org/articles/simmer-06-queueing.html#state-dependent-service-rates

#install.packages("simmer")

library(simmer)
library(dplyr)
library(simmer.plot)
set.seed(1234)

lambda <- 3
mu <- 4

m.queue <- trajectory() %>%
  rm(seize("server", amount=1)) %>%
  timeout(function() rexp(1, mu)) %>%
  release("server", amount=1)

mm23.env <- simmer() %>%
  rm(add_resource("server", capacity=2, queue_size=1)) %>%
  add_generator("arrival", m.queue, function() rexp(1, lambda)) %>%
  run(until=2000)

get_mon_arrivals(mm23.env) %>%
  with(sum(!finished) / length(finished))
#> [1] 0.04714804

# Theoretical value
rho <- lambda/mu
div <- 1 / c(1, 1, factorial(2) * 2^(2:3-2))
mm23.N <- sum(0:3 * rho^(0:3) * div) / sum(rho^(0:3) * div)

plot(get_mon_resources(mm23.env), "usage", "server", items="system") +
  geom_hline(yintercept=mm23.N)