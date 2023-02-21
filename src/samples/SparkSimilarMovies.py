from pyspark.sql  import SparkSession

def loadMovieNames():
    movieNames = {}
    with open("../data/movielens/u.item", encoding='ISO-8859-1') as f:
        for line in f:
            fields = line.split('|')
            movieNames[int(fields[0])] = fields[1]
    return movieNames

if __name__ == "__main__":
    spark = SparkSession.builder.appName("SimilarMovies").getOrCreate()
    # Read movie ratings into RDD
    ratings = spark.sparkContext.textFile('../data/movielens/u*.data')
    # 
    ratingDF = spark.createDataFrame(ratings)
    ratingDF.printSchema()
    #ratingDF.groupBy()
    # Read movie data
    #movies = spark.sparkContext.textFile('../data/movielens/u*.item')

    # merge the two in data frame
    spark.stop()