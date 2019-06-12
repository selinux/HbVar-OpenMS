# build OpenMS lib and tool
# 
#
FROM ubuntu:18.04

LABEL ch.hesge="HESSO - HEPIA - ITI" \
      description="OpenMS environment to build and execute proteomic workflow (mzML files)" \
      authors="Sebastien Chassot - sebastien.chassot@hesge.ch" \
      version="1.0" \
      ch.hesge.release-date="2019-06-12"


ENV LD_LIBRARY_PATH="/usr/include/OpenMS/lib:$LD_LIBRARY_PATH"
ENV PATH="$PATH:/usr/local/OpenMS/bin"

RUN apt-get -y update && \
    apt-get install -y \
    cmake \
    g++ \
    autoconf \
    automake \
    qtbase5-dev \
    libqt5svg5-dev \
    patch \
    libtool \
    make \
    git \
    libeigen3-dev libsqlite3-dev libwildmagic-dev libboost-random1.62-dev \
    libboost-regex1.62-dev libboost-iostreams1.62-dev libboost-date-time1.62-dev libboost-math1.62-dev \
    libxerces-c-dev libglpk-dev zlib1g-dev libsvm-dev libbz2-dev seqan-dev coinor-libcoinmp-dev libhdf5-dev && \
    rm -rf /var/lib/apt/lists/*

# clone OpenMS repo with submodules
RUN git clone -b 'Release2.4.0' --single-branch --depth 1 https://github.com/OpenMS/OpenMS.git /OpenMS && \
    cd /OpenMS # && git submodule update --init contrib

# build and clean OpenMS
RUN mkdir /openms-build && cd /openms-build && \
    cmake -DCMAKE_PREFIX_PATH="/contrib-build/;/usr/;/usr/local" \
    -DBOOST_USE_STATIC=Off \
    -DENABLE_DOCS=Off \
    -DENABLE_TUTORIALS=Off \
    -DENABLE_UPDATE_CHECK=Off \
    -DWITH_GUI=Off -DHAS_XSERVER=Off \
    -DPYOPENMS=Off \
    -DENABLE_TUTORIALS=Off \
    -DCMAKE_INSTALL_PREFIX=/usr/local/ \
    /OpenMS && \
    make OpenMS && \
    make && \
    make install && \
    make clean

RUN mkdir /src
WORKDIR /src

CMD ["/bin/bash"]
