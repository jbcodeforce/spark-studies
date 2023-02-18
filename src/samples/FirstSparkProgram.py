
from pyspark import SparkConf, SparkContext
"""
Filtering line from a Log file.
"""
 

if __name__ == "__main__":
    sparkConfiguration = SparkConf().setAppName("Get POST requests")
    sparkSession = SparkContext(conf = sparkConfiguration)
    # load text file in RDD
    lines = sparkSession.textFile('../data/access_log.txt')
    # get lines with POST trace
    posts = lines.filter(lambda l: "POST" in l).collect()
    print(posts)
    # Stop the session
    sparkSession.stop()