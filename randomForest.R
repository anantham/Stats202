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

# One of the benefits of decision trees is that ordinal (continuous or discrete) input data does not require
# any significant preprocessing. In fact, the results should be consistent regardless of any scaling or 
# translational normalization, since the trees can choose equivalent splitting points. 

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