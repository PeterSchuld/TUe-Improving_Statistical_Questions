#Install metafor and MBESS packages
if (!require(metafor)) {install.packages('metafor')}
library(metafor)

nSims <- 12 #number of simulated experiments

pop.pr1 <- 0.7 # Set percentage of successes in Group 1
pop.pr2 <- 0.5 # Set percentage of successes in Group 2

ai <- numeric(nSims) # set up empty vector for successes group 1
bi <- numeric(nSims) # set up empty vector for failures group 1
ci <- numeric(nSims) # set up empty vector for successes group 2
di <- numeric(nSims) # set up empty vector for failures group 2

for (i in 1:nSims) { #for each simulated experiment
  n <- sample(30:80, 1)
  x <- rbinom(n, 1, pop.pr1) #produce simulated participants (1 = success, 0 is failure)
  y <- rbinom(n, 1, pop.pr2) #produce simulated participants (1 = success, 0 is failure)
  ai[i] <- sum(x == 1) #Successes Group 1
  bi[i] <- sum(x == 0) #Failures Group 1
  ci[i] <- sum(y == 1) #Successes Group 2
  di[i] <- sum(y == 0) #Failures Group 2
}

# Combine data into dataframe
metadata <- cbind(ai, bi, ci, di)
# Create escalc object from metadata dataframe 
metadata <- escalc(measure = "OR", ai = ai, bi = bi, ci = ci, di = di, data = metadata)
# Perform Meta-analysis
result <- rma(yi, vi, data = metadata)
# Print result meta-analysis
result
# Create forest plot. Using ilab and ilab.xpos arguments to add counts
forest(result, 
       ilab = cbind(metadata$ai, metadata$bi, metadata$ci, metadata$di), 
       xlim = c(-10, 8), 
       ilab.xpos = c(-7, -6, -5, -4))
text(c(-7,-6,-5,-4), 14.7, c("E+", "E-", "C+", "C-"), font = 2, cex = .8) # add labels

# Daniel Lakens, 2019. 
# This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. https://creativecommons.org/licenses/by-nc-sa/4.0/