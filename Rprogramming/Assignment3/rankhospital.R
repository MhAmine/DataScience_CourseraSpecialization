rankhospital <- function(state,outcome,num){
  library(dplyr)
  outcomes = c("pneumonia", "heart attack", "heart failure")
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  if (!is.element(state, data$State)) {
    stop("invalid state")
  
  } else if(!is.element(outcome, outcome)) {
    stop("invalid outcome")
  
  } else {
    if (identical(outcome, "heart attack")){
      column <- colnames(data)[11]
    
    } else if(identical(outcome, "heart failure")){
      column <- colnames(data)[17]
    
    } else if(identical(outcome, "pneumonia")){
      column <- colnames(data)[23]
    }
    
    data <- data[data$State == state,]
    data[,column] <- as.numeric(data[,column])
    data <- data[!is.na(data[,column]),]
    data <- data[order(data[column],data["Hospital.Name"]),]
    data[,"Hospital.Name"]
    
    if(identical(num,"best")){
      hospital <- data[1, "Hospital.Name"]
    
    } else if(identical(num,"worst")){
      hospital <- data[dim(data)[1], "Hospital.Name"]
      
    } else {
      hospital <- data[num, "Hospital.Name"]  
      
    }
    
    hospital
    }
}