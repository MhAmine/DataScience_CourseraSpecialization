Course Project applied machine learning
================

Required libraries: library(caret), library(xgboost) and register multicore support with library(doMC) and register...

First step is reading the training and testing set.

I do not split the data into a train and cross validation set, since the xgboost algorithm, which I will use, has a built in cross validation function.

Next, Remove columns that have empty factor, NULL or NA to have a dense dataset and remove columns with little information.

Next, I convert names into numbers. This is necessary for xgboost, since it can deal only with numeric data. I also delete all the nun-numeric columns such as timestamp, new window etc...

Train xgboost model, first do cross validation and then feed best parameters into model for prediction.

    ## [1]  train-merror:0.189112+0.004398  test-merror:0.191824+0.011920 
    ## [2]  train-merror:0.079847+0.011519  test-merror:0.087555+0.007895 
    ## [3]  train-merror:0.035139+0.005650  test-merror:0.040617+0.006561 
    ## [4]  train-merror:0.016156+0.003121  test-merror:0.023544+0.006754 
    ## [5]  train-merror:0.009263+0.002843  test-merror:0.014523+0.005793 
    ## [6]  train-merror:0.004485+0.001402  test-merror:0.009937+0.003000 
    ## [7]  train-merror:0.002446+0.000882  test-merror:0.006880+0.001926 
    ## [8]  train-merror:0.001211+0.000317  test-merror:0.004841+0.001395 
    ## [9]  train-merror:0.000624+0.000265  test-merror:0.003465+0.001075 
    ## [10] train-merror:0.000191+0.000114  test-merror:0.002395+0.001039 
    ## [11] train-merror:0.000102+0.000065  test-merror:0.002293+0.000773 
    ## [12] train-merror:0.000077+0.000062  test-merror:0.001580+0.000812 
    ## [13] train-merror:0.000013+0.000026  test-merror:0.001121+0.000676 
    ## [14] train-merror:0.000000+0.000000  test-merror:0.000968+0.000710 
    ## [15] train-merror:0.000000+0.000000  test-merror:0.001020+0.000645 
    ## [16] train-merror:0.000000+0.000000  test-merror:0.000816+0.000672 
    ## [17] train-merror:0.000000+0.000000  test-merror:0.000867+0.000676 
    ## [18] train-merror:0.000000+0.000000  test-merror:0.000867+0.000676 
    ## [19] train-merror:0.000000+0.000000  test-merror:0.000816+0.000691 
    ## [20] train-merror:0.000000+0.000000  test-merror:0.000765+0.000684

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

The equivalences are: A=0, B=1 etc....
