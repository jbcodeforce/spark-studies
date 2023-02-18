#!/bin/sh
/spark/spark-3.3.2-bin-hadoop3/bin/spark-class org.apache.spark.deploy.worker.Worker \
    --webui-port $SPARK_WORKER_WEBUI_PORT \
    $SPARK_MASTER