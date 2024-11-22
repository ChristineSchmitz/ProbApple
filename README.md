# **🍏 ProbApple 🍎** 
A **Prob**abilistic model to forecast **Apple** yield and high-quality yield. 

# Background
Fruit growers aim to produce high-quality apples in their orchards. An approximation for the total yield and the high-quality yield at harvest early in the season, helps the apple producers in their operational planning. We developed ProbApple a probabilistic model, based on Monte Carlo simulations to forecast apple yield and high-quality yield a four key time points during the vegetation period: ‘at full bloom’, ‘before fruit thinning’, ‘after June drop’, ‘four weeks before harvest’. 

This repository contains all files to run ProbApple and visualize the results. Additionally the results for a case study on 'Gala' apple the German Rhineland are available here. Model and case study are described in the manuscript *ProbApple – A probabilistic model to forecast apple yield and quality* by [Christine Schmitz](https://github.com/ChristineSchmitz), [Lars Zimmermann](https://github.com/Lars-Zimmermann), [Katja Schiffers](https://github.com/katjaschiffers), Martin Balmer and [Eike Luedeling](https://github.com/eikeluedeling). 
The code is written in R (R Core team, 2024)[^1] and mainly uses the package decisionSupport (Luedeling et al., 2021)[^2]. Further functions from the packages tidyverse (Wickham et al., 2019)[^3], png (Urbanek, 2022)[^4], patchwork (Pedersen, 2024)[^5] and ggtext (Wilke, 2022)[^6] were used to sort and visualize the simulation results. 

## Abbreviations
Abbreviations for the forecasting time points used in code and inputs files

tp1 = at full bloom (BBCH 65), picture: [`Flower_Cluster_p1.png`](https://github.com/ChristineSchmitz/ProbApple/blob/main/Flower_Cluster_p1.png)

tp2 = before fruit thinning (fruitlets have a diameter of approximately 1 cm), picture: [`Fruit_Cluster_p2.png`](https://github.com/ChristineSchmitz/ProbApple/blob/main/Fruit_Cluster_p2.png)

tp3 = after June drop (after a natural fruit shedding period end of Mai or in June), picture: [`after_june_drop_p3.png`](https://github.com/ChristineSchmitz/ProbApple/blob/main/after_june_drop_p3.png)

tp4 = four weeks before the estimated harvest date, picture: [`apple_p4.png`](https://github.com/ChristineSchmitz/ProbApple/blob/main/apple_p4.png)

# Respository content

## ProbApple model

[`ProbApple_Code.R`](https://github.com/ChristineSchmitz/ProbApple/blob/main/ProbApple_Code.R) contains the functions for the ProbApple model. After loading the required packages, the functions for the yield and quality sub-models are defined. The sub-models were combined to one model function for each forecasting time point. 

[`Simulations_with_ProbApple.R`](https://github.com/ChristineSchmitz/ProbApple/blob/main/Simulations_with_ProbApple.R) loads the ProbApple model and the required inputs to run a Monte Carlo simulation. This script is needed to generate simulation results with ProbApple. Here the model is applied for two different management scenarios with and without anti-hail netting.  

## Input files

[`apple_quality_input_Gala.csv`](https://github.com/ChristineSchmitz/ProbApple/blob/main/apple_quality_input_Gala.csv) contains all estimates which are related to growing region and apple variety, but not orchard or year specific. 

[`apple_estimation_Gala.csv`](https://github.com/ChristineSchmitz/ProbApple/blob/main/apple_estimation_Gala.csv) contains all estimates which are orchard- and year-specific. 

[`Management_inputs.csv`](https://github.com/ChristineSchmitz/ProbApple/blob/main/Management_inputs.csv) and [`Management_inputs_without_hailnet.csv`](https://github.com/ChristineSchmitz/ProbApple/blob/main/Management_inputs_without_hailnet.csv) lists all management measures which are implemented in ProbApple and a value of 0 or 1 for each measure. 1 means that a measure is installed/conducted and 0 means that the measure is not done. 

## Results 
In a case study, we applied ProbApple for a Gala orchard in the Rhineland, an important apple growing region in western Germany. We tested it for two different management scenarios: with and without anti-hail netting. 
[`MC_results`](https://github.com/ChristineSchmitz/ProbApple/blob/main/MC_results) is a folder containing the simulation results for both scenarios at all four forecasting time points (at full bloom, before fruit thinning, after June drop and 4 weeks before the estimated harvest date). The results are provided as RDS and csv files. The RDS files could be used in R to further analyse the results, while cvs file could be used in other programs as well.

## Visualization of the results
[`Plotting_ProbApple_simulation_results.R`](https://github.com/ChristineSchmitz/ProbApple/blob/main/Plotting_ProbApple_simulation_results.R) generates histogram plots for yield and high-quality yield, it calculates and plots the Variable Importance in Projection (VIP) and provides a histogram plot to compare high-quality yield the management scenarios. To structure the results of the PLS regression for the VIP plot, the function in [`Sorting_VIP_data.R`](https://github.com/ChristineSchmitz/ProbApple/blob/main/Sorting_VIP_data.R) is needed. 

# References

[^1]: R Core Team, 2024. R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria.
[^2]: Luedeling, E., Goehring, L., Schiffers, K., Whitney, C., Fernandez, E., 2021. decisionSupport – Quantitative Support of Decision Making under Uncertainty. Contributed package to the R programming language. Version 1.106.
[^3]: Wickham, H., Averick, M., Bryan, J., Chang, W., McGowan, L., François, R., Grolemund, G., Hayes, A., Henry, L., Hester, J., Kuhn, M., Pedersen, T., Miller, E., Bache, S., Müller, K., Ooms, J., Robinson, D., Seidel, D., Spinu, V., Takahashi, K., Vaughan, D., Wilke, C., Woo, K., Yutani, H., 2019. Welcome to the Tidyverse. JOSS 4, 1686. https://doi.org/10.21105/joss.01686
[^4]: Urbanek, S., 2022. png: Read and write PNG images.R package version 0.1-8.
[^5]: Pedersen, T.L., 2024. patchwork: The Composer of Plots.R package version 1.3.0.
[^6]: Wilke, C.O., Wiernik, B.M., 2022. ggtext: Improved Text Rendering Support for “ggplot2.”R package version 0.1.2.