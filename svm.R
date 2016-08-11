# Support Vector Machines
library(caret)
library(plyr)         # Used by caret
library(kernlab)       # support vector machine 
library(pROC)	       # plot the ROC curves

raw_train <- read.csv(file="training.csv")
raw_test <- read.csv(file="test.csv")

train = raw_train
test = raw_test

# Correct the data types
train$relevance <- as.factor(train$relevance)
#train$is_homepage <- as.factor(train$is_homepage)

train$relevance <- revalue(train$relevance, c("1"="Yes", "0"="No"))

# we use 80% for training and rest for validation
set.seed(2325)
inTraining <- createDataPartition(train$relevance, p = .8, list = FALSE)
training <- train[ inTraining,]
testing  <- train[-inTraining,]

trainX = training[,-c(1,2,13)] # we want all numeric predictors.
testX = testing[,-c(1,2,13)]

# Setup for cross validation
ctrl <- trainControl(method="cv",  
                     number = 3,  # 9 fold cross validation
                     summaryFunction=twoClassSummary,	# Use Area under the ROC curve to pick the best model
                     classProbs=TRUE)
set.seed(2325)
svm.tune <- train(x = trainX,
                  y = training$relevance,
                  method = "svmRadialWeights",   #  kernel used
                  tuneLength = 2,					# 9 values of the cost function
                  preProc = c("center","scale"),  # Center and scale data
                  metric="ROC",
                  trControl=ctrl)

train.pred <- predict(svm.tune, testX)
table(testing$relevance, train.pred)
mean(testing$relevance!=train.pred)*100


