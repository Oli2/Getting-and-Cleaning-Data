# Getting-and-Cleaning-Data

This repository has been created to deliver the course project and as per the project requirements include:

1. run_analysis.R script

2. The tidy data sets which are result of the run_analysis.R script

3. A code book that describes the variables, the data, and any transformations or work that you
   performed to clean up the data called CodeBook.md

# About Raw Data
The 561 observations are unlabeled and can be found in the x_test.txt. The activity labels are in the y_test.txt file. The test subjects are in the subject_test.txt file.

#About the script
The run_analysis.R script, read the original data file provided from the following URL<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

It further unzips and unlinks from the source.

As per the course project requirements the scripts reads the data sets from the appropriate folders, it marges the testing and training data sets, adds labes to the varibales and extracts only observations revelant to mean and standard deviation, 


In the last section, the script creates a tidy data set containing the means of all the variables per per activity. This tidy dataset is created using write.table function to a file called tid_data_set.txt, which can also be found in this repository.

#About the Code Book

The CodeBook.md file explains step-by-step the transformations performed and the resulting data and variables.
