# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/pyspark-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# Install vim & nano
RUN apt-get update && \
    apt-get install -y vim nano

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

RUN rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

WORKDIR /home/$NB_USER/work
RUN mkdir /home/$NB_USER/.sparkmagic
ADD config.json /home/$NB_USER/.sparkmagic/config.json
RUN chown -R jovyan:users /home/$NB_USER/.sparkmagic

USER $NB_USER
RUN  jupyter serverextension enable --py sparkmagic

# Add krb5.conf
USER root
ADD krb5.conf /etc/krb5.conf

USER $NB_USER
WORKDIR /home/$NB_USER/work
