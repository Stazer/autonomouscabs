FROM debian:stable

RUN apt update && \
    apt install -Y cmake g++ libboost-dev
