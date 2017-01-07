# load libraries
library(dplyr)

# download data and create folder
if(!file.exists("UCI HAR Dataset")){
  
  url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  destfile = "UCI_HAR_Dataset.zip"

  download.file(url, destfile)
  
  unzip(destfile)
  
  }

# read feature vector and activity labels
data_folder = "./UCI HAR Dataset/"
features = read.table(paste0(data_folder, "features.txt"))
feature_vec = as.character(features[,2])
remove(features)
activity_labels = read.table(paste0(data_folder, "activity_labels.txt"), stringsAsFactors = F)

# read data
set = "train"
x_train = read.table(paste0(data_folder, set,"/", "X_", set, ".txt"))
y_train = read.table(paste0(data_folder, set,"/", "y_", set, ".txt"))
subject_train = read.table(paste0(data_folder, set,"/", "subject_", set, ".txt"))

set = "test"
x_test = read.table(paste0(data_folder, set,"/", "X_", set, ".txt"))
y_test = read.table(paste0(data_folder, set,"/", "y_", set, ".txt"))
subject_test = read.table(paste0(data_folder, set,"/", "subject_", set, ".txt"))

# merge train and test set and name columns according to featuve vector
data_all = rbind(x_train, x_test)
colnames(data_all) = feature_vec

# filter for columns including mean or std
filter = grepl(".*mean.*|.*Mean.*|.*std.*", colnames(data_all))
data = data_all[,filter]

# merge subject and activity labes to data and add column names for last two columns
subject = rbind(subject_train, subject_test)
y = rbind(y_train, y_test)
colnames(y) = "activity"
colnames(subject) = "subject"
data = cbind(subject, y, data)

# rename activities
renameActivities = function(num){return(activity_labels[num, 2])}
data$activity = sapply(data$activity, renameActivities)

# create and save tidy data set
tidy = aggregate(data, by=list(activity = data$activity, subject=data$subject), mean)
tidy = tidy[,-3:-4]
write.table(tidy, "tidy.txt")

# remove everything from workspace except data and tidy
rm(list=setdiff(ls(),c("data", "tidy")))
