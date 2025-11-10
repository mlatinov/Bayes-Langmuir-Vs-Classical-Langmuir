# Bayesian Analysis of Langmuir Monolayer Isotherms

A computational framework for Bayesian parameter estimation in lipid monolayer compression isotherms, providing robust alternatives to classical Langmuir trough analysis.

## Overview

This repository implements a Bayesian nonlinear regression model to estimate thermodynamic parameters from Langmuir monolayer compression isotherms. The methodology addresses key limitations of classical point-based analysis by leveraging complete experimental datasets and providing comprehensive uncertainty quantification.

## Scientific Background

Traditional analysis of Langmuir isotherms relies on single point at maximum compression to estimate molecular surface area (A_mol). This approach discards most experimental data and provides no inherent uncertainty quantification. The Bayesian implementation uses the complete compression trajectory to simultaneously estimate A_mol and maximum surface pressure (π_max), while naturally propagating experimental uncertainty through posterior distributions.

## Methodological Approach

### Bayesian Framework
- **Probability model** specifying likelihood and priors 
- **Hamiltonian Monte Carlo sampling** via Stan for posterior inference
- **Comparison against classical point-estimate method**

### Key Advantages
- **Utilization of complete experimental data** rather than single-point extrapolation
- **Natural uncertainty quantification** through posterior distributions
- **Propagation of measurement error** through the statistical model
- **Ability to incorporate prior knowledge** from related experimental systems

## Experimental Data

The compression isotherm data used in this analysis were collected through experimental work conducted at the University of Sofia, Faculty of Biology. The measurements were performed by myself and my colleagues The detailed experimental protocols, including Langmuir trough instrumentation specifications, sample preparation methods, and measurement procedures, are documented in our laboratory records. Unfortunately, this comprehensive documentation is currently available only in Bulgarian.

## Implementation

### Computational Pipeline
The analysis implements a reproducible workflow using the `targets` package:

1. **Data preprocessing** and quality control of raw compression isotherms
2. **Classical Langmuir analysis** for benchmark comparisons
3. **Prior Simulations** for priors quality and logic
4. **Bayesian model specification** and prior predictive checks
5. **Posterior sampling** and convergence diagnostics
6. **Results insights** and comparative visualization

## Model Specification

The Bayesian model assumes that the observed surface pressure measurements are normally distributed around the theoretical value given by the Langmuir equation:

$$\pi_i \sim \mathcal{N}(\mu_i, \sigma^2)$$

where $\pi_i$ is the measured surface pressure at a given molecular area $A_i$, and the expected value $\mu_i$ is defined by the Langmuir-Szyszkowski equation:

$$\mu_i = \pi_{\max} \left( 1 - \frac{A_{\text{mol}}}{A_{\text{mol}} + A_i} \right)$$

In this equation:
- $\pi_{\max}$ is the maximum surface pressure the system reaches at saturation
- $A_{\text{mol}}$ is the characteristic molecular area, describing the degree of surface coverage
- $\sigma$ denotes the standard deviation of the measurement error

Within the Bayesian framework, the parameters $\pi_{\max}$, $A_{\text{mol}}$, and $\sigma$ are treated as random variables with specified prior distributions. The joint posterior distribution is defined by Bayes' theorem as:

$$
p(\theta \mid \pi, A) \propto p(\pi \mid A, \theta) \, p(\theta)
$$

where $p(\pi \mid A, \theta)$ is the likelihood of the data and $p(\theta)$ is the joint prior distribution for the parameters.

The following weakly informative prior distributions were selected for the model:
- $\pi_{\max} \sim \text{Normal}(50, 20)$
- $A_{\text{mol}} \sim \text{Normal}(10, 5)$
- $\sigma \sim \text{Exponential}(1)$

These priors encode the assumptions that the maximum surface pressure is centered around 50 mN/m with substantial uncertainty, the characteristic molecular area is around 10 Å², and the measurement standard deviation is positive and likely small.

The complete model can be equivalently expressed as:

$$\pi_i \sim \mathcal{N}\left( \pi_{\text{max}} \times \left( 1 - \frac{A_{\text{mol}}}{A_{\text{mol}} + A_i} \right), \sigma^2 \right)$$
$$\pi_{\max} \sim \text{Normal}(50, 20)$$
$$A_{\text{mol}} \sim \text{Normal}(10, 5)$$
$$\sigma \sim \text{Exponential}(1)$$

## Installation and Execution

### Requirements
- R (≥ 4.1.0)
- Stan computational framework
- Key R packages: `targets`, `cmdstanr`, `posterior`, `tidyverse`,`brms`,`bayesplot`

### Execution
```r
# Execute complete analysis pipeline
tar_make()
