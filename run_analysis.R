library(dplyr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#creating the temp file which will be used to download and unzip the url

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)

file <- unzip(temp)

unlink(temp)
# 
# #reading the data sets
# 
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")

ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")

xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")

ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

# *************************************************************************************
#   Task 1 Merging the training and the test sets to create one data set.
# 
# *************************************************************************************
  
test_final <- bind_cols(xtest, ytest)

train_final <- bind_cols(xtrain, ytrain)

colnames(test_final)[562] <- "Y"
colnames(train_final)[562] <- "Y"


final<- bind_rows(train_final,test_final)

#End of Task 1

# *************************************************************************************
#   Task 2 Extracting only the measurements on the mean and standard deviation for each measurement. 
# *************************************************************************************
list<- read.table("./UCI HAR Dataset/features.txt")

list_by_mean <- list[grep("mean()", list$V2), ]

list_by_std <- list[grep("std()", list$V2), ]

list_by_m_s <- bind_rows(list_by_mean, list_by_std)

list_by_m_s[,2] <- lapply(list_by_m_s[,2], as.character)

list_by_m_s <- na.omit(list_by_m_s)

list_by_m_s[80,1] = 562

list_by_m_s[80,2] = "Y"

final_by_m_s<- select(final, list_by_m_s$V1)

final_by_m_s[,80] <- final[,562]

# End of Task 2
# at this point we have two final files which accomplish Task 1&2
# 1. final_by_m_s  -> includes all the measurements on the mean and standard deviation and column Y which identifies the type of activities
# 2. list_by_m_s  -> includes the number and descriptive names of the columns for final_by_m_s 

# *************************************************************************************
#   Task 3 & 4 
# 
# Uses descriptive activity names to name the activities in the data set
# 
# Appropriately labels the data set with descriptive variable names
# 
# *************************************************************************************


final_colnames<- setNames(final_by_m_s, list_by_m_s$V2)

colnames(final_colnames)[80] <- as.character('Activity Name')

final_colnames[,'Activity Name'][final_colnames[,'Activity Name']==5] <- 'STANDING'
final_colnames[,'Activity Name'][final_colnames[,'Activity Name']==1] <- 'WALKING'
final_colnames[,'Activity Name'][final_colnames[,'Activity Name']==2] <- 'WALKING UPSTAIRS'
final_colnames[,'Activity Name'][final_colnames[,'Activity Name']==3] <- 'WALKING DOWNSTAIRS'
final_colnames[,'Activity Name'][final_colnames[,'Activity Name']==4] <- 'SITTING'
final_colnames[,'Activity Name'][final_colnames[,'Activity Name']==6] <- 'LAYING'

#End of Tasks 3&4

# *************************************************************************************
#   Task 5
# 
# From the data set in Task 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
# 
# *************************************************************************************
 
final_colnames_mean <- aggregate(final_colnames[1:79], list(final_colnames$`Activity Name`), mean)

final_colnames_mean <- rename(final_colnames_mean, Activity = Group.1)

write.table(final_colnames_mean, "tidy_data_set.txt", row.names = FALSE)





  











