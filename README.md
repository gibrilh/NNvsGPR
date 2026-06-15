
# Surrogate-Based Multi-Objective Shape Optimisation of an Aircraft Maintenance Panel

**Module:** MECH0107 – Data-Driven Methods for Engineers (UCL)
**Type:** Individual coursework
**Grade:** 90/100

## Overview

This project develops and compares two surrogate models, Gaussian Process Regression (GPR) and a Neural Network (NN), to optimise the shape of an aircraft wing maintenance panel. The panel is modelled as a thin square plate with an oval port under biaxial loading, and the goal is to simultaneously minimise the maximum von Mises stress (maximising safety) and the panel mass.

Both surrogates are trained on FEA data and integrated into the NSGA-II multi-objective optimiser to generate Pareto fronts across four design variables: plate half-width (W₁), port half-width (W₂), fillet radius (R), and thickness (t).

## Approach

- **Data pipeline:** Latin Hypercube sampling of the design space, with each design evaluated through an Abaqus FEA model driven by a MATLAB script (von Mises stress and mass extracted per design).
- **GPR surrogate:** scikit-learn, C×RBF + WhiteKernel, 300 training samples, hyperparameters selected on RMSE.
- **NN surrogate:** Keras/TensorFlow, 64×64 architecture, tanh activation, Adam optimiser, early stopping on a validation set to limit overfitting.
- **Optimisation:** pymoo NSGA-II (population 150, 100 generations) run with each surrogate to produce Pareto fronts, which are compared against direct FEA on timing and accuracy.

**Outcome:** GPR was selected as the preferred surrogate based on accuracy, stability, and computational efficiency.

## Tech Stack

Python (scikit-learn, Keras/TensorFlow, pymoo, NumPy, Matplotlib), Abaqus FEA, MATLAB data pipeline.

## Feedback Summary (90/100)

- **Model setup (29/30):** Clear sampling/preprocessing explanation, strong quantitative comparison of kernels, architectures, activations, learning rates, and optimisers.
- **Results (27/30):** Clear error evaluation and clean Pareto fronts; the main point lost was not repeating NN training across multiple seeds to report mean and standard deviation of test error.
- **Discussion (17/20):** Strong quantitative justification of surrogate use; minor gaps in linking model choice to the optimisation task and in adding quantitative support under revised constraints.
- **Code (8/10):** Well-structured and clearly commented; suggestion was to modularise GPR training, NN training, and optimisation into separate scripts/functions.
- **Presentation & structure (9/10):** Well-structured and clearly written; figure labelling and small font sizes were the main fix.