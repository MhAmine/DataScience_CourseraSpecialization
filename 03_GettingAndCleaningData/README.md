Getting and cleaning data course project

The script run_analysis.R does the following:
1. Downloads data and create data folder
2. Reads feature vector and activity labels
3. Read train and test data and subject files
4. Merges train and test set and names columns according to feature vector
5. Filter for columns that include mean or std, excludes rest
6. Merges subject and activity labels to data and adds column names for subject and activity
7. Maps activity numbers to names
8. Creates and saves tidy data set, aggregated by activity and subject, given mean of all variables