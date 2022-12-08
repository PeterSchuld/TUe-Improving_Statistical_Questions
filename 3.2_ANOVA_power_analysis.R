# It is recommended to update all packages before running this code. 
if (!require(pwr)) {install.packages('pwr')}
library(pwr)
if (!require(devtools)) {install.packages('devtools')}
library(devtools)
if (!require(MASS)) {install.packages('MASS')}
library(MASS)
if (!require(afex)) {install.packages('afex')}
library(afex)
if (!require(ggplot2)) {install.packages('ggplot2')}
library(ggplot2)
if (!require(reshape2)) {install.packages('reshape2')}
library(reshape2)
devtools::install_github("arcaldwell49/Superpower")
library(Superpower) # Load Superpower
# Disable scientific notation (1.05e10)
options(scipen = 999)

#####################
# Code for Question 1
design_result <- ANOVA_design(design = "2b*2w",
                              n = 40, 
                              mu = c(1.03, 1.41, 0.98, 1.01), 
                              sd = 1.03, 
                              r = 0.8, 
                              labelnames = c("voice", "human", "robot", "emotion", "cheerful", "sad"),
                              plot = TRUE)

# Simulate data using ANOVA_exact function and print results
ANOVA_exact(design_result, alpha = 0.05)

####################################
# Code for Question 2, 3, 4: Power in a Two Group One-Way ANOVA
design_result <- ANOVA_design(design = "2b",
                              n = 100,
                              mu = c(24, 26.2), 
                              sd = 6.4, 
                              labelnames = c("condition", "control", "pet"),
                              plot = TRUE)

ANOVA_exact(design_result, alpha_level = 0.05)

# Create a power curve plot
plot_power(design_result, min_n = 10, max_n = 250, plot = TRUE)

#############################
# Question 5 and 6: Three independent groups
design_result <- ANOVA_design(design = "3b",
                              n = 50, 
                              mu = c(24, 26.2, 26.6), 
                              sd = 6.4, 
                              labelnames = c("condition", "control", "cat", "dog"),
                              plot = TRUE)

# Simulate data using ANOVA_exact function and print results
ANOVA_exact(design_result, alpha = 0.05)

# Create a power curve plot
plot_power(design_result, min_n = 10, max_n = 250, plot = TRUE)

##########################
#Question 9: Two group dependent design
design_result <- ANOVA_design(design = "2w",
                              n = 34, 
                              mu = c(-0.25, 0.25), 
                              sd = 1, 
                              r = 0.5, 
                              labelnames = c("speed", "fast", "slow"),
                              plot = TRUE)

ANOVA_exact(design_result)

####################################
#Three group repeated measures ANOVA
design_result <- ANOVA_design(design = "3w",
                              n = 20, 
                              mu = c(-0.3062, 0, 0.3062), 
                              sd = 1, 
                              r = 0.8, 
                              labelnames = c("speed", "fast", "medium", "slow"),
                              plot = TRUE)

ANOVA_exact(design_result)

####################################
# More complex designs: 
# 2 by 2 within design with correlations specified for each contrast.
design <- "2w*2w"
mu = c(2,1,4,2) 
n <- 45
sd <- 5
r <- c(
  0.8, 0.5, 0.4,
  0.4, 0.5,
  0.8
)
design_result <- ANOVA_design(design = design,
                              n = n, 
                              mu = mu, 
                              sd = sd, 
                              r = r,
                              plot = TRUE)

#Check the correlation matrix we specified
design_result$cor_mat
# We apply the Holm correction for multiple comparisons
ANOVA_power(design_result, p_adjust = "none", nsims = 1000)


# Daniel Lakens, 2019. 
# This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. https://creativecommons.org/licenses/by-nc-sa/4.0/