if (!require(MBESS)) {install.packages('MBESS', ask = FALSE, checkBuilt = TRUE, type = "binary")}
library(MBESS)
if (!require(metafor)) {install.packages('metafor', ask = FALSE, checkBuilt = TRUE, type = "binary")}
library(metafor)

# # # # # # # # # #
# Code for Part 1----
# # # # # # # # # #

# We calculate the standardized mean difference
# We store it as the variable g (because by default, Hedges' g is computed)
g <- escalc(measure = "SMD",
            n1i = 50, # sample size in group 1 is 50 
            m1i = 5.6, # observed mean in group 1 is 5.6
            sd1i = 1.2, # observed standard deviation in group 1 is 1.2
            n2i = 53, # sample size in group 2 is 50 
            m2i = 4.9, # observed mean in group 1 is 4.9 
            sd2i = 1.3) # observed standard deviation in group 2 is 1.3

# print results
g

# Perform the meta-analysis
rma(yi, vi, data = g)

# # # # # # # # # #
#End Code for Part 1----
# # # # # # # # # #

# # # # # # # # # #
# Code for Part 2----
# # # # # # # # # #

set.seed(1000) # place a # before the set.seed command to generate different data than the example
pop.m1 <- 106
pop.sd1 <- 15
pop.m2 <- 100
pop.sd2 <- 15
n1 <- 50
n2 <- 50
# simulate data
x <- rnorm(n = n1, 
           mean = pop.m1, 
           sd = pop.sd1) # simulate observations group 1
y <- rnorm(n = n2, 
           mean = pop.m2, 
           sd = pop.sd1) # simulate observations group 2

# Perform a t-test
t.test(x, y, var.equal = TRUE)
# Calculate Hedges g (because of 'unbiased=TRUE' option). 
# With very large samples, MBESS will give an error which can be resolved by setting unbiased = FALSE
smd(Mean.1 = mean(x), 
    Mean.2 = mean(y), 
    s.1 = sd(x), 
    s.2 = sd(y), 
    n.1 = n1, 
    n.2 = n2, 
    Unbiased = TRUE)

# Calculate 95% CI around effect size, using the t-statistic from the t-test comparing both groups
ci.smd(ncp = t.test(x, y, var.equal = TRUE)$statistic, #specify non-centrality parameter (=t-value)
       n.1 = n1, # specify sample size group 1 
       n.2 = n2, # specify sample size group 2
       conf.level = 0.95) # specify confidence interval

#using escalc to calculate the effect size
g <- escalc(n1i = n1, 
            n2i = n2, 
            m1i = mean(x), 
            m2i = mean(y), 
            sd1i = sd(x), 
            sd2i = sd(y), 
            measure = "SMD")

result <- rma(yi, vi, data = g) # perform meta-analysis
result # print results meta-analysis
forest(result) # create forest plot

# # # # # # # # # #
#End Code for Part 2----
# # # # # # # # # #

# Daniel Lakens, 2019. 
# This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. https://creativecommons.org/licenses/by-nc-sa/4.0/