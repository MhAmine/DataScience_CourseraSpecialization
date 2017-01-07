best <- function(state,outcome){
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
    min_mort_rate <- min(data[,column],na.rm=TRUE)  
    indices <- (data[,column] == min_mort_rate)
    hospitals <- data[indices,"Hospital.Name"]
    hospitals  
  }
}