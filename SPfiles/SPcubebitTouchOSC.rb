
#TouchOSC and Sonic Pi cubebit controller
#by Robin Newman, September 2018
use_real_time
#ADJUST THE TWO IP ADDRESSES BELOW
#AND THE PATH IN THE FULLOWING LINE (10)
set :cubeip,"pp.qq.rr.dd" #ip address of cube pizero
set :tip,"aa.bb.cc.dd" #ip address of TouchOSC tablet/phone

run_file "/set/up/path/to/setupCube.rb"
sync :finishedSetupCube
use_osc get(:cubeip),8000

use_osc_logging false
use_debug false
set :brMax,50
set :arpdelay,0.6
initTouch
define :setRv do |n|
  v=(n-32)/48.0
osc_send get(:tip),4000,"/cube/rv",v
set :crv,(255*v).to_i
end

define :setGv do |n|
  v=(n-32)/48.0
  osc_send get(:tip),4000,"/cube/gv",v
  set :cgv,(255*v).to_i
end

define :setBv do |n|
  v=(n-32)/48.0
  osc_send get(:tip),4000,"/cube/bv",v
  set :cbv,(255*v).to_i
end

osc "/setBrightness",0
sleep 0.1
setRv 32
sleep 0.1
setGv 32
sleep 0.1
setBv 32
sleep 0.1
clr
osc "/setBrightness",get(:brMax)

set :masterMute,false
set :playPats,true
set :cdlast,0

live_loop :display do
cd= [16**6,[compColor,0].max].min
if cd != get(:cdlast)
  osc_send get(:tip),4000,"/cube/cvalue",cd.to_s(16).rjust(6,"0").upcase
  osc "/colorAll",cd
  set :cdlast,cd
end
sleep 0.1
end

kill get(:longR)
kill get(:longG)
kill get(:longB)
sleep 0.5
set :longR, (synth :tb303, note: 0,sustain: 10000,amp: 0,pan: -1)
set :longG, (synth :fm, note: 0,sustain: 10000,amp: 0)
set :longB, (synth :dsaw, note: 0,sustain: 10000,amp: 0,pan: 1)
set :mute,true

live_loop :Rsound do
longR=get(:longR)
rv=get(:crv)
if (rv==0 and get(:mute)) or get(:masterMute)
control longR,amp: 0,amp_slide: 0#.02
else
n=rv/255.0*48+32
  control longR,note: n,note_slide: 0.1,amp: n/100.0,amp_slide: 0#.02
end
sleep 0.2
end

live_loop :Gsound do
  longG=get(:longG)
  rv=get(:cgv)
  if (rv==0 and get(:mute)) or get(:masterMute)
    control longG,amp: 0,amp_slide: 0#.02
  else
    n=rv/255.0*48+32
    control longG,note: n+12,note_slide: 0.1,amp: n/100.0,amp_slide: 0#.02
  end
  sleep 0.2
end

live_loop :Bsound do
  longB=get(:longB)
  rv=get(:cbv)
  if (rv==0 and get(:mute)) or get(:masterMute)
    control longB,amp: 0,amp_slide: 0#.02
  else
    n=rv/255.0*48+32
    control longB,note: n,note_slide: 0.1,amp: n/100.0,amp_slide: 0#.02
  end
  sleep 0.2
end

define :crossFade do |a,b|
  
  set :mute,false
  sc=[0,2,4,5,7,9,11,   12,14,16,17,19,21,23,   24,26,28,29,31,33,35,    36,38,40,41,43,45,47,48]
  sc.length.times do |i|
    break if get(:killMCF)
    setRv sc[i]+32 if a=="R"
    setRv sc[sc.length-i-1]+32 if b=="R"
    sleep 0.02
    setGv sc[i]+32 if a=="G"
    setGv sc[sc.length-i-1]+32 if b=="G"
    sleep 0.02
    setBv sc[i]+32 if a=="B"
    setBv sc[sc.length-i-1]+32 if b=="B"
    sleep 0.16
  end
  sleep 0.2 if get(:killMCF)==false
end
set :killMCF,false
#initialise note colour values correspodnding to note 32

define :musicalCubeFade do
  setRv 32
  setGv 32
  setBv 32
  
  crossFade("R","")
  crossFade("G","R")
  crossFade("B","G")
  crossFade("R","B")
  crossFade("","R")
  crossFade("G","")
  crossFade("B","G")
  crossFade("R","B")
  crossFade("G","R")
  crossFade("","G")
  crossFade("B","")
  crossFade("R","B")
  crossFade("G","R")
  crossFade("B","G")
  crossFade("","B")
  set :mute,true
end

live_loop :redBtn do
  use_real_time
  b= sync "/osc/cube/pr*"
  if b[0]>0
    n=parse_sync_address("/osc/cube/pr*")[2][-1].to_i
    lu=[0,0.25,0.50,0.75,1]
    setRv (32+lu[n-1]*48)
  end
end

live_loop :greenBtn do
  use_real_time
  b= sync "/osc/cube/pg*"
  if b[0]>0
    n=parse_sync_address("/osc/cube/pg*")[2][-1].to_i
    lu=[0,0.25,0.50,0.75,1]
    setGv (32+lu[n-1]*48)
  end
end

live_loop :blueBtn do
  use_real_time
  b= sync "/osc/cube/pb*"
  if b[0]>0
    n=parse_sync_address("/osc/cube/pb*")[2][-1].to_i
    lu=[0,0.25,0.50,0.75,1]
    setBv (32+lu[n-1]*48)
  end
end

live_loop :brigthBtn do
  use_real_time
  b= sync "/osc/cube/br*"
  if b[0]>0
    n=parse_sync_address("/osc/cube/br*")[2][-1].to_i
    lu=[0,0.25,0.50,0.75,1]
    osc_send get(:tip),4000, "/cube/lumen",lu[n-1]
    sleep 0.1
    puts "brbutton", (lu[n-1]*get(:brMax)).to_i
    sleep 0.1
    osc "/setBrightness",(lu[n-1]*get(:brMax)).to_i
  end
end

live_loop :muter do
  use_real_time
  b = sync "/osc/cube/mute"
  if b[0]==1
    set :masterMute,true
  else
    set :masterMute,false
  end
end

live_loop :mcfGo do
  use_real_time
  b = sync "/osc/cube/startMCF"
  if b[0]==1
    osc_send get(:tip),4000,"/cube/led4",1
    in_thread do
      musicalCubeFade
    end
  end
end

live_loop :mcfStop do
  use_real_time
  b = sync "/osc/cube/stopMCF"
  if b[0]>0
    set :killMCF,true
    set :mute,true
    setRv 32
    setGv 32
    setBv 32
    osc "/clearAll"
    clearcues
    set :stripedKill,true
    osc_send get(:tip),4000,"/cube/striped",0
    osc_send get(:tip),4000,"/cube/led4",0
    sleep 1.5
    set :killMCF,false
  end
end

define :upDown do |c|
  crossFade(c,"")
  crossFade("",c)
  sleep 0.2
  set :mute,true
end

live_loop :udLeds do
  use_real_time
  b = sync "/osc/cube/ud*"
  if b[0]>0
    n=parse_sync_address("/osc/cube/ud*")[2][-1]
    upDown "RGB"["RGB".index(n.upcase)]
  end
end

define :arpeg do |a,half=0,setcue=0|
  set :mute,false
  apr=[0,4,7,12, 16,19,24, 28,31,36, 40,43,48]
  case half
  when 0
    apr=apr+apr[0..-2].reverse
  when 1
    apr
  when 2
    apr=apr.reverse
  when 3
    apr=apr.reverse+apr[1..-1]
  end
  in_thread do
    puts setcue
    apr.length.times do|i|
      break if get(:killMCF)
      setRv 32+apr[i] if a=="R"
      setGv 32+apr[i] if a=="G"
      setBv 32+apr[i] if a=="B"
      sleep get(:arpdelay)
    end
    cue :arpfinishr if setcue==1 and a=="R"
    cue :arpfinishg if setcue==1 and a=="G"
    cue :arpfinishb if setcue==1 and a=="B"
  end
  set :mute,true
end


live_loop :arpegChoose do
  use_real_time
  b= sync "/osc/cube/arp*"
  if b[0]>0
    c=parse_sync_address("/osc/cube/arp*")[2][-1]
    #in_thread do
    arpeg "RGB"["RGB".index(c)]
    #end
  end
end

define :striped do
  until get(:stripedKill)
    osc "/sandwichCube","xz",get(:cdlast)
    sleep 0.5
    osc "/sandwichCube","yz",get(:cdlast)
    sleep 0.5
    osc "/sandwichCube","xy",get(:cdlast)
    sleep 0.5
  end
  osc "/colorAll",get(:cdlast)
end

live_loop :StripedOn do
  b = sync "/osc/cube/striped"
  if b[0]>0
    set :stripedKill,false
    in_thread do
      striped
    end
    
  end
end

live_loop :StripedOff do
  b = sync "/osc/cube/striped"
  set :stripedKill,true if b[0]==0
end

live_loop :t1 do
  use_real_time
  use_synth :tri
  b = sync "/osc/cube/test1"
  if b[0]>0
    osc_send get(:tip),4000,"/cube/led1",1
    d=0.3
    8.times do |i|
      play chord(:c5+i*2,:major,invert: 0),release: 4*d  if get(:playPats)
      osc "/triCube","xy",cv(['red','green'].choose),cv(['majenta','cyan'].choose),tick
      sync "/osc/tricubedone"+look.to_s
      sleep d
      break if get(:killMCF)
      play  chord(:c5+i*2,:major,invert: 1),release: 4*d if get(:playPats)
      osc"/triCube","yz",cv(['red','blue'].choose),cv(['yellow','w1'].choose),tick
      sync "/osc/tricubedone"+look.to_s
      sleep d
      break if get(:killMCF)
      play  chord(:c5+i*2,:major,invert: 2),release: 4*d if get(:playPats)
      osc"/triCube","xzm",cv(['blue','green'].choose),cv(['red','w4'].choose),tick
      sync "/osc/tricubedone"+look.to_s
      sleep d
      break if get(:killMCF)
    end
    clr
    osc_send get(:tip),4000,"/cube/led1",0
  end
end

live_loop :t2 do
  use_real_time
  use_synth :tb303
  b = sync "/osc/cube/test2"
  if b[0]>0
    osc_send get(:tip),4000,"/cube/led2",1
    d=1
    tick_reset
    4.times do |i|
      play  chord(:c2+i*2,:major,invert: 0),release: 0.8*d,cutoff: rrand(60,110) if get(:playPats)
      osc "/colorWipe",cv(['red','green'].choose),d,0,tick
      sync "/osc/colorwipedone"+look.to_s
      break if get(:ekillMCF)
      play  chord(:c2+i*2,:major,invert: 1),release: 0.8*d,cutoff: rrand(60,110) if get(:playPats)
      osc "/colorWipe",cv(['blue','yellow'].choose),d,1,tick
      sync "/osc/colorwipedone"+look.to_s
      break if get(:killMCF)
      play  chord(:c2+i*2,:major,invert: 2),release: 0.8*d,cutoff: rrand(60,110) if get(:playPats)
      osc "/colorWipe",cv(['majenta','cyan'].choose),d,0,tick
      sync "/osc/colorwipedone"+look.to_s
      break if get(:killMCF)
      play  chord(:c2+i*2,:major,invert: 3),release: 0.8*d,cutoff: rrand(60,110) if get(:playPats)
      osc "/colorWipe",cv(['w3','b3'].choose),d,1,tick
      sync "/osc/colorwipedone"+look.to_s
    end
    clr
    osc_send get(:tip),4000,"/cube/led2",0
  end
end


live_loop :arpegAuto do
  use_real_time
  b = sync "/osc/cube/test3"
  if b[0]>0
    osc_send get(:tip),4000,"/cube/led3",1
    1.times do
      puts "getMCF",get(:killMCF)
      break if get(:killMCF)
      arpeg("R",0,1)
      #sleep 1
      arpeg("G",2,1)
      sync :arpfinishg
      arpeg("B")
      arpeg("R",2)
      sync :arpfinishr
      arpeg("G",0,1)
      sync :arpfinishg
    end
    osc_send get(:tip),4000,"/cube/led3",0
  end
end
