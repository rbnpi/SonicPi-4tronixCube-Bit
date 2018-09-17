# SonicPi-4tronixBitCube
Code to allow Sonic Pi to drive a 4tronix bitcube using a pizero W

To use this you need a 4tronix bitcube with a raspberry pizero W connected to the base board as a driver.
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
  The OSC messages the script responds to are shown in the file callDocumentation.txt
  
