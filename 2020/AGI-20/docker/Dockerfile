FROM ubuntu:18.04

ENV OC_ORIGIN="singnet"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y gnupg2 wget
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -
RUN echo "deb https://apt.kitware.com/ubuntu/ bionic main" | tee '/etc/apt/sources.list.d/cmake.list'

RUN apt-get update

RUN apt-get install -y \
      build-essential \
      cmake \
      cython \
      guile-2.2-dev \
      libboost-all-dev \
      nano \
      python3-pip \
      unzip \
      rlwrap

RUN cd ~ && wget https://raw.githubusercontent.com/opencog/docker/master/opencog/tools/cli/scripts/.guile

RUN apt-get autoremove

RUN cd /tmp && \
    wget https://github.com/$OC_ORIGIN/cogutil/archive/master.zip && \
    unzip master.zip && \
    rm master.zip && \
    cd cogutil-master && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j && \
    make install && \
    ldconfig

RUN cd /tmp && \
    wget https://github.com/$OC_ORIGIN/atomspace/archive/master.zip && \
    unzip master.zip && \
    rm master.zip && \
    cd atomspace-master && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j && \
    make install && \
    ldconfig

RUN cd /tmp && \
    wget https://github.com/$OC_ORIGIN/ure/archive/master.zip && \
    unzip master.zip && \
    rm master.zip && \
    cd ure-master && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j && \
    make install && \
    ldconfig

RUN cd /tmp && \
    wget https://github.com/$OC_ORIGIN/miner/archive/master.zip && \
    unzip master.zip && \
    rm master.zip && \
    cd miner-master && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j && \
    make install && \
    ldconfig

RUN cd /tmp && \
    wget https://github.com/$OC_ORIGIN/pln/archive/master.zip && \
    unzip master.zip && \
    rm master.zip && \
    cd pln-master && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j && \
    make install && \
    ldconfig

RUN cd /tmp && \
    wget https://github.com/$OC_ORIGIN/agi-bio/archive/master.zip && \
    unzip master.zip && \
    rm master.zip && \
    cd agi-bio-master && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j && \
    make install && \
    ldconfig

RUN rm -rf /tmp/*
