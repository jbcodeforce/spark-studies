# Spark getting started

## Basic programming concepts

### RDD: Resilient Distributed Dataset

It is a dataset distributed against the cluster nodes. To create a RDD, we use the spark context object and then one of its APIs depending of the data source (JDBC, Hive, HDFS, Cassandra, HBase, ElasticSearch, CSV, json,...). In the code below, `movies` variable is a RDD.

```python
from pyspark import SparkConf, SparkContext

# get spark session
sparkConfiguration = SparkConf().setAppName("WorseMovie")
sparkSession = SparkContext(conf = sparkConfiguration)
# load movie ratings from a csv file as a RDD
movies = sparkSession.textFile('../data/movielens/u.data')
results = movies.take(10)
for result in results:
    print(result[0], result[1])
```

This program is not launched by using Python interpreter, but by the `spark-submit` tool. This tool is available in the Dockerfile we defined, with a python 3.7 interpreter.

```sh
/spark/bin/spark-submit nameoftheprogram.py
```

Creating a RDD can be done from different data sources, text file, csv, database, Hive, Cassandra...

### Spark context

Created by the driver program, it is responsible for making the RDD resilient and distributed. Here is an example of a special context creation for Spark Streaming, using local server with one executor per core, and using a batch size of 1 second.

```scala
val scc = new StreamingContext("local[*]", "TelemetryAlarmer", Seconds(1))
```

### Transforming RDDs

Use `map, flatmap, filter, distinct, union, intersection, substract`, ... functions, and then applies one of the action.

Nothing actually happens in your drive program until an action is called. Here is [the python API documentation](https://spark.apache.org/docs/latest/api/python/index.html).

[The wordscale.scala code](https://github.com/jbcodeforce/spark-studies/blob/master/src/SparkStreaming/SparkStreamingSamples/src/jbcodeforce/rdd/samples/wordscale.scala) uses RDD to count word occurence in a text.
To be able to get an executor running the code, the scala program needs to be an object and have a main function:

```scala
object wordcount {
  
  def main(args: Array[String]) {
  }
}
```

* `Map` transforms one row into another row:

    ```scala
    // Now extract the text of each tweeter status update into DStreams:
    val statuses = tweets.map(status => status.getText())
    ```

* while `mapFlat` transforms one row into multiple ones:

    ```scala
    // Blow out each word into a new DStream
        val tweetwords = statuses.flatMap(tweetText => tweetText.split(" "))
    ```

* `filter` helps to remove row not matching a condition:

    ```scala
        // Now eliminate anything that's not a hashtag
        val hashtags = tweetwords.filter(word => word.startsWith("#"))
    ```

A classical transformation,  is to create key-value pair to count occurence of something like words using a reduce approach. `reduce(f,l)` applies the function f to elements of the list l by pair: (i,j) where i is the result of f(i-1,j-1).

```scala
valrdd.reduce((x,y) => x + y)
```

```scala
// Map each hashtag to a key/value pair of (hashtag, 1) so we can count them up by adding up the values
val hashtagKeyValues = hashtags.map(hashtag => (hashtag, 1))

val counts = hashtagKeyValues.reduceByKey()
```

### DataFrames

Spark 2.0 supports exposing data in RDD as data frames to apply SQL queries. DataFrames contain Row Objects and may be easier to manipulate.

In the example below, the movies rating file includes records like:

```
0	50	5	881250949
0	172	5	881250949
```

The python code using RDD and data frame:

```python
from pyspark.sql import SparkSession
from pyspark.sql import Row
from pyspark.sql import functions

def parseInput(line):
    fields = line.split()
    return Row(movieID = int(fields[1]), rating = float(fields[2]))

# Create a SparkSession 
spark = SparkSession.builder.appName("PopularMovies").getOrCreate()
movies = spark.sparkContext.textFile("../data/movielens/u.data")
# Convert it to a RDD of Row objects with (movieID, rating)
movieRows = lines.map(parseInput)
# Convert that to a DataFrame
movieDataset = spark.createDataFrame(movieRows)
```

Then in data frame we can do SQL type of transformation

```python
 # Compute average rating for each movieID
averageRatings = movieDataset.groupBy("movieID").avg("rating")

# Compute count of ratings for each movieID
counts = movieDataset.groupBy("movieID").count()
```

## Scala

### Create scala project with maven

See [this article](https://docs.scala-lang.org/tutorials/scala-with-maven.html) to create a maven project for scala project, and package it. 

### SBT the scala CLI

[Scala SBT](http://scala-sbt.org) is a tool to manage library dependencies for Scala development. It also helps to package all dependencies in a single jar.

See [sbt by examples](https://www.scala-sbt.org/1.x/docs/sbt-by-example.html) note and [this SBT essential tutorial](https://www.scalawilliam.com/essential-sbt/).

Example to create a project template: `sbt create scala/helloworld.g8`.

Once code and unit tests done, package the scala program and then submit it to spark cluster:

```shell
# In spark-studies/src/scala-wordcount
sbt package
# start a docker container with spark image (see previous environment notes)
docker run --rm -it --network spark_network -v $(pwd):/home jbcodeforce/spark bash
# in the shell within the container
cd /home
spark-submit target/scala-2.12/wordcount_2.12-1.0.jar
```

!!! note
    The set of commands work well with spark cluster running on local host via docker compose. If you want to access a remote cluster, for example running on IKS OCP see [this section](#remote-spark). 


[Next step... Deployment with local run >>>](deployment.md)