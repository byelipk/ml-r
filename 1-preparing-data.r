# STEPS TO REPRODUCE
#
# 1. Reviewed data source
# 2. Downloaded data from DOT site
# 3. Used R to load CSV
# 4. Cleaned data (removed extraneous/duplicate fields)
# 5. Molded data  (remove rows we could not use, change data types in columns to what we needed)

# Helper functions to check if a string is empty.
is.empty <- function(x) return(x == "")
is.not_empty <- function(x) return(x != "")

###################
# LOADING THE DATA
###################
setwd("./")

# Load the data into a data frame with columns and rows
origData <- read.csv2(
  './Jan_2015_ontime.csv',    # The filepath.
  sep=",",                    # The delimiter is a comma.
  header=TRUE,                # The csv file contains headers.
  stringsAsFactors=FALSE      # This is an optimization left for later stages
                              # in the ml workflow.
)

# To speed thing up let's restrict data to only
# flights between certain large airports.
airports <-c('ATL','LAX', 'ORD', 'DFW', 'JFK', 'SFO', 'CLT', 'LAS', 'PHX', 'BOS')
origData <- subset(origData, DEST %in% airports & ORIGIN %in% airports)

###############################
# Inspecting and Cleaning Data
###############################

# Let's visually inspect data to find obvious issues.
head(origData,2)

# As we can see, we have a lot of columns. Most are
# expected, but notice the last column "X" with values
# of NA. The X column was created as part of the import
# from CSV. And NA means the data was "Not Available".
# So it looks like that column can be dropped. But to be
# sure let's check the end of the data frame with the
# tail() function.
tail(origData,2)

# Yes, it definitely appears that the column X has no
# value so lets remove this column. In R a column can be
# removed by setting it's value to NULL.
origData$X <- NULL

# When we check the data again we'll se the X column is gone.
head(origData,2)

# In general we want eliminate any columns that we do not
# need. In particular, we want to eliminate columns that
# are duplicates or provide the same or statistically similar
# information.
#
# There are two ways we can eliminate duplicate columns.
#
# 1. We can perform a visual inspection of the columns. In
#    some cases it may be obvious that a column is a duplicate.
#    However, a visual inspection is a quick and dirty solution
#    it won't be able to tell us if there is a mathematical
#    correlation between the values of the columns in question.
#
# 2. Sometimes there are correlated columns - columns that do
#    not share the same data type but contain the same
#    information. And these highly correlated columns usually
#    do not add information about how the data causes changes
#    in the results, but do cause the effect of a field
#    to be overly amplified because some algorithms naively treat
#    every columns as being independant and just as important.
#

########################################
# CLEANING DUPLICATE VALUES IN OUR DATA
########################################

head(origData,10)
# In looking at the data I see the possible correlations
# between ORIGIN_AIRPORT_SEQ_ID and ORIGIN_AIRPORT_ID
# and between DEST_AIRPORT_SEQ_ID and DEST_AIRPORT_ID.
# I am not sure we will use these fields, but if they are
# correlated we need only one of each pair.
#
# Let's Check the values using correlation function, cor().  Closer to 1 =>  more correlated
cor(origData[c("ORIGIN_AIRPORT_SEQ_ID", "ORIGIN_AIRPORT_ID")])

#                          ORIGIN_AIRPORT_ID ORIGIN_AIRPORT_SEQ_ID
# ORIGIN_AIRPORT_ID            1                     1
# ORIGIN_AIRPORT_SEQ_ID        1                     1
#
# Wow.  A perfect 1. So ORIGIN_AIRPORT_SEQ_ID and
# ORIGIN_AIRPORT_ID are moving in lock step.

# Let's check DEST_AIRPORT_SEQ_ID, DEST_AIRPORT_ID
cor(origData[c("DEST_AIRPORT_SEQ_ID", "DEST_AIRPORT_ID")])
# Another perfect 1.  So DEST_AIRPORT_SEQ_ID and DEST_AIRPORT_SEQ_ID are also moving in lock step.
#
# Let's drop the columns ORIGIN_AIRPORT_SEQ_ID and DEST_AIRPORT_SEQ_ID since they are not providing
# any new data
origData$ORIGIN_AIRPORT_SEQ_ID <- NULL
origData$DEST_AIRPORT_SEQ_ID <- NULL

# UNIQUE_CARRIER and CARRIER also look related, actually they look
# identical. Since the data types of these columns are not integers,
# we can see if the are identical by filtering the rows to those that
# are different. If there are 0 rows when we filter then then
# the columns are identical.
mismatched <- origData[origData$CARRIER != origData$UNIQUE_CARRIER,]
nrow(mismatched)

# 0 mismatched, so UNIQUE_CARRIER and CARRIER identical.
# So let's rid of the UNIQUE_CARRIER column.
origData$UNIQUE_CARRIER <- NULL

# let's see what origData looks like
head(origData,2)

############################################
# CLEANING NULL OR EMPTY VALUES IN OUR DATA
############################################

# Now that we have the desired columns, we need to
# clean our data of NULL or empty string values in columns
# which should have values.
#
# This code is telling R to filter the data frame
# of NULL and empty string values and assign it to
# a new data frame `onTimeData`.
onTimeData <- origData[
  !is.na(origData$ARR_DEL15) &   # Can't be NULL
  origData$ARR_DEL15 !=""    &   # Can't be empty string
  !is.na(origData$DEP_DEL15) &   # Can't be NULL
  origData$DEP_DEL15 !="", ]     # Can't be empty string


#####################################
# TRANSFORMING DATA INTO PROPER TYPES
#####################################

# When we examine the data types of our `onTimeData` we
# notice that `onTimeData$DISTANCE` is represented as
# a string. Chars are discrete values. If we feed
# our algorithms discrete values we run the risk of them
# not being computed properly. We need to change the data
# type to a continuous numeric type.
onTimeData$DISTANCE  <- as.integer(onTimeData$DISTANCE)
onTimeData$CANCELLED <- as.integer(onTimeData$CANCELLED)
onTimeData$DIVERTED  <- as.integer(onTimeData$DIVERTED)

# Sometimes algorithms perform better when you change columns
# into factors. Factors are similar to enums. They allow
# algorithms to keep counts of the number of times a column
# was a discrete value. If the number of discrete values
# is likely to be high, then the field should probably not
# be turned into a factor. Boolean columns are good candidates to
# be transformed into factors.
onTimeData$ARR_DEL15         <- as.factor(onTimeData$ARR_DEL15)
onTimeData$DEP_DEL15         <- as.factor(onTimeData$DEP_DEL15)
onTimeData$DEST_AIRPORT_ID   <- as.factor(onTimeData$DEST_AIRPORT_ID)
onTimeData$ORIGIN_AIRPORT_ID <- as.factor(onTimeData$ORIGIN_AIRPORT_ID)
onTimeData$DAY_OF_WEEK.      <- as.factor(onTimeData$DAY_OF_WEEK)
onTimeData$DEST              <- as.factor(onTimeData$DEST)
onTimeData$ORIGIN            <- as.factor(onTimeData$ORIGIN)
onTimeData$DEP_TIME_BLK      <- as.factor(onTimeData$DEP_TIME_BLK)
onTimeData$CARRIER           <- as.factor(onTimeData$CARRIER)

# Accurately predicting rare events is difficult!
# So before we can use our cleaned data to train a prediction
# we need to ensure the distribution of the data will allow
# us to train a prediction.
#
# Use tapply() to see how many times a boolean value is
# TRUE and how many times it is FALSE:
tapply(
  onTimeData$ARR_DEL15,
  onTimeData$ARR_DEL15, length)

# Now let's compute the prevelance of delayed flights in the data:
(6460 / (25664 + 6460)) # Approx 20% of our values are TRUE. That should be enough.
(7656 / (29468 + 7656)) #  0.2062278 of our values are TRUE. That should be enough.


# Now we're done cleaning/preparing our data.
# But do you actually remember how you got here?
