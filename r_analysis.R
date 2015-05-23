#read in test data
featuresTest = read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
activityTest = read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activity")
subjectTest = read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")


#read in the train data 
featuresTrain = read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
activityTrain = read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activity")
subjectTrain = read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

#combine subject data
subjectData = rbind(subjectTest, subjectTrain)

#combine activity data
activityData = rbind(activityTest, activityTrain)

#combine features data
featuresData = rbind(featuresTest, featuresTrain)

#read in features labels
featuresLabels = read.table("./UCI HAR Dataset/features.txt", head = FALSE)

#add the featuresLabels as names to the featuresData
names(featuresData) = featuresLabels$V2

#combine subject, activity, and feature data
data = cbind(subjectData, activityData, featuresData)

#create a subset of features labels that refer to mean or std
featuresLabelsSubset = featuresLabels$V2[grep("mean\\(\\)|std\\(\\)", featuresLabels$V2)]

#add subject and activity to the features labels subset
FinalfeaturesLabelSubset = c("subject", "activity", as.character(featuresLabelsSubset))

#create a subset of data using the final features labels subset
dataSubset = subset(data, select=FinalfeaturesLabelSubset)

#read in the activity labels
activityLabels = read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

#turn data subset activity variable into a factor 
dataSubset$activity = factor(dataSubset$activity)

#rename activity observations using the activity labels
dataSubset$activity = factor(dataSubset$activity, labels = as.character(activityLabels$V2))

#rename other variables with descriptive labels
names(dataSubset)<-gsub("^t", "time", names(dataSubset))
names(dataSubset)<-gsub("^f", "frequency", names(dataSubset))
names(dataSubset)<-gsub("Acc", "Accelerometer", names(dataSubset))
names(dataSubset)<-gsub("Gyro", "Gyroscope", names(dataSubset))
names(dataSubset)<-gsub("Mag", "Magnitude", names(dataSubset))
names(dataSubset)<-gsub("BodyBody", "Body", names(dataSubset))

#aggregate the data by subject and activity and find the mean
library(plyr)
dataFinal<-aggregate(. ~subject + activity, dataSubset, mean)

#write the final data to a new cvs
write.table(dataFinal, file = "tidydata.txt",row.name=FALSE)
