#! /bin/csh -f
#

set gcal=1751+096
set polcal=3c84

set dt=$2
set source=$3
set so="$source"_"$dt"

set separatesb="n"

set regdisp='arcsec,box(-10,-10,20,10)'
set regdisp='arcsec,box(-16,-16,16,16)'
set region='arcsec,box(-4,-4,4,4)'
set region=quart
set region=@"$source".region
set regdisp='im(1)'
set regdisp='arcsec,box(-12,-10,8,10)'
set regdisp='arcsec,box(-6,-6,16,16)'
set regdisp='arcsec,box(-5,-5,5,5)'
set regdisp='arcsec,box(-12,-12,12,12)'
set regdisp='arcsec,box(-8,-8,8,8)'
set regdisp='arcsec,box(-6,-6,6,6)'
set regdisp='arcsec,box(-20,-20,20,20)'
set niters=4000
#set gain=0.3
#set so=1733-130_$dt

if($#argv<1) then
echo "Incorrect usage: Needs start_pt "
echo "script.csh DISP "
goto terminate
endif

goto $1


goto terminate

GETDATA:
# 3c454.3 callisto 3c279 1733-130 i16293
\rm -fr test1_rxl.?sb test2_rxl.?sb
smalod in=/sma/data/science/mir_data.2013/130824_02:45:01/ out=test1 rxif=-2 options=circular,flagch0 sideband=2 refant=2 
smalod in=/sma/rtdata/science/mir_data/130824_06:55:26/ out=test2 rxif=-1 options=circular,flagch0 sideband=2 refant=2 
goto terminate

COMBINE:
foreach sb(lsb usb)
\rm -fr combined.$sb 
uvaver vis=titan.$sb,1751+096.$sb,smc.6.$sb,neptune.$sb,uranus.$sb,3c84.$sb out=combined.$sb 
end
goto terminate


FLAG:
foreach sb(lsb usb)
#uvflag vis=combined.$sb edge=8 flagval=f 
uvflag vis=combined.$sb select='pol(xx)' flagval=f 
# Pointing
# Badness
uvflag vis=combined.$sb select='time(02:59:44,03:20:51)' flagval=f 
uvflag vis=combined.$sb select='time(03:57:08,04:33:09)' flagval=f 
uvflag vis=combined.$sb select='time(05:14:10,05:35:17)' flagval=f 
uvflag vis=combined.$sb select='time(06:37:49,07:19:35)' flagval=f 
uvflag vis=combined.$sb select='time(08:01:57,08:35:38)' flagval=f 
uvflag vis=combined.$sb select='time(09:35:52,09:42:08)' flagval=f 
uvflag vis=combined.$sb select='time(10:23:32,10:40:53)' flagval=f 
uvflag vis=combined.$sb select='time(11:13:45,11:41:18)' flagval=f 
\rm -fr combined_unflgd.$sb
uvaver vis=combined.$sb out=combined_unflgd.$sb
end
goto terminate

TSYS:
foreach sb(lsb usb)
\rm -fr combined_tsys.$sb
#smafix device=/xw vis=combined_unflgd.$sb out=combined_tsys.$sb options=tsyscorr
# TSYS WAS ALREADY DONE IN MIR/IDL
uvcal vis=combined_unflgd.$sb out=combined_tsys.$sb
end
goto terminate


BPCAL:
foreach sb(lsb usb)
mfcal select='so(3c84),pol(ll,rr)' refant=2 interval=30,30 vis=combined_tsys.$sb  line=ch,384,1,16,16 edge=2
end
goto terminate

APPLYBP:
foreach sb(lsb usb)
\rm -fr combined.$sb.bp
uvaver vis=combined_tsys.$sb out=combined.$sb.bp options=nocal
end
goto terminate

FLUXSC:
set neptunelsbscale=`smaflux vis=combined.lsb.bp select='so(neptune),pol(ll,rr)' options=noapply | grep Scaling | awk '{print $5}'`
set uranuslsbscale=`smaflux vis=combined.lsb.bp select='so(uranus),pol(ll,rr)' options=noapply | grep Scaling | awk '{print $5}'`
set neptuneusbscale=`smaflux vis=combined.usb.bp select='so(neptune),pol(ll,rr)' options=noapply | grep Scaling | awk '{print $5}'`
set uranususbscale=`smaflux vis=combined.usb.bp select='so(uranus),pol(ll,rr)' options=noapply | grep Scaling | awk '{print $5}'`
set lsbscale=`echo $neptunelsbscale $uranuslsbscale | awk '{print 0.5*($1+$2)}'`
set usbscale=`echo $neptuneusbscale $uranususbscale | awk '{print 0.5*($1+$2)}'`
set lsbscale=0.93
set usbscale=0.96
\rm -fr combined.lsb.flux
uvcal vis=combined.lsb.bp scale=$lsbscale out=combined.lsb.flux
\rm -fr combined.usb.flux
uvcal vis=combined.usb.bp scale=$usbscale out=combined.usb.flux
goto terminate

AVER:
foreach sb(lsb usb)
\rm -fr combined.$sb.bp.aver
uvaver vis=combined.$sb.flux out=combined.$sb.bp.aver line=ch,1,1,6144
end
goto terminate

EVEC:
foreach sb(lsb usb)
puthd in=combined.$sb.bp.aver/mount value=4
puthd in=combined.$sb.bp.aver/telescop value=sma
puthd in=combined.$sb.bp.aver/evector value=-0.785398

\rm -fr combined.$sb.chi
uvredo vis=combined.$sb.bp.aver options=chi out=combined.$sb.chi
end
goto terminate

SPLIT:
foreach sb(lsb usb)
foreach so(titan 1751+096 smc.6 neptune uranus 3c84)
echo $so
\rm -fr "$so""_""$dt".$sb
uvaver vis=combined.$sb.chi select='so('$so')' interval=5 out="$so""_""$dt".$sb
end
end
goto terminate



POLCAL:
foreach sb(lsb usb)
# 3c84
gpcal vis=$polcal"_"$dt.$sb  refant=2 options=circular,qusolve interval=20 flux=6.64
end
goto terminate



GCAL:
foreach sb(lsb usb)
#mfcal vis=$gcal"_"$dt.$sb select='pol(ll,rr)' refant=2 options=nopassol  interval=20
selfcal vis=$gcal"_"$dt.$sb select='pol(ll,rr)' refant=2 options=phase  interval=20
gpbreak vis=$gcal"_"$dt.$sb break=04:15:00,05:20:00,07:00:00,08:15:00,09:40:00
gpcopy vis=$gcal"_"$dt.$sb out=$source"_"$dt.$sb options=nopol
gpcopy vis=$polcal"_"$dt.$sb out=$source"_"$dt.$sb options=nocal
end
goto terminate

INVERT:
foreach sb(lsb usb)
\rm -fr $so.$sb.?.mp $so.$sb.bm 
set imvis=$so.$sb,../120523/"$source"_120523.$sb
set imvis=$so.$sb
invert vis=$imvis imsize=256 cell=0.25 options=systemp sup=0  \
       map=$so.$sb.i.mp,$so.$sb.q.mp,$so.$sb.u.mp \
       stokes=i,q,u beam=$so.$sb.bm robust=2.0 
#taper=1
end


CLEAN:
foreach sb(lsb usb)
foreach pol(i q u)
\rm -fr $so.$sb.$pol.cl $so.$sb.$pol.cm
clean map=$so.$sb.$pol.mp beam=$so.$sb.bm  \
      out=$so.$sb.$pol.cl region=$region niters=$niters cutoff=0.005
restor map=$so.$sb.$pol.mp beam=$so.$sb.bm \
      out=$so.$sb.$pol.cm model=$so.$sb.$pol.cl
end
end

goto terminate

INVERTBOTHSB:
\rm -fr $so.?.mp $so.bm 
if($source == "smc.6") then
set imvis=../120523/"$source"_120523.lsb,../120523/"$source"_120523.usb,../120525/"$source"_120525.lsb,../120525/"$source"_120525.usb
endif

if($source == "smc.8") then
set imvis=$so.lsb,$so.usb,../120525/"$source"_120525.lsb,../120525/"$source"_120525.usb,../120523/"$source"_120523.lsb,../120523/"$source"_120523.usb
endif

if($source == "smc.1") then
set imvis=../120525/"$source"_120525.lsb,../120525/"$source"_120525.usb
endif

set imvis=$so.lsb,$so.usb
invert vis=$imvis  \
       map=$so.i.mp,$so.q.mp,$so.u.mp \
       stokes=i,q,u options=mfs,systemp  imsize=256 cell=0.25 \
       beam=$so.bm  sup=0


foreach pol(i q u)
\rm -fr $so.$pol.cl $so.$pol.cm
clean map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cl region=$region niters=10000 cutoff=0.002
restor map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cm model=$so.$pol.cl
end

goto terminate


IMPSB:

if($source == "smc.1") set sncutI=15
if($source == "smc.6") set sncutI=10
if($source == "smc.8") set sncutI=30
if($source == "smc.1") set sigmaQ=0.004
if($source == "smc.6") set sigmaQ=0.01
if($source == "smc.8") set sigmaQ=0.0015
foreach sb(lsb usb)
\rm -fr $so.$sb.poli $so.$sb.polierr $so.$sb.polm $so.$sb.polmerr $so.$sb.pa $so.$sb.paerr $so.$sb.unif
impol in=$so.$sb.q.mp,$so.$sb.u.mp,$so.$sb.i.cm sigma=$sigmaQ,$sigmaQ sncut=2.0,$sncutI \
      poli=$so.$sb.poli,$so.$sb.polierr polm=$so.$sb.polm,$so.$sb.polmerr \
      pa=$so.$sb.pa,$so.$sb.paerr
maths exp=$so.$sb.polm/$so.$sb.polm mask=$so.$sb.polm out=$so.$sb.unif
end

goto terminate


IMP:

if($source == "smc.1") set sncutI=15
if($source == "smc.6") set sncutI=30
if($source == "smc.8") set sncutI=30
if($source == "smc.1") set sigmaQ=0.004
if($source == "smc.6") set sigmaQ=0.006
if($source == "smc.8") set sigmaQ=0.0015
\rm -fr $so.poli $so.polierr $so.polm $so.polmerr $so.pa $so.paerr $so.unif
impol in=$so.q.mp,$so.u.mp,$so.i.cm sigma=$sigmaQ,$sigmaQ sncut=2.0,$sncutI \
      poli=$so.poli,$so.polierr polm=$so.polm,$so.polmerr \
      pa=$so.pa,$so.paerr
maths exp=$so.polm/$so.polm mask=$so.polm out=$so.unif
goto terminate

DISPSB:
if($source == "smc.6") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
if($source == "smc.8") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
if($source == "smc.1") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
set dev=/xw
set device="/cps"
set device="/xw"

foreach sb(lsb usb)
if($device == "/cps") set dev="$so.ps""/cps"
#cgdisp in=$so.i.cm,$so.i.cm type=c,p,amp,ang \
cgdisp in=$so.$sb.i.cm,$so.$sb.poli,$so.$sb.polm,$so.$sb.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=rot90,full,beambl,wedge range=0,0.0,lin,1 \
       lines=1,2,6 vecfac=1.5,8,8,0.0 labtyp=arcsec,arcsec  \
       range=0,0.0,lin,1  slev=p,1 levs1=$levs1
end
goto terminate

DISP:
if($source == "smc.6") set levs1=-20,-10,-5,5,10,20,30,40,50,60,70,80,90,95
if($source == "smc.8") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
if($source == "smc.1") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
set dev=/xw
set device="/cps"
set device="/xw"

if($device == "/cps") set dev="$so.ps""/cps"
#cgdisp in=$so.i.cm,$so.i.cm type=c,p,amp,ang \
cgdisp in=$so.i.cm,$so.poli,$so.unif,$so.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=rot90,full,beambl,wedge range=0,0.0,lin,1 \
       lines=1,2,6 vecfac=0.5,8,8,0.0 labtyp=arcsec,arcsec  \
       range=0,0.0,lin,1  slev=p,1 levs1=$levs1

# csize=1.4,0.8,0.7,0.8\
#       range=0,0.023,lin,1  
#slev=a,0.004 levs1=-100,-50,50,100,150,200,250
#if($device == "/cps") ggv "$so.ps" &




terminate:
