#!/usr/bin/env python3
#this script was developed by Robin Newman, September 2018
#starting point was
# developed from NeoPixel library strandtest example
# Author: Tony DiCola (tony@tonydicola.com)
#
# Script adds support for 16 different incoming OSC messages
# to control a 4tronix cubebit
#It is intended for use by Sonic Pi, but any device generating OSC messages can be used
import datetime
import time
from rpi_ws281x import *
import argparse
from pythonosc import dispatcher
from pythonosc import osc_server
from pythonosc import osc_message_builder
from pythonosc import udp_client
import sys

# LED strip configuration:
LED_COUNT      = 125    # Number of LED pixels.
LED_PIN        = 18      # GPIO pin connected to the pixels (18 uses PWM!).
#LED_PIN        = 10      # GPIO pin connected to the pixels (10 uses SPI /dev/spidev0.0).
LED_FREQ_HZ    = 800000  # LED signal frequency in hertz (usually 800khz)
LED_DMA        = 10      # DMA channel to use for generating signal (try 10)
LED_BRIGHTNESS = 110     # Set to 0 for darkest and 255 for brightest
LED_INVERT     = False   # True to invert the signal (when using NPN transistor level shift)
LED_CHANNEL    = 0       # set to '1' for GPIOs 13, 19, 41, 45 or 53

prflag=False #governs print messages on screen
colorof={'ff0000':"red",'ffa500':"orange",'ffff00':"yellow",'00ff00':"green",
    '0000ff':"blue",'4b0082':"indigo",'00ffff':"cyan",'c71585':"violet",
    'ff00ff':"magenta",'ff1493':"pink",'0f0000':"r0",'1f0000':"r1",
    '2f0000':"r2",'3f0000':"r3",'4f0000':"r4",'5f0000':"r5",'6f0000':"r6",
    '7f0000':"r7",'8f0000':"r8",'9f0000':"r9",'af0000':"rA",'bf0000':"rB",
    'cf0000':"rC",'df0000':"rD",'ef0000':"rE",'000f00':"g0",'001f00':"g1",
    '002f00':"g2",'003f00':"g3",'004f00':"g4",'005f00':"g5",'006f00':"g6",
    '007f00':"g7",'008f00':"g8",'009f00':"g9",'00af00':"gA",'00bf00':"gB",
    '00cf00':"gC",'00df00':"gD",'00ef00':"gE",'00000f':"b0",'00001f':"b1",
    '00002f':"b2",'00003f':"b3",'00004f':"b4",'00005f':"b5",'6f':"0000b6",
    '00007f':"b7",'00008f':"b8",'00009f':"b9",'0000af':"bA",'0000bf':"bB",
    '0000cf':"bC",'0000df':"bD",'0000ef':"bE",'000000':"black",'ffffff':"white",
    '111111':"w1",'222222':"w2",'333333':"w3",'333333':"w3",'444444':"w4",
    '555555':"w5",'666666':"w6",'777777':"w7",'888888':"w8",'999999':"w9",
    'aaaaaa':"wA",'bbbbbb':"wB",'cccccc':"wC",'dddddd':"wD",'eeeeee':"wE"}

#cube dimensions
cubeSide=5 #adjust for your setup
cubeHeight=5 #adjust for your setup
cubeSide2=cubeSide * cubeSide
cubeSide3=cubeSide * cubeSide * cubeHeight

#lookup colour name from colour value, or return hex if no name 
def hexpad(s):
    return s[2:].zfill(6)
def c(cval):   
    #if (hex(cval)[2:] in colorof):
    if (hexpad(hex(cval)) in colorof):
        return colorof[hexpad(hex(cval))]
        #return colorof[hex(cval)[2:]]
    else:
        return hexpad(hex(cval))

#split 6 digit hex to r,g,b tuple
def hex_to_rgb(value): 
    """Return (red, green, blue) for the color given as #rrggbb."""
    value =('0x%0*x' % (6,value))[2:] #pad to 6 digits and strip 0x
    lv = len(value)
    return tuple(int(value[i:i + lv // 3], 16) for i in range(0, lv, lv // 3))
        
        
#map x,y,z to led position
def pMap(x,y,z,side=cubeSide): 
    q=0
    if (x<side and y<side and z<cubeHeight and x>=0 and y >=0 and z >=0):
        if ((z%2) == 0):
            if((y%2) ==0):
                q = y * side + x
            else:
                q = y * side + side - 1 - x
        else:
            if ((side%2) == 0):
                y = side - y -1
            if ((x%2) == 0):
                q = side * (side - x) - 1 - y
            else:
                q = (side - 1 - x) * side + y
        return z*side*side + q
    return cubeSide3

#set leds in given plane, flash if parameter>0
def setPlane(plane, axis, color,flash=0,l=cubeSide,d=cubeSide,rev=0):
    if ("m" in axis):
        pl=cubeSide-1-plane
    else:
        pl=plane        
    if prflag: print("plane",pl) 
    if (axis[:2] == "yz"):
        for y in range(l):
            y2=cubeSide-1-y if rev==1 else y
            for z in range(d):
                if prflag==True: print("axis x,y,z",axis,pl,y2,z)
                strip.setPixelColor(pMap(pl,y2,z,cubeSide), color)
    elif (axis[:2] == "xz"):
        for x in range(l):
            x2=cubeSide-1-x if rev==1 else x
            for z in range(d):
                if prflag: print("axis x,y,z",axis,x2,pl,z)
                strip.setPixelColor(pMap(x2,pl,z,cubeSide), color)
    elif (axis[:2] == "xy"):
        for x in range(l):#(l-1,-1,-1):
            x2=cubeSide-1-x if rev==1 else x
            for y in range(d):
                if prflag:print("axis x y z",axis,x2,y,pl)
                strip.setPixelColor(pMap(x2,y,pl,cubeSide), color)
    strip.show()
    if(flash>0):
        time.sleep(flash)
        if (axis[:2] == "yz"):
            for y in range(l):
                y2=cubeSide-1-y if rev==1 else y
                for z in range(d):
                    if prflag: print("axis x,y,z",axis,pl,y2,z)
                    strip.setPixelColor(pMap(pl,y2,z,cubeSide), 0)
        elif (axis[:2] == "xz"):
            for x in range(l):
                x2=cubeSide-1-x if rev==1 else x
                for z in range(d):
                    if prflag: print("axis x,y,z",axis,x2,pl,z)
                    strip.setPixelColor(pMap(x2,pl,z,cubeSide), 0)
        elif (axis[:2] == "xy"):
            for x in range(l):#(l-1,-1,-1):
                x2=cubeSide-1-x if rev==1 else x
                for y in range(d):
                    if prflag: print("axis x y z",axis,x2,y,pl)
                    strip.setPixelColor(pMap(x2,y,pl,cubeSide), 0)
        strip.show()

#colour all leds. flash if param > 0
def colorAll(strip,color,flash=0): 
    for i in range(strip.numPixels()):
        strip.setPixelColor(i, color)
    strip.show()
    if(flash>0):
        time.sleep(flash)
        for i in range(strip.numPixels()):
            strip.setPixelColor(i, 0)
        strip.show()

#clear all leds
def clearAll(strip):
    for i in range(strip.numPixels()):
        strip.setPixelColor(i, 0)
    strip.show()

#fill vert line at x,y. flash if param > 0
def vLine(x,y,color,flash=0):
    for i in range(cubeSide):
        strip.setPixelColor(pMap(x,y,i),color)
    strip.show()
    if(flash>0):
        time.sleep(flash)
        for i in range(cubeSide):
            strip.setPixelColor(pMap(x,y,i),0)
        strip.show()
        
#fill left-right line at y,z. flash if param > 0
def lrLine(y,z,color,flash=0): 
    for i in range(cubeSide):
        strip.setPixelColor(pMap(i,y,z),color)
    strip.show()    
    if(flash>0):
        time.sleep(flash)
        for i in range(cubeSide):
            strip.setPixelColor(pMap(i,y,z),0)
        strip.show()

#fill front/back line at x,z. flash if param > 0
def fbLine(x,z,color,flash=0,): 
    for i in range(cubeSide):
        strip.setPixelColor(pMap(x,i,z),color)
    strip.show()    
    if(flash>0):
        time.sleep(flash)
        for i in range(cubeSide):
            strip.setPixelColor(pMap(x,i,z),0)
        strip.show()

#draw cube perim at x,y,z size side. flash if param> 0
def drawCube(x,y,z,side,color,flash=0):
    if ((x+side>cubeSide) or (y+side > cubeSide) or (z+side > cubeSide)):
        return
    for p in range(x,x+side):
        strip.setPixelColor(pMap(p,y,z),color)
        strip.setPixelColor(pMap(p,y+side-1,z),color)
        strip.setPixelColor(pMap(p,y,z+side-1),color)
        strip.setPixelColor(pMap(p,y+side-1,z+side-1),color)        
    for p in range(y,y+side):
        strip.setPixelColor(pMap(x,p,z),color)
        strip.setPixelColor(pMap(x+side-1,p,z),color)
        strip.setPixelColor(pMap(x,p,z+side-1),color)
        strip.setPixelColor(pMap(x+side-1,p,z+side-1),color)
    for p in range(z,z+side):
        strip.setPixelColor(pMap(x,y,p),color)
        strip.setPixelColor(pMap(x+side-1,y,p),color)
        strip.setPixelColor(pMap(x,y+side-1,p),color)
        strip.setPixelColor(pMap(x+side-1,y+side-1,p),color)
        strip.show() 
    if(flash>0):
        time.sleep(flash)
        for p in range(x,x+side):
            strip.setPixelColor(pMap(p,y,z),0)
            strip.setPixelColor(pMap(p,y+side-1,z),0)
            strip.setPixelColor(pMap(p,y,z+side-1),0)
            strip.setPixelColor(pMap(p,y+side-1,z+side-1),0)        
        for p in range(y,y+side):
            strip.setPixelColor(pMap(x,p,z),0)
            strip.setPixelColor(pMap(x+side-1,p,z),0)
            strip.setPixelColor(pMap(x,p,z+side-1),0)
            strip.setPixelColor(pMap(x+side-1,p,z+side-1),0)
        for p in range(z,z+side):
            strip.setPixelColor(pMap(x,y,p),0)
            strip.setPixelColor(pMap(x+side-1,y,p),0)
            strip.setPixelColor(pMap(x,y+side-1,p),0)
            strip.setPixelColor(pMap(x+side-1,y+side-1,p),0)
            strip.show()     

#draw filled cube at x,y,z size side. flash if param>0
def drawSolidCube(x,y,z,side,color,flash=0):
    for r in range(z,z+side):
        for q in range(y,y+side):
            for p in range(x,x+side):
                strip.setPixelColor(pMap(p,q,r),color)
    strip.show()
    if flash>0:
        time.sleep(flash)
        for r in range(z,z+side):
            for q in range(y,y+side):
                for p in range(x,x+side):
                    strip.setPixelColor(pMap(p,q,r),Color(0,0,0))
        strip.show()

def slantTriangle(x2,y2,z2,side,color,flash=0): #note only fills for cube shape not odd height
    strip.setPixelColor(pMap(x2,y2,z2),color)
    if (x2==0 and y2==0 and z2==0):
        for z in range(1,side):       
            for x in range(0,z+1):
                strip.setPixelColor(pMap(x,z-x,z),color)
    if (x2==cubeSide-1 and y2==0 and z2==0):
        for z in range(1,side):
            for x in range(0,z+1):
                strip.setPixelColor(pMap(x+cubeSide-1-z,x,z),color)
    if (x2==cubeSide-1 and y2==cubeSide-1 and z2==0):
        for z in range(1,side):
            for x in range(0,z+1):
                strip.setPixelColor(pMap(x+cubeSide-1-z,cubeSide-1-x,z),color)
    if (x2==0 and y2==cubeSide-1 and z2==0):
        for z in range(1,side):
            for x in range(0,z+1):
                strip.setPixelColor(pMap(x,x+cubeSide-1-z,z),color)                
    if (x2==0 and y2==0 and z2==cubeSide-1):
        for z in range(side-1,0,-1):
            for x in range(0,z+1):
                strip.setPixelColor(pMap(x,z-x,cubeSide-1-z),color)
    if (x2==cubeSide-1 and y2==0 and z2==cubeSide-1):
        for z in range(1,side):
            for x in range(0,z+1):
                strip.setPixelColor(pMap(x+cubeSide-1-z,x,cubeSide-1-z),color)
    if (x2==cubeSide-1 and y2==cubeSide-1 and z2==cubeSide-1):
        for z in range(1,side):
            for x in range(0,z+1):
                strip.setPixelColor(pMap(x+cubeSide-1-z,cubeSide-1-x,cubeSide-1-z),color)
    if (x2==0 and y2==cubeSide-1 and z2==cubeSide-1):
        for z in range(1,side):
            for x in range(0,z+1):
                strip.setPixelColor(pMap(x,x+cubeSide-1-z,cubeSide-1-z),color)                
    strip.show()
    if(flash>0): #turn leds off if flash set
        time.sleep(flash)
        strip.setPixelColor(pMap(x2,y2,z2),0)
        if (x2==0 and y2==0 and z2==0):
            for z in range(1,side):       
                for x in range(0,z+1):
                    strip.setPixelColor(pMap(x,z-x,z),0)
        if (x2==cubeSide-1 and y2==0 and z2==0):
            for z in range(1,side):
                for x in range(0,z+1):
                    strip.setPixelColor(pMap(x+cubeSide-1-z,x,z),0)
        if (x2==cubeSide-1 and y2==cubeSide-1 and z2==0):
            for z in range(1,side):
                for x in range(0,z+1):
                    strip.setPixelColor(pMap(x+cubeSide-1-z,cubeSide-1-x,z),0)
        if (x2==0 and y2==cubeSide-1 and z2==0):
            for z in range(1,side):
                for x in range(0,z+1):
                    strip.setPixelColor(pMap(x,x+cubeSide-1-z,z),0)
        if (x2==0 and y2==0 and z2==cubeSide-1):
            for z in range(side-1,0,-1):
                for x in range(0,z+1):
                    strip.setPixelColor(pMap(x,z-x,cubeSide-1-z),0)
        if (x2==cubeSide-1 and y2==0 and z2==cubeSide-1):
            for z in range(1,side):
                for x in range(0,z+1):
                    strip.setPixelColor(pMap(x+cubeSide-1-z,x,cubeSide-1-z),0)
        if (x2==cubeSide-1 and y2==cubeSide-1 and z2==cubeSide-1):
            for z in range(1,side):
                for x in range(0,z+1):
                    strip.setPixelColor(pMap(x+cubeSide-1-z,cubeSide-1-x,cubeSide-1-z),0)
        if (x2==0 and y2==cubeSide-1 and z2==cubeSide-1):
            for z in range(1,side):
                for x in range(0,z+1):
                    strip.setPixelColor(pMap(x,x+cubeSide-1-z,cubeSide-1-z),0)                
        strip.show()
               
# Define functions which animate LEDs in various ways.
def colorWipe(strip, color, wait_ms=50,rev=0):
    """Wipe color across display a pixel at a time."""
    if(rev==0):
        for i in range(strip.numPixels()):
            strip.setPixelColor(i, color)
            strip.show()
            time.sleep(wait_ms/1000.0)
    else:
        for i in range(strip.numPixels(),-1,-1):
            strip.setPixelColor(i, color)
            strip.show()
            time.sleep(wait_ms/1000.0)


def theaterChase(strip, color, wait_ms=50, iterations=10,clear=0):
    """Movie theater light style chaser animation."""
    for j in range(iterations):
        for q in range(3):
            for i in range(0, strip.numPixels(), 3):
                strip.setPixelColor(i+q, color)
            strip.show()
            time.sleep(wait_ms/1000.0)
            for i in range(0, strip.numPixels(), 3):
                strip.setPixelColor(i+q, 0)
    if(clear>0):
        clearAll(strip)

def wheel(pos):
    """Generate rainbow colors across 0-255 positions."""
    if pos < 85:
        return Color(pos * 3, 255 - pos * 3, 0)
    elif pos < 170:
        pos -= 85
        return Color(255 - pos * 3, 0, pos * 3)
    else:
        pos -= 170
        return Color(0, pos * 3, 255 - pos * 3)

def rainbow(strip, wait_ms=20, iterations=1,clear=0):
    """Draw rainbow that fades across all pixels at once."""
    for j in range(256*iterations):
        for i in range(strip.numPixels()):
            strip.setPixelColor(i, wheel((i+j) & 255))
        strip.show()
        time.sleep(wait_ms/1000.0)
    if(clear>0):
        clearAll(strip)

def rainbowCycle(strip, wait_ms=20, iterations=5,clear=0):
    """Draw rainbow that uniformly distributes itself across all pixels."""
    for j in range(256*iterations):
        for i in range(strip.numPixels()):
            strip.setPixelColor(i, wheel((int(i * 256 / strip.numPixels()) + j) & 255))
        strip.show()
        time.sleep(wait_ms/1000.0)
    if(clear>0):
        clearAll(strip)

def theaterChaseRainbow(strip, wait_ms=50,clear=0):
    """Rainbow movie theater light style chaser animation."""
    for j in range(256):
        for q in range(3):
            for i in range(0, strip.numPixels(), 3):
                strip.setPixelColor(i+q, wheel((i+j) % 255))
            strip.show()
            time.sleep(wait_ms/1000.0)
            for i in range(0, strip.numPixels(), 3):
                strip.setPixelColor(i+q, 0)
    if(clear>0):
        clearAll(strip)
                        

def fadeInAndOut( color, iterations,  wait_ms,direction=0,start=0,finish=cubeSide3):
    k=datetime.datetime.now() #to work out duration
    colrgb=hex_to_rgb(color)
    red=colrgb[0]
    green=colrgb[1]
    blue=colrgb[2]
    s1=s2=f1=f2=st1=st2=0
    if(direction==0): #0=up/down or 1=down/up
        s1=0;f1=102;st1=2
        s2=100;f2=-2;st2=-2
    else:
        s1=100;f1=-2;st1=-2
        s2=0;f2=102;st2=2
    for j in range(iterations):
        for b in range(s1,f1,st1):
            for i in range(start,finish):
                strip.setPixelColor(i, Color(int(red*b/100), int(green*b/100), int(blue*b/100)))
            strip.show()
            time.sleep(wait_ms/1000)
        for b in range(s2,f2,st2):
            for i in range(start,finish):
                strip.setPixelColor(i, Color(int(red*b/100), int(green*b/100), int(blue*b/100)))
            strip.show();
            time.sleep(wait_ms/1000)
    if prflag: print(datetime.datetime.now()-k) #print duration
   
#functions to handle osc dispatcher calls 
def oscClear(unused_addr,args,id=-1): 
    if prflag: print("/clearAll id",id)
    clearAll(strip)
    if id > -1: sender.send_message('/clearalldone'+str(id),"ok")

def oscpixelN(unused_addr,args,n,cv,flash=0,wait_ms=50):
    if prflag: print("/pixelN,n,colour,flash,wait_ms",n,c(cv),flash,wait_ms)
    lc=strip.getPixelColor(n)
    strip.setPixelColor(n,cv)
    strip.show()
    if (flash>0):
        cret=[0,lc][flash-1]
        time.sleep(wait_ms/1000.0)
        strip.setPixelColor(n,cret)
        strip.show()

def oscpixelXYZ(unused_addr,args,x,y,z,cv,flash=0,wait_ms=50):
    if prflag: print("/pixelXYZ x,y,z,colour,flash,wait_ms",x,y,z,c(cv))
    lc=strip.getPixelColor(pMap(x,y,z))
    strip.setPixelColor(pMap(x,y,z),cv)
    strip.show()
#     time.sleep(0.05)
#     strip.setPixelColor(pMap(x,y,z),0)
    strip.show()
    if (flash>0):
        cret=[0,lc][flash-1]
        if prflag: print(hexpad(cret))
        time.sleep(wait_ms/1000.0)
        strip.setPixelColor(pMap(x,y,z),cret)
        strip.show()
   
def oscLine(unused_addr,args,x,y,z,cv,flash=0,id=-1): #axis set by value <0
    if prflag: print("/Line x,y,z,cv,flash,id",x,y,z,c(cv),flash,id)
    if (x<0):
        lrLine(y,z,cv) #left-right when x<0
        if(flash>0):
            time.sleep(flash)
            lrLine(y,z,0)
    elif (y<0):
        fbLine(x,z,cv) #front back when y<0
        if(flash>0):
            time.sleep(flash)
            fbLine(x,z,0)           
    elif (z<0):
        vLine(x,y,cv) #vertical when z<0
        if(flash>0):
            time.sleep(flash)
            vLine(x,y,0)
    if id > -1: sender.send_message('/linedone'+str(id),"ok")
        
def oscHollowCube(unused_addr,args,x,y,z,side,cv,flash=0,id=-1):
    if prflag: print("/hollowCube x,y,z,side,cv,flash",x,y,z,side,c(cv),flash,id)
    drawCube(x,y,z,side,cv,flash)
    if id > -1: sender.send_message('/hollowcubedone'+str(id),"ok") 
                        
def oscSolidCube(unused_addr,args,x,y,z,side,cv,flash=0,id=-1):    
    if prflag: print("/solidCube x,y,z,side,cv,flash,id",x,y,z,side,c(cv),flash,id)
    drawSolidCube(x,y,z,side,cv,flash)
    if id > -1: sender.send_message('/solidcubedone'+str(id),"ok")
         
def oscSlantTriangle(unused_addr,args,x,y,z,side,cv,flash=0,id=-1):
    if prflag: print("/slantTriangle x,y,z,side,cv,flash,id",x,y,z,side,c(cv),flash,id)
    slantTriangle(x,y,z,side,cv,flash)
    if id > -1: sender.send_message('/slanttriangledone'+str(id),"ok")
         
def oscSetPlane(unused_addr,args,plane,axis,cv,flash=0,l=5,d=5,rev=0,id=-1):
    if prflag: print("/setPlane plane,axis,cv,flash,l,d,rev,id",plane,axis,c(cv),flash,l,d,rev,id)
    setPlane(plane,axis,cv,flash,l,d,rev)
    if id > -1: sender.send_message('/setplanedone'+str(id),"ok")
         
def oscColorAll(unused_addr,args,cv,flash=0,id=-1):
    if prflag: print("/colorAll cv,flash,id",c(cv),flash,id)
    colorAll(strip,cv,flash)
    if id > -1: sender.send_message('/coloralldone'+str(id),"ok") 
         
def oscColorWipe(unused_addr,args,cv,delay=50,rev=0,id=-1):
    if prflag: print("/colorWipe cv,delay,rev,id",c(cv),delay,rev,id)
    colorWipe(strip,cv,delay,rev)
    if id > -1: sender.send_message('/colorwipedone'+str(id),"ok""")	 
    
def oscRainbow(unused_addr,args,delay,iterations,clear=0,id=-1):
    if prflag: print("/rainbow delay,iterations,clear,id",delay,iterations,clear)
    rainbow(strip,delay,iterations,clear)
    if id > -1: sender.send_message('/rainbowdone'+str(id),"ok")	 
    
def oscRainbowCycle(unused_addr,args,delay,iterations,clear=0,id=-1):
    if prflag: print("/rainbowCycle delay,iterations,clear,id",delay,iterations,clear,id)
    rainbowCycle(strip,delay,iterations,clear)
    if id > -1: sender.send_message('/rainbowcycledone'+str(id),"ok")	 
    
def oscTheaterChase(unused_addr,args, cv, delay, iterations, clear=0,id=-1):
    if prflag: print("/theaterChase cv,delay,iterations,clear,id",c(cv),delay,iterations,clear,id)
    theaterChase(strip, cv, delay, iterations, clear)
    if id > -1: sender.send_message('/theaterchasedone'+str(id),"ok")
         
def oscTheaterChaseRainbow(unused_addr,args, delay,clear=0,id=-1):
    if prflag: print("/theaterChaseRainbow delay,clear,id",delay,clear,id)
    theaterChaseRainbow(strip, delay,clear)
    if id > -1: sender.send_message('/theaterchaserainbowdone'+str(id),"ok")
        
def oscFadeInAndOut(unused_addr,args,cv,iterations=10,delay=4,direction=0,start=0,finish=cubeSide3,id=-1 ):
    if prflag: print("/fadeInAndOut colour,iterations,delay,direction,start,finish,id",c(cv),iterations,delay,direction,start,finish,id)
    fadeInAndOut(cv,iterations,delay,direction,start,finish)
    if id > -1: sender.send_message('/fadeinandoutdone'+str(id),"ok")
         
def oscSetBrightness(unused_addr,args,brightness):
    if prflag: print("/setBrightness brightness",max(min(110, brightness), 0))
    strip.setBrightness(max(min(110, brightness), 0))
    strip.show() 

def oscPingBack(unused_addr,args,code): 
    if prflag: print("/pingBack code",code)
    #sender client set up in __main__ below
    sender.send_message('/pingbackdone'+str(code), "ok")

def oscGetColorN(unused_addr,args,n):
    if prflag: print("/getColorN n",n)
    #sender client set up in __main__ below
    if id > -1: sender.send_message('/colorN', strip.getPixelColor(n))

def oscGetColorXYZ(unused_addr,args,axis,cv,id=-1):
    if prflag: print("/getColorXYZ x,y,z",x,y,z)
    if id > -1: sender.send_message('/colorXYZ', strip.getPixelColor(pMap(x,y,z)))

def oscSandwichCube(unused_addr,args,axis,cv,id=-1):
    if prflag: print("/sandwichCube axis, colour, id",axis,c(cv),id)
    crgb=hex_to_rgb(cv)
    if prflag: print("crgb",crgb)
    setPlane(0,axis, cv)
    setPlane(4,axis,cv)    
    setPlane(3,axis,crgb[0]*16**4)                                     
    setPlane(2,axis,crgb[1]*16**2)                                     
    setPlane(1,axis,crgb[2])
    if id > -1: sender.send_message('/sandwichcubedone'+str(id),"ok")	 

def oscTriCube(unused_addr,args,axis,cv1,cv2,id=-1):
    if prflag: print("/triCube colour1, colour2, id",axis,c(cv1),c(cv2),id)
    setPlane(0, axis, cv1,0,5,5,0)
    setPlane(1, axis, cv1,0,4,5,0)
    setPlane(2, axis, cv1,0,3,5,0)
    setPlane(3, axis, cv1,0,2,5,0)
    setPlane(4, axis, cv1,0,1,5,0)
                                                 
    setPlane(4, axis, cv2,0,5,5,1)
    setPlane(3, axis, cv2,0,4,5,1)
    setPlane(2, axis, cv2,0,3,5,1)
    setPlane(1, axis, cv2,0,2,5,1)
    setPlane(0, axis, cv2,0,1,5,1)
    if prflag: print("tricubedone")
    if id > -1: sender.send_message('/tricubedone'+str(id),"ok")	 

# Main program logic follows:
if __name__ == '__main__':
    # Create NeoPixel object with appro priate configuration.
    strip = Adafruit_NeoPixel(LED_COUNT, LED_PIN, LED_FREQ_HZ, LED_DMA, LED_INVERT, LED_BRIGHTNESS, LED_CHANNEL)
    # Intialize the library (must be called once before other functions).
    strip.begin()
    # Process arguments
    parser = argparse.ArgumentParser() 
    parser.add_argument('-c', '--clear', action='store_true', help='clear the display on exit')
    parser.add_argument('-ip', '--ip',
    default='127.0.0.1', help="The ip to listen on")
    parser.add_argument("-sp",'--sp',
        default="127.0.0.1", help="The ip Sonic Pi is on")
    parser.add_argument('-pr','--pr', action='store_true',
        help='print messages on terminal screen')
    args = parser.parse_args()
    #must supply actual ip address of pizero or wont connect externally
    #check that ip has been supplied, exit if not
    if (args.ip=='127.0.0.1'):
        print("Must supply actual local ip address arg of this computer, (not 127.0.0.1)")
        print("use arg -ip xx.xx.xx.xx")
        sys.exit()
    if (args.sp=='127.0.0.1'):
        print("Must supply ip address of Sonic Pi computer, (not 127.0.0.1)")
        print("use arg -sp xx.xx.xx.xx")
        sys.exit()
    print("Sonic Pi expected on ip {} port 4559".format(args.sp))
    sender=udp_client.SimpleUDPClient(args.sp,4559) #sender set up for specified IP
    if(args.pr): prflag=True #control printing of messages         
    dispatcher=dispatcher.Dispatcher()
    dispatcher.map("/clearAll",oscClear,"id")
    dispatcher.map("/pixelN",oscpixelN,"n","cv","flash","wait_ms")
    dispatcher.map("/pixelXYZ",oscpixelXYZ,"x","y","z","cv","flash","wait_ms")
    dispatcher.map("/line",oscLine,"x","y","z","cv","flash,id")
    dispatcher.map("/hollowCube",oscHollowCube,"x","y","z","side","cv","flash","id")
    dispatcher.map("/solidCube",oscSolidCube,"x","y","z","side","cv","flash","id")
    dispatcher.map("/slantTriangle",oscSlantTriangle,"x","y","z","side","cv","flash","id")
    dispatcher.map("/setPlane",oscSetPlane,"plane","axis","cv","flash","l","d","rev","id")
    dispatcher.map("/colorAll",oscColorAll,"cv","flash","id")
    dispatcher.map("/colorWipe",oscColorWipe,"cv","delay","rev","id")
    dispatcher.map("/rainbow",oscRainbow, "delay", "iterations","clear","id")
    dispatcher.map("/rainbowCycle",oscRainbowCycle, "delay", "iterations","clear","id")
    dispatcher.map("/theaterChase",oscTheaterChase, "cv","delay", "iterations","clear","id")
    dispatcher.map("/theaterChaseRainbow",oscTheaterChaseRainbow, "delay", "clear","id")
    dispatcher.map("/fadeInAndOut",oscFadeInAndOut, "cv", "iterations","delay","start","finish","id")
    dispatcher.map("/setBrightness",oscSetBrightness, "brightness")
    dispatcher.map ("/pingBack",oscPingBack,"code")
    dispatcher.map("/getColorN",oscGetColorN,"n")
    dispatcher.map("/getColorXYZ",oscGetColorXYZ,"x","y","z")
    dispatcher.map("/sandwichCube",oscSandwichCube,"axis","cv","id")
    dispatcher.map("/triCube",oscTriCube,"axis","cv1","cv2","id")

    #start main code

    #print exit info
    print ('Press Ctrl-C to quit.')
    if not args.clear:
        print('Use "-c" argument to clear LEDs on exit')
    if not args.pr:
        print('use "-pr" argument to print messages on terminal screen')

    try:
      #set up and start osc server, running until keyboard interrupt (ctrl-C)
      server = osc_server.ThreadingOSCUDPServer(
          (args.ip, 8000), dispatcher)
      print("Serving on {}".format(server.server_address))

      time.sleep(2)
      #flash a layer to show cube is active and connected
      setPlane(0, "xy", Color(255,0,0),0)
      strip.show()
      time.sleep(1)
      clearAll(strip)
      server.serve_forever()      


    except KeyboardInterrupt:
        #if -c arg supplied clear all leds
        if args.clear:
            colorWipe(strip, Color(0,0,0), 10)
        #program finished!
