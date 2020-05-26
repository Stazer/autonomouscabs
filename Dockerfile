FROM debian:stable

RUN apt update && \
    apt -Y full-upgrade && \
    apt install -Y cmake g++ libboost-dev
