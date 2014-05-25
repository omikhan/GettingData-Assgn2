###########################Get Training data##########################

## get training activity codes..
train.activity <- read.table(".\\UCI HAR Dataset\\train\\y_train.txt", header=F, col.names=c("Activity.Code"))
## get the labels for acitivities..
activity.labels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt", header=F,  col.names=c("Activity.Code", "Activity.Desc"))
## merge activity labels into train.activity dataset. 
train.activity <- merge(train.activity, activity.labels)


## get the subject id for the training data..
train.subject.data <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt", header=F, col.names=c("Subject.ID"))

# read the column names
feature.names <- read.table(".\\UCI HAR Dataset\\features.txt", header=F, as.is=T, col.names=c("Feature.ID", "Feature.Name"))

# read the X training data 
x.train <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt", header=F, col.names=feature.names$Feature.Name)

# features having mean and standard deviation..
required.features <- grep(".*mean\\(\\)|.*std\\(\\)", feature.names$Feature.Name)

# get only the required feature data..
x.train <- x.train[,required.features]

# now add subject and activity data in the data set..
x.train$Activity.Code <- train.activity$Activity.Code
x.train$Activity.Desc <- train.activity$Activity.Desc
x.train$Subject.ID <- train.subject.data$Subject.ID

###########################################################

###########################Get Testing data##########################

## get testing activity codes..
test.activity <- read.table(".\\UCI HAR Dataset\\test\\y_test.txt", header=F, col.names=c("Activity.Code"))
## get the labels for acitivities..
activity.labels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt", header=F,  col.names=c("Activity.Code", "Activity.Desc"))
## merge activity labels into test.activity dataset. 
test.activity <- merge(test.activity, activity_labels)


## get the subject id for the testing data..
test.subject.data <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt", header=F, col.names=c("Subject.ID"))

# read the X test data 
x.test <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt", header=F, col.names=feature.names$Feature.Name)


# get only the required feature data..
x.test <- x.test[,required.features]

# now add subject and activity data in the data set..
x.test$Activity.Code <- test.activity$Activity.Code
x.test$Activity.Desc <- test.activity$Activity.Desc
x.test$Subject.ID <- test.subject.data$Subject.ID

###########################################################

#####Combine Training and Test Data################

combined.data <- rbind(x.train, x.test)


###########################################################
#################Reshape data##############################

library(reshape2)

# melt the dataset
id.cols = c("Activity.Code", "Activity.Desc", "Subject.ID")
feature.cols = setdiff(colnames(combined.data), id.cols)
melted_data <- melt(combined.data, id=id.cols, feature.cols=feature.cols)

# recast
tidyData <- dcast(melted_data, Activity.Desc + Subject.ID ~ variable, mean)

###########output tidy table...################################

write.table(tidyData, "tidyData.txt")
