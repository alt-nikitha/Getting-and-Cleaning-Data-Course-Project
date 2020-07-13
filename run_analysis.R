#train data
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/Y_train.txt")
s_train <- read.table("train/subject_train.txt")

# test data
x_test <- read.table( "test/X_test.txt")
y_test <- read.table( "test/Y_test.txt")
s_test <- read.table("test/subject_test.txt")

# Merge the training and the test sets to create one data set.
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)


# feature info
feature <- read.table("features.txt")

# Use descriptive activity names to name the activities in the data set
a_label <- read.table("activity_labels.txt")
a_label[,2] <- as.character(a_label[,2])

# Extract only the measurements on the mean and standard deviation for each measurement.
selectedCols <- grep("-(mean|std).*", as.character(feature[,2]))
selectedColNames <- feature[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)


# Extract data by cols & using descriptive name
x_data <- x_data[selectedCols]
allData <- cbind(s_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2])
allData$Subject <- as.factor(allData$Subject)


# Create a second, independent tidy data set with the average of each variable for each activity and each subject.
meltedData <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)

write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)