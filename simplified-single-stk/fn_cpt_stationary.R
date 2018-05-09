fn_cpt_stationary = function(stk_price_seq, stk_name, test_dir, NoData){
      
  # revised by Nathaniel Wei
  # email: w.nathaniel.s@gmail.com
      
      j=NoData 
      i=1
      Start=i
      Count=1
      repeat {
        Price=stk_price_seq[i:j]
        Count=Count+1
        i=i+1
        j=j+1
        if (j==length(stk_price_seq)) {
          break 
        } 
      }
      M= Count
      result=c()
      if (NoData <= 100){
        CV=-3.45
      } else if (100<NoData & NoData<=250){
        CV=-3.43
      } else if (250<NoData &NoData<=500){
        CV=-3.42
      }else if (NoData>500){
        CV=-3.41
      }
      # Stationay test 
      for(k in Start:M){
        j=NoData-1+k 
        if((j+NoData)>length(stk_price_seq))
        {break}  
        else{
          Price=stk_price_seq[k:j]
          Skip=0
          for (l in 1:NROW(Price)){
            if (is.na(Price[l])==TRUE){
              Skip=Skip+1 } 
          }
          if (Skip>=1){
            next
          } 
          else if (Skip==0) {
            H=adf.test(Price)
            if (H$statistic>CV) {
              next
            }  
          }
          result[length(result)+1] = k
          if (length(result)==10){
            break
          }
        }
      }
      if (is.null(result)){
        result=0
      }
      write.csv(result,paste0(test_dir, stk_name, ".csv"))
  
}
