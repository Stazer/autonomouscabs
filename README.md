# autonomouscabs

## Git Tutorials
- https://learngitbranching.js.org/
- https://git-scm.com/docs/gittutorial

## Workflow
- Pick issue
- Create new branch
- Solve issue by making changes
- Push changes
- Create pull request
- Pull request is reviewed by at least two people in order to ensure code quality, structure, requirements and succeeded unit tests
- Branch gets merged into master and gets deleted

## Quality Assurance
- Unit tests are written for most components
- Minimum 80% code coverage
- Few tests should cover much code
- Tests are executed by TravisCI on each commit
- TravisCI uses custom Dockerfile to run C++ and ADA tests
- Integration tests ensure the overall functionality and that all components are working together as expected

## Dependencies and Tools
### ADA
- [GNAT](https://www.adacore.com/gnatpro/toolsuite/gnatstudio) as IDE
- [GNATtest](https://www.adacore.com/gnatpro/toolsuite/gnattest) for unit testing
### C and C++
- [CMake](https://cmake.org/) as build system
- [Boost](https://www.boost.org/) for unit testing and networking

## Protocol
### General
- Binary protocol consisting of packet size (32-bit unsigned integer), packet id (32-bit unsigned integer) and payload
- The packet size defines the size of the next receiving packet and the packet id defines what type of packet is handled and what kind of payload was sent and is received
- Example: For the location data packet with id 3 the payload for transmitting the 2D location data could look like this:
```
typedef struct {
    uint64_t x;
    uint64_t y;
} location_data_payload;
```
- Although coordinates are floating point numbers, the data is transmitted using 64-Bit unsigned integers. All payloads should use fixed sized integers only. Marshalling and unmarshalling converts the integer into the appropriate floating point number with paying attention to host and network order. This is for avoiding any type differences with platforms, architectures and compilers.
- Whenever data is available on TCP stream the application copies incoming data into a buffer
- The buffer is processed by firstly reading the packet size
- If the buffer is at least so large as the received packet size, processing is continued by reading the packet id and the packet id dependent payload
