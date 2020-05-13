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
- Pull request is reviewed by at least two people in order to ensure code quality, structure, requirements and succeeded unit tests.
- Branch is merged into master and deleted

## Quality Assurance
- Unit tests are written for most components
- Minimum 80% code coverage
- Few tests should cover much code
- Tests are executed by TravisCI on each commit
- Integration tests ensure the overall functionality and that all components are working together as expected

## Dependencies and Tools
### ADA
- [GNAT](https://www.adacore.com/gnatpro/toolsuite/gnatstudio) as IDE
- [GNATtest](https://www.adacore.com/gnatpro/toolsuite/gnattest) for unit testing
### C++
- [CMake](https://cmake.org/) as build system
- [Boost](https://www.boost.org/) for unit testing and networking

## Protocol
### General
- Binary protocol consisting of packet id and payload
- The packet id (32-Bit) defines what type of packet is handled and what kind of payload is expected
- Example: For the location data packet with id 3 the payload for transmitting the 2D location data could look like this:
```
typedef struct {
    uint64_t x;
    uint64_t y;
} location_data_payload;
```
- Although coordinates are floating point numbers, the data is transmitted using 64-Bit unsigned integers. All payloads should use fixed sized integers only. Marshalling and unmarshalling converts the integer into the appropriate floating point number with paying attention to host and network order. This is for avoiding any type differences with platforms, architectures and compilers.
- Whenever data is available on TCP stream the application copies incoming data into a buffer
- The buffer is processed by reading a packet id and reading a packet id dependent payload
