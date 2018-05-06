# Author: Nathaniel Zikai Wei
# email:w.nathaniel.s@gmail.com
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

source("fn_cpt_stationary.r")


Days=c(60,120,240,360,480) 



# singlefiles put in the folder, 'Data'
# Set main_dir and stks_dir 
# main_dir is the location of your main.R
# For instance: main_dir = "C:/Users/Nathaniel/Desktop/parallel_computing/Task3/multi-stks-master/"
# All stock files should be in ./Data

main_dir = paste0(here(),"/")
main_dir = "C:/Users/Nathaniel/Desktop/parallel_computing/Task3/multi-stks-master/"
# put only file stk file in this dir <stks_dir>
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

for (stk_i in c(1:Len_Files)){
  print(stk_i)
  stk_name = str_sub(Files[stk_i], 1, 7) 
  stk_file_name = paste0(stks_dir, stk_name, ".csv")
  #paste(stks_dir, stk_name, ".csv", sep = "", collapse = "")
  stk = read.csv(stk_file_name, header=TRUE)
  
  stk_date = stk[,1]
  stk_price_seq = stk[,2]
  
  
  
  for(NoData in Days ){  
    # Simulate how many days? 
    # The half of total <Days>
    SimNo=NoData/2
    
    fn_cpt_stationary(stk_price_seq, stk_name, test_dir, NoData)
    Stationary=read.csv(paste0(test_dir,stk_name,".csv"))
    i = Stationary[1,2] 
    if (i == 0){
      next
    }
    
    
    j=NoData-1+i #j=NumOfRealPrice-1+i
    
    Date1=as.Date(stk_date[i:j],"%d/%m/%Y")
    Date2=as.Date(stk_date[(j-1):(j+SimNo-1)],"%d/%m/%Y") 
    Price1=stk_price_seq[i:j]
    Price2=stk_price_seq[(j-1):(j+SimNo-1)]
    dP=diff(Price1)
    dt=1 #dt=1/n, if daily price, n=1. if weekly, n=50.
    Z=Price1[-length(Price1)]
    data=lm(dP~Z)
    SpeedOfMRP=-coef(data)[2]/dt
    coeff=coef(lm(dP~Z))[1]
    LongRunMean=(coeff/SpeedOfMRP)/dt
    Res= sqrt(deviance(data)/df.residual(data))
    Error=dP-Res
    Vol=sd(Error)*sqrt(dt)
    result=c(SpeedOfMRP,LongRunMean,Vol)
    
    parameter_stk_dir = paste0(parameter_dir, "Parameter_",stk_name, ".csv")
    
    write.csv(result,row.names = c("Speed Of MRP","Long Run Mean","Volatility"),
              parameter_stk_dir)
    #Plot the simulated path
    
    Parameter=read.csv(parameter_stk_dir,header=TRUE)
    S=Parameter$x[1]
    LM=Parameter$x[2]
    V=Parameter$x[3]
    if (S<0){
      next
    }
    #Simulate 300 paths, with 1000 steps of simulation.
    Test=HWV(N = 10^3, M=300, T = SimNo , mu= S,theta = LM,sigma = V,x0 =Price2[1]) #T=R, x0=Price2[l]
    
    
    file_simprice = paste0(simprice_dir,"SimPrice_",stk_name,"_",i,".csv")
    write.csv(Test[1:SimNo,], file_simprice) 
    
    
    
    HWVSim=read.csv(file_simprice,header=TRUE)
    HWVSim=HWVSim[,-1]
    estmean=rowSums(HWVSim)/(300-1) 
    esterr=sqrt((rowSums((HWVSim-estmean)^2))/(300-1)) 
    Su=estmean+2*esterr
    Su=append(Price2[1], Su)
    Sd=estmean-2*esterr 
    Sd=append(Price2[1], Sd)
    estmean=append(Price2[1],estmean)
    j2=j+SimNo-1
    #For plotting MRP parameter
    M=NoData
    j3=M+i-1  
    Price3=stk_price_seq[i:j3]
    dP=diff(Price3)
    dt=1 
    Z=Price3[-length(Price3)]
    data=lm(dP~Z)
    SpeedOfMRP=-coef(data)[2]/dt
    coeff=coef(lm(dP~Z))[1]
    LongRunMean=(coeff/SpeedOfMRP)/dt
    Res= sqrt(deviance(data)/df.residual(data))
    Error=dP-Res
    Vol=sd(Error)*sqrt(dt)
    result=c(SpeedOfMRP,LongRunMean,Vol)
    parameter_MRP_file = paste0(parameter_MRP_dir,"Parameter_MRP_",stk_name,'.csv')
    write.csv(result,row.names = c("Speed Of MRP","Long Run Mean","Volatility"),
              parameter_MRP_file)
    
    
    
    i=i+1
    j3=j3+1
    repeat {
      Price3=stk_price_seq[i:j3]
      STOCKHK =read.csv(parameter_MRP_file,header=TRUE)
      dP=diff(Price3)
      dt=1/1 
      Z=Price3[-length(Price3)]
      data=lm(dP~Z)
      SpeedOfMRP=-coef(data)[2]/dt
      coeff=coef(lm(dP~Z))[1]
      LongRunMean=(coeff/SpeedOfMRP)/dt
      Res= sqrt(deviance(data)/df.residual(data))
      Error=dP-Res
      Vol=sd(Error)*sqrt(dt)
      if (SpeedOfMRP < 0){
        break
      }  else if (LongRunMean > max(stk_price_seq)){
        break
      } else if (LongRunMean < min(stk_price_seq)){
        break
      } else {
        result=c(SpeedOfMRP,LongRunMean,Vol)
        STOCKHK =cbind(STOCKHK ,result) 
        STOCKHK[,1]=NULL
        write.csv(STOCKHK,parameter_MRP_file)
        i=i+1
        j3=j3+1
        if (j3==j2) {
          break 
        }
      }
    }
    if (j3!=j2){
      next
    } else{
      STOCK1=read.csv(parameter_MRP_file,header=TRUE)
      STOCK1=STOCK1[,-1]
      rownames(STOCK1) = c("Speed Of MRP","Long Run Mean","Volatility")
      colnames(STOCK1)=1:length(STOCK1[1,])
      
      para3_file= paste0(parameter_MRP_dir,"Parameter3_", stk_name,'.csv')
      write.csv(STOCK1,para3_file)
      STOCK2 =read.csv(para3_file,header=TRUE)
      STOCK2=t(STOCK2)
      STOCK2=STOCK2[-1,]
      Speed=STOCK2[,1]
      
      speed_file= paste0(parameter_MRP_dir,"Speed_", stk_name,'.csv')
      write.csv(Speed, speed_file)
      HKVol=STOCK2[,3]
      volatility_file = paste0(parameter_MRP_dir,'Volatility_',stk_name,'.csv')
      write.csv(HKVol,volatility_file)
      HKLM=STOCK2[,2]
      
      longrunmean_file = paste0(parameter_MRP_dir,'LongRunMean_',stk_name,'.csv')
      write.csv(HKLM,longrunmean_file)
      graph_file = paste0(pdf_dir, "Graph_",stk_name,"_NoData",NoData,"_sim",SimNo,".pdf")
      pdf(graph_file, width = 15, height = 10)
      
      
      #Set margin size of the graph and plot 4 graph
      par(mar=c(5,4,1,6),mfrow = c(2,2))
      x1=range(as.Date(stk_date[i:j2],"%d/%m/%Y"))
      y1=range(Sd,Su,stk_price_seq[i:j2])
      fig_1_title = paste0(stk_name," ",NoData," data points sim ",SimNo," data points")
      plot(x1,y1, type="n",main=fig_1_title,xlab="Date", ylab="stk_price_seq Price",lwd=1.5,cex.main=1)
      lines(Price1~Date1, type="l",lwd=2)
      lines(Price2~Date2, type="l",lwd=2, col="orange")
      lines(Su~Date2, type="l",lwd=2, col="red")
      lines(Sd~Date2, type="l",lwd=2, col="red")
      lines(estmean~Date2, type="l", lwd=2, col="blue")
      for (k in c("Speed_", "Volatility_", "LongRunMean_")){
        Test=read.csv(paste0(parameter_MRP_dir,k,stk_name,'.csv'),header=TRUE)
        Test=Test[,-1]
        x=range(1:length(Test))
        y=range(Test)
        #sets the x and y axes scales
        plot(x,y, type="n", ylab=k)
        x=1:length(Test)
        y=Test
        lines(x,y, type="l", lwd=1.5)
        # add a title and subtitle 
        title(k, paste0("In every ",NoData," trading days"))
      }
      dev.off()
    }
  }
  
}
