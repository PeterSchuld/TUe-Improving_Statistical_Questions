#Install packages if needed
if (!require(metafor)) {install.packages('metafor')}
library(metafor)
if (!require(truncnorm)) {install.packages('truncnorm')}
library(truncnorm)
if (!require(pwr)) {install.packages('pwr')}
library(pwr)

nSims <- 100 # number of simulated experiments
pub.bias <- 0 # set percentage of significant results in the literature

pop.m1 <- 100 # If there is a large true effect, the simulation will take a very long time because non-significant p-values are very very rare
pop.sd1 <- 15
pop.m2 <- 100
pop.sd2 <- 15
metadata.sig <- data.frame(m1 = numeric(0), m2 = numeric(0), sd1 = numeric(0), sd2 = numeric(0), n1 = numeric(0), n2 = numeric(0), pvalues = numeric(0), pcurve = numeric(0))
metadata.nonsig <- data.frame(m1 = numeric(0), m2 = numeric(0), sd1 = numeric(0), sd2 = numeric(0), n1 = numeric(0), n2 = numeric(0), pvalues = numeric(0), pcurve = numeric(0))

# simulate significant effects in the expected direction
for (i in 1:nSims) { # for each simulated experiment
  p <- 1 # reset p to 1 
  n <- round(rtruncnorm(1, 20, 300, 50, 100)) #draw data from a truncated normal distribution between 20 and 300 with a mean of 50 and sd of 100
  while (p > 0.025) { #continue simulating as along as p is not significant
    x <- rnorm(n = n, mean = pop.m1, sd = pop.sd1) #produce  simulated participants
    y <- rnorm(n = n, mean = pop.m2, sd = pop.sd2) #produce  simulated participants
    p <- t.test(x,y, alternative = "greater", var.equal = TRUE, alpha = 0.025)$p.value
  }
  metadata.sig[i,1] <- mean(x)
  metadata.sig[i,2] <- mean(y)
  metadata.sig[i,3] <- sd(x)
  metadata.sig[i,4] <- sd(y)
  metadata.sig[i,5] <- n
  metadata.sig[i,6] <- n
  out <- t.test(x, y, var.equal = TRUE)
  metadata.sig[i,7] <- out$p.value
  metadata.sig[i,8] <- paste0("t(",out$parameter,")=",out$statistic)
}

# simulate non-significant effects (two-sided)
for (i in 1:nSims) { # for each simulated experiment
  p <- 0 # reset p to 1 
  n <- round(rtruncnorm(1, 20, 300, 50, 100))
  while (p < 0.05) { # continue simulating as along as p is significant
    x <- rnorm(n = n, mean = pop.m1, sd = pop.sd1) # produce  simulated participants
    y <- rnorm(n = n, mean = pop.m2, sd = pop.sd2) # produce  simulated participants
    p <- t.test(x, y, var.equal = TRUE)$p.value
  }
  metadata.nonsig[i,1] <- mean(x)
  metadata.nonsig[i,2] <- mean(y)
  metadata.nonsig[i,3] <- sd(x)
  metadata.nonsig[i,4] <- sd(y)
  metadata.nonsig[i,5] <- n
  metadata.nonsig[i,6] <- n
  out <- t.test(x, y, var.equal = TRUE)
  metadata.nonsig[i,7] <- out$p.value
  metadata.nonsig[i,8] <- paste0("t(",out$parameter,")=",out$statistic)
}

# Combine significant and non-significant data. Select percentage based on % of publication bias
metadata <- rbind(metadata.nonsig[sample(nrow(metadata.nonsig), nSims * (1 - pub.bias)), ], metadata.sig[sample(nrow(metadata.sig), nSims * (pub.bias)), ])

metadata <- escalc(n1i = n1, n2i = n2, m1i = m1, m2i = m2, sd1i = sd1, sd2i = sd2, measure = "SMD", data = metadata)
# add se for PET-PEESE analysis
metadata$sei <- sqrt(metadata$vi)

result <- rma(yi, vi, data = metadata, method = "FE")
result

# Forest plot with 95% CI 
forest(result, level = 0.95)

# PET PEESE code below is adapted from Joe Hilgard: https://github.com/Joe-Hilgard/PETPEESE/blob/master/PETPEESE_functions.R
# PET
PET <- rma(yi = yi, sei = sei, mods = ~sei, data = metadata, method = "FE")
PET

# PEESE
PEESE <- rma(yi = yi, sei = sei, mods = ~I(sei^2), data = metadata, method = "FE")
PEESE

# Funnel Plot 
funnel(result, level = 0.95, refline = 0, main = paste("FE d =", round(result$b[1],2),"PET d =", round(PET$b[1],2),"PEESE d =", round(PEESE$b[1],2)))
abline(v = result$b[1], lty = "dashed") #draw vertical line at meta-analytic effect size estimate
points(x = result$b[1], y = 0, cex = 1.5, pch = 17) #draw point at meta-analytic effect size estimate
# PET PEESE code below is adapted from Joe Hilgard: https://github.com/Joe-Hilgard/PETPEESE/blob/master/PETPEESE_functions.R
# PEESE line and point
sei <- (seq(0, max(sqrt(result$vi)), .001))
vi <- sei^2
yi <- PEESE$b[1] + PEESE$b[2]*vi
grid <- data.frame(yi, vi, sei)
lines(x = grid$yi, y = grid$sei, typ = 'l') # add line for PEESE
points(x = (PEESE$b[1]), y = 0, cex = 1.5, pch = 5) # add point estimate for PEESE
# PET line and point
abline(a = -PET$b[1]/PET$b[2], b = 1/PET$b[2]) # add line for PET
points(x = PET$b[1], y = 0, cex = 1.5) # add point estimate for PET
segments(x0 = PET$ci.lb[1], y0 = 0, x1 = PET$ci.ub[1], y1 = 0, lty = "dashed") #Add 95% CI around PET

# TES
# Get observed power values for all studies
Pow <- mapply(pwr.t2n.test, d = metadata$yi, n1 = metadata$n1, n2 = metadata$n2)
Pow <- sapply(Pow[5,1:nrow(metadata)], as.numeric)
# Calculate Mean Power
MeanPow <- mean(Pow)
# Calculate number of significant results
NumSig <- sum(metadata$pvalues < 0.05)
# Perform Binomial Test (with .9 CI)
Binom.Pow <- binom.test(NumSig, nrow(metadata), MeanPow, conf.level = .9, alternative = "greater")
# P-values for TES
Binom.Pow$p.value

#Give output for p-curve analysis
cat(metadata$pcurve,sep = "\n")

# TIVA code (Uli Schimmack: https://replicationindex.wordpress.com/2014/12/30/the-test-of-insufficient-variance-tiva-a-new-tool-for-the-detection-of-questionable-research-practices/)
k = length(metadata$pvalues) 
z = qnorm(1 - metadata$pvalues/2)
var.z = var(z) 
tiva.p = pchisq(var.z * (k - 1),k - 1) 
var.z 
round(tiva.p,3)

# Daniel Lakens, 2019. 
# This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. https://creativecommons.org/licenses/by-nc-sa/4.0/