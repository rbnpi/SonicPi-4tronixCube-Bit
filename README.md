# SonicPi-4tronixCube:Bit
Code to allow Sonic Pi to drive a 4tronix Cube:Bit using a Pizero W

To use this you need a 4tronix bitcube with a Raspberry Pizero W connected to the base board as a driver.
The pizero should have the latest Raspbian install, and in addition the following python libraries:
```
sudo pip3 install rpi-ws281x
sudo pip3 install python-osc
```
In addition, the file `osc-cube3.py` should be copied to a convenient location on the pizero.
This file is used to communicate with the pizero gpiopins and also with Sonic Pi (via OSC messages)
enabling the latter to control the 4tronix bitcube
```
usage: osc-cube3.py [-h] [-c] [-ip IP] [-sp SP] [-pr]

optional arguments:
  -h, --help       show this help message and exit
  -c, --clear      clear the display on exit
  -ip IP, --ip IP  The ip to listen on
  -sp SP, --sp SP  The ip Sonic Pi is on
  -pr, --pr        print messages on terminal screen
  ```
  The OSC messages the script responds to are shown in the file callDocumentation.md
  
The folder SP-files contains programs which run in Sonic Pi version 3.0.1 on a separate computer.
Tested on Mac and Pi3
testerCube.rb and testerSound.rb run together in separate Sonic Pi buffers. (Run testerSound first, then testerCube)

CubeWorkout has separate Pi and Mac versions (The Mac version is too long to run in a single buffer,
so is split into two parts which run consequetively.
The Pi version runs in a single file.
Both of these utilise a program setupCube.rb which they run internally.

I have also developed control of the cube using TouchOSC to provide input to Sonic Pi
which then passes on commands to the osc-cube3.py script. This requires TouchOSC.app running
on a tablet or phone (available for Mac and Android from hexler.net)
The Sonic Pi program is SPcubebitTouchOSC.rb
The TouchOSC template is in the folder TouchOSC. You need to download the index.xml file and the compress/zip
it to the filename cubeControl.touchosc YOu then use the TouchOSC editor to load it to your tablet/screen
where you can set up the osc host to your Sonic Pi computer ip and port 4559 and the incoming port to 4000

ALL THESE PROGRAMS REQUIRE YOU TO ADJUST IP address INFORMATION AND SOME FILE PATHS BEFORE RUNNING.
