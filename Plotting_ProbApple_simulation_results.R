#Load required packages####
library(ggtext)
library(png)
library(grid)
library(patchwork)
library(tidyverse)
library(decisionSupport)

#Prepare formatting functions####
options(scipen=100000)
remove_x <- theme(
  axis.text.x = element_blank(),
  #axis.ticks.x = element_blank(),
  axis.title.x = element_blank()
)

remove_title<-theme(strip.text.x = element_blank())

remove_legend<-theme(legend.position = "none")

remove_y <- theme(
  axis.text.y = element_blank(),
  #axis.ticks.y = element_blank(),
  axis.title.y = element_blank()
)
remove_y_only_title<-theme(axis.title.y = element_blank())
remove_x_only_title<-theme(axis.title.x = element_blank())

#read saved Monte Carlo simulation results
apple_quality_and_yield_mc_simulation_tp4<-readRDS("MC_results/MC_results_tp4.RDS")
apple_quality_and_yield_mc_simulation_tp3<-readRDS("MC_results/MC_results_tp3.RDS")
apple_quality_and_yield_mc_simulation_tp2<-readRDS("MC_results/MC_results_tp2.RDS")
apple_quality_and_yield_mc_simulation_tp1<-readRDS("MC_results/MC_results_tp1.RDS")

apple_quality_and_yield_mc_simulation_tp4_without_hailnet<-readRDS("MC_results/MC_results_tp4_without_hailnet.RDS")
apple_quality_and_yield_mc_simulation_tp3_without_hailnet<-readRDS("MC_results/MC_results_tp3_without_hailnet.RDS")
apple_quality_and_yield_mc_simulation_tp2_without_hailnet<-readRDS("MC_results/MC_results_tp2_without_hailnet.RDS")
apple_quality_and_yield_mc_simulation_tp1_without_hailnet<-readRDS("MC_results/MC_results_tp1_without_hailnet.RDS")

#VIP Quality yield with anti-hail netting####

#Function to sort the PLS-Results
source("Sorting_VIP_data.R")

#Read in model input data 
Apple_input<-read.csv("apple_quality_input_Gala.csv", colClasses = c("character", "character", "numeric", "character","numeric", "character","character"), sep = ",", dec = ".")
Apple_estimation<-read.csv("apple_estimation_Gala.csv",colClasses = c("character", "character", "numeric", "character","numeric", "character","character"), sep = ",", dec = ".")
Apple_prediction_input<-rbind(Apple_input, Apple_estimation)

#PLS regression to compute the Variable Importance in Projection (VIP) for high-quality yield#

#four weeks before harvest
pls_result_quality_yield_tp4 <- plsr.mcSimulation(object = apple_quality_and_yield_mc_simulation_tp4,
                                                  resultName = names(apple_quality_and_yield_mc_simulation_tp4$y)[5], ncomp = 1)
#saveRDS(pls_result_quality_yield_tp4, "VIP_quality_yield_tp4")

#after June drop
pls_result_quality_yield_tp3 <- plsr.mcSimulation(object = apple_quality_and_yield_mc_simulation_tp3,
                                                  resultName = names(apple_quality_and_yield_mc_simulation_tp3$y)[5], ncomp = 1)
#saveRDS(pls_result_quality_yield_tp3, "VIP_quality_yield_tp3")

#before fruit thinning
pls_result_quality_yield_tp2 <- plsr.mcSimulation(object = apple_quality_and_yield_mc_simulation_tp2,
                                                  resultName = names(apple_quality_and_yield_mc_simulation_tp2$y)[5], ncomp = 1)
#saveRDS(pls_result_quality_yield_tp2, "VIP_quality_yield_tp2")

#full bloom
pls_result_quality_yield_tp1 <- plsr.mcSimulation(object = apple_quality_and_yield_mc_simulation_tp1,
                                                  resultName = names(apple_quality_and_yield_mc_simulation_tp1$y)[5], ncomp = 1)
#saveRDS(pls_result_quality_yield_tp1, "VIP_quality_yield_tp1")

#restructure PLS results
pls_result_quality_yield_tp1_table<-VIP_table(pls_result_quality_yield_tp1, input_table = Apple_prediction_input, threshold = 0)
pls_result_quality_yield_tp2_table<-VIP_table(pls_result_quality_yield_tp2, input_table = Apple_prediction_input, threshold = 0)
pls_result_quality_yield_tp3_table<-VIP_table(pls_result_quality_yield_tp3, input_table = Apple_prediction_input, threshold = 0)
pls_result_quality_yield_tp4_table<-VIP_table(pls_result_quality_yield_tp4, input_table = Apple_prediction_input, threshold = 0)

#separate the variable descriptions
variablen_VIP<-pls_result_quality_yield_tp1_table$description

#extract important values from the PLS results
VIP_qualityyieldtp1<-pls_result_quality_yield_tp1_table$VIP
Coef_qualityyieldtp1<-pls_result_quality_yield_tp1_table$Coefficient
VIP_qualityyieldtp2<-pls_result_quality_yield_tp2_table$VIP
VIP_qualityyieldtp3<-pls_result_quality_yield_tp3_table$VIP
VIP_qualityyieldtp4<-pls_result_quality_yield_tp4_table$VIP
Coef_qualityyieldtp2<-pls_result_quality_yield_tp2_table$Coefficient
Coef_qualityyieldtp3<-pls_result_quality_yield_tp3_table$Coefficient
Coef_qualityyieldtp4<-pls_result_quality_yield_tp4_table$Coefficient

#create a data frame, with variable description, VIP and Coefficient 
VIP_quality_yield_all_tp<-data.frame(variablen_VIP,
                                     VIP_qualityyieldtp1,
                                     VIP_qualityyieldtp2,
                                     VIP_qualityyieldtp3,
                                     VIP_qualityyieldtp4)
Coef_quality_yield_all_tp<-data.frame(variablen_VIP,
                                      Coef_qualityyieldtp1,
                                      Coef_qualityyieldtp2,
                                      Coef_qualityyieldtp3,
                                      Coef_qualityyieldtp4)
VIP_and_Coef_quality_yield<-data.frame(variablen_VIP,
                                       VIP_qualityyieldtp1,
                                       Coef_qualityyieldtp1,
                                       VIP_qualityyieldtp2,
                                       Coef_qualityyieldtp2,
                                       VIP_qualityyieldtp3,
                                       Coef_qualityyieldtp3,
                                       VIP_qualityyieldtp4,
                                       Coef_qualityyieldtp4)


#set the threshold for important variables to a VIP > 1
VIP_and_Coef_quality_yield_threshold_mit_coef<-subset(VIP_and_Coef_quality_yield, abs(VIP_and_Coef_quality_yield$VIP_qualityyieldtp1)>1|
                                                        abs(VIP_and_Coef_quality_yield$VIP_qualityyieldtp2)>1|
                                                        abs(VIP_and_Coef_quality_yield$VIP_qualityyieldtp3)>1|
                                                        abs(VIP_and_Coef_quality_yield$VIP_qualityyieldtp4)>1)

#Restructure data frame
VIP_and_Coef_quality_yield_threshold_mit_coef_longer<-VIP_and_Coef_quality_yield_threshold_mit_coef%>%
  pivot_longer(cols = !variablen_VIP, names_to = c(".value","qualityyieldtp"), names_sep = "_")

#add new column with the information if the coefficient is positive or negative
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$PosNeg<-ifelse(VIP_and_Coef_quality_yield_threshold_mit_coef_longer$Coef>0,"positive","negative")

#add new column for VIP where all variables with a VIP <1 get the value "NA"
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$VIP_threshold_corr<-ifelse(VIP_and_Coef_quality_yield_threshold_mit_coef_longer$VIP>=1,VIP_and_Coef_quality_yield_threshold_mit_coef_longer$VIP, NA )

#read in images as labels for the plot
labels <- c("qualityyieldtp1" = "<img src='Flower_Cluster_p1.png' width='30' /><br>*tp 1*",
            "qualityyieldtp2" = "<img src='Fruit_Cluster_p2.png' width='30' /><br>*tp 2*",
            "qualityyieldtp3" = "<img src='after_june_drop_p3.png' width='30' /><br>*tp 3*",
            "qualityyieldtp4" = "<img src='apple_p4.png' width='30' /><br>*tp 4*") 

#reformat some descriptions to go over two lines
variablen_VIP[42]<-"Percentage change of weekly diameter\nincrease in case of overbearing (tp2-tp3, tp3-tp4, tp4-harvest)*"             
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$variablen_VIP[13]<-"Percentage change of weekly diameter\nincrease in case of overbearing (tp2-tp3, tp3-tp4, tp4-harvest)*"
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$variablen_VIP[14]<-"Percentage change of weekly diameter\nincrease in case of overbearing (tp2-tp3, tp3-tp4, tp4-harvest)*"
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$variablen_VIP[15]<-"Percentage change of weekly diameter\nincrease in case of overbearing (tp2-tp3, tp3-tp4, tp4-harvest)*"
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$variablen_VIP[16]<-"Percentage change of weekly diameter\nincrease in case of overbearing (tp2-tp3, tp3-tp4, tp4-harvest)*"

variablen_VIP[33]<-"Percentage of apples with\ninsufficient peel color under normal conditions (tp4-harvest)"                          
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$variablen_VIP[9]<-"Percentage of apples with\ninsufficient peel color under normal conditions (tp4-harvest)" 
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$variablen_VIP[10]<-"Percentage of apples with\ninsufficient peel color under normal conditions (tp4-harvest)" 
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$variablen_VIP[11]<-"Percentage of apples with\ninsufficient peel color under normal conditions (tp4-harvest)" 
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$variablen_VIP[12]<-"Percentage of apples with\ninsufficient peel color under normal conditions (tp4-harvest)" 

variablen_VIP[166]<-"Actual duration from 4 weeks before the\nestimated harvest date to harvest date"             
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$variablen_VIP[57]<-"Actual duration from 4 weeks before the\nestimated harvest date to harvest date"
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$variablen_VIP[58]<-"Actual duration from 4 weeks before the\nestimated harvest date to harvest date"
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$variablen_VIP[59]<-"Actual duration from 4 weeks before the\nestimated harvest date to harvest date"
VIP_and_Coef_quality_yield_threshold_mit_coef_longer$variablen_VIP[60]<-"Actual duration from 4 weeks before the\nestimated harvest date to harvest date"

#Plot the VIP results
png("Figures_manuscript/VIP_quality_yield_v2.png", pointsize=10, width=4500, height=6100, res=600)

ggplot(VIP_and_Coef_quality_yield_threshold_mit_coef_longer, aes(qualityyieldtp, forcats::fct_rev(variablen_VIP), color = PosNeg, size = VIP_threshold_corr)) +
  geom_point(shape = 16, stroke = 0) +
  geom_hline(yintercept = seq(.5, 30.5, 1), linewidth = .2, color= "gray75") +
  #scale_x_discrete() +
  scale_radius(range = c(1, 9)) +
  scale_color_manual(values = c("negative"="red", "positive"="blue"))  +
  theme_minimal() +
  theme(legend.position = "bottom", 
        panel.grid.major = element_blank(),
        legend.text = element_text(size = 8),
        legend.title = element_text(size = 8),
        axis.text = element_text(color = "black"),
        axis.text.x = ggtext::element_markdown()) +
  guides(size = guide_legend(override.aes = list(fill = NA, color = "black", stroke = .25), 
                             label.position = "bottom",
                             title.position = "top", 
                             order = 1),
         fill = guide_colorbar(ticks.colour = NA, order = 2)) +
  labs(size = "Area = VIP", color = "Coefficient", x = NULL, y = NULL)+
  scale_x_discrete(labels=labels, position = "top")+
  geom_vline(xintercept = seq(0.5,5.5,1), linewidth=.2, color="gray75")+
  theme(plot.caption = element_text(hjust = 0),
        plot.caption.position =  "plot")+
  labs(caption = "*This variable has a negative value. A less negative i.e. higher value positively influences\nthe high-quality yield, as the fruit growth is inhibited less strongly.")

dev.off()


#Yield and quality yield####

#select only the return from the simulations
results_tp4<-apple_quality_and_yield_mc_simulation_tp4$y
results_tp3<-apple_quality_and_yield_mc_simulation_tp3$y
results_tp2<-apple_quality_and_yield_mc_simulation_tp2$y
results_tp1<-apple_quality_and_yield_mc_simulation_tp1$y

#select the total yield and replace values >120 with 130
total_yield_diameter_p4<-results_tp4$total_yield_diameter
total_yield_diameter_p4<-ifelse(total_yield_diameter_p4>120, 130, total_yield_diameter_p4)
total_yield_diameter_p3<-results_tp3$total_yield_diameter
total_yield_diameter_p3<-ifelse(total_yield_diameter_p3>120, 130, total_yield_diameter_p3)
total_yield_diameter_p2<-results_tp2$total_yield_diameter
total_yield_diameter_p2<-ifelse(total_yield_diameter_p2>120, 130, total_yield_diameter_p2)
total_yield_diameter_p1<-results_tp1$total_yield_diameter
total_yield_diameter_p1<-ifelse(total_yield_diameter_p1>120, 130, total_yield_diameter_p1)

#select high-quality yield and replace values >120 with 135
high_quality_yield_diameter_p4<-results_tp4$high_quality_yield_diameter
high_quality_yield_diameter_p4<-ifelse(high_quality_yield_diameter_p4>120, 135, high_quality_yield_diameter_p4)
high_quality_yield_diameter_p3<-results_tp3$high_quality_yield_diameter
high_quality_yield_diameter_p3<-ifelse(high_quality_yield_diameter_p3>120, 135, high_quality_yield_diameter_p3)
high_quality_yield_diameter_p2<-results_tp2$high_quality_yield_diameter
high_quality_yield_diameter_p2<-ifelse(high_quality_yield_diameter_p2>120, 135, high_quality_yield_diameter_p2)
high_quality_yield_diameter_p1<-results_tp1$high_quality_yield_diameter
high_quality_yield_diameter_p1<-ifelse(high_quality_yield_diameter_p1>120, 135, high_quality_yield_diameter_p1)

#create a data frame with total and high-quality yield
yield_diameter_p1<-data.frame(total_yield_diameter_p1,
                              high_quality_yield_diameter_p1)
yield_diameter_p2<-data.frame(total_yield_diameter_p2,
                              high_quality_yield_diameter_p2)
yield_diameter_p3<-data.frame(total_yield_diameter_p3,
                              high_quality_yield_diameter_p3)
yield_diameter_p4<-data.frame(total_yield_diameter_p4,
                              high_quality_yield_diameter_p4)

#restructure the data frames 
yield_diameter_p1_longer<-pivot_longer(yield_diameter_p1, cols = c(total_yield_diameter_p1,
                                                                   high_quality_yield_diameter_p1))


yield_diameter_p2_longer<-pivot_longer(yield_diameter_p2, cols = c(total_yield_diameter_p2,
                                                                   high_quality_yield_diameter_p2))


yield_diameter_p3_longer<-pivot_longer(yield_diameter_p3, cols = c(total_yield_diameter_p3,
                                                                   high_quality_yield_diameter_p3))


yield_diameter_p4_longer<-pivot_longer(yield_diameter_p4, cols = c(total_yield_diameter_p4,
                                                                   high_quality_yield_diameter_p4))

#check the maximum height of a bar in the histogram
all_for_min_max<-rbind(yield_diameter_p1_longer,
                       yield_diameter_p2_longer,
                       yield_diameter_p3_longer,
                       yield_diameter_p4_longer)
floor(min(all_for_min_max$value))
ceiling(max(all_for_min_max$value))

#set x axis limits
axis_limits_x<-c((-1),
                 ceiling(max(all_for_min_max$value)))

#plot the histograms

#full bloom
yield_plot_p1<-ggplot(data = yield_diameter_p1_longer)+
  geom_histogram(mapping = aes(x=value, fill=name), 
                 binwidth = 1, alpha=0.5,
                 position = 'identity')+
  scale_x_continuous(limits = axis_limits_x)+
  theme_bw(base_size = 11)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(legend.position = "inside",
        legend.position.inside = c(0.175,0.8),
        axis.text = element_text(colour = "black"),
        text = element_text(family = "sans", size = 15))+
  xlab("Predicted yield [t/ha]")+
  ylab("Frequency")+
  scale_y_continuous(limits = c(0,500))+
  scale_fill_manual(values = c("#429323","#1E7BE1"),labels = c("high-quality yield", "total yield"))+
  theme(legend.title=element_blank())+
  geom_vline(xintercept = 127, color="black", linetype="dotted")+
  annotate(geom="text", x=c(135,108), y=c(250, 60), label=c("Yield > 120 t/ha"," at full bloom"), color="black", angle=c(90,0), fontface=c("plain","italic"))

#before fruit thinning
yield_plot_p2<-ggplot(data = yield_diameter_p2_longer)+
  geom_histogram(mapping = aes(x=value, fill=name), 
                 binwidth = 1, alpha=0.5,
                 position = 'identity')+
  scale_x_continuous(limits = axis_limits_x)+
  theme_bw(base_size = 11)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(legend.position = "inside",
        legend.position.inside = c(0.8,0.9),
        axis.text = element_text(colour = "black"),
        text = element_text(family = "sans", size = 15))+
  xlab("Predicted yield [t/ha]")+
  ylab("Frequency")+
  scale_y_continuous(limits = c(0,500))+
  scale_fill_manual(values = c("#429323","#1E7BE1"),labels = c("high-quality yield", "total yield"))+
  geom_vline(xintercept = 127, color="black", linetype="dotted")+
  annotate(geom="text", x=c(135,108), y=c(250, 100), label=c("Yield > 120 t/ha","before fruit\nthinning"), color="black", angle=c(90,0), fontface=c("plain","italic"))

#after June drop
yield_plot_p3<-ggplot(data = yield_diameter_p3_longer)+
  geom_histogram(mapping = aes(x=value, fill=name), 
                 binwidth = 1, alpha=0.5,
                 position = 'identity')+
  scale_x_continuous(limits = axis_limits_x)+
  theme_bw(base_size = 11)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(legend.position = "inside",
        legend.position.inside = c(0.8,0.9),
        axis.text = element_text(colour = "black"),
        text = element_text(family = "sans", size = 15))+
  xlab("Predicted yield [t/ha]")+
  ylab("Frequency")+
  scale_y_continuous(limits = c(0,500))+
  scale_fill_manual(values = c("#429323","#1E7BE1"),labels = c("high-quality yield", "total yield"))+
  geom_vline(xintercept = 127, color="black", linetype="dotted")+
  annotate(geom="text", x=c(135,108), y=c(250, 60), label=c("Yield > 120 t/ha","after June drop "), color="black", angle=c(90,0), fontface=c("plain","italic"))

#four weeks before harvest
yield_plot_p4<-ggplot(data = yield_diameter_p4_longer)+
  geom_histogram(mapping = aes(x=value, fill=name), 
                 binwidth = 1, alpha=0.5,
                 position = 'identity')+
  scale_x_continuous(limits = axis_limits_x)+
  theme_bw(base_size = 11)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(legend.position = "inside",
        legend.position.inside = c(0.8,0.9),
        axis.text = element_text(colour = "black"),
        text = element_text(family = "sans", size = 15))+
  xlab("Predicted yield [t/ha]")+
  ylab("Frequency")+
  scale_y_continuous(limits = c(0,500))+
  scale_fill_manual(values = c("#429323","#1E7BE1"),labels = c("high-quality yield", "total yield"))+
  geom_vline(xintercept = 127, color="black", linetype="dotted")+
  annotate(geom="text", x=c(135,108), y=c(250, 80), label=c("Yield > 120 t/ha","4 weeks before the\nestimated harvest date"), color="black", angle=c(90,0), fontface=c("plain","italic"))

#read in images showing the time points
img_p3<-readPNG("after_june_drop_p3.png")
img_p1<-readPNG("Flower_Cluster_p1.png")
img_p2<-readPNG("Fruit_Cluster_p2.png")
img_p4<-readPNG("apple_p4.png")
g_p1 <- rasterGrob(img_p1, interpolate=TRUE)
g_p2 <- rasterGrob(img_p2, interpolate=TRUE)
g_p3 <- rasterGrob(img_p3, interpolate=TRUE)
g_p4 <- rasterGrob(img_p4, interpolate=TRUE)

#add images to the plots
a<-yield_plot_p1 +
  annotation_custom(g_p1, xmin=90, xmax=125, ymin=90, ymax=450)

b<-yield_plot_p2 +
  annotation_custom(g_p2, xmin=90, xmax=125, ymin=90, ymax=450)

c<-yield_plot_p3 +
  annotation_custom(g_p3, xmin=90, xmax=125, ymin=90, ymax=450)

d<-yield_plot_p4 +
  annotation_custom(g_p4, xmin=90, xmax=125, ymin=120, ymax=480)

#combine the plots
yield_combined <- list(a+remove_x+remove_y_only_title,
                       b+remove_x+remove_legend+remove_y_only_title,
                       c+remove_x+remove_legend+remove_y_only_title,
                       d+remove_legend+remove_y_only_title)

#wrap plots with the patchwork package
plot_yield_all_tp<-wrap_plots(yield_combined, nrow = 4, ncol = 1) +
  plot_layout(guides = "keep")+
  #labs(tag = "Years with intervention")+
  theme(#plot.tag = element_text(size = 15),
    #plot.tag.position = c(0,-0.05),
    plot.margin = margin(0.2,0,0,0, "cm"))

#extra plot for separate y axis name
plot_y_axis_name <- ggplot(data.frame(l = "Frequency", x = 1, y = 1)) +
  geom_text(aes(x, y, label = l), angle = 90, size=15*0.352777778) + 
  theme_void() +
  coord_cartesian(clip = "off")

#complete and save the combined plot
png("Figures_manuscript/total_and_quality_yield.png", pointsize=10, width=3500, height=5000, res=600)
plot_y_axis_name+plot_yield_all_tp+plot_layout(widths = c(1,25))
dev.off()


#With and without anti-hail netting ####

#select only the return from the simulations
results_tp4_without_hailnet<-apple_quality_and_yield_mc_simulation_tp4_without_hailnet$y
results_tp3_without_hailnet<-apple_quality_and_yield_mc_simulation_tp3_without_hailnet$y
results_tp2_without_hailnet<-apple_quality_and_yield_mc_simulation_tp2_without_hailnet$y
results_tp1_without_hailnet<-apple_quality_and_yield_mc_simulation_tp1_without_hailnet$y

#create subsets of total yield without anti-hail netting
total_yield_diameter_p4_without_hailnet<-results_tp4_without_hailnet$total_yield_diameter
total_yield_diameter_p3_without_hailnet<-results_tp3_without_hailnet$total_yield_diameter
total_yield_diameter_p2_without_hailnet<-results_tp2_without_hailnet$total_yield_diameter
total_yield_diameter_p1_without_hailnet<-results_tp1_without_hailnet$total_yield_diameter

#create subsets of high-quality yield without anti-hail netting
high_quality_yield_diameter_p4_without_hailnet<-results_tp4_without_hailnet$high_quality_yield_diameter
high_quality_yield_diameter_p3_without_hailnet<-results_tp3_without_hailnet$high_quality_yield_diameter
high_quality_yield_diameter_p2_without_hailnet<-results_tp2_without_hailnet$high_quality_yield_diameter
high_quality_yield_diameter_p1_without_hailnet<-results_tp1_without_hailnet$high_quality_yield_diameter

#select the total yield with anti-hail netting and replace values >90 with 95
high_quality_yield_diameter_p4<-results_tp4$high_quality_yield_diameter
high_quality_yield_diameter_p4<-ifelse(high_quality_yield_diameter_p4>90, 95, high_quality_yield_diameter_p4)
high_quality_yield_diameter_p3<-results_tp3$high_quality_yield_diameter
high_quality_yield_diameter_p3<-ifelse(high_quality_yield_diameter_p3>90, 95, high_quality_yield_diameter_p3)
high_quality_yield_diameter_p2<-results_tp2$high_quality_yield_diameter
high_quality_yield_diameter_p2<-ifelse(high_quality_yield_diameter_p2>90, 95, high_quality_yield_diameter_p2)
high_quality_yield_diameter_p1<-results_tp1$high_quality_yield_diameter
high_quality_yield_diameter_p1<-ifelse(high_quality_yield_diameter_p1>90, 95, high_quality_yield_diameter_p1)

#select high-quality yield without anti-hail netting and replace values >90 with 100
high_quality_yield_diameter_p4_without_hailnet<-results_tp4_without_hailnet$high_quality_yield_diameter
high_quality_yield_diameter_p4_without_hailnet<-ifelse(high_quality_yield_diameter_p4_without_hailnet>90, 100, high_quality_yield_diameter_p4_without_hailnet)
high_quality_yield_diameter_p3_without_hailnet<-results_tp3_without_hailnet$high_quality_yield_diameter
high_quality_yield_diameter_p3_without_hailnet<-ifelse(high_quality_yield_diameter_p3_without_hailnet>90, 100, high_quality_yield_diameter_p3_without_hailnet)
high_quality_yield_diameter_p2_without_hailnet<-results_tp2_without_hailnet$high_quality_yield_diameter
high_quality_yield_diameter_p2_without_hailnet<-ifelse(high_quality_yield_diameter_p2_without_hailnet>90, 100, high_quality_yield_diameter_p2_without_hailnet)
high_quality_yield_diameter_p1_without_hailnet<-results_tp1_without_hailnet$high_quality_yield_diameter
high_quality_yield_diameter_p1_without_hailnet<-ifelse(high_quality_yield_diameter_p1_without_hailnet>90, 100, high_quality_yield_diameter_p1_without_hailnet)

#create data frames for high-quality yield
yield_diameter_p4_with_without_hailnet<-data.frame(high_quality_yield_diameter_p4,
                                           high_quality_yield_diameter_p4_without_hailnet)
yield_diameter_p3_with_without_hailnet<-data.frame(high_quality_yield_diameter_p3,
                                           high_quality_yield_diameter_p3_without_hailnet)
yield_diameter_p2_with_without_hailnet<-data.frame(high_quality_yield_diameter_p2,
                                           high_quality_yield_diameter_p2_without_hailnet)
yield_diameter_p1_with_without_hailnet<-data.frame(high_quality_yield_diameter_p1,
                                           high_quality_yield_diameter_p1_without_hailnet)

#restructure data frames
yield_diameter_p4_with_without_hailnet_longer<-pivot_longer(yield_diameter_p4_with_without_hailnet, cols = c(high_quality_yield_diameter_p4,
                                                                                             high_quality_yield_diameter_p4_without_hailnet))
yield_diameter_p3_with_without_hailnet_longer<-pivot_longer(yield_diameter_p3_with_without_hailnet, cols = c(high_quality_yield_diameter_p3,
                                                                                             high_quality_yield_diameter_p3_without_hailnet))
yield_diameter_p2_with_without_hailnet_longer<-pivot_longer(yield_diameter_p2_with_without_hailnet, cols = c(high_quality_yield_diameter_p2,
                                                                                             high_quality_yield_diameter_p2_without_hailnet))
yield_diameter_p1_with_without_hailnet_longer<-pivot_longer(yield_diameter_p1_with_without_hailnet, cols = c(high_quality_yield_diameter_p1,
                                                                                             high_quality_yield_diameter_p1_without_hailnet))

#check the maximum height of a bar in the histogram
all_for_min_max_with_without_hailnet<-rbind(yield_diameter_p1_with_without_hailnet_longer,
                                    yield_diameter_p2_with_without_hailnet_longer,
                                    yield_diameter_p3_with_without_hailnet_longer,
                                    yield_diameter_p4_with_without_hailnet_longer)
floor(min(all_for_min_max_with_without_hailnet$value))
ceiling(max(all_for_min_max_with_without_hailnet$value))

#define x axis limits
axis_limits_x_with_without_hailnet<-c((-1),
                              ceiling(max(all_for_min_max_with_without_hailnet$value)))

#creat plots 

#four weeks before harvest
yield_plot_p4_with_without_hailnet<-ggplot(data = yield_diameter_p4_with_without_hailnet_longer)+
  geom_histogram(mapping = aes(x=value, fill=name), 
                 binwidth = 1, alpha=0.5,
                 position = 'identity')+
  scale_x_continuous(limits = axis_limits_x_with_without_hailnet)+
  theme_bw(base_size = 11)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(legend.position = "inside",
        legend.position.inside = c(0.8,0.9),
        axis.text = element_text(colour = "black"),
        text = element_text(family = "sans", size = 15))+
  xlab("High-quality yield [t/ha]")+
  ylab("Frequency")+
  scale_y_continuous(limits = c(0,500))+
  scale_fill_manual(values = c("#429323","#B10BC3"),labels = c("with anti-hail net", "without anti-hail net"))+
  geom_vline(xintercept = 92, color="black", linetype="dotted")+
  annotate(geom="text", x=c(98,73), y=c(200, 125), label=c("Yield > 90 t/ha","4 weeks before the\nestimated harvest date"), color="black", angle=c(90,0), fontface=c("plain","italic"))

#after June drop
yield_plot_p3_with_without_hailnet<-ggplot(data = yield_diameter_p3_with_without_hailnet_longer)+
  geom_histogram(mapping = aes(x=value, fill=name), 
                 binwidth = 1, alpha=0.5,
                 position = 'identity')+
  scale_x_continuous(limits = axis_limits_x_with_without_hailnet)+
  theme_bw(base_size = 11)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(legend.position = "inside",
        legend.position.inside = c(0.8,0.9),
        axis.text = element_text(colour = "black"),
        text = element_text(family = "sans", size = 15))+
  xlab("High-quality yield [t/ha]")+
  ylab("Frequency")+
  scale_y_continuous(limits = c(0,500))+
  scale_fill_manual(values = c("#429323","#B10BC3"),labels = c("with anti-hail net", "without anti-hail net"))+
  geom_vline(xintercept = 92, color="black", linetype="dotted")+
  annotate(geom="text", x=c(98,70), y=c(200, 125), label=c("Yield > 90 t/ha","after June drop"), color="black", angle=c(90,0), fontface=c("plain","italic"))

#before fruit thinning
yield_plot_p2_with_without_hailnet<-ggplot(data = yield_diameter_p2_with_without_hailnet_longer)+
  geom_histogram(mapping = aes(x=value, fill=name), 
                 binwidth = 1, alpha=0.5,
                 position = 'identity')+
  scale_x_continuous(limits = axis_limits_x_with_without_hailnet)+
  theme_bw(base_size = 11)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(legend.position = "inside",
        legend.position.inside = c(0.8,0.9),
        axis.text = element_text(colour = "black"),
        text = element_text(family = "sans", size = 15))+
  xlab("High-quality yield [t/ha]")+
  ylab("Frequency")+
  scale_y_continuous(limits = c(0,500))+
  scale_fill_manual(values = c("#429323","#B10BC3"),labels = c("with anti-hail net", "without anti-hail net"))+
  geom_vline(xintercept = 92, color="black", linetype="dotted")+
  annotate(geom="text", x=c(98,70), y=c(200, 125), label=c("Yield > 90 t/ha","before fruit\nthinning"), color="black", angle=c(90,0), fontface=c("plain","italic"))

#full bloom
yield_plot_p1_with_without_hailnet<-ggplot(data = yield_diameter_p1_with_without_hailnet_longer)+
  geom_histogram(mapping = aes(x=value, fill=name), 
                 binwidth = 1, alpha=0.5,
                 position = 'identity')+
  scale_x_continuous(limits = axis_limits_x_with_without_hailnet)+
  theme_bw(base_size = 11)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(legend.position = "inside",
        legend.position.inside = c(0.2,0.825),
        axis.text = element_text(colour = "black"),
        text = element_text(family = "sans", size = 15))+
  xlab("High-quality yield [t/ha]")+
  ylab("Frequency")+
  scale_y_continuous(limits = c(0,500))+
  scale_fill_manual(values = c("#429323","#B10BC3"),labels = c("with anti-hail net", "without anti-hail net"))+
  theme(legend.title=element_blank())+
  geom_vline(xintercept = 92, color="black", linetype="dotted")+
  annotate(geom="text", x=c(98,70), y=c(200, 125), label=c("Yield > 90 t/ha","at full bloom"), color="black", angle=c(90,0), fontface=c("plain","italic"))


#add images to the plots
a1<-yield_plot_p1_with_without_hailnet +
  annotation_custom(g_p1, xmin=60, xmax=80, ymin=170, ymax=500)

b1<-yield_plot_p2_with_without_hailnet +
  annotation_custom(g_p2, xmin=55, xmax=85, ymin=170, ymax=500)

c1<-yield_plot_p3_with_without_hailnet +
  annotation_custom(g_p3, xmin=60, xmax=80, ymin=170, ymax=500)

d1<-yield_plot_p4_with_without_hailnet +
  annotation_custom(g_p4, xmin=60, xmax=80, ymin=170, ymax=500)

#combine plots
yield_combined_with_without_hailnet <- list(a1+remove_x+remove_y_only_title,
                                    b1+remove_x+remove_legend+remove_y_only_title,
                                    c1+remove_x+remove_legend+remove_y_only_title,
                                    d1+remove_legend+remove_y_only_title)

#wrap the plots with the patchwork package
plot_yield_all_tp_with_without_hailnet<-wrap_plots(yield_combined_with_without_hailnet, nrow = 4, ncol = 1) +
  plot_layout(guides = "keep")+
  #labs(tag = "Years with intervention")+
  theme(#plot.tag = element_text(size = 15),
    #plot.tag.position = c(0,-0.05),
    plot.margin = margin(0.2,0,0,0, "cm"))

#extra plot for separate y axis name
plot_y_axis_name <- ggplot(data.frame(l = "Frequency", x = 1, y = 1)) +
  geom_text(aes(x, y, label = l), angle = 90, size=15*0.352777778) + 
  theme_void() +
  coord_cartesian(clip = "off")

#complete and save the combined plot
png("Figures_manuscript/with_without_hailnet.png", pointsize=10, width=3500, height=5000, res=600)
plot_y_axis_name+plot_yield_all_tp_with_without_hailnet+plot_layout(widths = c(1,25))
dev.off()

