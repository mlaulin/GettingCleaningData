##----------------------------------------------------------------------------------------------------------
## The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
## The goal is to prepare tidy data that can be used for later analysis. 
## You will be graded by your peers on a series of yes/no questions related to the project. 
## You will be required to submit: 
## 1) a tidy data set as described below, 
## 2) a link to a Github repository with your script for performing the analysis, and 
## 3) a code book that describes the variables, the data, and 
## any transformations or work that you performed to clean up the data called CodeBook.md. 
## You should also include a README.md in the repo with your scripts. 
## This repo explains how all of the scripts work and how they are connected. 
##----------------------------------------------------------------------------------------------------------
## You should create one R script called run_analysis.R that does the following. 
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## Creates a second, independent tidy data set with the 
## average of each variable for each activity and each subject.
##----------------------------------------------------------------------------------------------------------

## Set the working folder
setwd("C:/DataScience/GettingCleaningData/Project")

## Create the merge directory to save merged test and train data sets
if(!file.exists("merge")){
  dir.create("merge")
}

print("Step 1: Merge the test and the train data sets to create one data set")

## Merge the test and the train data sets to create one data set
## Reading the test and the train data sets
list.files("./train")
trainDS <- read.table("./train/X_train.txt")
print(class(trainDS))
## print(head(trainDS))
print(dim(trainDS))

list.files("./test")
testDS <- read.table("./test/X_test.txt")
print(class(testDS))
## print(head(testDS))
print(dim(testDS))

## Row bind both data sets
mergeDS <- rbind(trainDS, testDS)
print(dim(mergeDS))

print("Step 2: Extract only the measurements on the mean and standard deviation for each measurement")

## Extract only the measurements on the mean and standard deviation for each measurement
## Get all the features
featuresDS <- read.table("./features.txt", stringsAsFactor=F)
colnames(featuresDS) <- c("id", "feature")
print(class(featuresDS))
print(head(featuresDS))
print(dim(featuresDS))

print("Step 3: Getting measurements based on Mean and Standard deviation by feature names")

## Getting measurements on Mean and Standard deviation by feature names
featuresMSD <- featuresDS[(grepl("mean()", featuresDS$feature, fixed = TRUE) | grepl("std()", featuresDS$feature, fixed = TRUE)), ]
print(head(featuresMSD))
print(dim(featuresMSD))
iCnt <- nrow(featuresMSD)

## Extract Mean and Standard deviation from merged data set (mergeDS)
mergeMSD <- mergeDS[, featuresMSD$id]

## Set new names
colnames(mergeMSD) <- featuresMSD$feature

## Adding subject id to each row
subjectTrainDS <- read.table("./train/subject_train.txt")
subjectTestDS <- read.table("./test/subject_test.txt")
mergeMSD$subject <- rbind(subjectTrainDS, subjectTestDS)$V1

## Print the data frame
## print(head(mergeMSD))
print(dim(mergeMSD))

print("Step 4: Use descriptive activity names to name the activities in the data set")
## Use descriptive activity names to name the activities in the data set

## Assigning activity labels to each row
activityTrainDS <- read.table("./train/y_train.txt")
activityTestDS <- read.table("./test/y_test.txt")
mergeMSD$label <- rbind(activityTrainDS, activityTestDS)$V1

## Match the activity numbers with appropriate activity names provided

## Read in activity labels
activityNamesDS <- read.table("./activity_labels.txt")
print(head(activityNamesDS))
print(dim(activityNamesDS))

## Merge the two data sets to get the label names
mergeMSD <- merge(mergeMSD, activityNamesDS, by.x="label", by.y="V1", all = TRUE)

## Remove label number field and rename new field
mergeMSD$label <- NULL
colnames(mergeMSD)[68] <- "activitylabels"

### Refine factor level names
levels(mergeMSD$activitylabels) <- tolower(levels(mergeMSD$activitylabels))
levels(mergeMSD$activitylabels) <- sub("_", "", levels(mergeMSD$activitylabels))

## Sort the dataset by subject id and then by activity name
mergeMSD <- mergeMSD[order(mergeMSD$subject, mergeMSD$activitylabels), ]

print("Step 5: Appropriately label the data set with descriptive column names")

## Appropriately label the data set with descriptive column names
## print(colnames(mergeMSD))
source("assignNames.R")
colnames(mergeMSD) <- assignNames(colnames(mergeMSD))

## Create a second, independent tidy data set with the 
## average of each variable for each activity and each subject.
tidyDS <- mergeMSD
tidyDS$activitylabels <- as.character(tidyDS$activitylabels)

## Group the observations by subject and activity (180 groups = 30 subjects * 6 activities)
tidyDS$group <- paste(tidyDS$subject, tidyDS$activitylabels)
tidyDS$group <- as.factor(tidyDS$group)

## Create the final tidyDS data frame
finalTidyDS=data.frame(1:180)

## Iteratively add each feature/field to the data frame
## iCnt is the number of features
for (i in 1:iCnt) {
  finalTidyDS[, colnames(tidyDS)[i]] <- tapply(tidyDS[, i], tidyDS$group, mean)
}

## Rename each row to corresponding group name
rownames(finalTidyDS) <- unique(tidyDS$group)

## Removing NULL
finalTidyDS[, 1] <- NULL
## print(head(finalTidyDS))
print(dim(finalTidyDS))

## Write the tidy set into text file
write.table(finalTidyDS, file="./merge/tidyDS.txt", sep="\t")
