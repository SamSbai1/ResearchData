#https://rdrr.io/cran/queuecomputer/man/queue_step.html

library(queuecomputer)

# With two servers
set.seed(1)
#Customers
n <- 100

#arival rate lambda
arrivals <- cumsum(rexp(n, 3))

#service rate ? mu
# rexp = exponential distribution
service <- rexp(n)


queue_obj <- queue_step(arrivals = arrivals, service = service, servers = 1)


summary(queue_obj)
plot(queue_obj)

