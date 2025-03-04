FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    build-essential \
    pkg-config \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    cmake \
    libuv1-dev \
    liblz4-dev \
    liblzma-dev \
    libdouble-conversion-dev \
    libdwarf-dev \
    libunwind-dev \
    libaio-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libgmock-dev \
    clang-format-14 \
    clang-14 \
    clang-tidy-14 \
    lld-14 \
    libgoogle-perftools-dev \
    google-perftools \
    libssl-dev \
    gcc-12 \
    g++-12 \
    libboost-all-dev \
    cargo \
    meson \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/libfuse/libfuse/releases/download/fuse-3.16.1/fuse-3.16.1.tar.gz \
    && tar -xzf fuse-3.16.1.tar.gz \
    && cd fuse-3.16.1 \
    && mkdir build && cd build \
    && meson setup .. \
    && ninja \
    && ninja install \
    && ldconfig \
    && cd ../.. \
    && rm -rf fuse-3.16.1*

RUN wget https://github.com/apple/foundationdb/releases/download/7.1.57/foundationdb-clients_7.1.57-1_amd64.deb \
    && dpkg -i foundationdb-clients*.deb \
    || apt-get install -f -y \
    && rm foundationdb-clients* \ 
    && wget https://github.com/apple/foundationdb/releases/download/7.1.57/foundationdb-server_7.1.57-1_amd64.deb \
    && dpkg -i foundationdb-server*.deb \
    || apt-get install -f -y \
    && rm foundationdb-server*

RUN git clone https://github.com/deepseek-ai/3fs
WORKDIR /3fs

RUN git submodule update --init --recursive
RUN ./patches/apply.sh

RUN cmake -S . -B build \
    -DCMAKE_CXX_COMPILER=clang++-14 \
    -DCMAKE_C_COMPILER=clang-14 \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

RUN cmake --build build -j 24

WORKDIR /3fs/build

