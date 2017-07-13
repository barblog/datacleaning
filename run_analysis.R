# install and load package
install.packages("reshape2")
library(reshape2)

# download and unzip file
url1 = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename = "data.zip"
if (!file.exists(filename)){
    download.file(url1,filename,method = "curl")
}
if (!file.exists("UCI HAR Dataset")) {
    unzip(filename)
}

# load activity labels and features
activitylabel = read.table("UCI HAR Dataset/activity_labels.txt")
feature = read.table("UCI HAR Dataset/features.txt")
activitylabel[,2] = as.character(activitylabel[,2])
feature[,2] = as.character(feature[,2])

# get only the mean and std data
targetfeaturerows = grep(".*mean.*|.*std.*",feature[,2])
targetfeature = feature[targetfeaturerows,2]
targetfeature = gsub("[-()]","",targetfeature)
targetfeature = gsub("mean","Mean",targetfeature)
targetfeature = gsub("std","Std",targetfeature)

# load and combine data
train = read.table("UCI HAR Dataset/train/X_train.txt")[targetfeaturerows]
trainactivity = read.table("UCI HAR Dataset/train/Y_train.txt")
trainsubject = read.table("UCI HAR Dataset/train/subject_train.txt")
train1 = cbind(trainsubject, trainactivity, train)

test = read.table("UCI HAR Dataset/test/X_test.txt")[targetfeaturerows]
testactivity = read.table("UCI HAR Dataset/test/Y_test.txt")
testsubject = read.table("UCI HAR Dataset/test/subject_test.txt")
test1 = cbind(testsubject, testactivity, test)

alldata = rbind(test1,train1)
colnames(alldata) = c("subject","activity",targetfeature)

# change activity and subject into factors
alldata$activity = factor(alldata$activity, levels = activitylabel[,1], labels = activitylabel[,2])
alldata$subject = as.factor(alldata$subject)

# melt and create dataset with average for each group (each subject's each activity)
melted = melt(alldata, id = c("subject", "activity"))
avgdata = dcast(melted, subject + activity ~ variable, mean)

# write new file
write.table(avgdata, "tidy.txt", row.names = FALSE, quote = FALSE)
