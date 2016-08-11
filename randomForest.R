# Bagging and random forests - 34.87% and 34.12%
library(randomForest)

raw_train <- read.csv(file="training.csv")
raw_test <- read.csv(file="test.csv")

train = raw_train
test = raw_test

# Correct the data types
train$relevance <- as.factor(train$relevance)
train$is_homepage <- as.factor(train$is_homepage)

train = train[,-c(1,2)]

train$sig3 = log(train$sig3+1)
train$sig4 = log(train$sig4+1)
train$sig5 = log(train$sig5+1)

set.seed(2325)
# Using all 10 predictors => bagging = bootstrap aggregating
bag.rank = randomForest(relevance~., data=train, ntree=500, mtry=10, importance=TRUE)

#  black solid line for overall OOB error, red for not relevant and green for relevant  
plot(bag.rank)

# OOB error
conf = table(bag.rank$predicted,train$relevance)
mean(bag.rank$predicted!=train$relevance)*100
plot(conf)


set.seed(2325)
# Using default value of mtry
rndForest.rank = randomForest(relevance~., data=train, ntree=1000)
plot(rndForest.rank)

# OOB error
conf = table(rndForest.rank$predicted,train$relevance)
mean(rndForest.rank$predicted!=train$relevance)*100
plot(conf)