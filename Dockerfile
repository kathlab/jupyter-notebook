# syntax=docker/dockerfile-upstream:master-labs
FROM ubuntu:jammy

# args
ARG PROJECT="Jupyter-Notebook"
ARG PACKAGES="git mc htop neovim git"
ARG CONDADIR="/miniconda"
ARG CONDAENV="juno"
ARG CONDA_PREFIX=${CONDADIR}/envs/${CONDAENV}
ARG CONDADEPS="requirements.yaml"
ARG CONDAURL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

### setup env for using conda
ENV PATH="/miniconda/bin:${PATH}"
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CONDA_PREFIX}/lib/

### install packages
RUN apt update && apt install -y ${PACKAGES}

# install conda
ADD --checksum=sha256:78f39f9bae971ec1ae7969f0516017f2413f17796670f7040725dd83fcff5689 ${CONDAURL} /
RUN chmod a+x /Miniconda3-latest-Linux-x86_64.sh
RUN /Miniconda3-latest-Linux-x86_64.sh -b -p ${CONDADIR}

### setup conda environment
COPY ${CONDADEPS} /root/
RUN ${CONDADIR}/bin/conda env create -n juno -f /root/${CONDADEPS}
RUN ${CONDADIR}/bin/conda init bash
# by default activate custom conda env
RUN echo "conda activate juno" >> /root/.bashrc

# all following RUNs should run in a real login shell to mitigate conda env activation problem
SHELL [ "conda", "run", "-n", "juno", "/bin/bash", "--login", "-c" ]

# update conda to prevent error: No module named '_sysconfigdata_x86_64_conda_linux_gnu'
RUN ${CONDADIR}/bin/conda update python

# change workdir to make notebooks browsable in jupyter notebooks
WORKDIR /notebooks

# volumes
VOLUME [ "/notebooks" ]
VOLUME [ "/workspace" ]