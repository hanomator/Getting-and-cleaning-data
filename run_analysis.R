
## 0. Download and unzip the files

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "data.zip")
unzip("data.zip")



## 1. Merges the training and the test sets to create one data set.
## Read the data

## read the training data
train_dat <- read.table("UCI HAR Dataset/train/X_train.txt")
train_act <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subj <- read.table("UCI HAR Dataset/train/subject_train.txt")

## read the test data
test_dat <- read.table("UCI HAR Dataset/test/X_test.txt")
test_act <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subj <- read.table("UCI HAR Dataset/test/subject_test.txt")


## 3. Uses descriptive activity names to name the activities in the data set

activities <- read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
train_act$V1 <- factor(train_act$V1,levels=activities$V1,labels=activities$V2)
test_act$V1 <- factor(test_act$V1,levels=activities$V1,labels=activities$V2)


## 4. Appropriately labels the data set with descriptive variable names. 

features <- read.table("UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")

colnames(train_dat) <- features$V2
colnames(test_dat) <- features$V2
colnames(train_act) <- c("Activity")
colnames(test_act) <- c("Activity")
colnames(train_subj) <- c("Subject_ID")
colnames(test_subj) <- c("Subject_ID")


## 1. Merges the training and the test sets to create one data set.
## Merge the named data sets

train_dat <- cbind(train_dat,train_act)
train_dat <- cbind(train_dat, train_subj)
test_dat <- cbind(test_dat,test_act)
test_dat <- cbind(test_dat,test_subj)
whole_dat <- rbind(train_dat,test_dat)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

whole_dat_mean <- sapply(whole_dat,mean,na.rm=TRUE)
whole_dat_sd <- sapply(whole_dat,sd,na.rm=TRUE)



## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(data.table)
whole_table <- data.table(whole_dat)
tidy_dat <- whole_table[,lapply(.SD,mean),by="Activity,Subject_ID"]
write.table(tidy_dat,file="tidy_data.txt",sep=",",row.names = FALSE)

