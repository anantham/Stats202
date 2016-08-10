# Boosting 33.44785% (without sig5 - 33.41037%)
library(pROC)
library(caret)
library(plyr)

train <- read.csv(file="training.csv")

# Correct the data types
train$relevance <- as.factor(train$relevance)
train$is_homepage <- as.factor(train$is_homepage)
train$relevance <- revalue(train$relevance, c("1"="Yes", "0"="No"))

train = train[,-c(1,2)] # Remove ID's
names(train)

set.seed(2325)
train_indices = sample(1:dim(train)[1], dim(train)[1]*1)
aTrain <- train[train_indices, ]
vTrain <- train[-train_indices, ]

outcomeName = "relevance"
predictorsNames =  names(aTrain)[names(aTrain)!=outcomeName]

# Tuning parameters 
objControl <- trainControl(method='cv', number=9, returnResamp='none', summaryFunction = twoClassSummary, classProbs = TRUE)


set.seed(2325)
objModel <- train(aTrain[,predictorsNames],
                  aTrain[,outcomeName],
                  method='gbm',
                  trControl=objControl,
                  metric = "ROC", # because its a classification model.
                  preProc = c("center", "scale")) # preprocessing done guys!

#  the splitting of nodes can cease when a certain number of observations are in each node - minobsinnode
objModel$bestTune

predictions <- predict(object=objModel, vTrain[,predictorsNames], type='raw')

table(vTrain$relevance,predictions)
mean(vTrain$relevance!=predictions)*100

test <- read.csv(file="test.csv")
inputTest = test[,-c(1,2)]
predictions <- predict(object=objModel, inputTest[,predictorsNames], type='raw')
write.table(predictions,file="actualSolutions.txt",quote=F,row.names = F,col.names = F)