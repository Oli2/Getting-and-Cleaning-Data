#Code Book for tidy_data_set.txt and run_analysis.R

Feature Selection

I refer you to the README and features.txt files in the original dataset to learn more about the feature selection for this dataset. And there you will find the follow description:

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

The reasoning behind my selection of features is that the assignment explicitly states "Extracts only the measurements on the mean and standard deviation for each measurement." To be complete, I included all variables having to do with mean or standard deviation.

In short, for this derived dataset, these signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

    tBodyAcc-XYZ
    tGravityAcc-XYZ
    tBodyAccJerk-XYZ
    tBodyGyro-XYZ
    tBodyGyroJerk-XYZ
    tBodyAccMag
    tGravityAccMag
    tBodyAccJerkMag
    tBodyGyroMag
    tBodyGyroJerkMag
    fBodyAcc-XYZ
    fBodyAccJerk-XYZ
    fBodyGyro-XYZ
    fBodyAccMag
    fBodyAccJerkMag
    fBodyGyroMag
    fBodyGyroJerkMag

The set of variables that were estimated (and kept for this assignment) from these signals are:

    mean(): Mean value
    std(): Standard deviation

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

    gravityMean
    tBodyAccMean
    tBodyAccJerkMean
    tBodyGyroMean
    tBodyGyroJerkMean

Other estimates have been removed for the purpose of this assignment



The resulting variable names have been exposed to the following transformations:

all characters have been transformed to lower case
special characters "()-" have been removed
prefix t is replaced by time
Acc is replaced by Accelerometer
Gyro is replaced by Gyroscope
prefix f is replaced by frequency
Mag is replaced by Magnitude
BodyBody is replaced by Body

example: tBodyAcc-mean()-X has been transformed to timebodyaccelerometermeanx

# Step-by-Step analysis of all the transformations performed by run_analysis.R

Getting and Cleaning Data course project 

*************************************************************************************
Task 1 Loading the data sets. Merging the "training" and the "test" sets to create one data set.

*************************************************************************************
library(dplyr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

creating the temp file which will be used to download and unzip the url

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)

file <- unzip(temp)

unlink(temp)

xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")

ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")

xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")

ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

xtest 

2947 obs. of 561 variables 

ytest

2947 jobs of 1 variable

action:

add ytest 1 variable to xtest using dplyr bind_cols

test_final <- bind_cols(xtest, ytest)

xtrain

7352 obs. of 561 variables

ytrain 

7352 jobs of 1 variable

action:

add Ytrain 1 variable to xtrain using dplyr bind_cols

train_final <- bind_cols(xtrain, ytrain)

dim(train_final)

[1] 7352  562



The 562nd column in both test_final and train_final should have a common unique name. We’ll rename it to ‘Y’ in both files:

colnames(test_final)[562] <- ‘Y'
colnames(train_final)[562] <- ‘Y'

now both files are ready for a process to bind them by rows:

final<- bind_rows(train_final,test_final)

dim(final)

[1] 10299   562


*************************************************************************************
Task 2 Extracting only the measurements on the mean and standard deviation for each measurement. 
*************************************************************************************

File features .txt includes two columns:

v1 - number (1:561) which identifies a column in our final  file created in step 1 (excluding column Y which we added)

V2 - name of the measurement

we read this file using:

list<- read.table("./UCI HAR Dataset/features.txt")


names(list)

[1] "V1" "V2"

 class(list)
 
[1] "data.frame"
 
 str(list)
'data.frame': 561 obs. of  2 variables:

 $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
 
 $ V2: Factor w/ 477 levels "angle(tBodyAccJerkMean),gravityMean)",..: 243 244 245 250 251 252 237 238 239 240 …


we need to extract only the measurements on:

a) mean()

b)  std()

we use grep() function to achieve that

list_by_mean <- list[grep(“mean()", list$V2), ]

list_by_std <- list[grep("std()", list$V2), ]

finally we bind them by rows

list_by_m_s <- bind_rows(list_by_mean, list_by_std)

the list_by_m_s does’t include the Y column (which identifies the type of activity)

we add this in the following way

we change the V2 column to a character

list_by_m_s[,2] <- lapply(list_by_m_s[,2], as.character)

we add row 80 V1 value:

list_by_m_s[80,1] = 562

we add row 80 V2 value:

list_by_m_s[80,2] = "Y"

we remove all the NAs from list_by_m_s

list_by_m_s <- na.omit(list_by_m_s)


to select only the columns listed in list_by_m_s from the “final” file we do

final_by_m_s<- select(final, list_by_m_s$V1)

final_by_m_s files needs to be supplemented with the “Y” column from the original “final” file so that we can match the type of activity.

final_by_m_s[,80] <- final[,562]

at this point we have two final files which accomplish Task 1&2

1. final_by_m_s  - includes all the measurements on the mean and standard deviation and column Y which identifies the type of activities
2. list_by_m_s  - includes the number and descriptive names of the columns for final_by_m_s 





*************************************************************************************
Task 3 & 4 

Uses descriptive activity names to name the activities in the data set

Appropriately labels the data set with descriptive variable names

*************************************************************************************
In order to appropriately label  final_by_m_s with descriptive variable names we need to apply the values from column V2 of list_by_m_s to final_by_m_s

final_colnames<- setNames(final_by_m_s, list_by_m_s$V2)

after this the only column with no descriptive name is Y. We address this by:

colnames(final_colnames)[87] <- as.character('Activity Name')

The below will apply descriptive activity names to name the activities in the data set


final_colnames[,'Activity Name'][final_colnames[,'Activity Name']==5] <-'STANDING'
final_colnames[,'Activity Name'][final_colnames[,'Activity Name']==1] <-'WALKING'
final_colnames[,'Activity Name'][final_colnames[,'Activity Name']==2] <-'WALKING UPSTAIRS'
final_colnames[,'Activity Name'][final_colnames[,'Activity Name']==3] <-'WALKING DOWNSTAIRS'
final_colnames[,'Activity Name'][final_colnames[,'Activity Name']==4] <-'SITTING'
final_colnames[,'Activity Name'][final_colnames[,'Activity Name']==6] <-'LAYING'


*************************************************************************************

Getting the names of variables nice and clean

*************************************************************************************

first step is use tolower() fanction to make  a list of all the names of the columns in lowercase.

final_colnames_list <- tolower(names(final_colnames))

then we can remove the string “()“ from the names of the variables

final_colnames_list <- gsub(“\\()“,””,final_colnames_list)

and follow to remove the “-“

final_colnames_list <- gsub(“\\-“,””, final_colnames_list)



Appropriately labeling the data set with descriptive variable names

prefix t is replaced by time
acc is replaced by accelerometer
gyro is replaced by gyroscope
prefix f is replaced by frequency
mag is replaced by magnitude
bodybody is replaced by body


final_colnames_list<-gsub("^t", "time", final_colnames_list)
final_colnames_list<-gsub("^f", "frequency", final_colnames_list)
final_colnames_list<-gsub(“acc", “accelerometer", final_colnames_list)
final_colnames_list<-gsub(“gyro", “gyroscope", final_colnames_list)
final_colnames_list<-gsub(“mag", “magnitude", final_colnames_list)
final_colnames_list<-gsub(“bodybody", “body", final_colnames_list)



now we apply final_colname_list to the final_colnames files

final_colnames <- setNames(final_colnames, final_colnames_list) #test it


The above transformations accomplish Tasks 3&4


*************************************************************************************
Task 5

From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

*************************************************************************************


the data set created above (final_colnames) can by grouped by activity using  column #87 “activity name” and then mean function can be applied to all the numeric columns [1:86] of each variable.

function aggregate will do the job in one line command


final_colnames_mean <- aggregate(final_colnames[1:86],
list(final_colnames$`activity name`), mean)

last line remanes the Group.1 column to Activity to properly describe this variable

final_colnames_mean <- rename(final_colnames_mean, Activity = Group.1)


File  final_colnames_mean accomplished Task 5 of the project course.



