#! /bin/csh -f
#
set dt=$2
set fn=$3
set trans=$4
set rx=rx1
set fname="$dt""_""$rx"
echo $fname
set inname=$2_$3

set regdisp='arcsec,box(-10,-10,20,10)'
set regdisp='arcsec,box(-16,-16,16,16)'
set regdisp=quart
set regdisp='im(1)'
set regdisp='arcsec,box(-3,-6,8,8)'
set regdisp='arcsec,box(-12,-12,12,12)'
set region=@omc1s.region
set region=quart
set region=@orkl.region
set region=@sio.region
set so=omc1s_"$dt"
set so=orkl_"$dt"

if($#argv<3) then
echo "Incorrect usage: Needs start_pt dt file"
echo "script.csh DISP 060407 06:18:46"
goto terminate
endif

goto $1


SMALOD:
#goto yy
#\rm -fr p1_$fname.lsb p1_$fname.usb p2_$fname.lsb p2_$fname.usb
\rm -fr $fname.lsb $fname.usb
smalod in=/sma/rtData/science/mir_data/080106_03:51:46 out=$dt rxif=1 options=circular,debug sideband=2  refant=2 nscans=2,
#smalod in=/sma/rtData/science/mir_data/071219_18:09:05 out=p2_"$dt" rxif=1 options=circular sideband=2  refant=2

#foreach sb(lsb usb)
#\rm -fr $fname.sb
#uvcal vis=p1_$fname.$sb,p2_$fname.$sb out=$fname.sb
#end


goto terminate

IPOLFLAG:
foreach sb(lsb usb)
\rm -fr $fname.$sb.flgd $fname.$sb.flgd.tmp
uvflag vis=$fname.$sb select='-pol(ll,lr,rl,rr)' flagval=f
#uvflag vis=$fname.$sb select='time(07:20,07:25)' flagval=f
uvcal vis=$fname.$sb options=unflagged out=$fname.$sb.flgd
#uvaver vis=$fname.$sb.flgd.tmp line=ch,2560,5,1,1 out=$fname.$sb.flgd
end
#goto terminate


TSYSFIX:
foreach sb(lsb usb)
\rm -fr $fname.$sb.tsys
smafix vis=$fname.$sb.flgd out=$fname.$sb.tsys options=tsyscorr device=/xw  dofit=2 options=tsyscorr,dosour,tsysswap device=/xw nxy=1,1 yrange=100,800 nxy=2,3
end
#goto terminate

FLAG:
foreach sb(lsb usb)
uvflag vis=$fname.$sb.tsys edge=4 flagval=f
#uvflag vis=$fname.$sb.tsys flagval=f select='time(03:03,03:13),time(03:49,03:53),time(05:29,05:37),time(06:57,07:31),time(08:47,08:55),time(09:51,10:27)'
# Source spectral lines flagging
if($sb == "lsb") then
#uvflag vis=$fname.$sb.tsys select='so(orkl)' line=ch,256,1,1,1  flagval=f
else
#uvflag vis=$fname.$sb.tsys select='so(ni4b),win(4)' line=ch,128,1,1  flagval=f
endif
end
#goto terminate

BPCAL:
foreach sb(lsb usb)
set options=averrll
smamfcal select='pol(ll,rr),so(3c273)' refant=4 interval=30 weight=2 vis=$fname.$sb.tsys  options=$options  line=ch,768,1,4,4
end
#goto terminate

APPLYBP:
foreach sb(lsb usb)
\rm -fr $fname.$sb.tsys.bp
uvaver vis=$fname.$sb.tsys out=$fname.$sb.tsys.bp options=nocal
end
#goto terminate


EVEC:
foreach sb(lsb usb)
puthd in=$fname.$sb.tsys.bp/evector value=0.7853
puthd in=$fname.$sb.tsys.bp/mount value=4

\rm -fr $fname.$sb.tsys.bp.chi
uvredo vis=$fname.$sb.tsys.bp options=chi out=$fname.$sb.tsys.bp.chi
end
#goto terminate

SPLIT:
foreach sb(lsb usb)
#foreach so(3c454.3 3c273 3c279 callisto 1733-130 sgrastar)
#foreach so(3c454.3 uranus neptune 0528+134 mms6 3c273 titan)
foreach so(3c273 0528+134 orkl omc1s)
echo $so
\rm -fr "$so""_""$dt".$sb
uvaver vis=$fname.$sb.tsys.bp.chi select='so('$so')' interval=6 out="$so""_""$dt".$sb line=ch,1,1,3072
end
end

foreach sb(lsb usb)
foreach so(orkl omc1s)
echo $so
\rm -fr "$so""_""$dt".$sb "$so""_""$dt".$sb.pf
uvcal vis=$fname.$sb.tsys.bp.chi select='so('$so')'  out="$so""_""$dt".$sb.pf

#if("$sb" == "usb") then
#foreach win(2 4 5 9 13 14 15 18 19 21 22 23)
#uvflag vis="$so""_""$dt".$sb.pf flagval=f select='win('"$win"')'
#end
#else
#foreach win(1 2 3 5 8 12 13 14 17 18 23 24)
#uvflag vis="$so""_""$dt".$sb.pf flagval=f select='win('"$win"')'
#end
#endif

uvaver vis="$so""_""$dt".$sb.pf select='so('$so')' interval=6 out="$so""_""$dt".$sb line=ch,3072

end
end

goto terminate

POLCAL:
foreach sb(lsb usb)
gpcal vis=3c273"_"$dt.$sb refant=2 options=circular,qusolve interval=20
#gpcal vis=3c454.3"_"$dt.$sb refant=4 options=circular,nopol interval=5
#gpcopy vis=../071215/3c454.3_071215.$sb out=3c454.3"_"$dt.$sb options=nocal
end
goto terminate


GCAL:
foreach sb(lsb usb)
selfcal vis=0528+134"_"$dt.$sb refant=2 options=amp select='pol(ll,rr)' interval=15
gpcopy vis=0528+134"_"$dt.$sb out=orkl"_"$dt.$sb
gpcopy vis=3c273"_"$dt.$sb out=orkl"_"$dt.$sb options=nocal
gpcopy vis=0528+134"_"$dt.$sb out=omc1s"_"$dt.$sb
gpcopy vis=3c273"_"$dt.$sb out=omc1s"_"$dt.$sb options=nocal
end
goto terminate

INVERT:
if($trans == "12co") then
set imline=vel,200,-100,1,1
set sb="usb"
endif

if($trans == "87sio") then
set imline=vel,150,-1400,1,1
set sb="usb"
endif


\rm -fr $so.$trans.?.mp $so.$trans.bm
invert vis=$so.$sb imsize=128 cell=0.6 options=systemp sup=0 robust=1.0 \
       map=$so.$trans.i.mp,$so.$trans.q.mp,$so.$trans.u.mp,$so.$trans.v.mp \
       stokes=i,q,u,v beam=$so.$trans.bm line=$imline slop=1

goto terminate


CLEAN:
foreach pol(i q u v)
\rm -fr $so.$trans.$pol.cl $so.$trans.$pol.cm
clean map=$so.$trans.$pol.mp beam=$so.$trans.bm  \
      out=$so.$trans.$pol.cl region=$region niters=10000 cutoff=0.2
restor map=$so.$trans.$pol.mp beam=$so.$trans.bm \
      out=$so.$trans.$pol.cm model=$so.$trans.$pol.cl
end

goto terminate

INVERTBOTHSB:
\rm -fr $so.?.mp $so.bm
#set allvis=../060910/orkl_060910.lsb,../060910/orkl_060910.usb,../070424/orkl_070424.lsb,../070424/orkl_070424.usb,../070425/orkl_070425.lsb,../070425/orkl_070425.usb,../070427/orkl_070427.lsb,../070427/orkl_070427.usb,../080106/orkl_080106.lsb,../080106/orkl_080106.usb
set vis060910lsb=../060910/orkl_060910.lsb
set vis060910usb=../060910/orkl_060910.usb
set vis060910=$vis060910lsb,$vis060910usb
set vis070424lsb=../070424/orkl_070424.lsb
set vis070424usb=../070424/orkl_070424.usb
set vis070424=$vis070424lsb,$vis070424usb
set vis070425lsb=../070425/orkl_070425.lsb
set vis070425usb=../070425/orkl_070425.usb
set vis070425=$vis070425lsb,$vis070425usb
set vis070427lsb=../070427/orkl_070427.lsb
set vis070427usb=../070427/orkl_070427.usb
set vis070427=$vis070427lsb,$vis070427usb
set vis080106lsb=../080106/orkl_080106.lsb
set vis080106usb=../080106/orkl_080106.usb
set vis080106=$vis080106lsb,$vis080106usb

set vislsb=$vis060910lsb,$vis070424lsb,$vis070425lsb,$vis070427lsb,$vis080106lsb
set visusb=$vis060910usb,$vis070424usb,$vis070425usb,$vis070427usb,$vis080106usb


set vis=$visusb
set vis=$vislsb
echo $vis

#invert vis=$so.lsb,$so.usb  \
invert vis=$vis  \
       map=$so.i.mp,$so.q.mp,$so.u.mp \
       stokes=i,q,u options=systemp sup=128 robust=0.0 imsize=256 cell=0.15 \
       beam=$so.bm

foreach pol(i q u)
\rm -fr $so.$pol.cl $so.$pol.cm
clean map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cl region=$region niters=10000 cutoff=0.003
restor map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cm model=$so.$pol.cl
end

IMP:
foreach sb(lsb usb)
\rm -fr $so.$sb.poli $so.$sb.polierr $so.$sb.polm $so.$sb.polmerr $so.$sb.pa $so.$sb.paerr
impol in=$so.$sb.q.cm,$so.$sb.u.cm,$so.$sb.i.cm sigma=0.006 sncut=6,250 \
      poli=$so.$sb.poli,$so.$sb.polierr polm=$so.$sb.polm,$so.$sb.polmerr \
      pa=$so.$sb.pa,$so.$sb.paerr
end

\rm -fr $so.poli $so.polierr $so.polm $so.polmerr $so.pa $so.paerr
impol in=$so.q.cm,$so.u.cm,$so.i.cm sigma=0.004 sncut=6,400 \
      poli=$so.poli,$so.polierr polm=$so.polm,$so.polmerr \
      pa=$so.pa,$so.paerr

DISP:
set dev=/xw
set device="/xw"
set device="/cps"
set vecfac=2.0,4,4
#foreach sb(lsb usb)
#if($device == "/cps") set dev="$so.$sb.ps""/cps"
#cgdisp in=$so.$sb.i.cm,$so.$sb.poli,$so.$sb.polm,$so.$sb.pa type=c,p,amp,ang \
#       device=$dev region=$regdisp \
#       options=full,beambl,wedge,rot90 \
#       lines=1,2,6 vecfac=2.5,2,3 labtyp=arcsec,arcsec
#       range=0,0.4,lin,-1  slev=p,1 levs1=-20,20,30,40,50,60,70,80,90,95
#if($device == "/cps") ggv "$so.$sb.ps" &
#end

if($device == "/cps") set dev="$so.ps""/cps"
cgdisp in=$so.i.cm,$so.i.cm,$so.polm,$so.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=full,beambl range=0,12.0,lin,1 \
       lines=1,2,6 vecfac=$vecfac labtyp=arcsec,arcsec
# csize=1.4,0.8,0.7,0.8\
#       range=0,0.023,lin,1
#slev=a,0.004 levs1=-100,-50,50,100,150,200,250
#if($device == "/cps") ggv "$so.ps" &




terminate:
