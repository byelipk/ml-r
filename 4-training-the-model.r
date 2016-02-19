# Load caret
library(caret)

# Inside our algorithm's code will likely exist numbers generated randomly.
# The random number sequence is based on a seed number. Different sequences
# can effect our training results. For better reproducability, we will set
# the seed number manually.
set.seed(122515)

# We know we only need a few of the columns from our cleaned data set to train the model.
# Which columns stand out as good candidates for why a flight might be delayed?
#
# HINT: We need to include the feature we are trying to predict - `ARR_DEL15` - because we
#       are using a supervised learning algorithm.
featureCols <- c(
  "ARR_DEL15",
  "DAY_OF_WEEK",
  "CARRIER",
  "DEST",
  "ORIGIN",
  "DEP_TIME_BLK"
)

# Now we can filter the data according to the features we are interested in.
onTimeDataFiltered <- onTimeData[, featureCols]

# Our next task is to split the data into training (70%) and testing (30%) sets.
# We need to ensure that we have the correct percentage of rows in the training and test
# data frames. We also need to ensure that the distribution of TRUE/FALSE values for the
# feature we are trying to predict (ARR_DEL15) is the same in both data frames.
#
# The Caret package has a function called #createDataPartition which we will use to
# ensure the correct distribution of values. We tell the function that we want
# the feature ARR_DEL15 to be distributed 70/30. The function returns a column vector
# with a list of row indices. We will use the row indices to split our data into
# training and test sets.
inTrainRows <- createDataPartition(
  onTimeDataFiltered$ARR_DEL15,
  p=0.70,
  list=FALSE
)

trainDataFiltered <- onTimeDataFiltered[inTrainRows,]
testDataFiltered  <- onTimeDataFiltered[-inTrainRows,]

# Let's check to ensure our proportions are correct:
nrow(trainDataFiltered) / (nrow(trainDataFiltered) + nrow(testDataFiltered)) # ~0.700
nrow(testDataFiltered) / (nrow(trainDataFiltered) + nrow(testDataFiltered))  # ~0.299



# Parameters:
#
# 1. A list of the features we are trying to predict and a list of columns used
#    to predict that value (`ARR_DEL15 ~ .`). Here we are trying to predict `ARR_DEL15`
#    using all (`.`) columns except those to the left of `~`. (i.e All columns except `ARR_DEL15`)
# 2. Specify the data we will use to train the model (`data=trainDataFiltered`).
# 3. Specify the method to use (`method="glm"`). We are training using a special case of
#    generalized logistic regression. See: http://topepo.github.io/caret/Generalized_Linear_Model.html
# 4. ...
# 5. ...
logisticRegModel <- train(
  ARR_DEL15 ~ .,
  data=trainDataFiltered,
  method="glm",
  family="binomial",
  trControl=trainControl(
    method="cv",
    number=10,
    repeats=10
  )
)
