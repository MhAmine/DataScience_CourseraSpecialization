rankall <- function(outcome, num = "best"){
  library(dplyr)
  outcomes = c("pneumonia", "heart attack", "heart failure")
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  if (!is.element(outcome, outcomes)) {
    stop("invalid outcome")
  
  } else {
    if (identical(outcome, "heart attack")){
      column <- colnames(data)[11]
    
    } else if(identical(outcome, "heart failure")){
      column <- colnames(data)[17]
    
    } else if(identical(outcome, "pneumonia")){
      column <- colnames(data)[23]
    }
    
    states <- unique(data$State)
    states <- sort(states)
    hospitals = c()
    
    for(state in states){
      data.state <- data[data$State == state,]
      data.state[,column] <- as.numeric(data.state[,column])
      data.state <- data.state[!is.na(data.state[,column]),]
      data.state <- data.state[order(data.state[column],data.state["Hospital.Name"]),]
      data.state[,"Hospital.Name"]
      
      if(identical(num,"best")){
        hospital <- data.state[1, "Hospital.Name"]
      
      } else if(identical(num,"worst")){
        hospital <- data.state[dim(data.state)[1], "Hospital.Name"]
        
      } else {
        hospital <- data.state[num, "Hospital.Name"]  
        
      }
    
      hospitals <- rbind(hospitals, hospital)     
    
    }
  output <- data.frame(states, hospitals)
  output
  }  
}