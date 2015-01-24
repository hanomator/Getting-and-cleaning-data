## Introduction

In this File you can find Information about the data set, and the work that has been performed to download and clean the data.

### Data Set Description

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

#### For each record it is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

#### The dataset includes the following files:

* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

### Variables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.


## Getting and cleaning the data set

#### Getting the data

The full description on the data can be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The data for the Project can be downloaded here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


You can download and extract the data by using the following function:
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "data.zip")
unzip("data.zip")

The data set has been stored in the "UCI HAR Dataset/" directory.



#### Reading and cleaning the data

"read.table" is used to load the data to R environment for the data, the activities and the subject of both test and training datasets.

train_dat <- read.table("UCI HAR Dataset/train/X_train.txt")
train_act <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subj <- read.table("UCI HAR Dataset/train/subject_train.txt")
test_dat <- read.table("UCI HAR Dataset/test/X_test.txt")
test_act <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subj <- read.table("UCI HAR Dataset/test/subject_test.txt")



#### Descriptive activity names to name the activities in the data set

The class labels linked with their activity names are loaded from the "activity_labels.txt" file. 
The numbers of the "test_act" and "train_act"" data frames are replaced by those names:

activities <- read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
train_act$V1 <- factor(train_act$V1,levels=activities$V1,labels=activities$V2)
test_act$V1 <- factor(test_act$V1,levels=activities$V1,labels=activities$V2)



#### Appropriately labels the data set with descriptive activity names

Each data frame of the data set is labeled - using the "features.txt - with the information about the variables used on the feature vector. The "Activity" and "Subject"" columns are also named properly before merging them to the test and train dataset.


features <- read.table("UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")

colnames(train_dat) <- features$V2
colnames(test_dat) <- features$V2
colnames(train_act) <- c("Activity")
colnames(test_act) <- c("Activity")
colnames(train_subj) <- c("Subject_ID")
colnames(test_subj) <- c("Subject_ID")


#### Merge test and training sets into one data set, including the activities

The "Activity" and "Subject"" columns are appended to the test and train data frames, and then are both merged in the "whole_dat" data frame.

train_dat <- cbind(train_dat,train_act)
train_dat <- cbind(train_dat, train_subj)
test_dat <- cbind(test_dat,test_act)
test_dat <- cbind(test_dat,test_subj)
whole_dat <- rbind(train_dat,test_dat)


#### Extract only the measurements on the mean and standard deviation for each measurement

"mean()" and "sd() are used in "whole_dat" via "sapply()" to extract the requested measurements.


whole_dat_mean <- sapply(whole_dat,mean,na.rm=TRUE)
whole_dat_sd <- sapply(whole_dat,sd,na.rm=TRUE)


A warning is returned for the "Activity" column because it's not numeric. This does not impact the calcucation of the rest and NA is stored in the new data frames instead, since mean and sd are not applicable in this case. The same applies for "Subject" where we're not interested about the mean and sd, but since it's numeric already there is no warning.


#### Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Finaly the desired result, a "tidy" data table is created with the average of each measurement per activity/subject combination. The new dataset is saved in "tidy_data.txt" file.

library(data.table)
whole_table <- data.table(whole_dat)
tidy_dat <- whole_table[,lapply(.SD,mean),by="Activity,Subject_ID"]
write.table(tidy_dat,file="tidy_data.txt",sep=",",row.names = FALSE)

