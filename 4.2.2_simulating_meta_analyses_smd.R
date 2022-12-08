# Install metafor package
if (!require(metafor)) {install.packages('metafor')}
library(metafor)

nSims <- 12 # number of simulated studies

pop.m1 <- 106
pop.sd1 <- 15
pop.m2 <- 100
pop.sd2 <- 15
metadata <- data.frame(yi = numeric(0), vi = numeric(0))

for (i in 1:nSims) { # for each simulated study
  n <- sample(30:80, 1)
  x <- rnorm(n = n, mean = pop.m1, sd = pop.sd1) # produce  simulated participants
  y <- rnorm(n = n, mean = pop.m2, sd = pop.sd2) # produce  simulated participants
  metadata[i,1] <- escalc(n1i = n, n2i = n, m1i = mean(x), m2i = mean(y), sd1i = sd(x), sd2i = sd(y), measure = "SMD")$yi
  metadata[i,2] <- escalc(n1i = n, n2i = n, m1i = mean(x), m2i = mean(y), sd1i = sd(x), sd2i = sd(y), measure = "SMD")$vi
}

result <- rma(yi, vi, data = metadata, method = "FE")
result
forest(result)

# Daniel Lakens, 2019. 
# This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. https://creativecommons.org/licenses/by-nc-sa/4.0/