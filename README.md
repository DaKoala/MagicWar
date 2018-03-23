# MagicWar
![code](https://img.shields.io/badge/code-Billy%20Zou-blue.svg)
![artwork](https://img.shields.io/badge/artwork-Echo%20Qu-blue.svg)
![processing](https://img.shields.io/badge/Processing-3.3.6-lightgrey.svg)
![license](https://img.shields.io/badge/license-LGPL--3.0-green.svg)

**A online double player Leap Motion game. Developed using Processing.**

This project is the midterm project for the course [Kinetic Interfaces](http://ima.nyu.sh/kinetic-interfaces/) I take this semester and is collaborated with Echo Qu(yq534), who is responsible for the artwork part.

Players should use their hands to control the characters, cast spell and make other interesting movements. The only goal is to beat your opponent.

## Installation

### Download

``` bash
git clone https://github.com/DaKoala/MagicWar.git
```

### Dependencies

* Processing 3.3.6
  + Leap Motion for Processing
  + Minim
  + Processing net library(built in)
* Leap Motion connected and Leap Motion App installed

## Instruction

### Setup
One computer should be the server and the other one should be the client. For server, run `LeapMotionServer/LeapMotionServer.pde` Replace the port number with your port number on line `46` (default 8000). For client Replace the IP address and port number with server's IP address and port number on line `85`, then run `LeapMotionClient/LeapMotionClient.pde`. Both server and client will see the user interface below.

![ui](https://s1.ax1x.com/2018/03/20/9Tj6Ld.png)

Server player is player 1 and client player is player 2. There are three states, offline, waiting and ready. Grab your hands to get ready!

### Interface Description

![ui](https://s1.ax1x.com/2018/03/20/9TjRot.png)

Player 1 is on the **right** side and player 2 is one the **left** side. Three bars from top to bottom represent:

* Health Point

    200 in total, will reduce due to damages.

* Mana Point

    500 in total and initally is 0. User can generate it up to 45/second.

* Super Power Point

    1500 in total and initally is 0. It will increase automatically 45/second. Players can gain extra super power points if they successfully deal damage to their enemies.

### Operation Guide

#### Right Hand

* **Scratch index while roll up other four fingers** to cast a fireball. Fireball can deal 10 damages and cost 30 mana points.
* **Pinch with your thumb and index** to cast a lightning ball. Lightning ball can deal 20 damages and destroy fireballs. Its damages will increase by 10 with each fireball it destroy. It costs 100 mana points.
* **Grab** to cast a ultimate orb. The ultimate orb can deal 50 damages and destroy lightning balls or fireballs. A player can only cast a ultimate orb when the super power is full and it will cost all super power points.

#### Left Hand

* **Move up and down** to control the character
* **Draw circle with index** to generate mana point
* **Grab** to defend. This will reduce 80% fireball damage, 50% lightning damage or 20% ultimate orb damage.

## Demo

![demo](https://s1.ax1x.com/2018/03/21/97iQij.gif)

Above is a short part of the demo. If you want to view the whole video, please click [here](https://youtu.be/K3fQKdyuORs).

There is also a screen capture demo. Click [here](https://www.youtube.com/watch?v=7uFNb8NIkQk) to view it.

## Credit

* [Leap Motion](https://www.leapmotion.com/)
* [Leap Motion library for Processing](https://github.com/nok/leap-motion-processing)
* [Net library for processing](https://github.com/processing/processing/tree/master/java/libraries/net)
* [Minim](http://code.compartmental.net/tools/minim/)

Special thanks to my instructor J.H Moon for the supporting in the course.

## License

LGPL V3.0