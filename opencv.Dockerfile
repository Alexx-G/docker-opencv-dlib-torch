FROM jsurf/rpi-raspbian:latest
MAINTAINER Alex Gavrisco <alexandr@gavrisco.com>

RUN ["cross-build-start"]

RUN apt-get update && apt-get install -y \
    build-essential cmake pkg-config apt-utils clang \
    curl \
    gfortran \
    libjpeg-dev libtiff-dev libjasper-dev libpng12-dev \
    libavcodec-dev libavformat-dev libswscale-dev libeigen3-dev \
    libunicap2-dev libv4l-0 libv4l-dev v4l-utils \
    libatlas-dev \
    libgtk2.0-dev \
    python-dev \
    python-numpy \
    python-protobuf\
    unzip \
    software-properties-common \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++

RUN cd ~ && \
    mkdir -p ocv-tmp && \
    cd ocv-tmp && \
    curl -L https://github.com/Itseez/opencv/archive/2.4.11.zip -o ocv.zip && \
    unzip ocv.zip && \
    cd opencv-2.4.11 && \
    mkdir release && \
    cd release && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D BUILD_PYTHON_SUPPORT=ON \
          -D BUILD_TESTS=NO \
          -D BUILD_PERF_TESTS=NO \
          .. && \
    make -j8 && \
    make install && \
    rm -rf ~/ocv-tmp

RUN ["cross-build-end"]

CMD ["/bin/bash"]
