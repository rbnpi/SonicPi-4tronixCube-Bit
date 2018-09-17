#This file is to accompany ragtimeCube.rb which controls a 4tronix cube:bit
#start this file running in a separate Sonic Pi buffer before starting ragtimeCube.rb
#Scott Joplin Maple Leaf Rag coded by Robin Newman September 2014
#music score http://conquest.imslp.info/files/imglnks/usimg/9/98/IMSLP270188-PMLP06700-Maple_Leaf_Rag.pdf
#on a Raspberry Pi turn OFF Print output in Sonic Pi Prefs
set_sched_ahead_time! 2
s = 1.0 / 12 #makes a crotchet (8) last 0.53s or about 112 crotchets/minute
with_fx :reverb,room: 0.6 do
  #first set up synth and note lengths
  #not all note lengths used in this piece
  use_synth :pretty_bell
  
  dsq = 1 * s #demi-semi-quaver
  sq = 2 * s #semi-quaver
  sqd = 3 * s #semi-quaver dotted
  q = 4 * s #quaver
  qd = 6 * s #quaver dotted
  qdd = 7 * s #quaver double dotted
  c = 8 * s #crotchet
  cd = 12 * s #crotchet dotted
  cdd = 14 * s #crotchet double dotted
  m = 16 * s #minim
  md = 24 * s #minim dotted
  mdd = 28 * s #minim double dotted
  b = 32 * s #breve
  bd = 48 * s #breve dotted
  define :playarray do |narray,darray,ratio = 0.9,vol=0.4|
    narray.zip(darray).each do |n,d|
      if n != :r
        play n,amp: vol,sustain: d * ratio,release: d * (1-ratio) #play note
      end
      sleep d #gap till next note
    end
  end
  p1n = [:r,:ab4,:eb5,:ab4,:c5,:eb5,:g4,:eb5,:g4,:bb4,:eb5,:r,:ab4,:eb5,:ab4,:c5,:eb5,:g4,:eb5,:g4,:bb4,:eb5,:r,:eb5]
  p1d = [sq,sq,sq,sq,sq,q,sq,sq,sq,sq,(sq+c),sq,sq,sq,sq,sq,q,sq,sq,sq,sq,(sq+q),sq,sq]
  p2n = [:r,:eb4,:r,:eb4,:r,:eb4,:r,:eb4,:r,:eb4,:r,:eb4,:r,:eb4,:r,:eb4,:r,:eb4]
  p2d = [q,sq,q,q,sq,sq,q,(sq+c),q,sq,q,q,sq,sq,q,(sq+q),sq,sq]
  p3n = [:ab3,:c4,:c4,:a3,:bb3,:db4,:db4,:eb3,:ab3,:c4,:c4,:a3,:bb3,:db4,:db4,:eb3]
  p3d = [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
  p4n = [:r,:ab3,:ab3,:r,:g3,:g3,:r,:ab3,:ab3,:r,:g3,:g3,:r]
  p4d = [q,q,q,c,q,q,c,q,q,c,q,q,q]
  p5n = [:ab2,:eb3,:eb3,:a2,:bb2,:eb3,:eb3,:eb2,:ab2,:eb3,:eb3,:a2,:bb2,:eb3,:eb3,:eb2]
  p5d = [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
  #bar 5
  p1n.concat [:r,:ab4,:cb4,:fb5,:r,:eb5,:r,:eb5,:r,:ab4,:cb4,:fb5,:r,:eb5,:r,:ab2,:cb2,:ab3,:r,:ab3,:cb3,:ab4,:r,:ab4,:cb4,:ab5,:r,:ab5,:cb5,:ab6]
  p1d.concat [sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q+sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq]
  p2n.concat [:r,:fb4,:r,:eb4,:r,:eb4,:r,:fb4,:r,:eb4,:r]
  p2d.concat [qd,sq,sq,sq,sq,sq,qd,sq,sq,sq,(q+b)]
  p3n.concat [:fb3,:eb3,:eb3,:fb3,:eb3,:r]
  p3d.concat [c,q,q,c,q,(q+b)]
  p4n.concat [:r]
  p4d.concat [2*b]
  p5n.concat [:fb2,:eb2,:eb2,:fb2,:eb2,:r,:eb1,:r,:ab2,:r,:ab3,:r,:ab4,:r]
  p5d.concat [c,q,q,c,q,q,q,q,q,q,q,q,q,q]
  #bar 9
  p1n.concat [:ab6,:ab6,:ab6,:ab6,:ab6,:eb6,:f6,:c6,:eb6,:f6,:ab5,:bb5,:cb5,:ab5,:bb5,:c6,:ab5,:c6,:ab5,:bb5,:ab5,:r,:ab5]
  p1d.concat [q,q,q,sq,q,sq,sq,sq,sq,q,q,sq,sq,sq,sq,q,sq,sq,sq,q,q,sq,qd]
  p2n.concat [:ab5,:ab5,:ab5,:ab5,:ab5,:r,:ab5,:fb5,:r,:fb5,:r,:eb5,:r,:eb5,:r,:eb5,:eb5,:r,:ab4]
  p2d.concat [q,q,q,sq,q,c,q,q,sq,sq,q,q,sq,sq,sq,q,q,sq,qd]
  p3n.concat [:b4,:b4,:b4,:b4,:c5,:c5,:c5,:c5,:cb4,:cb4,:c5,:c5,:c5,:db5,:c5,:r,:b4]
  p3d.concat [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
  p4n.concat [:ab4,:ab4,:ab4,:ab4,:ab4,:ab4,:ab4,:ab4,:ab4,:ab4,:ab4,:ab4,:ab4,:g4,:ab4,:r,:f4]
  p4d.concat [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
  p5n.concat [:d4,:d4,:d4,:d4,:eb4,:eb4,:eb4,:eb4,:fb4,:fb4,:eb4,:eb4,:eb4,:eb4,:ab4,:r,:d3]
  p5d.concat [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
  #bar 13b2
  p1n.concat [:ab5,:ab5,:ab5,:ab5,:eb5,:f5,:c5,:eb5,:f5,:ab4,:bb4,:cb4,:ab4,:bb4,:c5,:ab4]
  p1d.concat [q,q,sq,q,sq,sq,sq,sq,q,q,sq,sq,sq,sq,q,sq]
  p2n.concat [:ab4,:ab4,:ab4,:ab4,:r,:ab4,:r,:ab4,:fb4,:r,:fb4,:r,:eb4,:r]
  p2d.concat [q,q,sq,q,sq,sq,q,q,q,sq,sq,q,q,sq]
  p3n.concat [:b4,:b4,:b4,:c5,:c5,:c5,:c5,:cb4,:cb4,:c5,:c5]
  p3d.concat [q,q,q,q,q,q,q,q,q,q,q]
  p4n.concat [:f4,:f4,:f4,:ab4,:ab4,:ab4,:ab4,:ab4,:ab4,:ab4]
  p4d.concat [q,q,q,q,q,q,q,q,q,q]
  p5n.concat [:d3,:d3,:d3,:eb3,:eb3,:eb3,:eb3,:fb3,:fb3,:eb3,:eb3]
  p5d.concat [q,q,q,q,q,q,q,q,q,q,q]
  #repeat bar 1
  p1nrb1a = [:c5,:ab4,:bb4,:ab4,:r]
  p1drb1a = [sq,sq,q,q,q]
  p1nrb1b = p1nrb1a
  p1drb1b = p1drb1a
  p2nrb1a = [:eb4,:eb4,:eb4,:r]
  p2drb1a = [q,q,q,q]
  p2nrb1b = p2nrb1a
  p2drb1b = p2drb1a
  p3nrb1a = [:c4,:db4,:c4,:eb3]
  p3drb1a = [q,q,q,q]
  p3nrb1b = [:c4,:db4,:c4,:a3]###=>:ab5 on second page
  p3drb1b = [q,q,q,q]
  p4nrb1a = [:ab3,:g3,:ab3,:r]
  p4drb1a = [q,q,q,q]
  p4nrb1b = p4nrb1a
  p4drb1b = p4drb1a
  p5nrb1a = [:eb3,:eb3,:r,:eb2]
  p5drb1a = [q,q,q,q]
  p5nrb1b = [:eb5,:eb5,:r,:a2]#####=>:ab4 on second page
  p5drb1b = [q,q,q,q]
  lar =[[p1n,p1d],[p2n,p2d],[p3n,p3d],[p4n,p4d],[p5n,p5d]] #0-4
  define :sec do|n|
    in_thread do
      playarray(lar[n][0],lar[n][1])
    end
    in_thread do
      playarray(lar[n+1][0],lar[n+1][1])
    end
    in_thread do
      playarray(lar[n+2][0],lar[n+2][1])
    end
    in_thread do
      playarray(lar[n+3][0],lar[n+3][1])
    end
    playarray(lar[n+4][0],lar[n+4][1])
  end
  lar.concat [[p1nrb1a,p1drb1a],[p2nrb1a,p2drb1a],[p3nrb1a,p3drb1a],[p4nrb1a,p4drb1a],[p5nrb1a,p5drb1a]] #5-9
  lar.concat [[p1nrb1b,p1drb1b],[p2nrb1b,p2drb1b],[p3nrb1b,p3drb1b],[p4nrb1b,p4drb1b],[p5nrb1b,p5drb1b]] #10-14
  #play the first page of music here
  sync :startRag
  play_chord [:eb2,:eb3],amp: 0.4,sustain: q*0.9,release: q * 0.1 #upbeat
  sleep q
  sec(0)
  sec(5)
  sec(0)
  sec(10)
  #start second page of music
  #bar17
  p1n2 = [:r,:g5,:eb6,:g5,:bb5,:d6,:g5,:db6,:g5,:bb5,:c6,:eb5,:bb5,:eb5,:r,:c5,:ab5,:c5,:eb5,:f5,:c5,:ab5,:c5,:eb5,:f5,:c5,:f5]
  p1d2 = [sq,sq,sq,sq,sq,q,sq,sq,sq,sq,q,sq,sq,sq,sq,sq,sq,sq,sq,q,sq,sq,sq,sq,q,sq,q]
  p2n2 = [:r,:eb5,:r,:d5,:r,:db5,:r,:c5,:r,:bb4,:r,:ab4,:r,:f4,:r,:ab4,:r,:f4,:r,:f4]
  p2d2 = [q,sq,q,q,sq,sq,q,q,sq,sq,qd,sq,q,q,sq,sq,q,q,sq,q]
  p3n2 = [:bb3,:db4,:eb3,:db4,:bb3,:db4,:eb3,:g3,:ab3,:c4,:eb3,:c4,:ab3,:c4,:ab3,:a3]
  p3d2 = [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
  p4n2 = [:r,:g3,:r,:g3,:r,:g3,:r,:ab3,:r,:ab3,:r,:ab3,:r]
  p4d2 = [q,q,q,q,q,q,cd,q,q,q,q,q,c]
  p5n2 = [:bb2,:eb3,:eb2,:eb3,:bb2,:eb3,:eb2,:g2,:ab2,:eb3,:eb2,:eb3,:ab2,:eb3,:ab2,:a2]
  p5d2 = [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
  #bar21
  p1n2.concat [:r,:eb5,:g5,:bb4,:db5,:f5,:eb5,:g5,:bb4,:db5,:f5,:db5,:f5,:r,:c5,:ab5,:c5,:eb5,:f5,:c5,:ab5,:c5,:eb5,:f5,:c5,:f5]
  p1d2.concat [sq,sq,sq,sq,sq,q,sq,sq,sq,sq,q,sq,q,sq,sq,sq,sq,sq,q,sq,sq,sq,sq,q,sq,q]
  p2n2.concat [:r,:g4,:r,:f4,:r,:g4,:r,:db4,:r,:f4,:r,:ab4,:r,:f4,:r,:ab4,:r,:f4,:r,:f4]
  p2d2.concat [q,sq,q,q,sq,sq,q,q,sq,sq,qd,sq,q,q,sq,sq,q,q,sq,q]
  p3n2.concat [:bb3,:db4,:eb3,:db4,:bb3,:db4,:bb3,:b3,:c4,:c4,:eb3,:c4,:ab3,:c4,:ab3,:a3]
  p3d2.concat [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
  p4n2.concat [:r,:g3,:r,:g3,:r,:g3,:r,:ab3,:r,:ab3,:r,:ab3,:r]
  p4d2.concat [q,q,q,q,q,q,cd,q,q,q,q,q,c]
  p5n2.concat [:bb2,:eb3,:eb2,:eb3,:bb2,:eb3,:bb2,:b2,:c3,:eb3,:eb2,:eb3,:ab2,:eb3,:ab2,:a2]
  p5d2.concat [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
  #bar25
  p1n2.concat [:r,:g5,:eb6,:g5,:bb5,:d6,:g5,:db6,:g5,:bb5,:c6,:eb5,:bb5,:eb5,:r,:c5,:ab5,:c5,:eb5,:f5,:c5,:ab5,:ab5,:g5,:gb5]
  p1d2.concat [sq,sq,sq,sq,sq,q,sq,sq,sq,sq,q,sq,sq,sq,sq,sq,sq,sq,sq,q,sq,q,q,q,q]
  p2n2.concat [:r,:eb5,:r,:d5,:r,:db5,:r,:c5,:r,:bb4,:r,:ab4,:r,:f4,:r,:ab4,:ab4,:g4,:gb4]
  p2d2.concat [q,sq,q,q,sq,sq,q,q,sq,sq,qd,sq,q,q,sq,q,q,q,q]
  p3n2.concat [:bb3,:db4,:eb3,:db4,:bb3,:db4,:eb3,:g3,:ab3,:c4,:eb3,:c4,:ab3,:ab3,:g3,:gb3]
  p3d2.concat [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
  p4n2.concat [:r,:g3,:r,:g3,:r,:g3,:r,:ab3,:r,:ab3,:r]
  p4d2.concat [q,q,q,q,q,q,cd,q,q,q,m]
  p5n2.concat [:bb2,:eb3,:eb2,:eb3,:bb2,:eb3,:eb2,:g2,:ab2,:eb3,:eb2,:eb3,:ab2,:ab2,:g2,:gb2]
  p5d2.concat [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
  #bar29
  p1n2.concat [:r,:f4,:a4,:c5,:f5,:c5,:a4,:f4,:r,:f4,:bb4,:db5,:f5,:db5,:c5,:r,:c5,:r,:bb4,:eb4]
  p1d2.concat [sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,q,sq,sq,sq,q,sq]
  p2n2.concat [:r,:f4,:bb4,:ab4,:r,:ab4,:r,:db4,:r]
  p2d2.concat [m+c,q,q,q,sq,sq,sq,q,sq]
  p3n2.concat [:f3,:f3,:a3,:a3,:bb3,:db4,:db4,:db4,:bb3,:bb3,:eb3,:g3]
  p3d2.concat [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
  p4n2.concat [:r,:bb3,:bb3,:bb3,:f3,:f3,:r]
  p4d2.concat [m+q,q,q,q,q,q,c]
  p5n2.concat [:f2,:f2,:a2,:a2,:bb2,:f3,:f3,:f3,:bb2,:bb2,:eb2,:g2]
  p5d2.concat [q,q,q,q,q,q,q,q,q,q,q,q]
  #rb2
  p1nrb2a = [:ab4,:eb5,:eb5,:eb5]
  p1drb2a = [q,q,q,q]
  p1nrb2b = [:r,:ab4,:c5,:eb5,:ab5,:r]
  p1drb2b = [sq,sq,sq,sq,q,q]
  p2nrb2a = [:c4,:eb4,:eb4,:eb4]
  p2drb2a = [q,q,q,q]
  p2nrb2b = [:r,:ab4,:r]
  p2drb2b = [c,q,q]
  p3nrb2a = [:ab3,:c4,:c4,:a3]
  p3drb2a = [q,q,q,q]
  p3nrb2b = [:ab3,:eb4,:eb4,:eb3]
  p3drb2b = [q,q,q,q]
  p4nrb2a = [:r,:ab3,:ab3,:r]
  p4drb2a = [q,q,q,q]
  p4nrb2b = [:r,:c4,:c4,:r]
  p4drb2b = [q,q,q,q]
  p5nrb2a = [:ab2,:eb3,:eb3,:a3]
  p5drb2a = [q,q,q,q]
  p5nrb2b = [:ab2,:ab3,:ab3,:eb2]
  p5drb2b = [q,q,q,q]
  lar.concat [[p1n2,p1d2],[p2n2,p2d2],[p3n2,p3d2],[p4n2,p4d2],[p5n2,p5d2]] #15-10
  lar.concat [[p1nrb2a,p1drb2a],[p2nrb2a,p2drb2a],[p3nrb2a,p3drb2a],[p4nrb2a,p4drb2a],[p5nrb2a,p5drb2a]] #20-24
  lar.concat [[p1nrb2b,p1drb2b],[p2nrb2b,p2drb2b],[p3nrb2b,p3drb2b],[p4nrb2b,p4drb2b],[p5nrb2b,p5drb2b]] #25-29
  #play the second page of music
  sec(15)
  sec(20)
  sec(15)
  sec(25)
  sec(0)
  #alter the last note of section p3nrb1b and p5nrb1b
  p3nrb1b[3]=:ab5
  p5nrb1b[3]=:ab4
  sec(10)
end
