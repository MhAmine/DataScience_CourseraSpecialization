Course Project applied machine learning
================

Required libraries: library(caret), library(xgboost) and register multicore support with library(doMC) and register...

First step is reading the training and testing set.

I do not split the data into a train and cross validation set, since the xgboost algorithm, which I will use, has a built in cross validation function.

Next, Remove columns that have empty factor, NULL or NA to have a dense dataset and remove columns with little information.

Next, I convert names into numbers. This is necessary for xgboost, since it can deal only with numeric data. I also delete all the nun-numeric columns such as timestamp, new window etc...

Train xgboost model, first do cross validation and then feed best parameters into model for prediction.

    ## [1]  train-merror:0.185723+0.009116  test-merror:0.193964+0.009720 
    ## [2]  train-merror:0.079490+0.003996  test-merror:0.090715+0.006173 
    ## [3]  train-merror:0.035394+0.007894  test-merror:0.045253+0.008088 
    ## [4]  train-merror:0.015034+0.002523  test-merror:0.023289+0.004486 
    ## [5]  train-merror:0.006918+0.000717  test-merror:0.013403+0.002538 
    ## [6]  train-merror:0.004001+0.000891  test-merror:0.008714+0.001846 
    ## [7]  train-merror:0.002586+0.000567  test-merror:0.007033+0.001436 
    ## [8]  train-merror:0.001248+0.000420  test-merror:0.004841+0.001395 
    ## [9]  train-merror:0.000637+0.000176  test-merror:0.003363+0.001303 
    ## [10] train-merror:0.000319+0.000146  test-merror:0.002497+0.001085 
    ## [11] train-merror:0.000153+0.000087  test-merror:0.002089+0.000796 
    ## [12] train-merror:0.000064+0.000057  test-merror:0.001733+0.000828 
    ## [13] train-merror:0.000038+0.000031  test-merror:0.001478+0.000589 
    ## [14] train-merror:0.000026+0.000031  test-merror:0.001172+0.000473 
    ## [15] train-merror:0.000000+0.000000  test-merror:0.000968+0.000374 
    ## [16] train-merror:0.000000+0.000000  test-merror:0.000815+0.000338 
    ## [17] train-merror:0.000000+0.000000  test-merror:0.000815+0.000494 
    ## [18] train-merror:0.000000+0.000000  test-merror:0.000612+0.000346 
    ## [19] train-merror:0.000000+0.000000  test-merror:0.000561+0.000297 
    ## [20] train-merror:0.000000+0.000000  test-merror:0.000561+0.000297

I stop the iteration after 20 rounds, because the test error for a 5-fold cross validation does not improve any more. The parameters used for xgboost are

-   num\_class = 5, nthread = 4, nfold = 5, nround = 20, max\_depth = 5, eta = 1
-   params &lt;- list(objective = "multi:softprob", num\_class = num\_class, max\_depth = max\_depth, eta = eta )

Establish model for prediction with these parameters

    ## [1]  train-merror:0.191061 
    ## [2]  train-merror:0.085771 
    ## [3]  train-merror:0.037509 
    ## [4]  train-merror:0.021659 
    ## [5]  train-merror:0.011874 
    ## [6]  train-merror:0.006370 
    ## [7]  train-merror:0.002854 
    ## [8]  train-merror:0.001835 
    ## [9]  train-merror:0.000815 
    ## [10] train-merror:0.000561 
    ## [11] train-merror:0.000306 
    ## [12] train-merror:0.000204 
    ## [13] train-merror:0.000051 
    ## [14] train-merror:0.000000 
    ## [15] train-merror:0.000000 
    ## [16] train-merror:0.000000 
    ## [17] train-merror:0.000000 
    ## [18] train-merror:0.000000 
    ## [19] train-merror:0.000000 
    ## [20] train-merror:0.000000

    ##  [1] 1 0 1 0 0 4 3 1 0 0 1 2 1 0 4 4 0 1 1 1

These are the predictions on the test set. The equivalences are: A=0, B=1 etc....The accuracy on the test set is 100%.
