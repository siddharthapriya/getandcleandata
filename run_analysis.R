library(data.table)

#Download the zipped file from the weblink locally and then extract the directory UCI HAR Dataset
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "dataset.zip") #R studio running on windows machine
unzip("dataset.zip")

# Source files from the directory for various operations
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
test_data_acty <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
test_data_subt <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
train_data_acty <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
train_data_subt <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)

# Using the labels in the activity_labels file name the activites descriptively
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
test_data_acty$V1 <- factor(test_data_acty$V1,levels=activities$V1,labels=activities$V2)
train_data_acty$V1 <- factor(train_data_acty$V1,levels=activities$V1,labels=activities$V2)

# Appropriately labels the data set with descriptive activity names
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
colnames(test_data)<-features$V2
colnames(train_data)<-features$V2
colnames(test_data_acty)<-c("Activity")
colnames(train_data_acty)<-c("Activity")
colnames(test_data_subt)<-c("Subject")
colnames(train_data_subt)<-c("Subject")

# Merge test and training sets into one data set
test_data<-cbind(test_data,test_data_acty)
test_data<-cbind(test_data,test_data_subt)
train_data<-cbind(train_data,train_data_acty)
train_data<-cbind(train_data,train_data_subt)
combine_data<-rbind(test_data,train_data)

# Extract the mean and standard deviation for each measurement
combine_data_mean<-sapply(combine_data,mean,na.rm=TRUE)
combine_data_sd<-sapply(combine_data,sd,na.rm=TRUE)

# Creates the tidy data set tidy_data
DT <- data.table(combine_data)
tidy_data <- DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy_data,file="tidy_data.csv",sep=",",row.names = FALSE)
