# Some examples

## Assess the Tweeter popular Hashtags

The goal is to compute the most popular hashtag over a time window of 5 minutes and a slide interval of 1 seconds. See the solution in [PopularHashtags.scala](https://github.com/jbcodeforce/spark-studies/blob/master/src/SparkStreaming/SparkStreamingSamples/src/jbcodeforce/sparkstreaming/PopularHashtags.scala)

As seen previously, the approach is to get the tweet text, split it by words, and then generating key value pair for "(word, 1)" tuples, then use a specific reduce operation (`educeByKeyAndWindow`) using time window:

```scala
// Map each hashtag to a key/value pair of (hashtag, 1) so we can count them up by adding up the values
val hashtagKeyValues = hashtags.map(hashtag => (hashtag, 1))
  
// Now count them up over a 5 minute window sliding every one second
val hashtagCounts = hashtagKeyValues.reduceByKeyAndWindow( (x,y) => x + y, (x,y) => x - y, Seconds(300), Seconds(1))
  
```