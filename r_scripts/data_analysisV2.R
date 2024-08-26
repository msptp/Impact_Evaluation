#### DATA ANALYSIS SCRIPT ####
# 1. Setup ----
## load packages
library(haven)
library(dplyr)
library(digest)
library(readxl)
library(data.table)
library(corrplot)
library(caret)
library(broom)
library(pROC)
library(reshape2)
library(DataExplorer)
library(car)
library(caTools)

## set working directory
wd <- setwd("C:/Users/Sally.Pham/OneDrive - insidemedia.net/Documents/Personal Development/BPP University/BSc Data Science 1.0/Data Science Professional Practice/0. Assignments/Summative/1. Data/")

# 2. Read in data ----
## read in processed datasets
RC_Surviving <- read.csv("2. Processed/Reality Check/RC_Surviving.csv")
RC_Frustrated <- read.csv("2. Processed/Reality Check/RC_Frustrated.csv")
RC_Resentful <- read.csv("2. Processed/Reality Check/RC_Resentful.csv")
RC_Coping <- read.csv("2. Processed/Reality Check/RC_Coping.csv")
RC_Carefree <- read.csv("2. Processed/Reality Check/RC_Carefree.csv")
RC_Confident <- read.csv("2. Processed/Reality Check/RC_Confident.csv")


# 3. Split data into train & test sets ----
## set seed for reproducability
set.seed(123)

## create data splits
split1 <- createDataPartition(RC_Surviving$target, p = 0.75, list = FALSE)
split2 <- createDataPartition(RC_Frustrated$target, p = 0.75, list = FALSE)
split3 <- createDataPartition(RC_Resentful$target, p = 0.75, list = FALSE)
split4 <- createDataPartition(RC_Coping$target, p = 0.75, list = FALSE)
split5 <- createDataPartition(RC_Carefree$target, p = 0.75, list = FALSE)
split6 <- createDataPartition(RC_Confident$target, p = 0.75, list = FALSE)


## create train and test sets for each dataset
RC_Surviving_train <- RC_Surviving[split1, ]
RC_Surviving_test <- RC_Surviving[-split1, ]

RC_Frustrated_train <- RC_Frustrated[split2, ]
RC_Frustrated_test <- RC_Frustrated[-split2, ]

RC_Resentful_train <- RC_Resentful[split3, ]
RC_Resentful_test <- RC_Resentful[-split3, ]

RC_Coping_train <- RC_Coping[split4, ]
RC_Coping_test <- RC_Coping[-split4, ]

RC_Carefree_train <- RC_Carefree[split5, ]
RC_Carefree_test <- RC_Carefree[-split5, ]

RC_Confident_train <- RC_Confident[split5, ]
RC_Confident_test <- RC_Confident[-split5, ]



# 4. Logistic Regression ----
## logistic regression analysis
RC_Surviving_model <- glm(target ~ ., data = RC_Surviving_train, family = "binomial")
RC_Frustrated_model <- glm(target ~ ., data = RC_Frustrated_train, family = "binomial")
RC_Resentful_model <- glm(target ~ ., data = RC_Resentful_train, family = "binomial")
RC_Coping_model <- glm(target ~ ., data = RC_Coping_train, family = "binomial")
RC_Carefree_model <- glm(target ~ ., data = RC_Carefree_train, family = "binomial")
RC_Confident_model <- glm(target ~ ., data = RC_Confident_train, family = "binomial")

## extract model summary statistics
RC_Surviving_modelsum <- tidy(RC_Surviving_model)
RC_Frustrated_modelsum <- tidy(RC_Frustrated_model)
RC_Resentful_modelsum <- tidy(RC_Resentful_model)
RC_Coping_modelsum <- tidy(RC_Coping_model)
RC_Carefree_modelsum <- tidy(RC_Carefree_model)
RC_Confident_modelsum <- tidy(RC_Confident_model)

## output model stats
# write.csv(RC_Surviving_modelsum, "3. Results/Reality Check/Logistic Regression/RC_Surviving_model_results.csv")
# write.csv(RC_Frustrated_modelsum, "3. Results/Reality Check/Logistic Regression/RC_Frustrated_model_results.csv")
# write.csv(RC_Resentful_modelsum, "3. Results/Reality Check/Logistic Regression/RC_Resentful_model_results.csv")
# write.csv(RC_Coping_modelsum, "3. Results/Reality Check/Logistic Regression/RC_Coping_model_results.csv")
# write.csv(RC_Carefree_modelsum, "3. Results/Reality Check/Logistic Regression/RC_Carefree_model_results.csv")
# write.csv(RC_Confident_modelsum, "3. Results/Reality Check/Logistic Regression/RC_Confident_model_results.csv")


# 5. Model Evaluation ----
## run the logistic regression model on the test data
## type = response returns the probability of the positive class (i.e. 1) / the likelihood that the observation = 1 based on the input features
RC_Surviving_pred <- predict(RC_Surviving_model, newdata = RC_Surviving_test, type = "response")
RC_Frustrated_pred <- predict(RC_Frustrated_model, newdata = RC_Frustrated_test, type = "response")
RC_Resentful_pred <- predict(RC_Resentful_model, newdata = RC_Resentful_test, type = "response")
RC_Coping_pred <- predict(RC_Coping_model, newdata = RC_Coping_test, type = "response")
RC_Carefree_pred <- predict(RC_Carefree_model, newdata = RC_Carefree_test, type = "response")
RC_Confident_pred <- predict(RC_Confident_model, newdata = RC_Confident_test, type = "response")

## create ROC curves for each model to determine a threshold for each model
par(mar = c(4, 4, 2, 1)) 

roc1 <- roc(RC_Surviving_test$target, RC_Surviving_pred) #create the ROC curve
plot(roc1, main = "ROC Curve for RC_Surviving", col = "blue", lwd = 2) #plot the ROC curve

roc2 <- roc(RC_Frustrated_test$target, RC_Frustrated_pred) #create the ROC curve
plot(roc2, main = "ROC Curve for RC_Frustrated", col = "blue", lwd = 2) #plot the ROC curve

roc3 <- roc(RC_Resentful_test$target, RC_Resentful_pred) #create the ROC curve
plot(roc3, main = "ROC Curve for RC_Resentful", col = "blue", lwd = 2) #plot the ROC curve

roc4 <- roc(RC_Coping_test$target, RC_Coping_pred) #create the ROC curve
plot(roc4, main = "ROC Curve for RC_Coping", col = "blue", lwd = 2) #plot the ROC curve

roc5 <- roc(RC_Carefree_test$target, RC_Carefree_pred) #create the ROC curve
plot(roc5, main = "ROC Curve for RC_Carefree", col = "blue", lwd = 2) #plot the ROC curve

roc6 <- roc(RC_Confident_test$target, RC_Confident_pred) #create the ROC curve
plot(roc6, main = "ROC Curve for RC_Confident", col = "blue", lwd = 2) #plot the ROC curve

## find the optimal threshold for each model
optimal_coords1 <- coords(roc1, "best") #finding the top most left coordinate of the curve
optimal_coords2 <- coords(roc2, "best") #finding the top most left coordinate of the curve
optimal_coords3 <- coords(roc3, "best") #finding the top most left coordinate of the curve
optimal_coords4 <- coords(roc4, "best") #finding the top most left coordinate of the curve
optimal_coords5 <- coords(roc5, "best") #finding the top most left coordinate of the curve
optimal_coords6 <- coords(roc6, "best") #finding the top most left coordinate of the curve

threshold1 <- optimal_coords1$threshold[[1]] #defining the threshold
threshold2 <- optimal_coords2$threshold[[1]] #defining the threshold
threshold3 <- optimal_coords3$threshold[[1]] #defining the threshold
threshold4 <- optimal_coords4$threshold[[1]] #defining the threshold
threshold5 <- optimal_coords5$threshold[[1]] #defining the threshold
threshold6 <- optimal_coords6$threshold[[1]] #defining the threshold

## if the prediction is above the threshold, 1, else, 0
RC_Surviving_binarypredict <- ifelse(RC_Surviving_pred >= threshold1, "1", "0")
RC_Frustrated_binarypredict <- ifelse(RC_Frustrated_pred >= threshold2, "1", "0")
RC_Resentful_binarypredict <- ifelse(RC_Resentful_pred >= threshold3, "1", "0")
RC_Coping_binarypredict <- ifelse(RC_Coping_pred >= threshold4, "1", "0")
RC_Carefree_binarypredict <- ifelse(RC_Carefree_pred >= threshold5, "1", "0")
RC_Confident_binarypredict <- ifelse(RC_Confident_pred >= threshold6, "1", "0")

## converting the test data and the predictions to factors to create confusion matrices
RC_Surviving_binarypredict <- as.factor(RC_Surviving_binarypredict)
RC_Surviving_test$target <- as.factor(RC_Surviving_test$target)

RC_Frustrated_binarypredict <- as.factor(RC_Frustrated_binarypredict)
RC_Frustrated_test$target <- as.factor(RC_Frustrated_test$target)

RC_Resentful_binarypredict <- as.factor(RC_Resentful_binarypredict)
RC_Resentful_test$target <- as.factor(RC_Resentful_test$target)

RC_Coping_binarypredict <- as.factor(RC_Coping_binarypredict)
RC_Coping_test$target <- as.factor(RC_Coping_test$target)

RC_Carefree_binarypredict <- as.factor(RC_Carefree_binarypredict)
RC_Carefree_test$target <- as.factor(RC_Carefree_test$target)

RC_Confident_binarypredict <- as.factor(RC_Confident_binarypredict)
RC_Confident_test$target <- as.factor(RC_Confident_test$target)

## create confusion matrices
cm1 <- confusionMatrix(RC_Surviving_binarypredict, RC_Surviving_test$target)
cm2 <- confusionMatrix(RC_Frustrated_binarypredict, RC_Frustrated_test$target)
cm3 <- confusionMatrix(RC_Resentful_binarypredict, RC_Resentful_test$target)
cm4 <- confusionMatrix(RC_Coping_binarypredict, RC_Coping_test$target)
cm5 <- confusionMatrix(RC_Carefree_binarypredict, RC_Carefree_test$target)
cm6 <- confusionMatrix(RC_Confident_binarypredict, RC_Confident_test$target)

# write.csv(cm1$table, "3. Results/Reality Check/Logistic Regression/RC_Surviving_CM.csv")
# write.csv(cm2$table, "3. Results/Reality Check/Logistic Regression/RC_Frustrated_CM.csv")
# write.csv(cm3$table, "3. Results/Reality Check/Logistic Regression/RC_Resentful_CM.csv")
# write.csv(cm4$table, "3. Results/Reality Check/Logistic Regression/RC_Coping_CM.csv")
# write.csv(cm5$table, "3. Results/Reality Check/Logistic Regression/RC_Carefree_CM.csv")
# write.csv(cm6$table, "3. Results/Reality Check/Logistic Regression/RC_Confident_CM.csv")

## get accuracy, precision, recall and f1 score in 5 separate tables
## RC_Surviving
accuracy <- cm1$overall["Accuracy"]
precision <- cm1$byClass["Precision"]
recall <- cm1$byClass["Sensitivity"]
f1_score <- cm1$byClass["F1"]

RC_Surviving_metrics <- data.frame(
  Metric = c("Accuracy", "Precision", "Recall", "F1 Score"),
  Value = c(accuracy, precision, recall, f1_score)
)

## RC_Frustrated
accuracy <- cm2$overall["Accuracy"]
precision <- cm2$byClass["Precision"]
recall <- cm2$byClass["Sensitivity"]
f1_score <- cm2$byClass["F1"]

RC_Frustrated_metrics <- data.frame(
  Metric = c("Accuracy", "Precision", "Recall", "F1 Score"),
  Value = c(accuracy, precision, recall, f1_score)
)

## RC_Resentful
accuracy <- cm3$overall["Accuracy"]
precision <- cm3$byClass["Precision"]
recall <- cm3$byClass["Sensitivity"]
f1_score <- cm3$byClass["F1"]

RC_Resentful_metrics <- data.frame(
  Metric = c("Accuracy", "Precision", "Recall", "F1 Score"),
  Value = c(accuracy, precision, recall, f1_score)
)

## RC_Coping
accuracy <- cm4$overall["Accuracy"]
precision <- cm4$byClass["Precision"]
recall <- cm4$byClass["Sensitivity"]
f1_score <- cm4$byClass["F1"]

RC_Coping_metrics <- data.frame(
  Metric = c("Accuracy", "Precision", "Recall", "F1 Score"),
  Value = c(accuracy, precision, recall, f1_score)
)

## RC_Carefree
accuracy <- cm5$overall["Accuracy"]
precision <- cm5$byClass["Precision"]
recall <- cm5$byClass["Sensitivity"]
f1_score <- cm5$byClass["F1"]

RC_Carefree_metrics <- data.frame(
  Metric = c("Accuracy", "Precision", "Recall", "F1 Score"),
  Value = c(accuracy, precision, recall, f1_score)
)

## RC_Confident
accuracy <- cm5$overall["Accuracy"]
precision <- cm5$byClass["Precision"]
recall <- cm5$byClass["Sensitivity"]
f1_score <- cm5$byClass["F1"]

RC_Confident_metrics <- data.frame(
  Metric = c("Accuracy", "Precision", "Recall", "F1 Score"),
  Value = c(accuracy, precision, recall, f1_score)
)



# write.csv(RC_Surviving_metrics, "3. Results/Reality Check/Logistic Regression/RC_Surviving_metrics.csv")
# write.csv(RC_Frustrated_metrics, "3. Results/Reality Check/Logistic Regression/RC_Frustrated_metrics.csv")
# write.csv(RC_Resentful_metrics, "3. Results/Reality Check/Logistic Regression/RC_Resentful_metrics.csv")
# write.csv(RC_Coping_metrics, "3. Results/Reality Check/Logistic Regression/RC_Coping_metrics.csv")
# write.csv(RC_Carefree_metrics, "3. Results/Reality Check/Logistic Regression/RC_Carefree_metrics.csv")
# write.csv(RC_Confident_metrics, "3. Results/Reality Check/Logistic Regression/RC_Confident_metrics.csv")

# 6. Appendix ----
# Broom package/Tidy function https://broom.tidymodels.org/reference/tidy.lm.html#:~:text=Tidy%20summarizes%20information%20about%20the,but%20is%20usually%20self%2Devident.
# confusionMatrix function https://www.digitalocean.com/community/tutorials/confusion-matrix-in-r








