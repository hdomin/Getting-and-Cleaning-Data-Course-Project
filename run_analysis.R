
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

# read the list of features
features <- data.table::fread("./UCI HAR Dataset/features.txt")

# set the column names
colnames(x_data) <- features$V2
colnames(y_data) <- c("ActivityId")
colnames(s_data) <- c("SubjectId")


# Merges the training and the test sets to create one data set.
allData <- cbind(s_data, y_data, x_data)





# 2.-
# Extracts only the measurements on the mean and standard deviation for each measurement.
# read the feature and activity table
selectedFeatures <- grep("[mM]ean.*\\(\\)|[sS]td.*\\(\\)",features$V2,value=TRUE)
selectedFeatures <- append(selectedFeatures, c("SubjectId","ActivityId"), after=0 )

selectedData <- subset(allData, select=selectedFeatures)




# 3.-
#Uses descriptive activity names to name the activities in the data set
# read the list of activities
activities <- data.table::fread("./UCI HAR Dataset/activity_labels.txt")
colnames(activities) <- c("ActivityId", "Activity")
selectedData <- merge(selectedData, activities, by = "ActivityId", all =TRUE)




# 4.-
#Appropriately labels the data set with descriptive variable names.
names(selectedData) <- gsub("^t", "Time", names(selectedData))
names(selectedData) <- gsub("Acc", "Accelerometer", names(selectedData))
names(selectedData) <- gsub("mean", "Mean", names(selectedData))
names(selectedData) <- gsub("\\(\\)", "", names(selectedData))
names(selectedData) <- gsub("std", "Standard", names(selectedData))
names(selectedData) <- gsub("Gyro", "Gyroscope", names(selectedData))
names(selectedData) <- gsub("Mag", "Magnitude", names(selectedData))
names(selectedData) <- gsub("Freq", "Frequency", names(selectedData))
names(selectedData) <- gsub("^f", "Frequency", names(selectedData))

#show the column names
names(selectedData)


# 5.-
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
aggregatedData<- aggregate(. ~ SubjectId - Activity, data = selectedData, mean) 
write.table(aggregatedData, "AverageTidyData.txt", row.names = FALSE)
