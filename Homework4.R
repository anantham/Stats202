# Homework 4
library(ISLR)
data("Hitters")

# (a)
Hitters <- na.omit(Hitters)

logHitters = Hitters
logHitters$Salary <- log(logHitters$Salary)

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
mean((pred1 - logHitters.test$Salary)^2)

x <- model.matrix(Salary ~ ., data = logHitters.train)
x.test <- model.matrix(Salary ~ ., data = logHitters.test)
y <- logHitters.train$Salary
fit2 <- glmnet(x, y, alpha = 0)
pred2 <- predict(fit2, s = 0.01, newx = x.test)
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
