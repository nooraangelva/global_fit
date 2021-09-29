# Environment: ROOT6 on Ubuntu/Focal:
FROM ubuntu:focal

RUN apt-get -yq update && DEBIAN_FRONTEND=noninteractive \
    apt-get -yq install --no-install-recommends\
        build-essential \
        cpp \
        c++17 \
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
        python3-pip \
        python3-dev \
        python3 \
        xlibmesa-glu-dev \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get -y autoremove && \
    apt-get -y clean 

RUN ln -s /usr/bin/python3 /usr/bin/python

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

RUN git clone https://github.com/rootpy/root_numpy.git &&\
    cd root_numpy &&\
    python setup.py install

RUN pip install --no-cache-dir numpy root_pandas scipy decorator

RUN apt-get update \
    && apt-get install -y \
    texlive-full \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Set helpful environment variables to point to local ROOT installation
ENV CMAKE_PREFIX_PATH=/usr/local
ENV DYLD_LIBRARY_PATH=/usr/local/lib
ENV JUPYTER_PATH=/usr/local/etc/notebook
ENV PYTHONPATH=/usr/local/lib
ENV PYTHONPATH "${PYTHONPATH}:/tmp/chib_chic_polFW/python/"
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV LIBPATH=/usr/local/lib
ENV SHLIB_PATH=/usr/local/lib

