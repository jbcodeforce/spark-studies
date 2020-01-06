# Some getting started 

## RDD: Resilient Distributed Dataset

It is a dataset distributed against the cluster nodes. To create a RDD we use the spark context object and then one of it APIs depending of the data source (JDBC, Hive, HDFS, Cassandra, HBase, ElasticSearch, CSV, json,...):

```python
from pyspark import SparkConf, SparkContext

# get spark session
sparkConfiguration = SparkConf().setAppName("WorseMovie")
sparkSession = SparkContext(conf = sparkConfiguration)
# load movie ratings from a csv file as a RDD
lines = sparkSession.textFile('../data/movielens/u.data')
results = lines.take(10)
for result in results:
    print(result[0], result[1])
```

This program is not launched by using python interpreter by the `spark-submit` tool. This tool is available in the Dockerfile we defined, with a python 3.6 interpreter.

```
/spark/bin/spark-submit nameoftheprogram.py
```

## Transforming RDDs

Use Map, flatmap, filter, distinct, union, intersection, substract, ... functions, and then applies of one of action.

Nothing actually happens in your drive program until an action is called.

here is [an python API documentation](https://spark.apache.org/docs/latest/api/python/index.html).

## DataFrames

Spark 2.0 supports exposing data in RDD as data frames to apply SQL queries. DataFrames contain row Objects.

```python
from pyspark.sql import SparkSession
from pyspark.sql import Row
from pyspark.sql import functions

# Create a SparkSession 
spark = SparkSession.builder.appName("PopularMovies").getOrCreate()
lines = spark.sparkContext.textFile("../data/movielens/u.data")
# Convert it to a RDD of Row objects with (movieID, rating)
movies = lines.map(parseInput)
# Convert that to a DataFrame
movieDataset = spark.createDataFrame(movies)
```
