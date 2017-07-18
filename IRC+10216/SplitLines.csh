#! /bin/csh -f
#
#
set so=irc+10216
set dd=UVDATA
set lb=vis.uvcal
switch($1)
 case CS:
  set win='5'; 			set sb=usb;
  set freq=342.88285;		set lab=cs7-6
  set free=4,32,91,123,
 breaksw
 case SiS:
  set win='28'; 		set sb=usb;
  set freq=344.77947;		set lab=sis19-18
  set free=4,15,81,123
 breaksw
 case H13CN:  # 2 win
  set win='34,35'; 		set sb=usb;
  set freq=345.33976 ;		set lab=h13cn4-3
  set free=1,35,91,128;		set ch=vel,128,-70,0.705,0.705
 breaksw
 case CO:
  set win='40'; 		set sb=usb;
  set freq=345.7959;		set lab=co3-2
  set free=4,50,112,123
 breaksw
endsw

set vis=UVDATA/$so
\rm -fr tmp.* $vis.$lab
echo $lab
uvaver  vis=$vis'_'$sb.$lb out=tmp.1 select='win('$win')' 
uvputhd vis=tmp.1  out=tmp.2  hdvar=restfreq varval=$freq
uvredo  vis=tmp.2  out=tmp.3  options=velocity 
uvlist  vis=tmp.3 options=spec
if ($1 == 'H13CN') then
 uvflag  vis=tmp.3  flagval=f edge=5,5
 uvaver  vis=tmp.3 out=tmp.4 line=$ch
 \rm -r tmp.3
 mv tmp.4 tmp.3
endif
smauvspec vis=tmp.3 device=1/xs interval=1e3 stokes=i \
          axis=vel,amp nxy=2,3 
echo 'Return ';set rr=$<
uvlin vis=tmp.3 out=$vis.$lab chans=$free mode=line order=0
smauvspec vis=$vis.$lab device=1/xs interval=1e3 stokes=i \
          axis=ch,both nxy=2,2
smauvspec vis=$vis.$lab device=1/xs interval=1e3 stokes=v \
          axis=ch,both nxy=2,2

end:
