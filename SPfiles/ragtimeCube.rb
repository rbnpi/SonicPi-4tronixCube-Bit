#ragtimeCube displays patterns on the cube while ragtime music plays in a separate buffer
#by Robin Newman, September 2018
#SET IP ADDRESS OF CUBE PIZERO IN LINE BELOW
#START ragtimeMusic.rb playing in a separate buffer before running this program
use_osc "pp.qq.rr.ss",8000 #set IP address of cube pizero here

2.times do
  use_bpm 90
  osc "/clearAll"
  sleep 1
  cue :startRag #start ragtimeMusic.rb playing in a separate buffer
  osc "/triCube","xy",0xff,0x00ff00,1
  sync "/osc/tricubedone1"
  osc "/colorWipe",0xff0000,50,0,0
  sync "/osc/colorwipedone0"
  osc "/fadeInAndOut",0x00ff00,4,4,0,0,125,0
  sync "/osc/fadeinandoutdone0"
  osc "/rainbow",5,2,0,0
  sync "/osc/rainbowdone0"
  osc "/clearAll",1
  sync "/osc/clearalldone1"
  osc "/colorAll",0x1f1f00,0,1
  sync "/osc/coloralldone1"
  osc "/hollowCube",0,0,0,5,0xff,0,1
  sync "/osc/hollowcubedone1"
  sleep 1
  osc "/hollowCube",1,1,1,3,0xff0000,0,2
  sync "/osc/hollowcubedone2"
  sleep 1
  osc "/clearAll",2
  sync "/osc/clearalldone2"
  osc "/setPlane",0,"xy",0xff0000,0,5,5,1,1
  sync "/osc/setplanedone1"
  #sleep 0.2
  osc "/setPlane",1,"xy",0x111111,0,5,5,1,2
  sync "/osc/setplanedone2"
  #sleep 0.2
  osc "/setPlane",2,"xy",0x00ff00,0,5,5,1,3
  sync "/osc/setplanedone3"
  #sleep 0.2
  osc "/setPlane",3,"xy",0x111111,0,5,5,1,4
  sync "/osc/setplanedone4"
  sleep 0.2
  osc "/setPlane",4,"xy",0xff,0,5,5,1,5
  sync "/osc/setplanedone5"
  sleep 2
end
osc "/clearAll"

