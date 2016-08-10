# Naive Bayes - 39.50229 error rate

# k for K-FOLD CROSS VALIDATION
k = 9

# I use caret instead of e1071 cause I want to use cross validation
library('caret')

train <- read.csv(file="training.csv")
test <- read.csv(file="test.csv")

# Correct the data types
train$relevance <- as.factor(train$relevance)
train$is_homepage <- as.factor(train$is_homepage)

predictors = train[,3:12]
response = train[,13]

# I use K-fold cross validation - "cv"
train_control <- trainControl(method="cv", number=k)

# I train the naive bayes model - http://topepo.github.io/caret/Bayesian_Model.html
fit_nb <- train(predictors, response, method = "nb", trControl=train_control)

pred_nb = predict(fit_nb)
error_nb = mean(response != pred_nb)*100

cat("Error rate for normal Naive Bayes: ", error_nb)
