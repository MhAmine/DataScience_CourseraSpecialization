---
title: "Course Project applied machine learning"
output: pdf_document
---

Required libraries: library(caret), library(xgboost) and register multicore support with library(doMC) and register...



First step is reading the training and testing set.


```r
train = read.csv("pml-training.csv")
test = read.csv("pml-testing.csv")
```

I do not split the data into a train and cross validation set, since
the xgboost algorithm, which I will use, has a built in cross validation function.

Next, Remove columns that have empty factor, NULL or NA to have a dense dataset and remove columns
with little information.

```r
hasNoNA = complete.cases(t(train))

trainComplete = train[,hasNoNA]
testComplete = test[,hasNoNA]

toRemove = apply(trainComplete, 2, function(col) ifelse(any(col == ''), TRUE, FALSE))

trainComplete = trainComplete[,!toRemove]
testComplete = testComplete[,!toRemove]

rm(hasNoNA)
rm(toRemove)
```

Next, I convert names into numbers. This is necessary for xgboost, since it can deal only with numeric data. I also delete all the nun-numeric columns such as timestamp, new window etc...

```r
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



Train xgboost model, first do cross validation and then feed best parameters into model for prediction.

```r
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

```
## [1]	train-merror:0.181008+0.010430	test-merror:0.188004+0.015855 
## [2]	train-merror:0.078776+0.008568	test-merror:0.087097+0.007820 
## [3]	train-merror:0.035661+0.001789	test-merror:0.042860+0.001161 
## [4]	train-merror:0.018423+0.002441	test-merror:0.023647+0.004450 
## [5]	train-merror:0.009989+0.001935	test-merror:0.014729+0.003478 
## [6]	train-merror:0.005619+0.001046	test-merror:0.010397+0.001827 
## [7]	train-merror:0.002968+0.000739	test-merror:0.007645+0.000665 
## [8]	train-merror:0.001491+0.000561	test-merror:0.004944+0.001040 
## [9]	train-merror:0.000586+0.000419	test-merror:0.003771+0.000653 
## [10]	train-merror:0.000255+0.000090	test-merror:0.002293+0.000360 
## [11]	train-merror:0.000127+0.000057	test-merror:0.001886+0.000500 
## [12]	train-merror:0.000089+0.000065	test-merror:0.001631+0.000346 
## [13]	train-merror:0.000013+0.000026	test-merror:0.001274+0.000360 
## [14]	train-merror:0.000000+0.000000	test-merror:0.001172+0.000260 
## [15]	train-merror:0.000000+0.000000	test-merror:0.000968+0.000338 
## [16]	train-merror:0.000000+0.000000	test-merror:0.000917+0.000306 
## [17]	train-merror:0.000000+0.000000	test-merror:0.000816+0.000250 
## [18]	train-merror:0.000000+0.000000	test-merror:0.000816+0.000250 
## [19]	train-merror:0.000000+0.000000	test-merror:0.000765+0.000161 
## [20]	train-merror:0.000000+0.000000	test-merror:0.000765+0.000161
```

I stop the iteration after 20 rounds, because the test error for a 5-fold cross validation does not improve any more. The parameters used for xgboost are 

* num_class = 5, nthread = 4, nfold = 5, nround = 20, max_depth = 5, eta = 1 
* params <- list(objective = "multi:softprob",
      num_class = num_class,
      max_depth = max_depth,
      eta = eta
      )

Establish model for prediction with these parameters

```r
model <- xgboost(train.model, max.depth = max_depth, eta = eta, nthread = nthread, nround = nround, num_class = num_class, objective = "multi:softmax")
```

```
## [1]	train-merror:0.191061 
## [2]	train-merror:0.085771 
## [3]	train-merror:0.037509 
## [4]	train-merror:0.021659 
## [5]	train-merror:0.011874 
## [6]	train-merror:0.006370 
## [7]	train-merror:0.002854 
## [8]	train-merror:0.001835 
## [9]	train-merror:0.000815 
## [10]	train-merror:0.000561 
## [11]	train-merror:0.000306 
## [12]	train-merror:0.000204 
## [13]	train-merror:0.000051 
## [14]	train-merror:0.000000 
## [15]	train-merror:0.000000 
## [16]	train-merror:0.000000 
## [17]	train-merror:0.000000 
## [18]	train-merror:0.000000 
## [19]	train-merror:0.000000 
## [20]	train-merror:0.000000
```

```r
# prediction on test data
predictions <- predict(model, newdata = as.matrix(test.data))
predictions
```

```
##  [1] 1 0 1 0 0 4 3 1 0 0 1 2 1 0 4 4 0 1 1 1
```
These are the predictions on the test set. The equivalences are: A=0, B=1 etc....The accuracy on the test set is 100%.















