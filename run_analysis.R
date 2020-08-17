features <- read.table('/Applications/уроки/R programming/getting and cleaning data/UCI HAR Dataset/features.txt', col.names=c('label', 'feature'))
actlab<- read.table('/Applications/уроки/R programming/getting and cleaning data/UCI HAR Dataset/activity_labels.txt', col.names=c('label', 'activity'))
actlab
#train
subtrain <- read.table('/Applications/уроки/R programming/getting and cleaning data/UCI HAR Dataset/train/subject_train.txt', col.names='Subject ID')
xtrain <- read.table('/Applications/уроки/R programming/getting and cleaning data/UCI HAR Dataset/train/X_train.txt')
ytrain <- read.table('/Applications/уроки/R programming/getting and cleaning data/UCI HAR Dataset/train/y_train.txt')
colnames(xtrain) <- features$feature
colnames(ytrain) <- "activitylabels"
traindata <- cbind(subtrain,xtrain,ytrain)


#test
subtest <- read.table('/Applications/уроки/R programming/getting and cleaning data//UCI HAR Dataset/test/subject_test.txt', col.names='Subject ID')
xtest <- read.table('/Applications/уроки/R programming/getting and cleaning data//UCI HAR Dataset/test/X_test.txt')
ytest <- read.table('/Applications/уроки/R programming/getting and cleaning data//UCI HAR Dataset/test/y_test.txt')
colnames(xtest) <- features$feature
colnames(ytest) <- "activitylabels"
testdata <- cbind(subtest,xtest,ytest)
View(testdata)

#merging data sets 
data <- rbind(traindata,testdata)

#finding columns with mean and SD

mean.sd<- data[, c(1, grep( pattern = 'mean|std', x = names(data)), 563)]


#add descriptive activity names to the data set
mean.sd$activitylabels <- as.factor(mean.sd$activitylabels)
mean.sd$activity <- factor(mean.sd$activitylabels,
                              levels = actlab$label,
                              labels = actlab$activity)

#rename columns and change the order 

colnames(mean.sd) <- gsub("[(])","",names(mean.sd))
mean.sd <- mean.sd[ ,c(1,81,82, 2:80)]

#independant new clean data set 
library(dplyr)
tidydata <-(mean.sd%>% 
              group_by('Subject ID')%>%
              group_by(activity)%>%
              summarise_all(mean))
write.csv(tidydata,"/Applications/уроки/R programming/getting and cleaning data/UCI HAR Dataset/tidy data.csv", row.names = FALSE)
