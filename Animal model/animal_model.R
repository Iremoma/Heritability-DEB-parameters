#----------
# Heritability of energy budgeting in European seabass
# Moro, I., Campos-Candela, A., Bekaert, M., Sanchez, JB., Tomas, J.,Palmer. M
#----------

# Estimating heritability and genetic correlation of two DEB parameters (pAm and v) 
# for 343 seabass.

#--------
# Loading data and libraries
#--------
rm(list=ls())
library(brms)
load("input.Rdata")
#"GRM": genetic similarity matrix 
# "Y_frame": mean and sd of posteriors for pAm (f*pAm) and v at the fish level

#--------
# Figure 2 (histograms for pAm and v)
#--------
par(mfrow=c(3,1))
hist(Y_frame$pAm,main="",ylab="",xlab="f*p_Am (j/cm2/day)",breaks=seq(350,650,10),col="#4C78A8")
hist(Y_frame$v,main="",ylab="",xlab="v (1/day)",breaks=seq(0.045,0.075,0.001),col="#B279A2")
plot(Y_frame$pAm,Y_frame$v,pch=21,cex=1,xlab="f*p_Am",ylab="v",bg="#F58518")
lm=lm(Y_frame$v~Y_frame$pAm)
abline(coef(lm))
cor(Y_frame$pAm,Y_frame$v)

#scaling Y (mean = 0.0 sd = 1.0)
# the non-scaled version does not converge
temp=sd(Y_frame[,"pAm"])
Y_frame[,"pAm"] =(Y_frame[,"pAm"]-mean(Y_frame[,"pAm"]))/temp
Y_frame[,"pAmsd"] = Y_frame[,"pAmsd"]/temp
temp=sd(Y_frame[,"v"])
Y_frame[,"v"] =(Y_frame[,"v"]-mean(Y_frame[,"v"]))/temp
Y_frame[,"vsd"] = Y_frame[,"vsd"]/temp

#-------
# Animal model (brms sintax)
#-------
# setting the model
bf1 <- bf(pAm | se(pAmsd,sigma=TRUE) ~ 1 + (1 | p | gr(ID, cov = A)))
bf2 <- bf(v | se(vsd,sigma=TRUE) ~ 1 + (1 | p | gr(ID, cov = A)))

# scaled priors
priors <- c(
  # Intercepts
  prior(normal(0, 1), class = "Intercept", resp = "pAm"),
  prior(normal(0, 1), class = "Intercept", resp = "v"),
  
  # Additive genetic SD
  prior(student_t(3,0.0,0.4), class = "sd", group = "ID", resp = "pAm"),
  prior(student_t(3,0.0,0.4), class = "sd", group = "ID", resp = "v"),
  
  # Residual SD
  prior(student_t(3,0.0,0.7), class = "sigma", resp = "pAm"),
  prior(student_t(3,0.0,0.7), class = "sigma", resp = "v"),
  
  # Correlations
  prior(lkj(2), class = "cor"),
  prior(lkj(2), class = "rescor")
)

# initial values
init_fun <- function() {
  list(
    b_pAm_Intercept = 0,
    b_v_Intercept   = 0,
    sigma_pAm = 0.5,
    sigma_v   = 0.5
  )
}

# running
fit <- brm(
  bf1 + bf2 + set_rescor(TRUE),
  data = Y_frame,
  data2 = list(A = GRM),
  control = list(adapt_delta = 0.95, max_treedepth = 12),
  iter = 5000, warmup = 1000, chains = 4, cores = 4,
  prior = priors,
  sample_prior = "yes",
  init=init_fun
)

#-------
# saving results
#-------
#saveRDS(fit, "results.rds")

#--------
# references
#--------
# Halliwell, B., Holland, B. R., & Yates, L. A. (2025). Multiresponse phylogenetic mixed models: concepts and application. Biological Reviews, 100, 1294-1316. https://doi.org/10.1111/brv.70001
# Journal of Evolutionary Biology (phylogenetic heritability/correlation; Bayesian R implementations incl. brms)
