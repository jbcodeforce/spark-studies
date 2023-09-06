# Spark studies

!!!- "Update"
    Sept-05-2023

[Spark](https://spark.apache.org/) started at UC Berkeley in 2009, and it is one of the most adopted open source solution to run **parallel data processing** on distributed systems to process large-scale data.

The goal of Spark is to offer an **unified** platform for writing big data application: this means consistent APIs to do data loading, SQL, streaming, machine learning... 

From the business point of view, the users look at making sense of their data, and transform the data so it can be used by business intelligence applications or Machine Model training. The typical use case for Sparks is to define data pipelines to transform raw data to filter, clean, augmented data sets, enhanced with analytics, business level aggregates, directly consumable by business apps.

![](./diagrams/data-pipeline.drawio.png)

The unified model for file system access is Hadoop FS.

The commercial version is supported by Databricks, but it is also available as managed services by cloud providers, such as AWS (EMR).

Data Scientists use Python Pandas and scikit-learn to do most of their work on one computer, when the memory of one computer is not enough then Spark helps to process such big data. Pyspark is the API for Python.

## Characteristics

* Data is expensive to move so Spark focuses on performing computations over the data, no matter where they reside.
* Provide a unified API for common data analysis tasks: RDD and DataFrame (see in [this section](dev-on-spark.md))
* Spark architecture is based on cluster with one `manager` node and multiple `executor` nodes. It can scale horizontally by adding executor nodes.
* Spark main data element is the Resilient Distributed Dataset (RDD), or in its newest version: the **Data frame**. RDD is an abstraction to manage distributed data in Spark cluster. Each dataset in RDD is divided into logical partitions, which can be computed on different nodes of the cluster.
* Spark includes libraries for SQL for structured data (Spark SQL), machine learning (MLlib), stream processing (Spark Streaming and the newer Structured Streaming), and graph analytics (GraphX).

![Spark components](images/spark-components.png)

* Spark supports large-scale machine learning using iterative algorithms that need to make multiple passes over the data.
* It uses a directed acyclic graph, or DAG, to define the workflow to perform on the executor nodes. It is optimized by a DAG engine. Developers write code that is mapped to DAG for execution.
* Spark is written in [Scala](scala_summary.md), and it is recommended to develop Spark apps with Scala, even if Python is a viable soluton for POC and prototyping.
* It is fast, 100x faster than hadoop Map Reduce.

## Architecture

* Spark Applications consist of a driver process and a set of executor processes. The driver process runs the `main()` function, sits on a node in the cluster, and is responsible for three things:

    * maintaining information about the Spark Application.
    * responding to a user’s program or input.
    * analyzing, distributing, and scheduling work across the executors.

* Each executor is responsible for only two things: executing code assigned to it by the driver, and reporting the state of the computation on that executor back to the driver node.

![Spark architecture](./images/app-arch.png)

* The main entry point for programming is the `SparkSession` object:

```python
spark = SparkSession.builder.appName("PopularMovies").getOrCreate()

lines = spark.sparkContext.textFile("../data/movielens/u.data")
```

See more development practices [here](./dev/index.md).

### Extended architecture

The full architecture includes storage and Delta lake which is an intermediate layer between Spark and storage to add services like ACID transaction and metadata about the object in the data lake. Spark job uses the Delta Lake to read and write data. 

![](./diagrams/spark-delta-hla.drawio.png){ width=600 }

## Considerations

* Spark executors are not really cattle as they are keeping data partitions. So from a pure Spark architecture, a kubernetes deployment, may look like an anti-pattern. RDD should help to compensate for pod failure.


[Next step... Getting started >>>](dev/index.md)
