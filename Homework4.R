# Homework 4 - chapter 8
library(ISLR)

# Problem 10
data("Hitters")

# (a)
# lucky for us "NA"'s only exisit in salary in our data
Hitters <- na.omit(Hitters)

logHitters = Hitters
#logHitters$Salary <- log(logHitters$Salary)

hist(Hitters$Salary)
hist(logHitters$Salary)


# extract "log(Salary)" data vector
logSalary = logHitters$Salary
n = length(logSalary)

mean.logSalary = mean(logSalary)
var.logSalary = var(logSalary)
sd.logSalary = sd(logSalary)

# set n points in the interval (0,1)
# use the formula k/(n+1), for k = 1,..,n
# this is a vector of the n probabilities
probabilities = (1:n)/(n+1)

# calculate normal quantiles using mean and standard deviation from "logSalary"
normal.quantiles = qnorm(probabilities, mean(logSalary , na.rm = T), sd(logSalary , na.rm = T))

# normal quantile-quantile plot for "logSalary"
plot(sort(normal.quantiles), sort(logSalary) , xlab = 'Theoretical Quantiles from Normal Distribution', ylab = 'Sample Quqnatiles of logSalary', main = 'Normal Quantile-Quantile Plot of logSalary')
abline(0,1)

# (b)
trainIndex <- 1:200
logHitters.train <- logHitters[trainIndex, ]
logHitters.test <- logHitters[-trainIndex, ]

# (c)
library(gbm)

set.seed(2016)
# From -10 to -0.2 by increments of 0.1
pows <- seq(-10, -0.2, by = 0.1)

# shrinkage parameter
lambdas <- 10^pows

train.err <- rep(NA, length(lambdas))

for (i in 1:length(lambdas)) {
  logBoost.hitters <- gbm(Salary ~ ., data = logHitters.train, distribution = "gaussian", n.trees = 1000, shrinkage = lambdas[i])
  pred.train <- predict(logBoost.hitters, logHitters.train, n.trees = 1000)
  train.err[i] <- mean((pred.train - logHitters.train$Salary)^2)
}

plot(lambdas, train.err, type = "b", xlab = "Shrinkage values", ylab = "Training MSE")

# (d)
set.seed(2016)
test.err <- rep(NA, length(lambdas))
for (i in 1:length(lambdas)) {
  boost.hitters <- gbm(Salary ~ ., data = logHitters.train, distribution = "gaussian", n.trees = 1000, shrinkage = lambdas[i])
  yhat <- predict(boost.hitters, logHitters.test, n.trees = 1000)
  test.err[i] <- mean((yhat - logHitters.test$Salary)^2)
}
plot(lambdas, test.err, type = "b", xlab = "Shrinkage values", ylab = "Test MSE")

# (e)
library(glmnet)

fit1 <- lm(Salary ~ ., data = logHitters.train)
pred1 <- predict(fit1, logHitters.test)
# Test MSE for 
mean((pred1 - logHitters.test$Salary)^2)

x <- model.matrix(Salary ~ ., data = logHitters.train)
x.test <- model.matrix(Salary ~ ., data = logHitters.test)
y <- logHitters.train$Salary
# alpha = 0 means this is ridge regression 
fit2 <- glmnet(x, y, alpha = 0)
# I am using 0.01 as my lamda 
pred2 <- predict(fit2, s = 0.01, newx = x.test)
# Test MSE
mean((pred2 - logHitters.test$Salary)^2)

# (f)
finalLambda = lambdas[which.min(test.err)]
boost.hitters <- gbm(Salary ~ ., data = logHitters.train, distribution = "gaussian", n.trees = 1000, shrinkage = finalLambda)
summary(boost.hitters)

# (g)
set.seed(2016)
library(randomForest)
# As we are doing bagging we use all 19 predictors at every split, 500 seems enough 
bag.hitters <- randomForest(Salary ~ ., data = logHitters.train, mtry = 19, ntree = 500)
yhat.bag <- predict(bag.hitters, newdata = logHitters.test)
mean((yhat.bag - logHitters.test$Salary)^2)


# Problem 11
library(gbm)

# (a)
set.seed(2016)
train <- 1:1000
Caravan$Purchase <- ifelse(Caravan$Purchase == "Yes", 1, 0)
Caravan.train <- Caravan[train, ]
Caravan.test <- Caravan[-train, ]

# (b)
set.seed(2016)
boost.caravan <- gbm(Purchase ~ ., data = Caravan.train, distribution = "gaussian", n.trees = 1000, shrinkage = 0.01)
summary(boost.caravan)

# (c)
set.seed(2016)
# Use the fraction of the trees saying "yes" to calculate probability 
probs.test <- predict(boost.caravan, Caravan.test, n.trees = 1000, type = "response")
pred.test <- ifelse(probs.test > 0.2, 1, 0)
table(Caravan.test$Purchase, pred.test)

conf = table(Caravan.test$Purchase, pred.test)
plot(conf)

# binomial logistic regression
logit.caravan <- glm(Purchase ~ ., data = Caravan.train, family = "binomial")
probs.test2 <- predict(logit.caravan, Caravan.test, type = "response")

pred.test2 <- ifelse(probs.test2 > 0.2, 1, 0)
conf_log = table(Caravan.test$Purchase, pred.test2)
plot(conf_log)

#Knn TODO 20 percernt propotion
library(class)
train.X <- as.matrix(Caravan.train)
test.X <- as.matrix(Caravan.test)

set.seed(2016)
prob.knn <- knn(train.X, test.X, Caravan.train$Purchase, k = 10, l = 0, prob = TRUE, use.all = FALSE)
r=attr(prob.knn, "probabilities")

pred.test3 <- ifelse(prob.knn > 0.2, 1, 0)
conf_knn = table(Caravan.test$Purchase, prob.knn )
plot(conf_knn)

# Chapter 9 Problem 1

# I GIVE UP - I drew it by hand LOL

# Problem 8
library(e1071)
data(OJ)
set.seed(2016)
# Get a "random" sample of 800 observations
train_indices = sample(1:dim(OJ)[1], 800)
OJ.train <- OJ[train_indices, ]
OJ.test <- OJ[-train_indices, ]

# We can think of the cost as a budget for the amount that the margin can be violated 
svm.linear = svm(Purchase~., data = OJ.train, kernel ="linear", cost = 0.01)
summary(svm.linear)

train.pred <- predict(svm.linear, OJ.train)
table(OJ.train$Purchase, train.pred)
mean(OJ.train$Purchase!=train.pred)

test.pred <- predict(svm.linear, OJ.test)
table(OJ.test$Purchase, test.pred)
mean(OJ.test$Purchase!=test.pred)


set.seed(2016)
tune.out <- tune(svm, Purchase ~ ., data = OJ.train, kernel = "linear", ranges = list(cost = 10^seq(-2, 1, by = 0.25)))
summary(tune.out)

tuneCost = tune.out$best.parameter$cost

svm.linear <- svm(Purchase ~ ., kernel = "linear", data = OJ.train, cost = 0.01 )
train.pred <- predict(svm.linear, OJ.train)
table(OJ.train$Purchase, train.pred)
mean(OJ.train$Purchase!=train.pred)*100

test.pred <- predict(svm.linear, OJ.test)
table(OJ.test$Purchase, test.pred)
mean(OJ.test$Purchase!=test.pred)*100


svm.radial <- svm(Purchase ~ ., kernel = "radial", data = OJ.train)
summary(svm.radial)

# Radial with default gamma
train.pred <- predict(svm.radial, OJ.train)
table(OJ.train$Purchase, train.pred)
mean(OJ.train$Purchase!=train.pred)*100

test.pred <- predict(svm.radial, OJ.test)
table(OJ.test$Purchase, test.pred)
mean(OJ.test$Purchase!=test.pred)*100

# Tune for optimal gamma
set.seed(2016)
tune.out <- tune(svm, Purchase ~ ., data = OJ.train, kernel = "radial", ranges = list(cost = 10^seq(-2, 1, by = 0.25)))
summary(tune.out)

svm.radial <- svm(Purchase ~ ., kernel = "radial", data = OJ.train, cost = tune.out$best.parameter$cost)
summary(svm.radial)

# Radial with optimal gamma
train.pred <- predict(svm.radial, OJ.train)
table(OJ.train$Purchase, train.pred)
mean(OJ.train$Purchase!=train.pred)*100

test.pred <- predict(svm.radial, OJ.test)
table(OJ.test$Purchase, test.pred)
mean(OJ.test$Purchase!=test.pred)*100

# Polynomial 
svm.poly <- svm(Purchase ~ ., kernel = "polynomial", data = OJ.train, degree = 2)
summary(svm.poly)

train.pred <- predict(svm.poly, OJ.train)
table(OJ.train$Purchase, train.pred)