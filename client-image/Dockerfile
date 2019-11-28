# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/pyspark-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# Install vim & nano
RUN apt-get update && \
    apt-get install -y vim nano maven openjdk-8-jdk python3-dev libsasl2-dev libsasl2-2 libsasl2-modules-gssapi-mit zip

# RSpark config
ENV R_LIBS_USER $SPARK_HOME/R/lib
RUN fix-permissions $R_LIBS_USER

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    gcc && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

# R packages
RUN conda install --quiet --yes \
    'r-base=3.5.1' \
    'r-irkernel=0.8*' \
    'r-ggplot2=3.1*' \
    'r-sparklyr=0.9*' \
    'r-rcurl=1.95*' && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Spark Magic
RUN pip install --no-cache-dir sparkmagic && \
    jupyter nbextension enable --py --sys-prefix widgetsnbextension

USER root
WORKDIR /opt/conda/lib/python3.7/site-packages
RUN jupyter-kernelspec install sparkmagic/kernels/sparkkernel && \
    jupyter-kernelspec install sparkmagic/kernels/pysparkkernel && \
#    jupyter-kernelspec install sparkmagic/kernels/pyspark3kernel && \
    jupyter-kernelspec install sparkmagic/kernels/sparkrkernel

WORKDIR /home/$NB_USER/work
RUN mkdir /home/$NB_USER/.sparkmagic
ADD configs/config.json /home/$NB_USER/.sparkmagic/config.json
RUN chown -R jovyan:users /home/$NB_USER/.sparkmagic

USER $NB_USER
RUN  jupyter serverextension enable --py sparkmagic

# Add krb5.conf
USER root
ADD krb5.conf /etc/krb5.conf

RUN rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN wget -O /tmp/spark-2.3.2-bin-without-hadoop.tgz https://archive.apache.org/dist/spark/spark-2.3.2/spark-2.3.2-bin-without-hadoop.tgz
RUN tar -xf /tmp/spark-2.3.2-bin-without-hadoop.tgz
RUN mv spark-2.3.2-bin-without-hadoop /opt/
RUN ln -s /opt/spark-2.3.2-bin-without-hadoop /opt/spark

RUN wget -O /tmp/hadoop-3.1.1.tar.gz https://archive.apache.org/dist/hadoop/common/hadoop-3.1.1/hadoop-3.1.1.tar.gz
RUN tar -xf /tmp/hadoop-3.1.1.tar.gz
RUN mv hadoop-3.1.1 /opt/
RUN ln -s /opt/hadoop-3.1.1 /opt/hadoop

ADD configs/spark/spark-defaults.conf /opt/spark/conf/
ADD configs/spark/spark-env.sh /opt/spark/conf/
ADD configs/spark/spark-log4j.properties /opt/spark/conf/
ADD configs/spark/spark-metrics.properties /opt/spark/conf/

ADD configs/hadoop/core-site.xml /opt/hadoop/etc/hadoop/
ADD configs/hadoop/hadoop-env.sh /opt/hadoop/etc/hadoop/
ADD configs/hadoop/hdfs-site.xml /opt/hadoop/etc/hadoop/
ADD configs/hadoop/log4j.properties /opt/hadoop/etc/hadoop/
ADD configs/hadoop/capacity-scheduler.xml /opt/hadoop/etc/hadoop/
ADD configs/hadoop/container-executor.cfg /opt/hadoop/etc/hadoop/
ADD configs/hadoop/resource-types.xml /opt/hadoop/etc/hadoop/
ADD configs/hadoop/yarn-env.sh /opt/hadoop/etc/hadoop/
ADD configs/hadoop/yarn-site.xml /opt/hadoop/etc/hadoop/
ADD configs/hadoop/topology_script.py /opt/hadoop/etc/hadoop/
RUN chmod a+rx /opt/hadoop/etc/hadoop/topology_script.py

ADD configs/hadoop/mapred-env.sh /opt/hadoop/etc/hadoop/
ADD configs/hadoop/mapred-site.xml /opt/hadoop/etc/hadoop/

# HiveQL

RUN pip install --upgrade hiveqlKernel
RUN jupyter hiveql install --user

# Bash kernel

RUN pip install calysto_bash

# HBase

RUN wget -O /tmp/hbase-2.0.2-bin.tar.gz http://archive.apache.org/dist/hbase/2.0.2/hbase-2.0.2-bin.tar.gz
RUN tar -xf /tmp/hbase-2.0.2-bin.tar.gz
RUN mv hbase-2.0.2 /opt/
RUN ln -s /opt/hbase-2.0.2 /opt/hbase

ADD configs/hbase/hbase-env.sh /opt/hbase/conf/
ADD configs/hbase/hbase-site.xml /opt/hbase/conf/
ADD configs/hbase/log4j.properties /opt/hbase/conf/
ADD configs/hbase/regionservers /opt/hbase/conf/

ADD configs/hbase/hbase-site.xml /opt/hadoop/etc/hadoop/
RUN cp -r /opt/hbase/lib/hbase-* /opt/hadoop/lib

# Phoenix

RUN wget -O /tmp/apache-phoenix-5.0.0-HBase-2.0-bin.tar.gz http://apache.rediris.es/phoenix/apache-phoenix-5.0.0-HBase-2.0/bin/apache-phoenix-5.0.0-HBase-2.0-bin.tar.gz
RUN tar -xf /tmp/apache-phoenix-5.0.0-HBase-2.0-bin.tar.gz
RUN mv apache-phoenix-5.0.0-HBase-2.0-bin /opt/
RUN ln -s /opt/apache-phoenix-5.0.0-HBase-2.0-bin /opt/phoenix
RUN ln -s /opt/phoenix/bin/sqlline.py /usr/bin/phoenix-sqlline
RUN sed -i '1{s/$/2.7/}' /opt/phoenix/bin/sqlline.py

# Kafka

RUN wget -O /tmp/kafka_2.11-2.0.0.tgz https://archive.apache.org/dist/kafka/2.0.0/kafka_2.11-2.0.0.tgz
RUN tar -xf /tmp/kafka_2.11-2.0.0.tgz
RUN mv kafka_2.11-2.0.0 /opt/
RUN ln -s /opt/kafka_2.11-2.0.0 /opt/kafka
ADD configs/kafka/kafka_client_jaas.conf /opt/kafka/config/kafka_client_jaas.conf
ADD configs/kafka/kafka_jaas.conf /opt/kafka/config/kafka_jaas.conf

# Pig

RUN pwd
RUN wget -O /tmp/pig-client.tar.gz https://edi-files-edi.apps.openshift.deustotech.eu/static/notebook/pig-client.tar.gz
RUN tar -xf /tmp/pig-client.tar.gz
RUN mv pig-client /opt/pig-client
RUN ln -s /opt/pig-client /opt/pig
ADD configs/pig/log4j.properties /opt/pig/conf/log4j.properties
ADD configs/pig/pig-env.sh /opt/pig/conf/pig-env.sh
ADD configs/pig/pig.properties /opt/pig/conf/pig.properties

# Tez

RUN wget -O /tmp/tez-client.tar.gz https://edi-files-edi.apps.openshift.deustotech.eu/static/notebook/tez-client.tar.gz
RUN ln -s /opt/tez-client /opt/tez
ADD configs/tez/tez-env.sh /opt/tez/conf/tez-env.sh
ADD configs/tez/tez-site.xml /opt/tez/conf/tez-site.xml

# Oozie

ADD oozie-client-4.3.1-client.tar.gz /tmp
RUN mv /tmp/oozie-client-4.3.1 /opt/
RUN ln -s /opt/oozie-client-4.3.1 /opt/oozie-client

# Fix user permissions
RUN fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# User Config
USER $NB_USER
WORKDIR /home/$NB_USER/work

# HiveQL

RUN pip install --upgrade hiveqlKernel
RUN jupyter hiveql install --user

ENV PATH="/opt/hbase/bin/:/opt/spark/bin:/opt/hadoop/bin:/opt/kafka/bin:/opt/pig/bin:/opt/oozie-client/bin:${PATH}"
ENV HADOOP_HOME="/opt/hadoop"
ENV HADOOP_CONF_DIR="/opt/hadoop/etc/hadoop"
ENV JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-amd64"
ENV SPARK_HOME="/opt/spark"
ENV HADOOP_VERSION="3.1.1"
ENV APACHE_SPARK_VERSION="2.3.2"
ENV HDP_VERSION="3.1.0.0-78"
ENV HBASE_HOME="/opt/hbase"
ENV HBASE_CONF_DIR="${HBASE_HOME}/conf"
ENV KAFKA_OPTS="-Djava.security.auth.login.config=/opt/kafka/config/kafka_client_jaas.conf"
ENV TEZ_JARS="/opt/tez"
ENV TEZ_CONF_DIR="/opt/tez/conf"
ENV PIG_CLASSPATH="${HADOOP_HOME}/conf:${TEZ_HOME}/conf"
ENV PIG_HOME="/opt/pig"
ENV HADOOP_CLASSPATH="${HBASE_HOME}/lib/*:${HBASE_HOME}/conf/*:${TEZ_CONF_DIR}:${TEZ_JARS}/*:${TEZ_JARS}/lib/*"


RUN git clone https://github.com/edincubator/stack-examples ~/work/examples

USER root

RUN rm -rf /tmp/*

USER $NB_USER

ADD configs/.bashrc /home/jovyan/.bashrc