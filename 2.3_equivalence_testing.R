#Run the lines below to install and load the TOSTER package
#Install TOSTER package if needed
if (!require(TOSTER)) {install.packages('TOSTER')}
#Load TOSTER package
library(TOSTER)

#Question 2 and 3 (replace the zeroes with correct values)
# You can type ?TOSTtwo for help with the TOSTtwo function
TOSTtwo(m1 = 0.0, m2 = 0.0, sd1 = 0.0, sd2 = 0.0, n1 = 00, n2 = 00, low_eqbound_d = -0.0, high_eqbound_d = 0.0)

#Question 4 (replace the zeroes with correct values)
# You can type ?powerTOSTtwo for help with the powerTOSTtwo function
powerTOSTtwo(alpha = 0.00, N = 0, statistical_power = 0.0)

#Question 5 and 6 (replace the zeroes with correct values)
# You can type ?powerTOSTtwo for help with the powerTOSTtwo function
powerTOSTtwo(alpha = 0.00, statistical_power = 0.0, low_eqbound_d = -0.0, high_eqbound_d = 0.0)

#Question 7 (replace the zeroes with correct values)
# You can type ?TOSTmeta for help with the TOSTmeta function

TOSTmeta(alpha = 0.00, ES = 0.00, se = 0.000, low_eqbound_d = -0.0, high_eqbound_d = 0.0)

#Question 8 (replace the zeroes with correct values)
# You can type ?powerTOSTr for help with the powerTOSTr function
powerTOSTr(alpha = 0.00, N = 00, statistical_power = 0.0)

#Question 9 (replace the zeroes with correct values)
# You can type ?TOSTr for help with the TOSTr function
TOSTr(alpha = 0.00, n = 00, r = 0.00, low_eqbound_r = -0.0, high_eqbound_r = 0.0)





# Daniel Lakens, 2019. 
# This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. https://creativecommons.org/licenses/by-nc-sa/4.0/