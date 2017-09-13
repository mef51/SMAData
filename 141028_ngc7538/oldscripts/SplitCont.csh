#! /bin/csh -f
#
#
set so=NGC7538
set dd=UVDATA
set lb=vis.uvcal
switch($1)
 case USB:
  # 65 110 200 280 300 400 580 600 620 640
  set sb=usb;			set ch=vel,345,-2149,5.0,5.0
  set freq=345.0;		set lab=cnt.usb
  set free=1,23,33,85,95,104,108,140,150,166,180,216,228,268,305,322,329,345
 breaksw
endsw

set vis=UVDATA/$so
set suffix='S-s3'
\rm -fr tmp.* $vis.$lab
echo "Starting with:" $vis$suffix'.'$sb
uvaver  vis=$vis$suffix'.'$sb out=tmp.1
uvputhd vis=tmp.1  out=tmp.2  hdvar=restfreq varval=$freq
uvredo  vis=tmp.2  out=tmp.3  options=velocity
uvflag  vis=tmp.3  flagval=f edge=5,5 # this is because we average 5 velocity channels into 1
uvaver  vis=tmp.3 out=tmp.4 line=$ch
uvlist  vis=tmp.3 options=spec
uvlist  vis=tmp.4 options=spec
smauvspec vis=tmp.4 device=1/xw interval=1e3 stokes=i \
          axis=ch,amp nxy=2,3
echo 'Return ';set rr=$<
uvlin vis=tmp.3 out=$vis.$lab chans=$free mode=chan0 order=0
#smauvplt vis=$vis.$lab device=2/xs interval=1e3 stokes=i,v \
#          axis=time,pha nxy=2,2
echo "Started with:" $vis'.'$sb
echo "Output:" $vis.$lab
end:
