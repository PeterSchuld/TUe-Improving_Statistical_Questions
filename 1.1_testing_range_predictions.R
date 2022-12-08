if (!require(TOSTER)) {install.packages('TOSTER')}
library(TOSTER)

TOSTone.raw(m = 4.71,
            mu = 0,
            sd = 0.931,
            n = 33,
            low_eqbound = 1, 
            high_eqbound = 10, 
            alpha = 0.05)




# Daniel Lakens, 2019. 
# This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. https://creativecommons.org/licenses/by-nc-sa/4.0/