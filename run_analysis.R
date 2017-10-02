# download file
zipfile1 <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "getandcleanwk4.zip")
# unzip file
cleandata <- unzip("getandcleanwk4.zip", exdir = "getandcleanwk4")
# trainings tables:
x_train <- read.table("./getandcleanwk4/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./getandcleanwk4/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./getandcleanwk4/UCI HAR Dataset/train/subject_train.txt")
# testing tables:
x_test <- read.table("./getandcleanwk4/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./getandcleanwk4/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./getandcleanwk4/UCI HAR Dataset/test/subject_test.txt")
# feature vector:
features <- read.table('./getandcleanwk4/UCI HAR Dataset/features.txt')
# activity labels:
activityLabels = read.table('./getandcleanwk4/UCI HAR Dataset/activity_labels.txt')
# assigning colnames
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# merging together
mergetrain <- cbind(y_train, subject_train, x_train)
mergetest <- cbind(y_test, subject_test, x_test)
alltogether <- rbind(mergetrain, mergetest)

# colnames merged data
colNames <- colnames(alltogether)

# mean and std
meanandstd <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) )

# subset data
meanandstd2 <- alltogether[ , meanandstd == TRUE]
actnames <- merge(meanandstd2, activityLabels, by='activityId', all.x=TRUE)

# second tidy set
secondtidyset <- aggregate(. ~subjectId + activityId, actnames, mean)
secondtidyset <- secondtidyset[order(secondtidyset$subjectId, secondtidyset$activityId),]

# write second set in txt file
write.table(secondtidyset, "secTidySet.txt", row.name=FALSE)
