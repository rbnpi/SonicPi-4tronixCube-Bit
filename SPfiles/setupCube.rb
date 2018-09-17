#setupCube has supporting routines for using 4tronix cube via OSC messages from Sonic Pi
#written by Robin Newman,September 2018. See details in SonicPi-4tronixCube-Bit respository
use_real_time
use_osc get(:cubeip),8000
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
#fade rigns for primary colours
rv=(ring 'black','r0','r1','r2','r3','r4','r5','r6','r7','r8','r9','rA','rB','rC','rD','rE','red')
set :rv,rv+rv.reverse
gv=(ring 'black','g0','g1','g2','g3','g4','g5','g6','g7','g8','g9','gA','gB','gC','gD','gE','green')
set :gv,gv+gv.reverse
bv=(ring 'black','b0','b1','b2','b3','b4','b5','b6','b7','b8','b9','bA','bB','bC','bD','bE','blue')
set :bv,bv+bv.reverse

cred=(ring,0xff0000,0xff0000,0xff0707,0xff0f0f,0xff1f1f,0xff2f2f,0xff3f3f,0xff4f4f,0xff5f5f,0xff6f6f,0xff7f7f,0xffffff)
set :cred,cred.reverse+cred
cgreen=(ring,0x00ff00,0x00ff00,0x07ff07,0x0fff0f,0x1fff1f,0x2fff2f,0x3fff3f,0x4fff4f,0x5fff5f,0x6fff6f,0x7fff7f,0xffffff)
set :cgreen,cgreen.reverse+cgreen
cblue=(ring,0x0000ff,0x0000ff,0x0707ff,0x0f0fff,0x1f1fff,0x2f2fff,0x3f3fff,0x4f4fff,0x5f5fff,0x6f6fff,0x7f7fff,0xffffff)
set :cblue,cblue.reverse+cblue
set :collist,(ring cred,cgreen,cblue)

define :cv do |cname|
colorof=get(:colorof)
  if colorof.has_key? cname
    return colorof[cname].to_i(16)
  else
    return 0xffffff
  end
end

define :to_hex do |s|
  return s.to_s(16).rjust(6,'0')
end

define :padstring do |cname|
colorof=get(:colorof)
  if colorof.has_key? cname
    return colorof[cname][2..-1]
  else
    return "ffffff"
   end
end

define :clr do |id=0|
  osc "/clearAll",id
  sync "/osc/clearalldone"+id.to_s
end

define :parse_sync_address do |address| #get address wildcards
  v= get_event(address).to_s.split(",")[6]
  if v != nil
    return v[3..-2].split("/")
  else
    return ["error"]
  end
end

define :clearcues do
  24.times do |i|
    cue "/osc/tricubedone"+i.to_s
    cue "/osc/cwdone"+i.to_s
    cue "/osc/clearalldone"+i.to_s
  end
    cue :arpfinishr
    cue :arpfinishg
    cue :arpfinishb
end

define :initTouch do
  with_osc get(:tip),4000 do
  osc "/cube/lumen",1
  osc "/cube/mute",0
  osc "/cube/striped",0
  osc "/cube/mutePatterns",0
  osc "/cube/led1",0
  osc "/cube/led2",0
  osc "/cube/led3",0
  osc "/cube/led4",0
  end
end


#overall brightness fader (with sound in pl)
define :pl do |i,delay|
  play i,release: 0.8*delay/1000.0 if i>30
end

define :fade do |s,f,delay=6|
  shift=0
  if (s-f).abs <20
    delay=delay*4
  shift=48
    elsif (s-f).abs <50
  delay=delay*2
    shift=32
  end
  if (s > f)
    s.downto(f).each do |i|
      osc "/setBrightness",i
      pl(i+shift,delay)
      sleep delay/1000.0
    end
  else
    (s..f).each do |i|
      osc "/setBrightness",i
      pl(i+shift,delay)
      sleep delay/1000.0
    end
  end
end

define :pb do |code| #gets pingback from cube to send a cue :code
  use_real_time
  osc "/pingBack",code
    b= sync "/osc/pingbackdone"+code.to_s
    retcode=b[0]
cue code.to_sym
end

define :getColorN do |n|
  #use_real_time
  osc "/getColorN",n
  rv=false
  while rv==false
    b= sync "/osc/colorN"
    retcode=b[0]
    rv=true
  end
  return b[0].to_s(16)
end

define :getColorXYZ do |x,y,z|
  #use_real_time
  osc "/getColorXYZ",x,y,z
  rv=false
  while rv==false
    b= sync "/osc/colorXYZ"
    retcode=b[0]
    rv=true
  end
  return b[0].to_s(16)
end

define :clr do
osc "/clearAll",0
sync "/osc/clearalldone0"
end

set :crv,0
set :cgv,0
set :cbv,0

define :compColor do
  return ((16**4)*get(:crv)+(16**2)*get(:cgv)+get(:cbv)).to_s(16).to_i(16)
end

live_loop :getR do
  use_real_time
  b= sync "/osc/cube/rv"
  set :crv,(b[0]*255).to_i
end

live_loop :getG do
  use_real_time
  b= sync "/osc/cube/gv"
  set :cgv,(b[0]*255).to_i
end

live_loop :getB do
  use_real_time
  b= sync "/osc/cube/bv"
  set :cbv,(b[0]*255).to_i
end

live_loop :getBr do
  use_real_time
  b= sync "/osc/cube/lumen"
  puts "brightness",(b[0]*get(:brMax)).to_i
  osc "/setBrightness",(b[0]*get(:brMax)).to_i
end

 live_loop :mutePatterns do
    use_real_time
    b = sync "/osc/cube/mutePatterns"
    if b[0]==1
      set :playPats,false
    else
      set :playPats,true
    end
  end
cue :finishedSetupCube
