
pollutantmean <- function(directory, pollutant, id=1:332) {
  wd<-"C:\\Users\\Peter\\Dropbox\\2015_Coursera_Edx\\2015_R programming\\"
  init_data <- NULL    
  for(i in id){
    file_def<-paste0(wd,directory, "\\", formatC(i, width=3, flag="0"), ".csv")
    data<-read.csv(file_def)
    init_data<-rbind(init_data,data)
  }
  
  x <- mean(init_data[,pollutant], na.rm = TRUE)
  return(x)
}
    
    

                
      
  

