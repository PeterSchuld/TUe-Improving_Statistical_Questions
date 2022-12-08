#Install pwr package if needed
if (!require(pwr)) {install.packages('pwr')}
library(pwr)

alpha_level <- 0.05 #set alpha level
n <- 100 #set number of observations
st_dev <- 1 #set true standard deviation
SESOI <- 0.5 #set smallest effect size of interest (raw mean difference)

# calculate lower and upper critical values c_l and c_u
c_l <- sqrt((n - 1)/qchisq(alpha_level/2, n - 1, lower.tail = FALSE))
c_u <- sqrt((n - 1)/qchisq(alpha_level/2, n - 1, lower.tail = TRUE))

# calculate lower and upper confidence interval for sd
st_dev * c_l
st_dev * c_u

# d based on lower bound of the 95CI around the SD
SESOI/(st_dev * c_l)
# d based on upper bound of the 95CI around the SD
SESOI/(st_dev * c_u)

pwr.t.test(d = SESOI/(st_dev * c_l), power = 0.9, sig.level = 0.05)
pwr.t.test(d = SESOI/(st_dev * c_u), power = 0.9, sig.level = 0.05)

# Power analysis for true standard deviation for comparison
pwr.t.test(d = SESOI/st_dev, power = 0.9, sig.level = 0.05)


# Daniel Lakens, 2019. 
# This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. https://creativecommons.org/licenses/by-nc-sa/4.0/