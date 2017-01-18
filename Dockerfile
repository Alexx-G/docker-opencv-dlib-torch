FROM gavrisco/rpi-opencv:v2.4.13
MAINTAINER Alex Gavrisco <alexandr@gavrisco.com>

# Deps
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    curl \
    git \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libatlas-dev \
    libboost-all-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    python-protobuf\
    software-properties-common \
    zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Build Torch
RUN git clone https://github.com/torch/distro.git ~/torch --recursive
RUN cd ~/torch && bash install-deps && ./install.sh && \
    cd install/bin && \
    ./luarocks install nn && \
    ./luarocks install dpnn && \
    ./luarocks install image && \
    ./luarocks install optim && \
    ./luarocks install csvigo && \
    ./luarocks install torchx && \
    ./luarocks install tds

# Build dlib
RUN cd ~ && \
    mkdir -p dlib-tmp && \
    cd dlib-tmp && \
    curl -L \
         https://github.com/davisking/dlib/archive/v19.0.tar.gz \
         -o dlib.tar.bz2 && \
    tar xf dlib.tar.bz2 && \
    cd dlib-19.0/python_examples && \
    mkdir build && \
    cd build && \
    cmake ../../tools/python && \
    cmake --build . --config Release && \
    cp dlib.so /usr/local/lib/python2.7/dist-packages && \
    rm -rf ~/dlib-tmp
