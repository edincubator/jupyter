# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/pyspark-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# Install vim & nano
RUN apt-get update && \
    apt-get install -y vim nano maven

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
    jupyter-kernelspec install sparkmagic/kernels/pyspark3kernel && \
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

RUN wget -O /tmp/spark-2.3.1-bin-without-hadoop.tgz https://archive.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-without-hadoop.tgz
RUN tar -xf /tmp/spark-2.3.1-bin-without-hadoop.tgz
RUN mv spark-2.3.1-bin-without-hadoop /opt/
RUN ln -s /opt/spark-2.3.1-bin-without-hadoop /opt/spark

RUN wget -O /tmp/hadoop-3.1.0.tar.gz https://archive.apache.org/dist/hadoop/common/hadoop-3.1.0/hadoop-3.1.0.tar.gz
RUN tar -xf /tmp/hadoop-3.1.0.tar.gz
RUN mv hadoop-3.1.0 /opt/
RUN ln -s /opt/hadoop-3.1.0 /opt/hadoop

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


USER $NB_USER
WORKDIR /home/$NB_USER/work

ENV PATH="/opt/spark/bin:/opt/hadoop/bin:${PATH}"
ENV HADOOP_HOME="/opt/hadoop"
ENV HADOOP_CONF_DIR="/opt/hadoop/etc/hadoop"
ENV JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-amd64"
ENV SPARK_HOME="/opt/spark"
ENV HADOOP_VERSION="3.1.0"
ENV APACHE_SPARK_VERSION="2.3.1"

RUN git clone https://github.com/edincubator/stack-examples ~/work/examples