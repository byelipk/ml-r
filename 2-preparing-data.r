# STEPS TO REPRODUCE
#
# 1. Reviewed data source
# 2. Downloaded data from DOT site
# 3. Used R to load CSV
# 4. Cleaned data (removed extraneous/duplicate fields)
# 5. Molded data  (remove rows we could not use, change data types in columns to what we needed)


# OnTime.R - R OnTime script
setwd("./")

# Load the data into a data frame with columns and rows
# We specify the file path, separator, whether the CSV file's 1st row is clumn names, and how to treat strings.
origData <- read.csv2(
  './Jan_2015_ontime.csv',
  sep=",",
  header=TRUE,
  stringsAsFactors = FALSE
)

# To speed thing up let's restrict data to only flight between certain large airports
airports <-c('ATL','LAX', 'ORD', 'DFW', 'JFK', 'SFO', 'CLT', 'LAS', 'PHX')
origData <- subset(origData, DEST %in% airports & ORIGIN %in% airports)

# Inspecting and Cleaning Data

# Let's visually inspect data to find obvious issues
head(origData,2)

# As we can see, we have a lot of columns.  Most are expected, but notice the last column "X" with values of NA.  The X column was created
# as part of the import from CSV.  And NA means the data was "Not Available".  So it looks like that column can be dropped.
# But to be sure let's check the end of the data frame with the tail() function.
tail(origData,2)

# Yes, it definitely appears that the column X has no value so lets remove this column.
# The column can be removed by setting it's value to NULL
origData$X <- NULL

# Let's check the data again,
head(origData,2)
# yes the X column is gone

# In general we want eliminate any columns that we do not need.
# In particular, we want to eliminate columns that are duplicates or provide the same information
# We can do this by:
# 1. Visual inspect if we have columns that are really the same. But visual inspection is error prone
#    and does not deal with a second issue of correlation.
# 2. Often there are correlated columns such as an ID and the text value for the ID.
#    And these highly correlated columns usually do not add information about
#    how the data causes changes in the results, but do cause the effect of a field
#    to be overly amplified because some algorithm naively treat ever columns as
#    being independant and just as important.
#
# A helper function to check if a string is empty.
is.empty <- function(x) return(x == "")
is.not_empty <- function(x) return(x != "")

head(origData,10)
# In looking at the data I see the possible correlations between ORIGIN_AIRPORT_SEQ_ID and ORIGIN_AIRPORT_ID
# and between DEST_AIRPORT_SEQ_ID and DEST_AIRPORT_ID.  I am not sure we will use these fields,
# but if they are correlated we need only one of each pair.
#
# Let's Check the values using correlation function, cor().  Closer to 1 =>  more correlated
cor(origData[c("ORIGIN_AIRPORT_SEQ_ID", "ORIGIN_AIRPORT_ID")])
# Wow.  A perfect 1. So ORIGIN_AIRPORT_SEQ_ID and ORIGIN_AIRPORT_ID are moving in lock step.
# Let's check DEST_AIRPORT_SEQ_ID, DEST_AIRPORT_ID
cor(origData[c("DEST_AIRPORT_SEQ_ID", "DEST_AIRPORT_ID")])
# Another perfect 1.  So DEST_AIRPORT_SEQ_ID and DEST_AIRPORT_SEQ_ID are also moving in lock step.
#
# Let's drop the columns ORIGIN_AIRPORT_SEQ_ID and DEST_AIRPORT_SEQ_ID since they are not providing
# any new data
origData$ORIGIN_AIRPORT_SEQ_ID <- NULL
origData$DEST_AIRPORT_SEQ_ID <- NULL

# UNIQUE_CARRIER and CARRIER also look related, actually they look like identical
# We can see if the are identical by filtering the rows to those we they are different.
mismatched <- origData[origData$CARRIER != origData$UNIQUE_CARRIER,]
nrow(mismatched)
# 0 mismatched, so UNIQUE_CARRIER and CARRIER identical. So let's rid of the UNIQUE_CARRIER column
origData$UNIQUE_CARRIER <- NULL
# let's see what origData looks like
head(origData,2)

# We need to clean our data of NULL or empty string values
# in columns which should be a boolean 0 or 1.
onTimeData <- origData[
  !is.na(origData$ARR_DEL15) &   # Can't be NULL
  origData$ARR_DEL15 !=""    &   # Can't be empty string
  !is.na(origData$DEP_DEL15) &   # Can't be NULL
  origData$DEP_DEL15 !="", ]     # Can't be empty string


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
onTimeData$ARR_DEL15 <- as.factor(onTimeData$ARR_DEL15)
onTimeData$DEP_DEL15 <- as.factor(onTimeData$DEP_DEL15)
onTimeData$DEST_AIRPORT_ID <- as.factor(onTimeData$DEST_AIRPORT_ID)
onTimeData$ORIGIN_AIRPORT_ID <- as.factor(onTimeData$ORIGIN_AIRPORT_ID)
onTimeData$DAY_OF_WEEK <- as.factor(onTimeData$DAY_OF_WEEK)
onTimeData$DEST <- as.factor(onTimeData$DEST)
onTimeData$ORIGIN <- as.factor(onTimeData$ORIGIN)
onTimeData$DEP_TIME_BLK <- as.factor(onTimeData$DEP_TIME_BLK)
onTimeData$CARRIER <- as.factor(onTimeData$CARRIER)

# We need to check the distribution of values to ensure
# our cleaned data will allow us to make a prediction.
# (Accurately predicting rare events is difficult)
# Let's see how many delayed vs. non-delayed results
# occur in the data:
tapply(onTimeData$ARR_DEL15, onTimeData$ARR_DEL15, length)
(6460 / (25664 + 6460)) # Approx 20% of our values are TRUE. That should be enough.


# Now we're done cleaning/preparing our data.
# But do you actually remember how you got here?
