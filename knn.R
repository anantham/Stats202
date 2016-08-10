# KNN  41.53654%  after scaling its 34.25%
library(class)

train <- read.csv(file="training.csv")
test <- read.csv(file="test.csv")

# Correct the data types
train$relevance <- as.factor(train$relevance)

# Because the KNN classifier predicts the class of a given test observation by
# identifying the observations that are nearest to it, the scale of the variables
# matters. Any variables that are on a large scale will have a much larger
# effect on the distance between the observations, and hence on the KNN
# classifier, than variables that are on a small scale.

train_indices = sample(1:dim(train)[1], dim(train)[1]*0.8)

aTrain <- train[train_indices, ]
vTrain <- train[-train_indices, ]

# A matrix containing the predictors associated with the data for train and test
train.X = scale(cbind(aTrain[,3:12]))
test.X = scale(cbind(vTrain[,3:12]))
# A vector containing the class labels for the training observations
train.relevance = aTrain$relevance
train.err <- rep(NA, length(lambdas))
# Tuning for k using LOOCV
for(i in seq(200,300,5)){
  cross = knn.cv(train.X,train.relevance,k=i)
  table(cross,aTrain$relevance)
  cat("\n\n Error rate for KNN ", mean(cross!=aTrain$relevance)*100)
  cat("\nk = ",i)
}

# A value for K, the number of nearest neighbors to be used by the classifier
k = 300
set.seed(2325)
knn.pred = knn(train.X, test.X, train.relevance, k)
table(knn.pred,vTrain$relevance)
cat("\n\n Error rate for KNN ", mean(knn.pred!=vTrain$relevance)*100)



# RESULTS - before scaling
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

# After scaling
# Error rate for KNN  42.29856 - 1
# Error rate for KNN  43.37914 - 2
# Error rate for KNN  39.05059 - 5 
# Error rate for KNN  37.83885 - 10 
# Error rate for KNN  35.64022 - 20
# Error rate for KNN  34.57214 - 50
# Error rate for KNN  34.20987 - 100
# Error rate for KNN  34.26608 - 150
# Error rate for KNN  34.23485 - 200

# (200,250,300,350,400,450)
# Error rate for KNN  34.27858
# 
# Error rate for KNN  34.14116
# 
# Error rate for KNN  34.25359
# 
# Error rate for KNN  34.35978
# 
# Error rate for KNN  34.36602
# 
# Error rate for KNN  34.22861

# Cross validation - c(1,2,5,10,15,40,70,100,150,200,300,400,500,600,700)

# Error rate for KNN  42.37304
# 
# Error rate for KNN  42.38709
# 
# Error rate for KNN  38.63296
# 
# Error rate for KNN  37.30558
# 
# Error rate for KNN  35.97664
# 
# Error rate for KNN  34.68674
# 
# Error rate for KNN  34.45562
# 
# Error rate for KNN  34.31507
# 
# Error rate for KNN  34.14642
# 
# Error rate for KNN  34.08551
# 
# Error rate for KNN  34.0293
# 
# Error rate for KNN  34.0699

# CV of KNN in 300 to 400

# Error rate for KNN  34.00587
# k =  300
# 
# Error rate for KNN  34.03554
# k =  305
# 
# Error rate for KNN  34.0293
# k =  310
# 
# Error rate for KNN  33.99963
# k =  315
# 
# Error rate for KNN  34.04804
# k =  320
# 
# Error rate for KNN  33.99963
# k =  325
# 
# Error rate for KNN  34.03086
# k =  330
# 
# Error rate for KNN  34.02773
# k =  335
# 
# Error rate for KNN  34.05428
# k =  340
# 
# Error rate for KNN  34.01836
# k =  345
# 
# Error rate for KNN  34.01993
# k =  350
# 
# Error rate for KNN  34.05741
# k =  355
# 
# Error rate for KNN  34.03867
# k =  360
# 
# Error rate for KNN  34.08864
# k =  365
# 
# Error rate for KNN  34.09488
# k =  370
# 
# Error rate for KNN  34.09801
# k =  375
# 
# Error rate for KNN  34.08864
# k =  380
# 
# Error rate for KNN  34.11831
# k =  385
# 
# Error rate for KNN  34.08551
# k =  390
# 
# Error rate for KNN  34.07302
# k =  395
# 
# Error rate for KNN  34.08239
# k =  400
