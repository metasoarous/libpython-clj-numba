FROM clojure:openjdk-11-tools-deps-bullseye

# Updating Ubuntu packages & misc installs
# ========================

RUN apt-get -qq update &&\
    apt-get -qq -y install curl wget bzip2

# This should make tech.ml stuff fast for things like pca/svd
RUN apt-get install -y libblas-dev


# Setting up python environment
# =============================

RUN curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh &&\
  bash /tmp/miniconda.sh -bfp /usr/local &&\
  rm -rf /tmp/miniconda.sh &&\
  conda install -y python=3 &&\
  conda update conda

RUN apt-get -qq -y autoremove &&\
  apt-get autoclean &&\
  rm -rf /var/lib/apt/lists/* /var/log/dpkg.log &&\
  conda clean --all --yes

ENV PATH /opt/conda/bin:$PATH

RUN conda create -n pyclj python=3.8
RUN conda install -n pyclj scikit-learn
RUN conda install -n pyclj numpy

## To install pip packages into the pyclj environment do
#RUN conda run -n pyclj python3 -mpip install trimap

# This makes it so that all further `RUN` commands are executed using the conda environment
SHELL ["conda", "run", "-n", "pyclj", "/bin/bash", "-c"]

# Would be great to be able to do this, but doesn't work properly, so hardcoding the path below
#RUN PYTHON_LD_PATH=$(python3-config --prefix)/lib
ENV LD_LIBRARY_PATH "/usr/local/envs/pyclj:/usr/local/lib:$LD_LIBRARY_PATH"


# App setup
# =========

# Everything after this will get rerun even if the commands haven't changed, since data could change
WORKDIR /app

# Make sure deps are pre-installed
COPY deps.edn .
RUN clojure -P

EXPOSE 3851

COPY . .

# This is key; the `SHELL` call below does not 
CMD ["conda", "run", "-n", "pyclj", "clojure", "-M:cider-nrepl"]

