Course Project applied machine learning
================

Required libraries: library(caret), library(xgboost) and register multicore support with library(doMC) and register...

First step is reading the training and testing set.

I do not split the data into a train and cross validation set, since the xgboost algorithm, which I will use, has a built in cross validation function.

Next, Remove columns that have empty factor, NULL or NA to have a dense dataset and remove columns with little information.

Next, I convert names into numbers. This is necessary for xgboost, since it can deal only with numeric data. I also delete all the nun-numeric columns such as timestamp, new window etc...

Train xgboost model, first do cross validation and then feed best parameters into model for prediction.

    ## [1]  train-merror:0.183697+0.008014  test-merror:0.192130+0.009507 
    ## [2]  train-merror:0.080726+0.007810  test-merror:0.091530+0.001932 
    ## [3]  train-merror:0.039357+0.006611  test-merror:0.048975+0.007138 
    ## [4]  train-merror:0.019634+0.004138  test-merror:0.026704+0.004013 
    ## [5]  train-merror:0.008664+0.002191  test-merror:0.013862+0.002939 
    ## [6]  train-merror:0.004650+0.001350  test-merror:0.009836+0.002617 
    ## [7]  train-merror:0.002344+0.000551  test-merror:0.007237+0.001918 
    ## [8]  train-merror:0.001134+0.000168  test-merror:0.004689+0.000525 
    ## [9]  train-merror:0.000561+0.000357  test-merror:0.004077+0.000534 
    ## [10] train-merror:0.000293+0.000131  test-merror:0.003058+0.000581 
    ## [11] train-merror:0.000178+0.000158  test-merror:0.002752+0.000813 
    ## [12] train-merror:0.000076+0.000074  test-merror:0.001937+0.000657 
    ## [13] train-merror:0.000051+0.000074  test-merror:0.001886+0.000637 
    ## [14] train-merror:0.000013+0.000026  test-merror:0.001886+0.000472 
    ## [15] train-merror:0.000013+0.000026  test-merror:0.001376+0.000306 
    ## [16] train-merror:0.000000+0.000000  test-merror:0.001223+0.000250 
    ## [17] train-merror:0.000000+0.000000  test-merror:0.001274+0.000426 
    ## [18] train-merror:0.000000+0.000000  test-merror:0.001172+0.000444 
    ## [19] train-merror:0.000000+0.000000  test-merror:0.001019+0.000483 
    ## [20] train-merror:0.000000+0.000000  test-merror:0.000917+0.000473

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

These are the predictions on the test set. The equivalences are: A=0, B=1 etc....
