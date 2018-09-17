#Sonic Pi cube-bit workout by Robin Newman, September 2018 MAC VERSION PART 1
#SET IP ADDRESS OF CUBE:BIT PIZERO BELOW instead of pp.qq.rr.ss
#SET PATH FOR SECOND PART IN LAST LINE OF PROGRAM
#ALSO SET PATH FOR setubCube.rb in line 9

set :ip, "pp.qq.rr.ss" #ip of cube-bit pizero store for use in part 2
set :tip, "127.0.0.1" #ip of Touch OSC (not used here)
use_osc get(:ip),8000 
run_file "/set/path/to/setupCube.rb" #some setup functions. SETUP THE PATH
sync :finishedSetupCube
set :brMax,110 #set max brihtness (limited to 110 max)
sleep 1
use_osc_logging false
use_debug false
use_real_time
osc "/clearAll"
osc "/setBrightness",get(:brMax)


define :cubeFade do |n|
  osc "/colorAll",0x0f0f0f
  rv=get:rv
  gv=get(:gv)
  bv=get(:bv)
  sleep 0.1
  n.times do
    34.times do
      osc "/hollowCube",0,0,0,5,cv(rv.tick)
      sleep 0.05
    end
    34.times do
      osc "/hollowCube",1,1,1,3,cv(gv.tick)
      sleep 0.05
    end
    34.times do
      osc "/line",2,2,-1,cv(bv.tick)
      sleep 0.05
    end
  end
end
define :colCube do |n|
  collist=get(:collist)
  pc=collist[2];sz=5
  p=1
  (n*24*4).times do
    tick
    if look%24==0
      pc=collist.tick(:inner)
      sz=(ring 2,3,4,5).look(:inner)
      if sz==2
        osc "/clearAll"
        p=dice(8)
        sleep 0.08
      end
    end
    osc "/solidCube",0,0,0,sz,pc.look if p==1
    osc "/solidCube",5-sz,0,0,sz,pc.look if p==2
    osc "/solidCube",0,5-sz,0,sz,pc.look if p==3
    osc "/solidCube",0,0,5-sz,sz,pc.look if p==4
    osc "/solidCube",5-sz,5-sz,0,sz,pc.look if p==5
    osc "/solidCube",5-sz,0,5-sz,sz,pc.look if p==6
    osc "/solidCube",0,5-sz,5-sz,sz,pc.look if p==7
    osc "/solidCube",5-sz,5-sz,5-sz,sz,pc.look if p==8
    sleep 0.04
  end
end

define :colPlane do |n|
  pn="xz"
  cred=get(:cred)
  cgreen=get(:cgreen)
  cblue=get(:cblue)
  endit=-1
  tick_reset
  (n*44).times do
    tick
    endit=look if look==(n*43)
    if look%11==0
      pn=(ring,"xy","yz","xz").tick(:plane)
      sleep 1
    end
    #endit=1 if look==44
    osc"/setPlane",0,pn,cred.look
    osc "/setPlane",4,pn,cred.reverse.look
    osc "/setPlane",1,pn,cgreen.look
    osc "/setPlane",3,pn,cgreen.reverse.look
    osc "/setPlane",2,pn,cblue.look,0,5,5,0,endit #gives a cue on completion
    sleep 0.05
  end
end

define :lineflash do |cycles=20,del=0.2|
  osc "/line",-1,0,0,cv('red')
  sleep del
  rx=0;rz=0
  x=vt
  cycles.times do
    osc "/line",-1,rx,rz,0
    rx=rand_i(5);rz=rand_i(5)
    osc "/line",-1,rx,rz,cv('red')
    sleep del
  end
  osc "/line",-1,rx,rz,0
  sleep del
  osc "/line",0,-1,0,cv('green')
  sleep del
  gx=0;gz=0
  cycles.times do
    osc "/line",gx,-1,gz,0
    gx=rand_i(5);gz=rand_i(5)
    osc "/line",gx,-1,gz,cv('green')
    sleep del
  end
  osc "/line",gx,-1,gz,0
  sleep del
  osc "/line",0,0,-1,cv('blue')
  sleep del
  bx=0;by=0
  cycles.times do
    osc "/line",bx,by,-1,0
    bx=rand_i(5);by=rand_i(5)
    osc "/line",bx,by,-1,cv('blue')
    sleep del
  end
  osc "/line",bx,by,-1,0
end

define :planeFlash do |num=4,del=0.18667|
  num.times do
    osc "/setPlane",0,"xy",cv('red')
    osc "/setPlane",4,"xy",cv('red')
    sleep del
    osc "/setPlane",1,"xy",cv('green')
    osc "/setPlane",3,"xy",cv('green')
    sleep del
    osc "/setPlane",2,"xy",cv('blue')
    sleep del
    osc "/setPlane",0,"xy",0
    osc "/setPlane",4,"xy",0
    sleep del
    osc "/setPlane",1,"xy",0
    osc "/setPlane",3,"xy",0
    sleep del
    osc "/setPlane",2,"xy",0
    sleep del
  end
end
define :triangleFaders do |n|
  n.times do
    ft=15
    osc "/solidCube",0,0,0,5,0x7f7f7f
    sleep 0.1
    osc "/slantTriangle",0,0,0,5,cv('red')
    sleep 0.01
    osc "/slantTriangle",4,4,4,5,cv('red')
    fade(0,get(:brMax),ft)
    fade(get(:brMax),0,ft)
    osc "/solidCube",0,0,0,5,0x7f7f7f
    sleep 0.1
    osc "/slantTriangle",4,0,0,5,cv('green')
    sleep 0.1
    osc "/slantTriangle",0,4,4,5,cv('green')
    fade(0,get(:brMax),ft)
    fade(get(:brMax),0,ft)
    osc "/solidCube",0,0,0,5,0x7f7f7f
    sleep 0.1
    osc "/slantTriangle",0,4,0,5,cv('blue')
    sleep 0.1
    osc "/slantTriangle",4,0,4,5,cv('blue')
    fade(0,get(:brMax),ft)
    fade(get(:brMax),0,ft)
    osc "/solidCube",0,0,0,5,0x7f7f7f
    sleep 0.1
    osc "/slantTriangle",0,0,4,5,cv('yellow')
    sleep 0.1
    osc "/slantTriangle",4,4,0,5,cv('yellow')
    fade(0,get(:brMax),ft)
    fade(get(:brMax),0,ft)
  end
end
#======================

sleep 0.1
puts "start"

uncomment do #switches on/off first half of program
  #wrap music with reverb
  with_fx :reverb,room: 0.8,mix: 0.7 do
    #play music 1 in thread
    in_thread do
      sleep 0
      puts "loop industrial start"
      #cue :startSeq
      #sleep 0.5
      12.times do
        sample :loop_industrial,beat_stretch: 1
        sleep 1
      end
      puts"m1 end"
    end
    #start first cube animation
    puts "start colPlane"
    in_thread do
      colPlane 2
    end
    sync "/osc/setplanedone86" #sync on end of animation
    sleep 0.4
    clr #clear cube
    puts "c1 end"
    
    sleep 0.2
    #start second music thread
    in_thread do
      2.times do
        sample :loop_amen_full,beat_stretch: 7.84
        sleep 7.84
      end
      puts "m2 end"
    end
    #start second cube animation
    puts "start colCube"
    colCube(4)
    puts "finished colCube"
    
    #send finish cue
    pb "finishcolCube"
    sync :finishcolCube #continue when pb sends cue
    #start third music thread
    in_thread do
      puts "garzul"
      2.times do
        sample :loop_garzul,beat_stretch: 7.7
        sleep 7.7
      end
      puts "m3 end"
    end
    #start third cube animation
    puts "start cubeFade"
    cubeFade(3)
    clr
    sleep 0.1
    
    puts "finished cubeFade"
    #start fourth music thread
    in_thread do
      bt=1.081
      use_synth :tb303
      cd=[[:c4,:major,0],[:c4,:major,1],[:c4,:major,2],[:c4,:major,3],
          [:d4,:minor,0],[:d4,:minor,1],[:d4,:minor,2],[:d4,:minor,3],
          [:g4,:major,-1],[:g4,:major,0],[:g4,:major,1],[:g4,:major,2],
          [:c4,:major,4],[:c4,:major,3],[:c4,:major,2],[:c4,:major,1]]
      cd.length.times do |i|
        play chord(cd[i][0],cd[i][1],invert: cd[i][2]),release: bt,cutoff: rrand(80,110)
        sleep bt
      end
      puts "m4 end"
    end
  end #reverb  #no reverb for next music section
  
  #start fourth cube animation
  
  puts "start lineflash"
  lineflash
  puts "startplaneFlash"
  planeFlash
  puts "finishplaneFlash"
  
  #start fifth cube animation. This genrates its own music
  puts "starttriangleFaders"
  triangleFaders 1
  osc "clearAll"
  sleep 0.1
  osc "/setBrightness",110
  puts "finishtriangleFaders" #4
  sleep 0.1
  #start final music thread
  in_thread do
    with_fx :reverb,room: 0.8,mix: 0.7 do
      with_fx :compressor ,amp: 6 do
        sample :loop_tabla,beat_stretch: 12,amp: 6
      end
      puts"m5 end"
    end
  end
  
  #start final cube animation
  x=vt
  osc "/setPlane",0,"xy",cv("red")
  osc "/setPlane",2,"xy",cv("red")
  osc "/setPlane",4,"xy",cv("red")
  sleep 1
  osc "/fadeInAndOut",cv("red"),2,10,1,0,25
  osc "/fadeInAndOut",cv("blue"),2,10,0,25,50
  osc "/fadeInAndOut",cv("red"),2,10,1,50,75
  osc "/fadeInAndOut",cv("blue"),2,10,0,75,100
  osc "/fadeInAndOut",cv("red"),2,10,1,100,125
  sleep 7
  osc "/clearAll"
  sleep 0.1
  osc "/fadeInAndOut",cv("yellow"),1,20
  sleep 4
  puts "final animation time",vt-x
end #comment==================================
#=============================phase 2==============
puts "start second half of program"
run_file"/set/path/to/MacCubeWorkout-part2.rb" #ADJUST PATH BEFORE RUNNING
