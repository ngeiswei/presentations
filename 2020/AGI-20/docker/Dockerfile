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
      git \
      nano \
      python3-pip \
      unzip \
      rlwrap \
      emacs \
      vim \
      less \
      screen \
      byobu

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
    git clone https://github.com/ngeiswei/atomspace.git && \
    cd atomspace && \
    git checkout agi-20 && \
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
    git clone https://github.com/ngeiswei/pln.git && \
    cd pln && \
    git checkout pln-api-improv && \
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

RUN wget https://github.com/ngeiswei/presentations/raw/master/2020/AGI-20/docker/AGI-20-PLN-Tutorial-intro.pdf
RUN wget https://github.com/ngeiswei/presentations/raw/master/2020/AGI-20/docker/AGI-20-PLN-Tutorial-follow-along.md
RUN wget https://github.com/ngeiswei/presentations/raw/master/2020/AGI-20/docker/kb.scm
RUN cd ~ && wget https://raw.githubusercontent.com/opencog/docker/master/opencog/tools/cli/scripts/.guile
RUN cd ~ && wget https://github.com/ngeiswei/presentations/raw/master/2020/AGI-20/docker/.emacs
