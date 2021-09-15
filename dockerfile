# Environment: ROOT6 on Ubuntu/Bionic:
FROM ubuntu:focal
RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive \
    apt-get -y install --no-install-recommends\
        build-essential \
        cpp \
        c++17 \
        python3 \
        gfortran \
        git \
        dpkg-dev \
        cmake\
        g++ \
        gcc \
        binutils \
        libx11-dev \
        libxpm-dev \
        libxft-dev \
        libxext-dev \
        libssl-dev \
        make \
        openssl \
        python3-dev \
        python3-pip \
        xlibmesa-glu-dev \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get -y autoremove && \
    apt-get -y clean \
    pip install numpy \
    pip install root_numpy \
    pip install root_pandas


ENV ROOTSYS /usr/local
RUN git clone --quiet --depth 1 --branch v6-24-00 http://root.cern.ch/git/root.git /code/root && \
    cd /code && \
    mkdir _build && \
    cd _build && \
    cmake -Dcxx17=On -Dbuiltin_xrootd=On -Dminuit2=On ../root && \
    cmake --build . -- -j3 && \
    cmake -P cmake_install.cmake && \
    cd / && \
    rm -rf /code

# Set helpful environment variables to point to local ROOT installation
ENV CMAKE_PREFIX_PATH=/usr/local
ENV DYLD_LIBRARY_PATH=/usr/local/lib
ENV JUPYTER_PATH=/usr/local/etc/notebook
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV LIBPATH=/usr/local/lib
ENV PYTHONPATH=/usr/local/lib
ENV SHLIB_PATH=/usr/local/lib
