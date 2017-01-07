

corr <- function(directory, threshold = 0) {
  wd<-"C:\\Users\\Peter\\Dropbox\\2015_Coursera_Edx\\2015_R programming\\"
  id <- 1:332 
  output <- c()
  for(i in id){
    file_def<-paste0(wd,directory, "\\", formatC(i, width=3, flag="0"), ".csv")
    data<-read.csv(file_def)
    data<-data[complete.cases(data[,2],data[,3]),]
    
    if(nrow(data)>threshold){
      correlations <- cor(data[,2],data[,3])
      output <- c(output,correlations)
    }
    
  }
  
  return(output)
}


