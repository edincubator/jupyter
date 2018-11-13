FROM jupyterhub/jupyterhub

RUN conda install --quiet --yes -c conda-forge jupyterhub-ldapauthenticator 
RUN pip install dockerspawner

ADD jupyterhub_config.py /srv/jupyterhub
