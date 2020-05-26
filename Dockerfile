FROM debian:stable

RUN useradd -m user && \
    apt-get update && \
    apt-get install -y cmake g++ libboost-dev

USER user

COPY Stazer/autonomouscabs /home/user/repository

RUN cd /home/user/repository && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make
