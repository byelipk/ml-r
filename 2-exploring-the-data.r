# EXPLORING NUMERIC VARIABLES
# (Measures of central tendency and spread)
#
# Let's explore numeric data by generating summary
# statistics for origData$DISTANCE
summary(onTimeData$DISTANCE)


# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# 187     414     936    1176    1773    2704
#
# The fact that the minimum distance traveled is
# 187 miles leads us to conclude that the data we're
# looking at is for regional flights at the low end and
# cross-country flights at the high end.

# And one for `origData$DEP_TIME`
summary(onTimeData$DEP_TIME)

# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#  1     923    1322    1332    1732    2400
#
# We see that 50% of the flights depart earlier than
# 13:22
#
# When we plot the departure times as a histogram
# we see a large spike after 05:00 that is sustained
# until late in the evening. The data are slightly
# skewed to the left.
hist(onTimeData$DEP_TIME)

# MEASURING CENTRAL TENDENCY
#
# We use measures of central tendancy to find values
# that fall somewhere in the middle of a data set.
mean(onTimeData$DISTANCE)
median(onTimeData$DISTANCE)

# MEASURING SPREAD
#
# Measuring the mean and median is one way of summarizing
# our values, but they tell us nothing about whether or
# not their is diversity in our data set.
#
# So to measure diversity we employ another type of summary
# statistics that is concerned with how tightly or
# loosely the data are spaced. Knowing the spead will tell
# us whether or not most values are like or unlike
# our measures of central tendancy.
range(onTimeData$DISTANCE)        # The span between min/max
diff(range(onTimeData$DISTANCE))  # Difference between min/max
IQR(onTimeData$DISTANCE)          # Difference between Q1/Q3
quantile(onTimeData$DISTANCE)
quantile(onTimeData$DISTANCE, seq(from=0,to=1,by=0.20))


###########################
# VISUALIZING NUMERIC DATA
###########################
#
# When we plot mileage as a boxplot we don't notice
# any outliers in our data.
boxplot(
  onTimeData$DISTANCE,
  main="Boxplot of Distance Flown",
  ylab="Disntance (mi)"
)

# VARIANCE & STANDARD DEVIATION
#
# When interpreting variance, larger values indicate
# the data are spread more widely around the mean.
var(onTimeData$DISTANCE)

# The standard deviation indicates, on average, how much
# each value differs from the mean.
sd(onTimeData$DISTANCE)

###########################
# EXPLORING CATEGORICAL DATA
###########################
#
# In constrast to numeric data, categorical data is
# explored using tables rather than summary statistics.
#
# Here's a one-way-table for onTimeData$CARRIER
table(onTimeData$CARRIER)

# Here's a calculation of table proportions:
prop.table(table(onTimeData$CARRIER))

# Here's the proportions displayed with a single decimal place
# to make it easier to read:
carrier_tbl <- table(onTimeData$CARRIER)
carrier_pct <- prop.table(carrier_tbl) * 100
round(carrier_pct, digits = 1)

# THE MODE
#
# A measure of central tendancy for categorical variables.
# To find the mode, use the table() function and find the
# category with the greatest number of values.
#
# Is this data unimodal? Bimodal? Multimodal?
table(onTimeData$CARRIER)

# QUESTIONS
#
# - Does the DISTANCE data tell us that we're dealing
#   with regional flights, domestic flights, or both?
#
# - Is there a relationship between the time a flight
#   departs and the distance it travels?
plot(x=onTimeData$DISTANCE, y=onTimeData$DEP_TIME)
