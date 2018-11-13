FROM jupyterhub/jupyterhub

RUN conda install --quiet --yes -c conda-forge jupyterhub-ldapauthenticator 
RUN pip install dockerspawner

RUN apt-get update
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get update && apt-get install -y docker-ce

RUN pip install sudospawner

ADD jupyterhub_config.py /srv/jupyterhub
