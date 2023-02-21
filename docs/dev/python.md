# Spark programming with Python

See [the product documentation to learn how to use pyspark](https://spark.apache.org/docs/latest/api/python/index.html).

The advantages:

* Write Spark app in Python
* Use interactive analysis of data in distributed environment
* Pandas can be used and scaled on Spark.

## Environment setup

I used the Spark 3.3 release within docker image. To use Eclipse IDE see [instructions from Sundog education](https://sundog-education.com/spark-streaming).

See [those explanations](../deployment/#using-docker-compose) to run Spark with docker compose.

## First python program

See FirstSparkProgram.py code in [src/samples](https://github.com/jbcodeforce/spark-studies/tree/master/src/samples) folder.

All Spark python program need a main function and then can use SparkContext or sql.SparkSession

```python
if __name__ == "__main__":
    sparkConfiguration = SparkConf().setAppName("App name")
    sparkSession = SparkContext(conf = sparkConfiguration)
    # .. do a lot of things
    sparkSession.stop()
```

The main function build a spark session, loads the data in a RDD and perform transformation or actions.

```python
    sparkConfiguration = SparkConf().setAppName("Get POST requests")
    sparkSession = SparkContext(conf = sparkConfiguration)
    # load text file in RDD
    lines = sparkSession.textFile('../data/access_log.txt')
    # get lines with POST trace
    posts = lines.filter(lambda l: "POST" in l).collect()
```

* Be sure docker compose has started a master node and at least one worker node. 
* Verify the Masster console: [http://localhost:8085/](http://localhost:8085/)
* Run the sample python program: To be able to run program as job on spark cluster we need to connect to the cluster and use `spark-submit` command. 

    For that we are using another container instance, with the source code mounted to `/home`:

    ```shell
    docker run --rm -it --network spark-network -v $(pwd):/home jbcodeforce/spark bash
    ```

    In the shell within this container runs:

    ```shell
    bash-5.2# cd /home/src
    bash-5.2# spark-submit samples/FirstSparkProgram.py
    ```

## Computing the lowest rated movie

It reads the rating file and map each line to a SQL Row( movieID , rating) then transforms it in data frame, then compute average rating for each movieID, and count the number of time the movie is rated, joins the two data frames
and pull the top 10 results:

See the code in [LowestRatedMovieDataFrame.py](https://github.com/jbcodeforce/spark-studies/blob/master/src/samples/LowestRatedMovieDataFrame.py)

```sh
bash-4.4# spark-submit samples/LowestRatedMovieDataFrame.py

Amityville: Dollhouse (1996) 1.0
Somebody to Love (1994) 1.0
Every Other Weekend (1990) 1.0
Homage (1995) 1.0
3 Ninjas: High Noon At Mega Mountain (1998) 1.0
Bird of Prey (1996) 1.0
Power 98 (1995) 1.0
Beyond Bedlam (1993) 1.0
Falling in Love Again (1980) 1.0
T-Men (1947) 1.0
```

## Assessing similar movies

This example is using Pandas with Spark to merge two files: movie rating and movie data. Spark context has the read_text from different files into a single RDD

## Movie recommendations

It reads the rating file and map each line to a SQL Row(userID , movieID , rating) then transform it in data frame
so it can apply ML recommendation using the [Alternating Least Squares](https://spark.apache.org/docs/latest/api/python/reference/api/pyspark.ml.recommendation.ALS.html) api on the dataframe. Once the model is fitted, take the movies with at least 100 ratings, build a test dataframe with the movie evaludated by user 0. From those movies use the model to do a recommendations, finally get the top 20 movies with the highest predicted rating for this user.

See the code in [MovieRecommendationsALS.py](https://github.com/jbcodeforce/spark-studies/blob/master/src/samples/MovieRecommendationsALS.py)

```sh
bash-5.2# spark-submit samples/MovieRecommendationsALS.py

Clerks (1994) 5.125946044921875
Die Hard (1988) 5.088437557220459
Star Wars (1977) 5.009941101074219
Army of Darkness (1993) 4.961264610290527
Empire Strikes Back, The (1980) 4.9492716789245605
Alien (1979) 4.911722183227539
Frighteners, The (1996) 4.8579559326171875
Reservoir Dogs (1992) 4.808855056762695
Raiders of the Lost Ark (1981) 4.786505222320557
Star Trek: The Wrath of Khan (1982) 4.760307312011719
Terminator, The (1984) 4.759642124176025
...
```


## Deeper dive

* [RDD pyspark API](https://spark.apache.org/docs/latest/api/python/reference/api/pyspark.RDD.html)