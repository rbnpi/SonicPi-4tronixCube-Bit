sync :two
#existing program I had which is used as a sound accompaniment, to testerCube.rb
#Tomtom rhythms found on wikipedia https://en.wikipedia.org/wiki/Rhythm_in_Sub-Saharan_Africa#/media/File:Standard_pattern,_six_beats.png
#form the basis of this piece coded for Sonic PI by Robin Newman, December 2017
#version 2, more interesting bass. Best wirth a pair of decent speakers with good bass response!
l1=(ring 1,0,1,0,1,0,1,0,1,0,1,0)
l2=(ring 0,1,0,1,0,1,0,1,0,1,0,1)
l3=(ring 0,1,0,0,1,1,0,1,0,1,0,1)
l4=(ring 1,0,1,0,1,1,0,1,0,1,0,1)
l=(ring l1,l2,l3,l4)
set :kill,0 #initialise kill flag
set :tr,0
use_bpm 50
with_fx :reverb,room: 0.7,mix: 0.6 do
  live_loop :drums1 do
    r=l.tick(:l)
    24.times do
      stop if get(:kill)==1 #check for when to stop this thread
      tick
      a=0.5;a=1 if look%3==0
      sample :drum_tom_hi_hard,amp: a,pan: [-1,1].choose  if r.look==1
      sleep 0.1
    end
  end
  
  live_loop :drums2 do
    stop if get(:kill)==1 #check for when to stop this thread
    a=0.5;a=1 if tick%4==0
    sample :drum_tom_lo_hard,amp: a,pan: [-0.5,0.5].choose
    sleep 0.3
  end
  
  
  live_loop :bass,delay: 1.2 do
    tick
    use_synth :tb303
    set :tr,7 if look==4
    set :tr,-5 if look==12
    set :tr,0 if look==8
    set :tr,0 if look==16
    
    q= play note(:e1)+get(:tr),attack: 1.2,release: 1.2+2.4,cutoff: 40,amp: 0.5
    control q,note: :e0,note_slide: 4.8 if look==21
    
    #play :e2,attack: 1.2,release: 1.2+2.4,cutoff: 60,amp: 0.25
    sleep 4.8
    if look==21 #adjust to give desired duration
      set :kill,1 #set stop flag
      stop #stop this thread
    end
  end
  
  live_loop :notes,delay: 1.2 do
    stop if get(:kill)==1 #check for when to stop this thread
    use_synth :blade
    n=scale(note(:e3)+get(:tr), :minor_pentatonic,num_octaves: 2).choose
    play n,release: 0.1,amp: [1,2].choose,pan: [-0.75,0,0.75].choose if spread(5,8).tick
    play n-12,release: 0.1,amp: [1,2].choose,pan: [-0.75,0,0.75].choose if !spread(5,8).look
    sleep 0.1
  end
end
