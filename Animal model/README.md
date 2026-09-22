# Heritability of energy budgeting in European seabass
# Moro, I., Campos-Candela, A., Bekaert, M., Sanchez, JB., Catanese, G., Tomas, J. & Palmer. M

This folder contains the R script to estimate the heritability and genetic correlation of two Dynamic Energy Budget (DEB) parameters — the assimilation rate \( f \cdot p_{Am} \) and the volume-specific maintenance rate \( v \) — in European seabass (*Dicentrarchus labrax*) using a Bayesian animal model. The model is fitted with `brms` on a dataset of 343 individuals.

---

## Contents

| File | Description |
|------|-------------|
| `Analysis.R` | Main R script. Loads data, scales traits, defines the bivariate animal model with `brms`, and saves the fitted model. |
| `input.Rdata` | Processed dataset containing the genetic relationship matrix (`GRM`) and the phenotypic data frame (`Y_frame`) with posterior means and standard deviations for \( f \cdot p_{Am} \) and \( v \) at the fish level. |
| `results.rds` | (Generated) Fitted `brms` model object. |
| `Figure2.pdf` | (Generated) Three-panel figure with histograms of \( f \cdot p_{Am} \) and \( v \), and their phenotypic correlation. |

---

## Requirements

- **R** (≥ 4.1.3)
- **brms** (≥ 2.20.0)
- **rstan** or **cmdstanr** (for model fitting; see [brms installation guide](https://github.com/paul-buerkner/brms))
- Optional: **ggplot2** or base R for plotting

---

## Workflow

1. **Prepare environment**  
   Open R and set the working directory to this folder.

2. **Load data and libraries**  
   Load `input.Rdata` which contains:
   - `GRM`: genetic similarity matrix
   - `Y_frame`: mean and SD of posteriors for \( f \cdot p_{Am} \) and \( v \) at the fish level

3. **Visualise raw data**  
   The script produces Figure 2:
   - Histogram of \( f \cdot p_{Am} \)
   - Histogram of \( v \)
   - Scatterplot of \( v \) vs. \( f \cdot p_{Am} \) with a linear fit

4. **Scale traits**  
   Both traits are standardised (mean = 0, SD = 1) because the non-scaled version does not converge. The corresponding standard errors (`pAmsd`, `vsd`) are scaled by the same factor.

5. **Fit the animal model**  
   The bivariate animal model is specified as:
   ```r
   bf1 <- bf(pAm | se(pAmsd, sigma = TRUE) ~ 1 + (1 | p | gr(ID, cov = A)))
   bf2 <- bf(v   | se(vsd,   sigma = TRUE) ~ 1 + (1 | p | gr(ID, cov = A)))
   ```
   The two responses are fitted jointly with `set_rescor(TRUE)` to estimate the genetic and residual correlations. Weakly informative priors are used for all parameters, and the model is run with 4 chains, 5000 iterations (1000 warmup), and `adapt_delta = 0.95`.

6. **Save outputs**  
   The fitted model is saved as `results.rds` (currently commented out in the script; uncomment `saveRDS(fit, "results.rds")` to enable).

---

## Key model features

- **Bivariate animal model**  
  Two DEB parameters (\( f \cdot p_{Am} \) and \( v \)) are modelled simultaneously, allowing estimation of both heritabilities and genetic correlation.

- **Genetic relationship matrix**  
  The `GRM` is passed to `brms` via `data2 = list(A = GRM)` and used as the covariance structure for the individual random effect `(1 | p | gr(ID, cov = A))`.

- **Measurement error**  
  The standard errors of the posterior means (`pAmsd`, `vsd`) are included as known sampling variances using the `se()` term.

- **Priors**  
  - Intercepts: `normal(0, 1)`
  - Additive genetic SDs: `student_t(3, 0.0, 0.4)`
  - Residual SDs: `student_t(3, 0.0, 0.7)`
  - Correlations: `lkj(2)` for genetic and residual correlations

- **Diagnostics**  
  Trace plots, Rhat, and effective sample sizes should be checked with `summary(fit)` and `plot(fit)` after fitting.

---

## Customisation

To adapt the model to your own data:

1. Replace `input.Rdata` with your own dataset, ensuring it contains a genetic relationship matrix and a data frame with the same variable names (`pAm`, `pAmsd`, `v`, `vsd`, `ID`).
2. Adjust the priors in the `priors` object if your traits are on a different scale or you have stronger prior information.
3. Modify the `brmsformula` if you need different fixed or random effects (e.g., adding covariates).
4. If the model does not converge, try increasing `adapt_delta`, `max_treedepth`, or the number of iterations.

---

