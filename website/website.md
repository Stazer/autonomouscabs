# Cab Service 3
**Group members**: *Henrik Claßen*, *Justus Flerlage*, *Felix Heimann*, *Luyanda Mlangeni*, *Gerda Zsejke Móré*, *Yue Wang*

## Project overview
Cities like Copenhagen in Denmark show how modern transportation will look like.
Here computers control the metro fully automated without any human driving interaction.
We want to take this a step further by creating an autonomous cab-on-demand service for transporting
passengers from their predefined locations to their destinations.

### Goals
Our main goal is to have a working prototype, meeting given requirements. The project is very challenging,
so problems with algorithms are expected. Therefor, related issues are still within our goal set.

### Requirements
#### General
- Pick up passengers at predefined locations
- Transport passengers quickly to their destination
- Use available cabs efficiently
- Avoid collisions
#### Environment
- All roads should be one-way(exception: connection to the depot)
- There should be at least two passing sections
- There should be at least one depot, where you can park unused cabs
- There should be at least four pick-up locations
#### Robot
- Only use the following types of sensors: ultrasonic distance sensor, camera, light sensor
- Place at least two robots in your environment
- Each robot has room for at least two passengers
#### Control
- Use the general architecture from the overview presentation
- Coordinate your robots to achieve your mission
- Make the operation safe: robust to communication failure, ...
- Verify/validate the operation
- Optimize cab efficiency: average travel time, load, ...

### Approach
Creating an autonomous service is related to a lot of problems. Especially, things
like collision avoidance and general path following are very difficult problems, even in more simpler environments.
How have you tried to meet the above requirements? What were your ideas?

- Approach 1
- Approach 2
- Approach 3

## System architecture
The overall system architecture consists of three different applications. For each cab there is a single instance
of the webots controller and a single instance of the external controller. Here the webots controller is responsible
for the interaction with our simulated environment, while the external controller manages and controls the cab by using
provided data. It is like the brain of a cab, while the webots controller is more like muscles and senses. The third application
is the backend, which controls passenger requests and the cab provisioning and distribution by communicating with
the external controller. 

![diagram](./images/architecture.svg)

### Software design
#### General
The communication between all three componets is done by using the Transmission Control Protocol (TCP), 
as it is reliable and still fast enough for our purposes. For this, we introduced a binary protocol 
on top of TCP for exchanging data between all parties.

#### Webots Controller
A single class is implemented, which handles the data exchange and command execution:
- Written in C++17
- Utilizing the [webots API](https://www.cyberbotics.com/doc/reference/index) for the interaction with the environment
- Asynchronous networking with [Boost](https://www.boost.org/)

#### External Controller
Since the external controller is the most important application, as it controls and manages a cab, it is written in Ada:
- Ada makes it easier to verify program code and to proof its correctness
- Makes use of three different modules each running in its own thread:  
    - Two manage the communication with the backend and the webots controller
    - The third one does calculation

#### Backend
The backend is a simple TCP server:
- written in C++17
- Uses [Boost](https://www.boost.org/) for asynchronous networking, graph abstraction and command line parsing
- Receives position and route data from the external controllers
- Retrieves any passenger requests and distributes those onto the cabs

### Robot design
The cab hast two sensor types: a camera and several distance sensors
- The camera placed in front is used to detect the white line on the road
- The distance sensors are places at the front and both sides of the cab to detect the road barriers as well as
obstacles on the road.

![robot](./images/cab.png)

### Environment design
The environment consists of eight pickup locations and a depot for the unused cabs.
Pickup locations on the outer roads (P4 - P7) take a longer time to arrive at, which
allows for a more complex cab provision algorithm.

![evironment](./images/environment.png)

### Algorithms
Write an introduction to the **most essential** algorithms or technologies in general that you have chosen for your project. 

Maybe with **short** code examples.

```python
def our_algorithm(x, y):
    # Do fancy stuff here
    return {'x': x, 'y': y}
```

## Summary
Although all subsystems work quite well, the integration of the overall system is still lacking. This is mainly due to
wrong time management. The project topic itself is very interesting, but even in simple environments very complicated, since
it introduces topics like collision avoidance and path following. We think that a little bit more time for the project would have
resolved the integration issue.

### Lessions learned
We did not reach our overall goal, but everyone in our group did a good job and gave its best. For the future, we can tell,
that time management, management in general and communication are the very most important things for a project.

### Future work
What problems would you tackle if you would continue to work on the project? Are there things you might actually take up and work on in the future? This part is **optional**.
