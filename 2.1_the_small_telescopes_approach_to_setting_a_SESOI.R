#Run the lines below to install and load the TOSTER package
#Install pwr package if needed
if (!require(pwr)) {install.packages('pwr')}
#Load pwr package
library(pwr)

#The code below should help you complete the assignment.

pwr.t.test(n = 20, sig.level = 0.05, power = 0.33, type = "one.sample", alternative = "two.sided")

pwr.t.test(n = X, sig.level = 0.05, power = X, type = "two.sample", alternative = "two.sided")

pwr.r.test(n = X, sig.level = 0.05, power = X, alternative = "two.sided")


# Daniel Lakens, 2019. 
# This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. https://creativecommons.org/licenses/by-nc-sa/4.0/