# autonomouscabs
## Setup
### Install packages
#### Debian 11 (Bullseye), Ubuntu 20.04 (Focal Fossa)
    `cmake g++ libboost-all-dev gnat gprbuild libaunit19-dev`
#### Debian 10 (Buster), Ubuntu 19.10 (Eoan Ermine)
    `cmake g++ libboost-all-dev gnat gprbuild libaunit18-dev`
#### FreeBSD 12, FreeBSD 13 (backend only)
    `cmake boost-libs`
### Note
Unfortunately, Ubuntu 18.10 (Bionic Beaver) is not supported due
to outdated boost packages. Compiling boost is an alternative, but not covered in this README.
For the following `make` calls, feel free to add `-jX` (where X is the amount of CPU cores + 1)
for using multiple cores for compiling.
### Create backend Makefile
    `mkdir build`
    `cd build`
    `cmake ..`
### Build backend and C++ tests
    `cd build`
    `make`
### Build external controller
    `cd external`
    `make`
## Run
### backend
    `./backend.bin --help`
### external_controller
    for each cab: `./main {webots_port} {backend_port}`
