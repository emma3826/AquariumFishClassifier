FROM fastai/fastai:2020-11-08

LABEL maintainer="emma3826"

ARG NB_USER=app
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}
ENV PATH ${HOME}/.local/bin:$PATH

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

COPY DeepLearningExperiments.ipynb ${HOME}
COPY aquarium_fish_model.pkl ${HOME}
COPY environmental_sound_model.pkl ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME} && mkdir -p /usr/etc/jupyter && chown -R ${NB_UID} /usr/etc/jupyter
USER ${NB_USER}

WORKDIR ${HOME}

RUN pip install voila \
    && jupyter serverextension enable voila --sys-prefix

RUN pip install git+https://github.com/fastaudio/fastaudio.git

EXPOSE 8866

#CMD ["voila", "DeepLearningExperiments.ipynb", "-debug"]
CMD voila --debug DeepLearningExperiments.ipynb
