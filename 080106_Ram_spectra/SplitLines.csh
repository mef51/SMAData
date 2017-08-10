#! /bin/csh -f
#
#
set so=orkl_080106
set dd=UVDATA
set lb=vis.uvcal
switch($1)
 case CO:
  set win='4'; 		set sb=usb;
  set freq=345.7959;		set lab=co3-2
  set free=1,19,48,53,69,74,93,102
 breaksw
 case SiO:
  set win='23';    set sb=usb;
  set freq=347.3306;    set lab=sio8-7
  set free=74,124
 breaksw
endsw

set vis=UVDATA/$so
\rm -fr tmp.* $vis.$lab
echo "Starting with:" $vis'.'$sb
uvaver  vis=$vis'.'$sb out=tmp.1 select='win('$win')'
uvputhd vis=tmp.1  out=tmp.2  hdvar=restfreq varval=$freq
uvredo  vis=tmp.2  out=tmp.3  options=velocity
uvlist  vis=tmp.3 options=spec
smauvspec vis=tmp.3 device=1/xs interval=1e3 stokes=i \
          axis=chan,amp nxy=2,3
echo 'Return ';set rr=$<
uvlin vis=tmp.3 out=$vis.$lab chans=$free mode=line order=0
smauvspec vis=$vis.$lab device=1/xs interval=1e3 stokes=i \
          axis=ch,both nxy=2,2
smauvspec vis=$vis.$lab device=1/xs interval=1e3 stokes=v \
          axis=ch,both nxy=2,2
echo "Started with:" $vis'.'$sb
echo "Output:" $vis.$lab
end:
