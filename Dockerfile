FROM debian:stable

RUN apt update && \
    apt full-upgrade && \
    apt install cmake g++ libboost-dev
