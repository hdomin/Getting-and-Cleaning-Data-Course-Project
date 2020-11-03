## Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Check the /UCI HAR Dataset/README.txt file for further details about this dataset.

A video of the experiment including an example of the 6 recorded activities with one of the participants can be seen in the following link: [Web Link](http://www.youtube.com/watch?v=XOEN9W05_4A)

An updated version of this dataset can be found at [Web Link](http://archive.ics.uci.edu/ml/datasets/Smartphone-Based+Recognition+of+Human+Activities+and+Postural+Transitions). It includes labels of postural transitions between activities and also the full raw inertial signals instead of the ones pre-processed into windows.


## Attribute Information:

For each record in the dataset it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

Ref. (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)


## Feature Selection 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
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

The set of variables that were estimated from these signals are: 

mean(): Mean value  
std(): Standard deviation  
mad(): Median absolute deviation   
max(): Largest value in array  
min(): Smallest value in array  
sma(): Signal magnitude area  
energy(): Energy measure. Sum of the squares divided by the number of values.   
iqr(): Interquartile range   
entropy(): Signal entropy  
arCoeff(): Autorregresion coefficients with Burg order equal to 4  
correlation(): correlation coefficient between two signals  
maxInds(): index of the frequency component with largest magnitude  
meanFreq(): Weighted average of the frequency components to obtain a mean frequency  
skewness(): skewness of the frequency domain signal   
kurtosis(): kurtosis of the frequency domain signal   
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.  
angle(): Angle between to vectors.  

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean  
tBodyAccMean  
tBodyAccJerkMean  
tBodyGyroMean  
tBodyGyroJerkMean  

The complete list of variables of each feature vector is available in 'features.txt'



## Code and transformation data

### Getting the data
Download Dataset, initialize the url where is the zipped files and the filename to save in the local disk. Then unzip the file
```
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "dataset.zip"

download.file(url, filename)
unzip(filename)
```

### 1.- Merges the training and the test sets to create one data set.
Import the data.table library and read each file and save in a table, test and train data.
For train data:  
x_train: contains the data values
y_train: contains the activities values
s_train: contains the subjects values

For test data:  
x_test: contains the data values
y_test: contains the activities values
s_test: contains the subjects values

```
library(data.table)

# read the train data
x_train <- data.table::fread("./UCI HAR Dataset/train/X_train.txt")
y_train <- data.table::fread("./UCI HAR Dataset/train/Y_train.txt")
s_train <- data.table::fread("./UCI HAR Dataset/train/subject_train.txt")

# read the test data
x_test <- data.table::fread("./UCI HAR Dataset/test/X_test.txt")
y_test <- data.table::fread("./UCI HAR Dataset/test/Y_test.txt")
s_test <- data.table::fread("./UCI HAR Dataset/test/subject_test.txt")
```

Join rows of test and train data, this is the first step to make an only data table
```
# merge the data
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)

# remove train and test data
remove(x_train); remove(y_train); remove(s_train)
remove(x_test); remove(y_test); remove(s_test)
```

Read the list of features to label the data variables (columns), also set the column name for Activity and Subject on the activity a subject data table.
```
# read the list of features
features <- data.table::fread("./UCI HAR Dataset/features.txt")

# set the column names
colnames(x_data) <- features$V2
colnames(y_data) <- c("ActivityId")
colnames(s_data) <- c("SubjectId")
```

Merge (join) the columns of the three data tables, subject, activity, data values
```
# Merges the training and the test sets to create one data set.
allData <- cbind(s_data, y_data, x_data)
```

### 2.- Extracts only the measurements on the mean and standard deviation for each measurement.

selectedFeatures contains all the named variables with mean ans std, then append SubjectId and ActivityId
```
# read the feature and activity table
selectedFeatures <- grep("[mM]ean.*\\(\\)|[sS]td.*\\(\\)",features$V2,value=TRUE)
selectedFeatures <- append(selectedFeatures, c("SubjectId","ActivityId"), after=0 )
```

Get the subset of data selecting only the variables in selectedFeatures of the allData table
```
selectedData <- subset(allData, select=selectedFeatures)
```

### 3.- Uses descriptive activity names to name the activities in the data set
activities contains the list of activities, then change the columns names to prepare to merge with the data table
```
# read the list of activities
activities <- data.table::fread("./UCI HAR Dataset/activity_labels.txt")
colnames(activities) <- c("ActivityId", "Activity")
```

Merge the subset selectedData and activities using "ActivityID" variable
```
selectedData <- merge(selectedData, activities, by = "ActivityId", all =TRUE)
```

### 4.- Appropriately labels the data set with descriptive variable names.
First, list the names of selectedData to check what is needed to change, then change every set of caracters.
```
names(selectedData)
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

```

### 5.- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
aggregatedData contains the result to apply aggregate mean function to each variable and activity
then write the tidy table to a file
```
aggregatedData<- aggregate(. ~ SubjectId - Activity, data = selectedData, mean) 
write.table(aggregatedData, "AverageTidyData.txt")

```
