
#Loading the Datafile
if(!file.exists("./data")){dir.create("./data")} 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(fileUrl,destfile = "./data/Assignment1.zip") 
unzip("./data/Assignment1.zip",exdir="./data") 

library(data.table)
library(dplyr)
##Loading in the TEST data set   
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt") 
X_test = read.table("UCI HAR Dataset/test/X_test.txt") 
Y_test = read.table("UCI HAR Dataset/test/Y_test.txt") 
      
##Loading in the TRAIN data set 
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt") 
X_train = read.table("UCI HAR Dataset/train/X_train.txt") 
Y_train = read.table("UCI HAR Dataset/train/Y_train.txt") 
      
##Merging both data sets on the selected information and including an appropriate naming convention
features_selected <- read.table("UCI HAR Dataset/features.txt", col.names=c("featureId", "featureLabel")) 
activities_selected <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activityId", "activityLabel")) 
activities_selected$activityLabel <- gsub("_", "", as.character(activities_selected$activityLabel)) 
SelectFeatures <- grep("-mean\\(\\)|-std\\(\\)", features_selected$featureLabel) 
subject <- rbind(subject_test, subject_train) 
names(subject) <- "subjectId" 
X <- rbind(X_test, X_train) 
X <- X[, SelectFeatures] 

names(X) <- gsub("\\(|\\)", "", features_selected$featureLabel[SelectFeatures]) 
Y <- rbind(Y_test, Y_train)
names(Y) = "activityId" 
activity <- merge(Y, activities_selected, by="activityId")$activityLabel 
      
## Merging the different data sets into one final table 
data1 <- cbind(subject, X, activity) 
write.table(data1, "final_data.txt") 
      
##Creating from above final_data set a new independant data set with the average of each variable for each activity and each subject and including standard deviation  
data2 <- data.table(data1) 
Mean_SD<- data2[, lapply(.SD, mean), by=c("subjectId", "activity")] 
write.table(Mean_SD, "final_data_Mean_SD.txt") 
 
