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

A good research question will define scope of solution, expected performance, the context in which it will be used, and the process we'll use to create the solution.

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
Our first step at building a good research question involves identifying the most important assumptions we'll be making.

Doing this will help narrow down our data set.

* US flights only
* Flights between US airports only

So we'll only be concerning ourselves with flight data from the United States. And only those flights between US airports. So, given our question and assumptions, where can we go find data?

## Where's the data?

U.S. Department of Transportation (DOT) is a good data source.

```
Using DOT data, predict if a flight would be on time.
```

###### What do we notice about the data?
* No "on time" statistics
* Delays tracked

```
Using DOT data, predict if a flight would be delayed.
```

###### What kind of performance do we want our model to have?
* Binary result (T/F)
* Coin flip = 50% accuracy
* 70% accuracy is a good start

> Using DOT data, predict with 70+% accuracy if a flight would be delayed.

###### What is the context of our problem domain and data set?
* Data driven results
* DOT "delayed" => greater than 15 minutes after scheduled arrival

> Using DOT data, predict with 70+% accuracy if a flight would arrived 15+ minutes after scheduled arrival time.

###### How will we create a model?
* Use machine learning workflow
* Process data from DOT site
* Transform data as required

> Use the machine learning workflow to process and transform DOT data to create a prediction model. This model must predict whether a flight would arrived 15+ minutes after the scheduled arrival time with 70+% accuracy.
