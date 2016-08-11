library(caret)

train <- read.csv(file="training.csv")
test <- read.csv(file="test.csv")

# Box plot showing the outliers
boxplot(train[,3:13])

hist(train$sig3)
data <- array(train$sig3)
newdata <- data[ which(data <5000)]
hist(newdata, main = paste("Histogram of log(sig3+1)"))

hist(train$sig4)
data <- array(train$sig4)
newdata <- data[ which(data <5000)]
hist(newdata, main = paste("Histogram of log(sig4+1)"))

hist(train$sig5)
data <- array(train$sig5)
newdata <- data[ which(data <5000)]
hist(newdata, main = paste("Histogram of log(sig5+1)"))

hist(train$sig6)
data <- array(train$sig6)
newdata <- data[ which(data <500)]
hist(newdata, main = paste("Histogram of log(sig6)+1"))

#input$relevance <- as.factor(input$relevance)
#input$is_homepage <- as.factor(input$is_homepage)

train$sig3 = log(train$sig3+1)
train$sig4 = log(train$sig4+1)
train$sig5 = log(train$sig5+1)
train$sig6 = log(train$sig6+1)

input = train[,3:13]

numericInput <- input

# No need to remove factors, use them as numbers
#numericInput = input[, -c(2, 11)]

names(numericInput)
covar = cor(numericInput)

# testing sig3 and sig5
cor.test(numericInput[,c(4)],numericInput[,c(6)])
# testing sig5 and sig6
cor.test(numericInput[,c(6)],numericInput[,c(7)])

comboInfo <- findLinearCombos(numericInput) 
comboInfo # no linear dependence found

nzv <- nearZeroVar(numericInput, saveMetrics= TRUE)
nzv # None of the variables are problematic - having near zero variance

prop.table(table(input$relevance))# enough observations for each class of response variable

summary(input)
dim(input)


# outlierKD(input, query_length) # 7910 - 11%
# outlierKD(input, is_homepage) # 0
# outlierKD(input, relevance) # 0
# outlierKD(input, sig1) # 3816 - 5%
# outlierKD(input, sig2) # 0
# outlierKD(input, sig3) # 11705 - 17%
# outlierKD(input, sig4) # 7967 - 11%
# outlierKD(input, sig5) # 11159 - 16.2%
# outlierKD(input, sig6) # 14942 - 23%
# outlierKD(input, sig7) # 173 - 0.2%
# outlierKD(input, sig8) # 0
# # Outliers - Thanks to https://www.r-bloggers.com/identify-describe-plot-and-remove-the-outliers-from-the-dataset/
# outlierKD <- function(dt, var) {
#   var_name <- eval(substitute(var),eval(dt))
#   na1 <- sum(is.na(var_name))
#   m1 <- mean(var_name, na.rm = T)
#   par(mfrow=c(2, 2), oma=c(0,0,3,0))
#   boxplot(var_name, main="With outliers")
#   hist(var_name, main="With outliers", xlab=NA, ylab=NA)
#   outlier <- boxplot.stats(var_name)$out
#   mo <- mean(outlier)
#   var_name <- ifelse(var_name %in% outlier, NA, var_name)
#   boxplot(var_name, main="\n\nWithout outliers")
#   hist(var_name, main="\n\nWithout outliers", xlab=NA, ylab=NA)
#   title("\n\nOutlier Check", outer=TRUE)
#   na2 <- sum(is.na(var_name))
#   cat("\n\nOutliers identified:", na2 - na1, "n")
#   cat("\n\nPropotion (%) of outliers:", round((na2 - na1) / sum(!is.na(var_name))*100, 1), "n")
#   cat("\n\nMean of the outliers:", round(mo, 2), "n")
#   m2 <- mean(var_name, na.rm = T)
#   cat("\n\nMean without removing outliers:", round(m1, 2), "n")
#   cat("\n\nMean if we remove outliers:", round(m2, 2), "n")
#   response <- readline(prompt="\n\nDo you want to remove outliers and to replace with NA? [yes/no]: ")
#   if(response == "y" | response == "yes"){
#     dt[as.character(substitute(var))] <- invisible(var_name)
#     assign(as.character(as.list(match.call())$dt), dt, envir = .GlobalEnv)
#     cat("\n\n Outliers successfully removed", "n")
#     return(invisible(dt))
#   } else{
#     cat("\n\n Nothing changed", "n")
#     return(invisible(var_name))
#   }
# }
# 
