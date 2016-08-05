# KNN  41.53654%  
library (class)

train <- read.csv(file="training.csv")
test <- read.csv(file="test.csv")

# Correct the data types
train$relevance <- as.factor(train$relevance)
train$is_homepage <- as.factor(train$is_homepage)

train_indices = sample(1:dim(train)[1], dim(train)[1]*0.8)

aTrain <- train[train_indices, ]
vTrain <- train[-train_indices, ]

# A matrix containing the predictors associated with the data for train and test
train.X = cbind(aTrain[,3:12])
test.X = cbind(vTrain[,3:12])
# A vector containing the class labels for the training observations
train.relevance = aTrain$relevance

#A value for K, the number of nearest neighbors to be used by the classifier
k = 150

knn.pred = knn(train.X, test.X, train.relevance ,k)

table(knn.pred,vTrain$relevance)

cat("Error rate for KNN ", mean(knn.pred!=vTrain$relevance)*100)

k_values = c(1,5,10,50,100,150,500,1000)

for (i in k_values){
  cat("\n\n\n k = ",i)
  knn.pred = knn(train.X, test.X, train.relevance ,i)
  cat("\n Error rate for KNN ", mean(knn.pred!=vTrain$relevance)*100)
}


# 
# RESULTS
# k =  1 Error rate for KNN  46.05871
# k =  2 Error rate for KNN  46.35853
# k =  3 Error rate for KNN  45.03435
# k =  4 Error rate for KNN  45.58401
# k =  5 Error rate for KNN  43.8476
# k =  6 Error rate for KNN  44.36602
# k =  7 Error rate for KNN  43.59151
# k =  8 Error rate for KNN  44.00999
# k =  9 Error rate for KNN  43.49781
# k =  10 Error rate for KNN  43.46034
# k =  11 Error rate for KNN  43.34791
# k =  12 Error rate for KNN  43.0356
# k =  13 Error rate for KNN  42.79825
# k =  14 Error rate for KNN  43.01062
# k =  15 Error rate for KNN  42.56715
# k =  16 Error rate for KNN  42.75453
# k =  17 Error rate for KNN  42.38601
# k =  18 Error rate for KNN  42.69831
# k =  19 Error rate for KNN  42.40475
# k =  20 Error rate for KNN  42.49844
