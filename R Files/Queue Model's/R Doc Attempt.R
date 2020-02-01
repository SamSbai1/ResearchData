

#https://journal.r-project.org/archive/2017/RJ-2017-051/RJ-2017-051.pdf
#install.packages("queueing")

#The following code is an example of a model using queueing.
#It can be thought of as cars arriving at a petrol station, following an exponential
# distribution at the rate ?? = 2. The cars are served
# exponentially distributed at the rate µ = 3.

#This situation is modelled in queueing using a single node in 
#which the customer inter-arrival time and service time both follow an 
#exponential distribution, at the rates ?? = 2 and µ = 3 respectively,

# Load the package
library(queueing)
# Create the inputs for the model.
i_mm1 <- NewInput.MM1(lambda=2, mu=3)

# Optionally check the inputs of the model
CheckInput(i_mm1)

# Create the model
o_mm1 <- QueueingModel(i_mm1)

# Print on the screen a summary of the model
print(summary(o_mm1), digits=2)