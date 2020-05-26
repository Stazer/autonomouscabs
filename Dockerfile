FROM debian:stable

RUN useradd -m user && \
    apt-get update && \
    apt-get install -y cmake g++ libboost-dev

COPY $TRAVIS_BUILD_DIR /home/user/repository

RUN chown -R user:user /home/user/repository

USER user

RUN cd /home/user/repository && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make
