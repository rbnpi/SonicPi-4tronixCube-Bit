#2nd half of workout program for Mac by Robin Newman, September 2018
#as too long to run from one buffer

use_osc get(:IP),8000
set :kill,false
set :kill2,false
set :bpm,60
numCycles=5
osc "/clearAll"
sleep 0.4

live_loop :wrapit do
  tick
  puts "Cycle #{look + 1} of #{numCycles}"
  sync :finish
  if (look == numCycles-1)
    set :kill,true
    stop
  end
  sleep 1
end

live_loop :sl do
  if get(:kill)
    set :kill2,true
    stop
  end
  bpm=get(:bpm)
  use_bpm bpm
  d1=0.49*60/bpm
  del=20.0
  d2=del*60/bpm
  sleep 0.3 #allow for latency
  osc "/clearAll"
  sleep 0.5
  
  4.times do
    osc "/slantTriangle",0,0,0,5,cv('red'),d1
    sleep 0.5
    osc "/slantTriangle",4,0,0,5,cv('green'),d1
    sleep 0.5
    osc "/slantTriangle",4,4,0,5,cv('red'),d1
    sleep 0.5
    osc "/slantTriangle",0,4,0,5,cv('green'),d1
    sleep 0.5
    osc "/slantTriangle",0,0,4,5,cv('blue'),d1
    sleep 0.5
    osc "/slantTriangle",4,0,4,5,cv('yellow'),d1
    sleep 0.5
    osc "/slantTriangle",4,4,4,5,cv('blue'),d1
    sleep 0.5
    osc "/slantTriangle",0,4,4,5,cv('yellow'),d1
    sleep 0.5
  end
  osc "/clearAll"
  sleep 0.5
  osc"/solidCube",1,1,1,3,0x00007F,0
  sleep 0.5
  osc "/solidCube",0,0,0,2,0x7F7F00,0
  sleep 0.5
  osc "/solidCube",3,0,0,2,0x7F7F00,0
  sleep 0.5
  osc "/solidCube",3,3,0,2,0x7F7F00,0
  sleep 0.5
  osc "/solidCube",0,3,0,2,0x7F7F00,0
  sleep 0.5
  osc "/solidCube",0,0,3,2,0x7F7F00,0
  sleep 0.5
  osc "/solidCube",3,0,3,2,0x7F7F00,0
  sleep 0.5
  osc "/solidCube",3,3,3,2,0x7F7F00,0
  sleep 0.5
  osc "/solidCube",0,3,3,2,0x7F7F00,0
  sleep 0.5
  osc "/clearAll"
  sleep 0.5
  osc "/hollowCube",0,0,0,5,cv('r7'),0
  sleep 2
  osc "/setPlane",0,"yz",cv('red'),0
  sleep 0.5
  osc "/setPlane",1,"yz",cv('yellow'),0
  sleep 0.5
  osc "/setPlane",2,"yz",cv('white'),0
  sleep 0.5
  osc "/setPlane",3,"yz",cv('magenta'),0
  sleep 0.5
  osc "/setPlane",4,"yz",cv('cyan'),0
  sleep 0.5
  osc "/setPlane",4,"xy",cv('red'),d1
  sleep 0.5
  osc "/setPlane",3,"xy",cv('blue'),d1
  sleep 0.5
  osc "/setPlane",2,"xy",cv('red'),d1
  sleep 0.5
  osc "/setPlane",1,"xy",cv('blue'),d1
  sleep 0.5
  osc "/setPlane",0,"xy",cv('red'),0
  sleep 1
  osc "/clearAll"
  sleep 0.5
  osc "/colorWipe",0xFF0000,d2
  sleep 0.75+del*125/1000
  osc "/colorWipe",0x00FF00,d2
  sleep 0.75+del*125/1000
  osc "/colorWipe",0x0000FF,d2
  sleep 0.75+del*125/1000
  
  osc "/colorAll",0xFFFFFF,0
  sleep 1
  osc "/colorWipe",0x0,d2
  sleep 1.5+del*125/1000
  cue :finish
  set :bpm,bpm+30
end

use_synth :tb303
with_fx :reverb,room:0.8,mix: 0.7 do
  live_loop :pl do
    bpm=get(:bpm)
    use_bpm bpm
    if get(:kill2)
      sample :ambi_lunar_land,amp: 5,beat_stretch: 8
      osc "/rainbow",1,1,0
      sleep rt(4)
      osc "/colorWipe",0,20
      sleep 6
      stop
    end
    n=rrand_i(32,84)
    pn=((n-32)/52.0*125).to_i
    osc "/pixelN",pn,rand_i(0x1000000),2,80*60.0/bpm
    play n,release: 0.2,cutoff: rrand(60,110),pan: 1-dice(2)
    sleep 0.2
  end
end

