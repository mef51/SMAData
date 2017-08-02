#! /bin/csh -f
#
#
set so=orkl_080106
set dd=UVDATA
set lb=vis.uvcal
switch($1)
 case LSB:
  # 190 340 610 700
  set sb=lsb;			set ch=vel,717,-2632,5.0,5.0
  set freq=331.6;		set lab=cnt.lsb
  set free=1,194,203,346,355,648,659,700,709,717
 breaksw
 case USB:
  # 65 110 200 280 300 400 580 600 620 640
  set sb=usb;			set ch=vel,689,-1312.5,5.0,5.0
  set freq=345.0;		set lab=cnt.usb
set free=1,61,69,115,125,193,204,291,302,393,401,585,592,605,613,621,631,636,643,689
 breaksw
endsw

set vis=UVDATA/$so
\rm -fr tmp.* $vis.$lab
echo $lab
uvaver  vis=$vis'_'$sb.$lb out=tmp.1
uvputhd vis=tmp.1  out=tmp.2  hdvar=restfreq varval=$freq
uvredo  vis=tmp.2  out=tmp.3  options=velocity
uvflag  vis=tmp.3  flagval=f edge=5,5
uvaver  vis=tmp.3 out=tmp.4 line=$ch
uvlist  vis=tmp.3 options=spec
uvlist  vis=tmp.4 options=spec
smauvspec vis=tmp.4 device=1/xs interval=1e3 stokes=i \
          axis=ch,amp nxy=2,3
echo 'Return ';set rr=$<
uvlin vis=tmp.3 out=$vis.$lab chans=$free mode=chan0 order=0
#smauvplt vis=$vis.$lab device=2/xs interval=1e3 stokes=i,v \
#          axis=time,pha nxy=2,2

end:
