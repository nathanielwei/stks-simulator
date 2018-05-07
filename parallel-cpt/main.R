# Author: Nathaniel Zikai Wei
# email:w.nathaniel.s@gmail.com


##########################################
############  Priliminary   ##############
##########################################

First_time = FALSE

# The 1st time ussage, use TRUE
if(First_time){
  install.packages("TTR")
  install.packages("xts")
  install.packages("zoo")
  install.packages("quantmod")
  install.packages("PerformanceAnalytics")
  install.packages("stringr")
  install.packages("pracma")
  install.packages("parallel")
  install.packages("Sim.DiffProc")
  install.packages("rms")
  install.packages("tseries")
  install.packages("here")
}


library("Sim.DiffProc")
library("rms")
library("stringr")
library("tseries")
library("here")
library("parallel")


# singlefiles put in the folder, 'Data'
# Set main_dir and stks_dir
# main_dir is the location of your main.R
# For instance: main_dir = "C:/Users/Nathaniel/Desktop/parallel_computing/Task3/multi-stks-master/"
# All stock files should be in ./Data
main_dir = paste0(here(),"/")
main_dir = "C:/Users/Nathaniel/Desktop/parallel_computing/Task3/multiprocess/multiprocess/"
stks_dir = paste0(main_dir, "Data/")
save_dir = paste0(main_dir, "Results/")
test_dir = paste0(main_dir, "TestStationary/")
parameter_dir = paste0(main_dir, "Parameter/")
simprice_dir = paste0(main_dir, "Simprice/")
parameter_MRP_dir = paste0(main_dir, "Parameter_MRP/")
pdf_dir = paste0(main_dir, "PDF/")




# Make dir first time
if(First_time){
  dir.create(save_dir)
  dir.create(test_dir)
  dir.create(parameter_dir)
  dir.create(simprice_dir)
  dir.create(parameter_MRP_dir)
  dir.create(pdf_dir)
}





# paste(main_dir, "Data/", sep = "", collapse = "")
Files = list.files(path = stks_dir)
Len_Files = length(Files)





##########################################
#############   Uni-core    ##############
##########################################

# timer start ####
ptm1 <- proc.time()
##################

lapply(1:Len_Files, function(stk_i){
  
  
  library("Sim.DiffProc")
  library("rms")
  library("stringr")
  library("tseries")
  library("here")
  library("parallel")
  source("fn_cpt_stationary.r")
  source("fun_cpt_main.r")
  
  
  main_dir = "C:/Users/Nathaniel/Desktop/parallel_computing/Task3/multiprocess/multiprocess/"
  stks_dir = paste0(main_dir, "Data/")
  save_dir = paste0(main_dir, "Results/")
  test_dir = paste0(main_dir, "TestStationary/")
  parameter_dir = paste0(main_dir, "Parameter/")
  simprice_dir = paste0(main_dir, "Simprice/")
  parameter_MRP_dir = paste0(main_dir, "Parameter_MRP/")
  pdf_dir = paste0(main_dir, "PDF/")
  
  Files = list.files(path = stks_dir)
  stk_name = str_sub(Files[stk_i], 1, 7)
  stk_file_name = paste0(stks_dir, stk_name, ".csv")
  #paste(stks_dir, stk_name, ".csv", sep = "", collapse = "")
  stk = read.csv(stk_file_name, header=TRUE)
  
  print(stk_i)
  print(stk_name)
  
  fun_cpt_main(stk, stk_name, save_dir, test_dir, parameter_dir, simprice_dir, parameter_MRP_dir, pdf_dir)
  
}

)
###########
# timer end
uni_core_time <- proc.time() - ptm1
print(uni_core_time)
write.csv(list(uni_core_time[1],uni_core_time[2],uni_core_time[3]), paste0(main_dir, "uni_core_time.csv"))
###########







##########################################
#############   Multi-core  ##############
##########################################

##################
# Calculate the number of cores (minus 1)
no_core <- detectCores()

# Initialize cluster
cluster <- makeCluster(no_core)
# socket cluster with 8 nodes on host 'localhost'


# timer start ####
ptm2 <- proc.time()

# parLapply part
parLapply(cluster, 1:Len_Files, function(stk_i){
  
  
  library("Sim.DiffProc")
  library("rms")
  library("stringr")
  library("tseries")
  library("here")
  library("parallel")
  source("fn_cpt_stationary.r")
  source("fun_cpt_main.r")
  
  
  main_dir = "C:/Users/Nathaniel/Desktop/parallel_computing/Task3/multiprocess/multiprocess/"
  stks_dir = paste0(main_dir, "Data/")
  save_dir = paste0(main_dir, "Results/")
  test_dir = paste0(main_dir, "TestStationary/")
  parameter_dir = paste0(main_dir, "Parameter/")
  simprice_dir = paste0(main_dir, "Simprice/")
  parameter_MRP_dir = paste0(main_dir, "Parameter_MRP/")
  pdf_dir = paste0(main_dir, "PDF/")
  
  Files = list.files(path = stks_dir)
  stk_name = str_sub(Files[stk_i], 1, 7)
  stk_file_name = paste0(stks_dir, stk_name, ".csv")
  #paste(stks_dir, stk_name, ".csv", sep = "", collapse = "")
  stk = read.csv(stk_file_name, header=TRUE)
  
  print(stk_i)
  print(stk_name)
  
  fun_cpt_main(stk, stk_name, save_dir, test_dir, parameter_dir, simprice_dir, parameter_MRP_dir, pdf_dir)
  
}

)
###########
# timer end
multi_core_time <- proc.time() - ptm2
print(multi_core_time)
write.csv(list(multi_core_time[1],multi_core_time[2],multi_core_time[3]), paste0(main_dir, "multi_core_time.csv"))

###########
