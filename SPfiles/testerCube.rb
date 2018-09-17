#Tester Sonic Pi program to try out 4tronix Cube:Bit by Robin Newman, September 2018
#first run testerSound.rb in a separate Sonic Pi buffer.(it will await a cue from this program)
#then run this program, which drives the cube via  messages to the osc-cube3.py script
#NB SETUP IP ADDRESS BELOW FIRST
use_osc "pp.qq.rr.ss",8000 #substitute ip address of cube pizero for pp.qq.rr.ss

use_real_time

#setp colour lookup hash

set :colorof,{"red"=>'0xff0000',"orange"=>'0xffa500',"yellow"=>'0xffff00',
              "green"=>'0x00ff00',"blue"=>'0x0000ff',"indigo"=>'0x4b0082',
              "cyan"=>'0x00ffff',"violet"=>'0xc71585',"magenta"=>'0xff00ff',
              "pink"=>'0xff1493',"r0"=>'0x0f0000',"r1"=>'0x1f0000',"r2"=>'0x2f0000',
              "r3"=>'0x3f0000',"r4"=>'0x4f0000',"r5"=>'0x5f0000',"r6"=>'0x6f0000',
              "r7"=>'0x7f0000',"r8"=>'0x8f0000',"r9"=>'0x9f0000',"rA"=>'0xaf0000',
              "rB"=>'0xbf0000',"rC"=>'0xcf0000',"rD"=>'0xdf0000',"rE"=>'0xef0000',
              "g0"=>'0x000f00',"g1"=>'0x001f00',"g2"=>'0x002f00',"g3"=>'0x003f00',
              "g4"=>'0x004f00',"g5"=>'0x005f00',"g6"=>'0x006f00',"g7"=>'0x007f00',
              "g8"=>'0x008f00',"g9"=>'0x009f00',"gA"=>'0x00af00',"gB"=>'0x00bf00',
              "gC"=>'0x00cf00',"gD"=>'0x00df00',"gE"=>'0x00ef00',
              "b0"=>'0x00000f',"b1"=>'0x00001f',"b2"=>'0x00002f',"b3"=>'0x00003f',
              "b4"=>'0x00004f',"b5"=>'0x00005f',"b6"=>'0x00006f',"b7"=>'0x00007f',
              "b8"=>'0x00008f',"b9"=>'0x00009f',"bA"=>'0x0000af',"bB"=>'0x0000bf',
              "bC"=>'0x0000cf',"bD"=>'0x0000df',"bE"=>'0x0000ef',
              "black"=>'0x000000',"white"=>'0xffffff',"w1"=>'0x111111',
              "w2"=>'0x222222',"w3"=>'0x333333',"w4"=>'0x444444',"w5"=>'0x555555',
              "w6"=>'0x666666',"w7"=>'0x777777',"w8"=>'0x888888',"w9"=>'0x999999',
              "wA"=>'0xaaaaaa',"wB"=>'0xbbbbbb',"wC"=>'0xcccccc',"wD"=>'0xdddddd',
              "wE"=>'0xeeeeee'}

#function returns hex number for colour name, or 0xffffff if not matched
define :cv do |cname|
  colorof=get(:colorof)
  if colorof.has_key? cname
    return colorof[cname].to_i(16)
  else
    return 0xffffff
  end
end


define :clr do |id=0|
  osc "/clearAll",id
  sync "/osc/clearalldone"+id.to_s
end


clr
cue :two #cue accompanying sound file (in separate Sonic Pi buffer)
2.times do
  osc "/rainbow",2,1,tick,1 #clear second time
  sync "/osc/rainbowdone1"
end

4.times do
  use_random_seed(rand(100))
  osc "/line",rand_i(4),rand_i(4),-1,cv('green')
  sleep 0.1
  osc "/line",rand_i(4),rand_i(4),-1,cv('red')
  sleep 0.1
  osc "/line",-1,rand_i(4),rand_i(4),cv('blue')
  sleep 0.1
  osc "/line",-1,rand_i(4),rand_i(4),cv('yellow')
  sleep 0.1
  osc "/line",rand_i(4),-1,rand_i(4),cv('majenta')
  sleep 0.1
  osc "/line",rand_i(4),-1,rand_i(4),cv('cyan'),0,1
  sync "/osc/linedone1"
  sleep 2
  clr
end


osc "/hollowCube",0,0,0,5,cv('b5'),0,1
sync "/osc/hollowcubedone1"
osc "/hollowCube",1,0,1,4,cv('g4'),0,2
sync "/osc/hollowcubedone2"
osc "/hollowCube",2,0,2,2,cv('r2'),0,3
sync "/osc/hollowcubedone3"
sleep 2
clr

osc "/fadeInAndOut",cv('cyan'),1,1,0,0,25,1
sync "/osc/fadeinandoutdone1"
osc "/fadeInAndOut",cv('r4'),1,1,0,25,75,2
sync "/osc/fadeinandoutdone2"
osc "/fadeInAndOut",cv('yellow'),1,1,0,75,125,3
sync "/osc/fadeinandoutdone3"
osc "/colorAll",cv('blue'),1


osc "/slantTriangle",0,0,0,5,cv('green'),1,1
sync "/osc/slanttriangledone1"
osc "/slantTriangle",4,0,0,5,cv('red'),1,2
sync "/osc/slanttriangledone2"
osc "/slantTriangle",0,4,0,5,cv('blue'),1,3
sync "/osc/slanttriangledone3"
osc "/slantTriangle",0,0,4,5,cv('green'),1,4
sync "/osc/slanttriangledone4"


2.times do
  osc "/triCube","xy",cv('red'),cv('blue'),1
  sync "/osc/tricubedone1"
  sleep 0.4
  clr
  osc "/triCube","xz",cv('red'),cv('blue'),2
  sync "/osc/tricubedone2"
  sleep 0.4
  clr
  osc "/triCube","xym",cv('red'),cv('blue'),2
  sync "/osc/tricubedone2"
  sleep 0.4
  clr
  osc "/triCube","xzm",cv('red'),cv('blue'),2
  sync "/osc/tricubedone2"
  sleep 0.4
  clr
  osc "/triCube","yz",cv('red'),cv('blue'),2
  sync "/osc/tricubedone2"
  sleep 0.4
  clr
  osc "/triCube","yzm",cv('red'),cv('blue'),2
  sync "/osc/tricubedone2"
  sleep 0.4
  clr
end


osc "/colorWipe",cv('green'),10,1,0
sync "/osc/colorwipedone0"
osc "/colorWipe",cv('blue'),10,0,1
sync "/osc/colorwipedone1"
osc "/colorWipe",cv('red'),10,1,2
sync "/osc/colorwipedone2"
osc "/colorWipe",cv('black'),10,0,3
sync "/osc/colorwipedone3"


osc "/sandwichCube","xy",cv('white'),1
sync "/osc/sandwichcubedone1"
12.times do |i|
  osc "/setBrightness",110-i*10
  sleep 0.2
end
osc "/sandwichCube","yz",cv('white'),2
sync "/osc/sandwichcubedone2"
12.times do |i|
  osc "/setBrightness",i*10
  sleep 0.2
end
osc "/sandwichCube","xz",cv('white'),3
sync "/osc/sandwichcubedone3"
12.times do |i|
  osc "/setBrightness",110-i*10
  sleep 0.2
end
clr
osc "/setBrightness",110


osc "/theaterChase",cv('cyan'),50,20,1,1
sync "/osc/theaterchasedone1"
osc "/theaterChase",cv('r7'),50,20,1,2
sync "/osc/theaterchasedone2"
osc "/theaterChase",cv('yellow'),50,20,1,3
sync "/osc/theaterchasedone3"


osc "/rainbowCycle",3,5,1,1
sync "/osc/rainbowcycledone1"


osc "/theaterChaseRainbow",20,1,1
sync "/osc/theaterchaserainbowdone1"


osc "/colorAll",0x070707
sleep 0.5
200.times do
  #2 param returns to original colour after flash
  osc "/pixelN",rand_i(126),cv(['red','green','blue'].choose),2
  sleep 0.08
end


4.times do |i|
  osc "/solidCube",0,0,0,i+2,cv('red')
  sleep 0.4
end
4.times do |i|
  osc "/solidCube",0,0,0,i+2,cv('black')
  sleep 0.4
end
4.times do |i|
  osc "/solidCube",0,0,0,i+2,cv('green')
  sleep 0.4
end
4.times do |i|
  osc "/solidCube",0,0,0,i+2,cv('black')
  sleep 0.4
end
4.times do |i|
  osc "/solidCube",0,0,0,i+2,cv('blue')
  sleep 0.4
end
4.times do |i|
  osc "/solidCube",0,0,0,i+2,cv('black')
  sleep 0.4
end

osc "/pingBack","finish"

sync "/osc/pingbackdonefinish"
puts "Ended"
sleep 5
osc_send "localhost",4557,"/stop-all-jobs","rbnguid" #shuts down all running Sonic Pi jobs
