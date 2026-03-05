FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential cmake make \
    gcc g++ flex bison \
    libpcap-dev libssl-dev \
    libz-dev libmaxminddb-dev \
    python3 python3-dev \
    swig curl wget ca-certificates \
    libkrb5-dev binutils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN wget https://download.zeek.org/zeek-6.0.0.tar.gz && \
    tar -xzf zeek-6.0.0.tar.gz

WORKDIR /build/zeek-6.0.0
RUN ./configure \
        --prefix=/usr/local/zeek \
        --enable-packet-header-info \
        --disable-broker-tests \
        --disable-python \
        --disable-zeekctl && \
    make -j$(nproc) && \
    make install && \
    rm -rf /build

ENV PATH="/usr/local/zeek/bin:${PATH}"
WORKDIR /zeek-test
CMD ["/bin/bash"]
