
source("jimmy/pixel_circle.R")
source("jimmy/plotting.R")
source("jimmy/scan_patterns.R")



# plotting figures for three circles, radius 5, 0 angles

load(paste("true_theta/three_circles_rad",5,".RData",sep=""))

load(paste("em_results/three_circles/three_circles_radius",5,"_numangles", 1,"_N", 8 ,".RData",sep=""))

plot_matrix(true_theta)

plot_matrix(em_res$theta_est)

abs_diff_mat <- abs(em_res$theta_est - true_theta)

plot_matrix(abs_diff_mat)



# plotting figures for three circles, radius 5, 2 angles

load(paste("true_theta/three_circles_rad",5,".RData",sep=""))

load(paste("em_results/three_circles/three_circles_radius",5,"_numangles", 2,"_N", 10 ,".RData",sep=""))

plot_matrix(true_theta)

plot_matrix(em_res$theta_est)

abs_diff_mat <- abs(em_res$theta_est - true_theta)

plot_matrix(abs_diff_mat)



# plotting figures for three circles, radius 5, 6 angles

load(paste("true_theta/three_circles_rad",5,".RData",sep=""))

load(paste("em_results/three_circles/three_circles_radius",5,"_numangles", 3,"_N", 7 ,".RData",sep=""))

plot_matrix(true_theta)

plot_matrix(em_res$theta_est)

abs_diff_mat <- abs(em_res$theta_est - true_theta)

plot_matrix(abs_diff_mat)



##################

# plotting figures for three circles, radius 10, 6 angles

load(paste("true_theta/three_circles_rad",10,".RData",sep=""))

load(paste("em_results/three_circles/three_circles_radius",10,"_numangles", 3,"_N", 7 ,".RData",sep=""))

plot_matrix(true_theta)

plot_matrix(em_res$theta_est)

abs_diff_mat <- abs(em_res$theta_est - true_theta)

plot_matrix(abs_diff_mat)





load("three_circles_results.RData")

#Output is a mulit-dimensional array
#Dim 1: Radius. Length=3 for radius=c(3,5,10)
#Dim 2: Angles Length=3 for angles: none, 45 deg and all three
#Dim 3: Metrics. Length=3 for metric = c('RMSE', 'Spectral', 'Iterations')
#Dim 4: Monte Carlo N. length=N=10
#Thus, we willl have an 3x5x3x10 array (=450 data points)

names.angles = c("none", "deg45", "deg.all")
names.radius = c("rad3", "rad5", "rad10")

names.list = list(names.angles, names.radius)



rmse_mean_mat <- matrix(NA, nrow = 3, ncol = 3, dimnames = names.list)

spec_mean_mat <- matrix(NA, nrow = 3, ncol = 3, dimnames = names.list)

iter_mean_mat <- matrix(NA, nrow = 3, ncol = 3, dimnames = names.list)

rmse_sd_mat <- matrix(NA, nrow = 3, ncol = 3, dimnames = names.list)

spec_sd_mat <- matrix(NA, nrow = 3, ncol = 3, dimnames = names.list)

iter_sd_mat <- matrix(NA, nrow = 3, ncol = 3, dimnames = names.list)

# iterate over angles
for(b in 1:3){

  # iterate over radii
  for(a in 1:3){
    
    rmse_mean_mat[b, a] <- mean(three_circles_results[a, b, 1, ])
    spec_mean_mat[b, a] <- mean(three_circles_results[a, b, 2, ])
    iter_mean_mat[b, a] <- mean(three_circles_results[a, b, 3, ])
    rmse_sd_mat[b, a] <- sd(three_circles_results[a, b, 1, ])
    spec_sd_mat[b, a] <- sd(three_circles_results[a, b, 2, ])
    iter_sd_mat[b, a] <- sd(three_circles_results[a, b, 3, ])
    
  }
  
}

round(rmse_mean_mat, digits = 2)

round(rmse_sd_mat, digits = 2)



