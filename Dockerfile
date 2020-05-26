FROM debian:stable

RUN apt-get update && \
    apt-get install -y cmake g++ libboost-dev
