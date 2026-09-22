# Heritability and genetic correlations of physiological processes inferred from bioenergetic model parameters

This repository contains all the code related to our work entitled **Heritability and genetic correlations of physiological processes inferred from bioenergetic model parameters**, by Irene Moro-Martinez, Andrea Campos-Candela, Michaël Bekaert Juan Sanchez, Gaetano Catanese, Joaquim Tomàs-Ferrer and Miquel Palmer.

The work presented here investigates whether key physiological processes involved in energy acquisition and energy mobilization exhibit additive genetic variation. We use a mechanistic Dynamic Energy Budget (DEB) [More about DEB theory [here](https://debportal.debtheory.org/docs/)] framework to derive individual-level parameters describing these processes and subsequently quantify their heritability and genetic correlation using genomic information.

In particular, we estimate two individual-level DEB parameters in European seabass (*Dicentrarchus labrax*): a compound parameter describing energy acquisition, combining the scaled functional response and the surface-specific maximum assimilation rate \(∀\), and the energy conductance \(v\), which governs the mobilization of energy reserves. These parameters are interpreted as latent traits summarizing biologically meaningful physiological processes.

The DEB parameters were estimated using a hierarchical Bayesian model implemented in STAN [More about STAN [here](https://mc-stan.org/)], based on repeated measurements of total length, wet weight and muscle fat content. Subsequently, genomic relatedness was quantified using approximately 28,800 SNP markers, and a Bayesian bivariate animal model was used to estimate heritability and genetic and residual correlations between the two DEB parameters.

The primary codebase underlying the implementation presented here, including detailed documentation and explanations, and associated with Palmer *et al.* (2024), is available at the following repository: [DEB_IndividualVariability-Palmer-et-al.2024](https://github.com/Iremoma/DEB_IndividualVariability-Palmer-et-al.2024)

This repository is licensed under a [MIT License Copyright (c) 2026b Irene Moro-Martinez](./LICENSE). 


# Requirements
Install: 
- [R](https://www.r-project.org/about.html) (4.1.3 or higher)
- CmdStanR (Command Stan R) in R: CmdStanR is a lightweight interface to Stan for R users. If you are using Stan in R for the first time, or you have no experience with this package, we encourage you to visit [Getting started with CmdStanR](https://mc-stan.org/cmdstanr/articles/cmdstanr.html) and follow the recommended steps to install the package.
- [brms](https://cran.r-project.org/package=brms): An R package for Bayesian generalized multivariate modeling using Stan.
- [AGHmatrix](https://cran.r-project.org/package=AGHmatrix): An R package for constructing relationship matrices, including genomic relationship matrices.
- [PLINK](https://www.cog-genomics.org/plink/): A command-line toolset for quality control and analysis of genotype data.

The Bayesian DEB model and the animal model are implemented in STAN and fitted through R using CmdStanR and brms, respectively.

Recommended properties of the computer, and those that characterized the computer used for running these models, are: 
- Intel(R) Xeon(R)  CPU E5-2620 v4 @ 2.10GHz (40 cores and 64 GB RAM)

# Contents
We provide the R scripts necessary to reproduce the heritability and genetic correlation of the DEB parameters as presented on the paper Chapter 4 of my thesis **INDIVIDUAL VARIABILITY AND HERITABILITY OF PHYSIOLOGICAL RESPONSES UNDER OCEAN RISING TEMPERATURES: A CASE STUDY FOR A MEDITERRANEAN FISH SPECIES by Irene Moro-Martínez** . **Note that the scripts are self-explanatory and have a lot of notations to guide the user on the different steps.** 

All the code is organized in the following folder:

### [Animal model](https://github.com/Iremoma/Heritability-DEB-parameters/tree/main/Animal%20model)

This folder contains the code used to estimate the additive genetic variance and covariance of the two DEB parameters.

Genomic information was available for 372 individuals, with 28,804 SNP markers retained after quality control. The genomic relationship matrix (GRM) was calculated using the AGHmatrix R package. The final animal-model dataset included 343 fish for which both genomic and DEB parameter information were available.

The Bayesian bivariate animal model was used to partition phenotypic variation into additive genetic and residual components while accounting for uncertainty in the individual DEB parameter estimates.

We provide:

- The input data file `input.RData` which the pre‑processed dataset used for the analysis.
- The Bayesian bivariate animal model implemented in brms.
- Prior specification and sensitivity analyses.
- Convergence diagnostics.
- Script for calculating heritability and genetic and residual correlations `animal_model.R`.

The animal model accounts for uncertainty in the individual-level DEB parameter estimates through their posterior standard deviations.


# Citation

If you use this code, please consider citing our work:

Moro-Martínez, I.; Campos-Candela, A.; Bekaert, M.; Sanchez, J.; Catanese, G.; Tomàs-Ferrer, J.; and Palmer, M. (in prep). Heritability and genetic correlations of physiological processes inferred from bioenergetic model parameters.


# Contact

Any questions: m.palmer@csic.es , irenejues@gmail.com
