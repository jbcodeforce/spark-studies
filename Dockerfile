ARG OWNER=jupyter
FROM ${OWNER}/scipy-notebook
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root
ENV JDK_VERSION 11

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    "openjdk-${JDK_VERSION}-jre-headless" \
    ca-certificates-java  \
    curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Elyra
RUN  pip3 install --upgrade pip  && pip3 install --no-cache-dir  --upgrade  elyra[all] findspark
RUN jupyter lab  build --dev-build=False --minimize=False


# Spark dependencies
WORKDIR /usr/local
ENV SPARK_VERSION 3.5.1
ENV HADOOP_VERSION 3
ENV SCALA_VERSION 2.13
ENV JUPYTER_ENABLE_LAB=yes

ENV SPARK_DIR=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
ENV SPARK_HOME=/usr/local/${SPARK_DIR}
ENV SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH="${PATH}:${SPARK_HOME}/bin"

ENV SPARK_ARCHIVE spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

RUN wget http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_ARCHIVE}
ENV PYTHONUNBUFFERED=1
RUN echo "**** install Spark ****" && \
    tar -xzf $SPARK_ARCHIVE && \
    rm $SPARK_ARCHIVE 

RUN mkdir -p /usr/local/bin/before-notebook.d && \
    ln -s "${SPARK_HOME}/sbin/spark-config.sh" /usr/local/bin/before-notebook.d/spark-config.sh

USER jovyan

WORKDIR "${HOME}"

EXPOSE 10000
ENV MEM 2048m

COPY start-master.sh /start-master.sh
COPY start-worker.sh /start-worker.sh
