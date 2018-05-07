# Single stock case
In folder [tutorial-single-stk][single-folder], the intial files are:  
* [hk-share-cpt.R][hk-share-cpt]
  * A main file --- only need to run this file and keep [fn_cpt_stationary.R][cpt-fun] and 
    Folder [Data][data-folder] in the same path
  * If one is first time to run this file: set **<span style="color:blue">First-Time</span> = <span style="color:red">TRUE</span>**
  * Double check the variable **main_dir** 
    * If < main_dir = paste0(here(),"/") > does not represent the path as where your main file is, set it as
      * main_dir = "C:/Users/Nathaniel/Desktop/parallel_computing/Task3/tutorial-single-stk/"
* [fn_cpt_stationary.R][cpt-fun]
* Folder [Data][data-folder], inside which is [HK00008.csv][data-file]
   * Please check the data format in [HK00008.csv][data-file]
   * Use the same form once one may use anotherinstrument
   * Keep the 2 columns to be **Data** (d/m/y) and **Price**
   * The date format is very important

# Brief guidelines
1. Make a clone, then have a folder [tutorial-single-stk][single-folder]
2. Only keep [hk-share-cpt.R][hk-share-cpt], [fn_cpt_stationary.R][cpt-fun], and folder [Data][data-folder] left
3. Set **First_Time = TRUE** in [hk-share-cpt.R][hk-share-cpt] for first run; otherwise, set it *FALSE*
4. Set main_dir to be the path of folder [tutorial-single-stk][single-folder]  
   with steps 1-4, one can repeat the work already
5. Change the data in [Data][data-folder] if needed
   * keep only one data file in [Data][data-folder]
   * once change another instrument, please keep the same data format in the ".csv" as the example [HK00008.csv][data-file]


[single-folder]: https://github.com/nathanielwei/stks-simulator/tree/master/tutorial-single-stk
[hk-share-cpt]: https://github.com/nathanielwei/stks-simulator/blob/master/tutorial-single-stk/hk-share-cpt.R
[cpt-fun]: https://github.com/nathanielwei/stks-simulator/blob/master/tutorial-single-stk/fn_cpt_stationary.R
[data-folder]: https://github.com/nathanielwei/stks-simulator/tree/master/tutorial-single-stk/Data
[data-file]: https://github.com/nathanielwei/stks-simulator/blob/master/tutorial-single-stk/Data/HK00008.csv