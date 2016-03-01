# Intro

```ruby
MLW = [
  "Asking the right question",
  "Preparing data",
  "Selecting an algorithm",
  "Training the model",
  "Testing the model"
]
```

A good research question (solution statement) will define our end goal, our starting point, and how we will achieve our end goal to include the expected performance of our algorithm and the context in which it will be used.

* Identify scope and data sources
* Define target performance measurements
* Define context for usage
* Define how solution will be created

We'll start off with a simple, naive question and build it out into something that better fits our expectations of a good question.

Here's what we'll start off with:

```
Predict if a flight would be on time.
```

And here's what we'll be building towards:

```
Use the machine learning workflow to process and transform
DOT data to create a prediction model. This model must
predict whether a flight would arrived 15+ minutes after
the scheduled arrival time with 70+% accuracy.
```

## What assumptions are we making?
Our first step at building a good research question involves identifying the most important assumptions we'll be making. Doing this will help narrow down our data set and set us on the path of building a better research question.

First, we'll only be concerning ourselves with flight data from the United States. Second, we only care about those flights between US airports.

* US flights only
* Flights between US airports only

So, given our question and assumptions, where can we go find data?

## Where's the data?

U.S. Department of Transportation (DOT) is a good data source.

See: http://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time

Now we can build out our question to something like:

```
Using DOT data, predict if a flight would be on time.
```

Now that we know our data source, we can take a preliminary look at our data. When we do we notice that there are no raw statistics tracked about flights being "on time". Rather DOT collects data on whether or not a flight's arrival or departure is "delayed".

* No "on time" statistics
* Delays tracked

We can now improve the fidelity of our research question to the problem domain:

```
Using DOT data, predict if a flight would be delayed.
```

###### What kind of performance do we want our model to have?

We're defining the prediction in a binary fashion (i.e. "Delayed" or "Not Delayed"). So even a trivial solution that emulated flipping a coin would work 50% of the time in theory. So obviously we'll want more accuracy than 50%.

* Binary result (T/F)
* Coin flip = 50% accuracy
* 70% accuracy is a good start

> Using DOT data, predict with 70+% accuracy if a flight would be delayed.

###### What is the context of our problem domain and data set?

We're predicting delays, so what does it mean for a flight to be delayed? Does it mean leaving late or arriving late? For this problem "delayed" will mean arriving late to the destination airport.

The second question we have to answer is "How late is delayed?"

The DOT has legally defined "delayed" as arriving 15 or greater after the schedule time.

* Data driven results
* DOT "delayed" => greater than 15 minutes after scheduled arrival

> Using DOT data, predict with 70+% accuracy if a flight would arrived 15+ minutes after scheduled arrival time.

###### How will we create a model?
* Use machine learning workflow
* Process data from DOT site
* Transform data as required

> Use the machine learning workflow to process and transform DOT data to create a prediction model. This model must predict whether a flight would arrived 15+ minutes after the scheduled arrival time with 70+% accuracy.
