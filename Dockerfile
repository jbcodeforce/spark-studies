FROM openjdk:8-alpine
# Update alpine repositories, and get wget, tar...
RUN apk --update add wget tar bash
 
RUN wget http://apache.mirror.anlx.net/spark/spark-3.3.1/spark-3.3.1-bin-hadoop3.tgz
ENV PYTHONUNBUFFERED=1
RUN echo "**** install Spark ****" && \
    tar -xzf spark-3.3.1-bin-hadoop3.tgz && \
    mv spark-3.3.1-bin-hadoop3 /spark && \
    rm spark-3.3.1-bin-hadoop3.tgz && \
    echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi
    
ENV PATH=/spark/bin:$PATH
COPY start-master.sh /start-master.sh
COPY start-worker.sh /start-worker.sh
