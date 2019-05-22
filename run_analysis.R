#Data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#Requirements:
#You should create one R script called run_analysis.R that does the following. 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Set Working Directory.

setwd("/Users/saralu/Desktop/Coursera/UCI HAR Dataset")

#1. Merge the training and the test data.

#Read the data general and training.

features <- read.table("./features.txt",header = FALSE)
activityLabel <- read.table("./activity_labels.txt",header = FALSE)
subjectTrain <- read.table("./train/subject_train.txt", header = FALSE)
xTrain <- read.table("./train/X_train.txt", header = FALSE)
yTrain <- read.table("./train/y_train.txt", header = FALSE)

#Assign column names to the data above.

colnames(activityLabel)<-c("activityId", "activityType")
colnames(subjectTrain) <- "subId"
colnames(xTrain) <- features[,2]
colnames(yTrain) <- "activityId"

#Merge training Data.

trainData <- cbind(yTrain, subjectTrain, xTrain)

#Read the test Data.

subjectTest <- read.table("./test/subject_test.txt", header = FALSE)
xTest <- read.table("./test/X_test.txt", header = FALSE)
yTest <- read.table("./test/y_test.txt", header = FALSE)

#Assign column names to test data.

colnames(subjectTest) <- "subId"
colnames(xTest) <- features[,2]
colnames(yTest) <- "activityId"

#Merge test Data.

testData <- cbind(yTest, subjectTest, xTest)

#Final merged data.

finalData <- rbind(trainData, testData)

#Create a vector for column names to be used further.

colNames <- colnames(finalData)

# 2. Extract only the measurements on the mean and standard deviation for each measurement.

tidyData <- finalData[, grepl("mean|std|subject|activityId", colnames(finalData))]

# 3. Uses descriptive activity names to name the activities in the data set.

# install plyr if needed.

install.packages("plyr")

library(plyr)

tidyData <- join(tidyData, activityLabel, by = "activityId", match = "first")

tidyData <- data_mean_std[,-1]

#4. Appropriately labels the data set with descriptive variable names.

#Remove parentheses.

names(tidyData) <- gsub("\\(|\\)", "", names(tidyData), perl  = TRUE)

#correct syntax in names.

names(tidyData) <- make.names(names(tidyData))

#add descriptive names.

names(tidyData)[2] = "activity"
names(tidyData)[1] = "subject"
names(tidyData)<-gsub("Acc", "Accelerometer", names(tidyData))
names(tidyData)<-gsub("Gyro", "Gyroscope", names(tidyData))
names(tidyData)<-gsub("BodyBody", "Body", names(tidyData))
names(tidyData)<-gsub("Mag", "Magnitude", names(tidyData))
names(tidyData)<-gsub("^t", "Time", names(tidyData))
names(tidyData)<-gsub("^f", "Frequency", names(tidyData))
names(tidyData)<-gsub("tBody", "TimeBody", names(tidyData))
names(tidyData)<-gsub("-mean()", "Mean", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-std()", "STD", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-freq()", "Frequency", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("angle", "Angle", names(tidyData))
names(tidyData)<-gsub("gravity", "Gravity", names(tidyData))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_Data <- ddply(tidyData, c("subject", "activity"), numcolwise(mean))

write.table(tidy_Data, file = "tidy_Data.txt")
