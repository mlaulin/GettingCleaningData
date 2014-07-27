GettingCleaningData
===================

Coursera Project Work for Module 3: Getting and Cleaning Data

There are 4 files that have been submitted:
1. CodeBook.md
2. README.md
3. run_analysis.R
4. assignNames.R

1. CodeBook.md: Describes all the variables used in the run_analysis.R program
2. README.md: This is the current file that provides details on the scripts that have been submitted
3. run_analysis.R: This file performs the required operations such as:
    3a. Merging the training and the test sets to create one data set
    3b. Extracting only the measurements on the mean and standard deviation for each measurement
    3c. Uses descriptive activity names to name the activities in the data set
    3d. Appropriately labels the data set with descriptive variable names (calls the assignNames.R function)
    3e. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
4. assignNames.R: This function simply takes the present column names and labels them in user friendly readable format
