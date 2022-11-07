from pyspark import SparkConf, SparkContext
"""
Try to find the worse movies: the lowest average rating.
"""

def loadMoviesNames():
    '''
    Create a dictionary to map movie ID to movie name
    '''
    movieNames = {}
    with open('../data/movielens/u.item',  encoding='ISO-8859-1') as f:
        for line in f:
            fields = line.split('|')
            movieNames[int(fields[0])] = fields[1]
    return movieNames


def parseMovieRecord(line):
    """exi
    convert the input line to (movieID, (rating, 1.0)) 
    """
    fields = line.split()
    return (int(fields[1]), (float(fields[2]),1.0))
    

if __name__ == "__main__":
    mn = loadMoviesNames()
    sparkConfiguration = SparkConf().setAppName("WorseMovie")
    sparkSession = SparkContext(conf = sparkConfiguration)
    # load movie ratings as RDD
    lines = sparkSession.textFile('../data/movielens/u.data')
    # Start to use spark RDD apis: map() to convert to (movieID, (rating, 1.0)) by using the parsing function
    movieRatings = lines.map(parseMovieRecord)
    # Reduce to (movieID, (sumOfRatings, totalRatings))
    ratingTotalsAndCount = movieRatings.reduceByKey(lambda movie1, movie2: (movie1[0] + movie2[0], movie1[1] + movie2[1]))
    print(ratingTotalsAndCount)
    # Map to 
    # averageRatings = ratingTotalsAndCount.mapValues( lambda totalAndCount: totalAndCount[0] / totalAndCount[1])
    #sortedMovies = averageRatings.sortBy(lambda x: x[1])
    #results = sortedMovies.take(10)
    #for result in averageRatings.take(10):
        # print(mn[result[0]], result[1])
    #    print(result)
    # Stop the session
    sparkSession.stop()