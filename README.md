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
Also the Boost library is used in the backend and the webots controller.
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
### Build webots controller
    `cd webots/controllers/controller`
    `make`
Alternatively compile in webots directly.
## Run
### backend
    `./backend.bin --help`
To add a new request write to the console: 

    `P<x> P<y> <k>`
where `P<x>` is the source and `P<y>` the destination pickup location and `<k>` the amount of passengers.
`<k>` is limited to 4.
### external_controller
For each cab run

    `./main {webots_address} {webots_port} {backend_address} ({backend_port})`
Backend port is optional. If not set the default port is used.
### webots controller
For each robot node specify the port in controllerArgs.
#### Note
Th simulation will only start if every robot has a connection with an external controller.
If a robot is not needed for a test just leave the controllerArgs field empty.
