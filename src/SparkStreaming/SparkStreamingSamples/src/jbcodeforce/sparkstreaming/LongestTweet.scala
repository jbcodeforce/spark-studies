package jbcodeforce.sparkstreaming

import org.apache.spark._
import org.apache.spark.SparkContext._
import org.apache.spark.streaming._
import org.apache.spark.streaming.twitter._
import org.apache.spark.streaming.StreamingContext._
import Utilities._
import java.util.concurrent._
import java.util.concurrent.atomic._

object LongestTweet {
   def main(args: Array[String]) {
     setupTwitter()
     // use batch size of 2 seconds
     val ssc = new StreamingContext("local[*]", "AverageTweetLength", Seconds(2))
    
    // Get rid of log spam (should be called after the context is set up)
    setupLogging()

    // Create a DStream from Twitter using our streaming context
    val tweetStream = TwitterUtils.createStream(ssc, None)
    
     // Now extract the text of each status update into DStreams using map()
    val tweets = tweetStream.map(status => status.getText())
    
    // Map this to tweet character lengths.
    val lengths = tweets.map(status => status.length())
    var longestTweet = new AtomicLong(0)
    lengths.foreachRDD((rdd, time) => {
       var count = rdd.count()
       if ( count > 0 ) {
        // get the length of the rdd and compare it to longestTweet and uses highest value as new longest
      }
    })
   }
}