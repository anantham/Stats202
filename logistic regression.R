
# Logistic regression model  -Fitting log-odds to be linear in X

# 36.41474 -> 36.40225% Error rates

train <- read.csv(file="training.csv")
test <- read.csv(file="test.csv")


# Correct the data types
train$relevance <- as.factor(train$relevance)
train$is_homepage <- as.factor(train$is_homepage)

train_indices = sample(1:dim(train)[1], dim(train)[1]*0.8)

aTrain <- train[train_indices, ]
vTrain <- train[-train_indices, ]

glm.fit = glm(relevance~., data=aTrain , family=binomial )
glm.fit1 = glm(relevance~query_length+is_homepage+sig1+sig2+sig6+sig7+sig8, data=aTrain , family=binomial )

summary(glm.fit)
summary(glm.fit1)

glm.probs = predict(glm.fit, vTrain)
glm.pred = rep(0 ,dim(vTrain)[1])
glm.pred[glm.probs >.5] = 1
cat("Error rate for logistic regression with all predictors: ", mean(glm.pred!=vTrain$relevance)*100)

glm.probs1 = predict(glm.fit1, vTrain)
glm.pred1 = rep(0 ,dim(vTrain)[1])
glm.pred1[glm.probs1 >.5] = 1
cat("Error rate for logistic regression using query_length,is_homepage, sig1, sig2, sig6, sig7, sig8 as predictors is", mean(glm.pred1!=vTrain$relevance)*100)
