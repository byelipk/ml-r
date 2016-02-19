# Now it's time to evaluate the predictive capabilities of our model.
# To do that we will use the `predict` function passing it the training model and
# the test data frame. The function will use the trained model to predict delays from
# the test data frame. It returns an object containing the predictions.
logRegPrediction <- predict(logisticRegModel, testDataFiltered)

# We will create a confusion matrix to analyze the results. We can call the `confusionMatrix`
# function and pass it the prediction object and the column we're trying to predict.
logRegConfMat <- confusionMatrix(logRegPrediction, testDataFiltered[,"ARR_DEL15"])

# QUESTION: Use the machine learning workflow to
# process and transform DOT data to create a prediction
# model. This model must predict whether a flight would
# arrive 15+ minutes after the scheduled arrival time
# with 70+% accuracy.

#######################################
# Here's how to interpret the results:
#######################################
#
#
# Confusion Matrix and Statistics
#
#           Reference
# Prediction 0.00 1.00
#       0.00 7668 1906        A  B
#       1.00   31   32        C  D
#
#
#                Accuracy : 0.799
#                  95% CI : (0.7909, 0.807)
#     No Information Rate : 0.7989
#     P-Value [Acc > NIR] : 0.4959
#
#                   Kappa : 0.0196
#  Mcnemar's Test P-Value : <2e-16
#
#             Sensitivity : 0.99597
#             Specificity : 0.01651
#          Pos Pred Value : 0.80092
#          Neg Pred Value : 0.50794
#              Prevalence : 0.79890
#          Detection Rate : 0.79568
#    Detection Prevalence : 0.99346
#       Balanced Accuracy : 0.50624
#
#        'Positive' Class : 0.00
#
#
# ANALYSIS
#
# A = The flights predicted to not be delayed that were, in fact, NOT delayed.
# B = The flights predicted to not be delayed that were, in fact, delayed.
# C = The flights predicted to be delayed that were, in fact, NOT delayed.
# D = The flights predicted to be delayed that were, in fact, delayed.
#
# STATISTICS
#
# `Accuracy` is the ratio of the model prediction to the correct answer.
# (i.e Predicting a flight is delayed when it is delayed and predicting a flight
# is not delayed when it is not delayed.)
#
# (A + D / num test rows)
# (7668 + 32 / (7668 + 1906 + 31 + 32))
# 0.799 is GOOD


# `Sensitivity` is the measure of how the model predicts
# no delay when there is no delay.
#
# (A / A + C)
# (7668 / 7668 + 31)
# 0.99597 is GOOD


# `Specificity` is the measure of the model's ability to
# predict a delay when there is a delay.
#
# (D / B + D)
# (32 / 1906 + 32)
# 0.01651 is POOR


# `Pos Pred Value` predicts when there will be no delay.
# 0.80092 is GOOD


# `Neg Pred Value` predicts when there will be a delay.
# 0.50794 is POOR


# Our problem is that there are too many flights that are
# delayed that are not being predicted as delayed.
#
# How can we increase prediction accuracy? What options do
# we have? New data? New algorithm? Re-train the model differently?
# If we wanted to add additional predictor columns, which ones
# would we add?
