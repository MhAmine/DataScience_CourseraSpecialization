
complete <- function(directory, id=1:332) {
  wd<-"C:\\Users\\Peter\\Dropbox\\2015_Coursera_Edx\\2015_R programming\\"
  nobs <- NULL    
  for(i in id){
    file_def<-paste0(wd,directory, "\\", formatC(i, width=3, flag="0"), ".csv")
    data<-read.csv(file_def)
    nobs<-rbind(nobs,sum(complete.cases(data[,2],data[,3])))
  }
  
  return(data.frame(id,nobs))
}
