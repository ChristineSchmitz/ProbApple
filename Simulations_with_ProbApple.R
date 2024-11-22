#Case study simulations with ProbApple

#Load all functions
source("ProbApple_Code.R")

#Case study: Read in input data####
Apple_input<-read.csv("apple_quality_input_Gala.csv", colClasses = c("character", "character", "numeric", "character","numeric", "character","character"), sep = ",", dec = ".")
Apple_estimation<-read.csv("apple_estimation_Gala.csv",colClasses = c("character", "character", "numeric", "character","numeric", "character","character"), sep = ",", dec = ".")

#Combine to one input table
Apple_prediction_input<-rbind(Apple_input, Apple_estimation)


#Case Study: Simulations for the scenario with anti-hail netting####
#Read in management options
Management_values<-read.csv("Management_inputs.csv",colClasses = c("character", "numeric"), sep = ",", dec = ".")

##Four weeks before the estimated harvest date####
apple_quality_and_yield_mc_simulation_tp4 <- mcSimulation(estimate = as.estimate(Apple_prediction_input),
                                                          model_function = quality_and_yield_p4,
                                                          numberOfModelRuns = 10000,
                                                          functionSyntax = "plainNames")
#save
#saveRDS(apple_quality_and_yield_mc_simulation_tp4, "MC_results/MC_results_tp4.RDS")
#write.csv(apple_quality_and_yield_mc_simulation_tp4, "MC_results/MC_results_tp4_csv.csv")

##After June drop####
apple_quality_and_yield_mc_simulation_tp3 <- mcSimulation(estimate = as.estimate(Apple_prediction_input),
                                                          model_function = quality_and_yield_p3,
                                                          numberOfModelRuns = 10000,
                                                          functionSyntax = "plainNames")
#save
#saveRDS(apple_quality_and_yield_mc_simulation_tp3, "MC_results/MC_results_tp3.RDS")
#write.csv(apple_quality_and_yield_mc_simulation_tp3, "MC_results/MC_results_tp3_csv.csv")

##Before fruit thinning####
apple_quality_and_yield_mc_simulation_tp2 <- mcSimulation(estimate = as.estimate(Apple_prediction_input),
                                                          model_function = quality_and_yield_p2,
                                                          numberOfModelRuns = 10000,
                                                          functionSyntax = "plainNames")
#save
#saveRDS(apple_quality_and_yield_mc_simulation_tp2, "MC_results/MC_results_tp2.RDS")
#write.csv(apple_quality_and_yield_mc_simulation_tp2, "MC_results/MC_results_tp2_csv.csv")

##Full bloom####
apple_quality_and_yield_mc_simulation_tp1 <- mcSimulation(estimate = as.estimate(Apple_prediction_input),
                                                          model_function = quality_and_yield_p1,
                                                          numberOfModelRuns = 10000,
                                                          functionSyntax = "plainNames")
#save
#saveRDS(apple_quality_and_yield_mc_simulation_tp1, "MC_results/MC_results_tp1.RDS")
#write.csv(apple_quality_and_yield_mc_simulation_tp1, "MC_results/MC_results_tp1_csv.csv")

#Case Study: Simulations for the scenario without anti-hail netting####
#Read in management options
Management_values<-read.csv("Management_inputs_without_hailnet.csv",colClasses = c("character", "numeric"), sep = ",", dec = ".")
##Four weeks before the estimated harvest date####
apple_quality_and_yield_mc_simulation_tp4_without_hailnet <- mcSimulation(estimate = as.estimate(Apple_prediction_input),
                                                                    model_function = quality_and_yield_p4,
                                                                    numberOfModelRuns = 10000,
                                                                    functionSyntax = "plainNames")
#saveRDS(apple_quality_and_yield_mc_simulation_tp4_without_hailnet, "MC_results/MC_results_tp4_without_hailnet.RDS")
#write.csv(apple_quality_and_yield_mc_simulation_tp4_without_hailnet, "MC_results/MC_results_tp4_without_hailnet_csv.csv")

##After June drop####
apple_quality_and_yield_mc_simulation_tp3_without_hailnet <- mcSimulation(estimate = as.estimate(Apple_prediction_input),
                                                                    model_function = quality_and_yield_p3,
                                                                    numberOfModelRuns = 10000,
                                                                    functionSyntax = "plainNames")
#saveRDS(apple_quality_and_yield_mc_simulation_tp3_without_hailnet, "MC_results/MC_results_tp3_without_hailnet.RDS")
#write.csv(apple_quality_and_yield_mc_simulation_tp3_without_hailnet, "MC_results/MC_results_tp3_without_hailnet_csv.csv")

##Before fruit thinning####
apple_quality_and_yield_mc_simulation_tp2_without_hailnet <- mcSimulation(estimate = as.estimate(Apple_prediction_input),
                                                                    model_function = quality_and_yield_p2,
                                                                    numberOfModelRuns = 10000,
                                                                    functionSyntax = "plainNames")
#saveRDS(apple_quality_and_yield_mc_simulation_tp2_without_hailnet, "MC_results/MC_results_tp2_without_hailnet.RDS")
#write.csv(apple_quality_and_yield_mc_simulation_tp2_without_hailnet, "MC_results/MC_results_tp2_without_hailnet_csv.csv")

##Full bloom####
apple_quality_and_yield_mc_simulation_tp1_without_hailnet <- mcSimulation(estimate = as.estimate(Apple_prediction_input),
                                                                    model_function = quality_and_yield_p1,
                                                                    numberOfModelRuns = 10000,
                                                                    functionSyntax = "plainNames")
#saveRDS(apple_quality_and_yield_mc_simulation_tp1_without_hailnet, "MC_results/MC_results_tp1_without_hailnet.RDS")
#write.csv(apple_quality_and_yield_mc_simulation_tp1_without_hailnet, "MC_results/MC_results_tp1_without_hailnet_csv.csv")
