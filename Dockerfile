FROM amazoncorretto:17.0.6-al2022-RC-headful

WORKDIR /spark

ENV SPARK_VERSION 3.3.2
ENV HADOOP_VERSION 3
ENV SCALA_VERSION 2.13

ENV SPARK_ARCHIVE spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN yum -y install wget tar python3 pip gzip  && cd /spark
RUN wget http://apache.mirror.anlx.net/spark/spark-${SPARK_VERSION}/${SPARK_ARCHIVE}
ENV PYTHONUNBUFFERED=1
RUN echo "**** install Spark ****" && \
    tar -xzf $SPARK_ARCHIVE && \
    rm $SPARK_ARCHIVE 

ENV SPARK_DIR "/spark/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"

ENV PATH=$SPARK_DIR/bin:$PATH


EXPOSE 10000
ENV MEM 2048m

COPY start-master.sh /start-master.sh
COPY start-worker.sh /start-worker.sh
