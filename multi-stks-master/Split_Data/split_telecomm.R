library(here)
library(stringr)

here()
main_dir = paste0(here(),"/") # set the pwd where "split_telecomm.R" is
main_dir = "C:/Users/Nathaniel/Desktop/parallel_computing/Task3/multi-stks-master/Split_Data/"

file = paste0(main_dir,"Telecommunication ","20110103-20170127.csv")
StockPrice=read.csv(file, header=TRUE)




for ( N in c(1:22)){
  i = 2*N-1
  j = 2*N
  
  
  # prepare regular expression
  
  col_name_str = colnames(StockPrice[j])
  
  regexp <- "[[:digit:]]+"
  
  # process string
  str_extract(col_name_str, regexp)
  stk_idx = str_extract(col_name_str, regexp)
  
  n_idx = nchar(stk_idx)
  if ( n_idx == 4) {
    stkname = paste0("HK0", stk_idx)
  } else if ( n_idx == 3) {
    stkname = paste0("HK00", stk_idx)
  } else if ( n_idx == 2) {
    stkname = paste0("HK000", stk_idx)
  } else {
    stkname = paste0("HK0000", stk_idx)
  }
  print(stkname)
  csvfile = paste0(main_dir, stkname, '.csv')
  reconstruct = data.frame(StockPrice$Date, StockPrice[,j], row.names = NULL) 
  write.csv(reconstruct, csvfile, row.names=FALSE) 
}