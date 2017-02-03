Course Project applied machine learning
================

Required libraries: library(caret), library(xgboost)

Read train and test set

``` r
train = read.csv("pml-training.csv")
test = read.csv("pml-testing.csv")
```

I do not split the date into a train and cross validation set, since the xgboost algorithm has a built in cross validation function, which I am using.

Remove columns that have empty factor, NULL or NA

``` r
hasNoNA = complete.cases(t(train))

trainComplete = train[,hasNoNA]
testComplete = test[,hasNoNA]

toRemove = apply(trainComplete, 2, function(col) ifelse(any(col == ''), TRUE, FALSE))

trainComplete = trainComplete[,!toRemove]
testComplete = testComplete[,!toRemove]

rm(hasNoNA)
rm(toRemove)
```

Convert names into numbers for xgboost

``` r
convertNamesToNumbers <- function(x){
    if (x == "carlitos"){
        return(1)
    }
    else if (x == "pedro"){
        return(2)    
    }
    else if (x == "adelmo"){
        return(3)
    }
    else if (x == "charles"){
        return(4)
    }
    else if (x == "eurico"){
        return(5)
    }
    else if (x == "jeremy"){
        return(6)
    }
}

trainComplete$user_name = as.character(trainComplete$user_name)
trainComplete$user_name = sapply(trainComplete$user_name, convertNamesToNumbers)

testComplete$user_name = as.character(testComplete$user_name)
testComplete$user_name = sapply(testComplete$user_name, convertNamesToNumbers)
```

Delete all the nun-numeric columns for xgboost

Train xgboost model, first do cross validation and then feed best parameters into model for prediction.

``` r
train.model <- xgb.DMatrix(data = as.matrix(train.data), label = train.label)

num_class = 5
nthread = 4
nfold = 5
nround = 20
max_depth = 5
eta = 1

params <- list(objective = "multi:softprob",
      num_class = num_class,
      max_depth = max_depth,
      eta = eta
      )

cv <- xgb.cv(train.model, params = params, nthread = nthread, nfold = nfold, nround = nround)
```

    ## [1]  train-merror:0.186640+0.010200  test-merror:0.193558+0.009815 
    ## [2]  train-merror:0.079286+0.007550  test-merror:0.087506+0.011873 
    ## [3]  train-merror:0.040592+0.006255  test-merror:0.048925+0.007920 
    ## [4]  train-merror:0.020143+0.003304  test-merror:0.027877+0.002319 
    ## [5]  train-merror:0.009785+0.001425  test-merror:0.015849+0.001652 
    ## [6]  train-merror:0.005083+0.001890  test-merror:0.010090+0.001517 
    ## [7]  train-merror:0.002765+0.000719  test-merror:0.007084+0.001314 
    ## [8]  train-merror:0.001363+0.000687  test-merror:0.005351+0.000838 
    ## [9]  train-merror:0.000675+0.000371  test-merror:0.003720+0.000989 
    ## [10] train-merror:0.000420+0.000174  test-merror:0.002701+0.000766 
    ## [11] train-merror:0.000229+0.000131  test-merror:0.002090+0.000672 
    ## [12] train-merror:0.000115+0.000102  test-merror:0.001580+0.000590 
    ## [13] train-merror:0.000064+0.000070  test-merror:0.001580+0.000590 
    ## [14] train-merror:0.000013+0.000026  test-merror:0.001325+0.000494 
    ## [15] train-merror:0.000000+0.000000  test-merror:0.001274+0.000484 
    ## [16] train-merror:0.000000+0.000000  test-merror:0.001121+0.000616 
    ## [17] train-merror:0.000000+0.000000  test-merror:0.000917+0.000525 
    ## [18] train-merror:0.000000+0.000000  test-merror:0.000815+0.000467 
    ## [19] train-merror:0.000000+0.000000  test-merror:0.000866+0.000525 
    ## [20] train-merror:0.000000+0.000000  test-merror:0.000764+0.000484

I stop the iteration after 20 rounds, because the test set error does not improve any more.

Establish model for prediction

``` r
model <- xgboost(train.model, max.depth = max_depth, eta = eta, nthread = nthread, nround = nround, num_class = num_class, objective = "multi:softmax")
```

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

``` r
# prediction on test data
predictions <- predict(model, newdata = as.matrix(test.data))
predictions
```

    ##  [1] 1 0 1 0 0 4 3 1 0 0 1 2 1 0 4 4 0 1 1 1

The equivalences are: A=0, B=1 etc....
