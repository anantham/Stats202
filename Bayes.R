# Naive Bayes

# Error rate for normal Naive Bayes with and without scaleing:  40.11119
# Error rate for normal Naive Bayes without sig5: 39.73638 (without scaling = 39.76137)

# from  e1071 I got 39.87381 error rate -> 39.54898

# k for K-FOLD CROSS VALIDATION
k = 9

# I use caret instead of e1071 cause I want to use cross validation
library('caret')
library(pROC)

raw_train <- read.csv(file="training.csv")
raw_test <- read.csv(file="test.csv")

train = raw_train
test = raw_test

# Correct the data types
train$relevance <- as.factor(train$relevance)
train$is_homepage <- as.factor(train$is_homepage)
train$relevance <- revalue(train$relevance, c("1"="Yes", "0"="No"))

# we use 80% for training and rest for validation
set.seed(2325)
inTraining <- createDataPartition(train$relevance, p = .8, list = FALSE)
training <- train[ inTraining,]
testing  <- train[-inTraining,]

# index 9 is for sig5
train.predictors = training[,-c(1,2,9,13)]
train.response = training[,13]

test.predictors = testing[,-c(1,2,9,13)]
test.response = testing[,13]

# I use K-fold cross validation - "cv"
train_control <- trainControl(method='cv', number=k, returnResamp='none', summaryFunction = twoClassSummary, classProbs = TRUE)

# I train the naive bayes model
fit_nb <- train(train.predictors, train.response, method = "nb", trControl=train_control, metric = "ROC")

pred_nb = predict(fit_nb, test.predictors)
error_nb = mean(test.response != pred_nb)*100

cat("Error rate for normal Naive Bayes: ", error_nb)
