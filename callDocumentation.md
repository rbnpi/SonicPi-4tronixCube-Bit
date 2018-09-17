OSC calls for osc-cube3.py. Requires ip of Cube:Bit Pizero and ip of Sonic Pi computer.
start with
```
 sudo python3 -c -ip xx.xx.xx.xx -sp xx.xx.xx.xx
```
ctrl-C to quit

    "/clearAll",oscClear,id=-1
    "/pixelN",oscpixelN,n,cv,flash=0,wait_ms=50
    "/pixelXYZ",oscpixelXYZ,"x","y","z","cv","flash","wait_ms"
    "/line",oscLine,x,y,z,cv,flash=0,id=-1   #axis set by x,y,z value < 0
    "/hollowCube",oscHollowCube,x,y,z,side,cv,flash=0,id=-1
    "/solidCube",oscSolidCube,x,y,z,side,cv,flash=0,id=-1
    "/slantTriangle",oscSlantTriangle,x,y,z,side,cv,flash=0,id=-1
    "/setPlane",plane,axis,cv,flash=0,l=5,d=5,rev=0,id=-1
    "/colorAll",oscColorAll,cv,flash=0,id=-1
    "/colorWipe",oscColorWipe,cv,delay=50,rev=0,id=-1
    "/rainbow",oscRainbow, delay,iterations,clear=0,id=-1
    "/rainbowCycle",oscRainbowCycle, delay,iterations,clear=0,id=-1
    "/theaterChase",oscTheaterChase, cv, delay, iterations, clear=0,id=-1
    "/theaterChaseRainbow",oscTheaterChaseRainbow, delay,clear=0,id=-1
    "/fadeInAndOut",oscFadeInAndOut,        cv,iterations=10,delay=4,direction=0,start=0,finish=cubeSide3,id=-1
    "/setBrightness",oscSetBrightness, brightness
    "/pingBack",oscPingBack,code
    "/getColorN",oscGetColorN,n
    "/getColorXYZ",oscGetColorXYZ,x,y,z
    "/sandwichCube",oscSandwichCube,axis,cv,id=-1
    "/triCube",oscTriCube,axis,cv1,cv2,id=-1

Notes:
id default is -1 give no return cue id >-1 give cue /osc/lowercase<name>doneNUM
where NUM is the id supplied

flash parameter= 0 leaves on, flash parameter n leaves on for n seconds
special case of pixelN and pixelXYZ flash 1 turns off after wait_ms, flash 2 restores previous colour after wait_ms.

delay is in seconds unless  parameter  is wait_ms when it is in milliseconds

cv is colour value 0 -> 0xFFFFFF (hex) or 16777215 (decimal)

x,y,z are pixel coordinates in the cube

axis is one of "xy","yz","xz"
axis can also accept "xym","yzm","xzm" in which case plane is mirrored about cube centre

rev (when 1) reverse direction of for loops to build up plane or colorWipe

brightness level range is 0->110 (110 is neopixel 40%) so that cube can be used with a modest power supply. Can be altered in the osc-cube3.py script, but take care with higher values that your power supply can cope.
