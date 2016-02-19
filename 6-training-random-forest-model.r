library(randomForest)

# randomForestModel <- train(
#   ARR_DEL15 ~ .,
#   data=trainDataFiltered,
#   method="rf",
#   proximity = TRUE,
#   importance = TRUE,
#   trControl=trainControl(
#     method="cv",
#     number=10,
#     repeats=10
#   )
# )

# This code will run for a while!
# It ran for ~20 minutes on a Macbook Air.
rfModel <- randomForest(
  trainDataFiltered[-1],
  trainDataFiltered$ARR_DEL15,
  proximity = TRUE,
  importance = TRUE)

# Use Random Forest algorithm to make predictions on our test data set.
rfValidation <- predict(rfModel, testDataFiltered)

# Get detailed statistics of prediction versus actual via Confusion Matrix
rfConfMat <- confusionMatrix(rfValidation, testDataFiltered[,"ARR_DEL15"])
rfConfMat

# Confusion Matrix and Statistics
#
#           Reference
# Prediction 0.00 1.00
#       0.00 7300 1709
#       1.00  399  229
#
#                Accuracy : 0.7813
#                  95% CI : (0.7729, 0.7895)
#     No Information Rate : 0.7989
#     P-Value [Acc > NIR] : 1
#
#                   Kappa : 0.0888
#  Mcnemar's Test P-Value : <2e-16
#
#             Sensitivity : 0.9482
#             Specificity : 0.1182
#          Pos Pred Value : 0.8103
#          Neg Pred Value : 0.3646
#              Prevalence : 0.7989
#          Detection Rate : 0.7575
#    Detection Prevalence : 0.9348
#       Balanced Accuracy : 0.5332
#
#        'Positive' Class : 0.00
