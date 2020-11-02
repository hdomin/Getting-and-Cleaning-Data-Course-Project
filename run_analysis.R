
# Download Dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "dataset.zip"

download.file(url, filename)
unzip(filename)

# 1.-
# Merges the training and the test sets to create one data set.
library(data.table)

# read the train data
x_train <- data.table::fread("./UCI HAR Dataset/train/X_train.txt")
y_train <- data.table::fread("./UCI HAR Dataset/train/Y_train.txt")
s_train <- data.table::fread("./UCI HAR Dataset/train/subject_train.txt")

# read the test data
x_test <- data.table::fread("./UCI HAR Dataset/test/X_test.txt")
y_test <- data.table::fread("./UCI HAR Dataset/test/Y_test.txt")
s_test <- data.table::fread("./UCI HAR Dataset/test/subject_test.txt")

# merge the data
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)

# remove train and test data
remove(x_train); remove(y_train); remove(s_train)
remove(x_test); remove(y_test); remove(s_test)


# 2.-
# Extracts only the measurements on the mean and standard deviation for each measurement.
# read the feature and activity table
feature <- data.table::fread("./UCI HAR Dataset/features.txt")
activity <- data.table::fread("./UCI HAR Dataset/activity_labels.txt")

grep("mean\\(\\)|std\\(\\)", feature[,2], value=TRUE)

# 3.-
#Uses descriptive activity names to name the activities in the data set
# 4.-
#Appropriately labels the data set with descriptive variable names.
# 5.-
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
