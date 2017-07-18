#! /bin/csh -f
#

set gcal=1751+096
set polcal=3c84
set polcal2=3c279

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
set regdisp='arcsec,box(-16,-16,16,16)'
set regdisp='arcsec,box(-8,-8,8,8)'
set regdisp='arcsec,box(-6,-6,6,6)'
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
\rm -fr test1_rxl.?sb 
smalod in=/sma/rtdata/science/mir_data/121014_05:41:44/ out=test1 rxif=-1 options=circular,flagch0 sideband=2 refant=2 
goto terminate

COMBINE:
foreach sb(lsb usb)
\rm -fr combined.$sb 
#uvaver vis=3c84_3x3.$sb,3c279_3x3.$sb out=combined.$sb line=ch,1536
uvaver vis=3c84_4x4.$sb,3c279_4x4.$sb out=combined.$sb line=ch,1536
end
goto terminate


FLAG:
foreach sb(lsb usb)
uvflag vis=combined.$sb select='time(16:19,16:24)' flagval=f 
uvflag vis=combined.$sb select='ant(5),time(12:54,12:56)' flagval=f 
uvflag vis=combined.$sb select='time(12:05,12:30)' flagval=f 
uvflag vis=combined.$sb select='ant(4),time(11:06,11:15)' flagval=f 
uvflag vis=combined.$sb select='time(06:57,07:12)' flagval=f 
uvflag vis=combined.$sb select='ant(3),time(05:46,06:10)' flagval=f 
uvflag vis=combined.$sb select='time(05:21,05:45)' flagval=f 
uvflag vis=combined.$sb select='ant(1),time(04:26,04:34)' flagval=f 
uvflag vis=combined.$sb select='time(03:00,04:09)' flagval=f 
\rm -fr combined_unflgd.$sb
uvaver vis=combined.$sb out=combined_unflgd.$sb
end
goto terminate


BPCAL:
foreach sb(lsb usb)
#mfcal select='so(bllac),pol(ll,rr)' refant=2 interval=30,30 vis=combined_tsys.$sb  line=ch,384,1,16,16
smamfcal select='so(3c84),pol(ll,rr)' options=opolyfit,averrll polyfit=2 refant=2 interval=30,30 vis=combined_unflgd.$sb  line=ch,384,1,4,4
end
goto terminate

APPLYBP:
foreach sb(lsb usb)
\rm -fr combined.$sb.bp
uvaver vis=combined_unflgd.$sb out=combined.$sb.bp options=nocal
end
goto terminate


AVER:
foreach sb(lsb usb)
\rm -fr combined.$sb.bp.aver
uvaver vis=combined.$sb.bp out=combined.$sb.bp.aver line=ch,1,1,1536
end
goto terminate

EVEC:
foreach sb(lsb usb)
#puthd in=combined.$sb.bp.aver/evector value=0.7853
puthd in=combined.$sb.bp.aver/evector value=-0.7853
puthd in=combined.$sb.bp.aver/mount value=4
puthd in=combined.$sb.bp.aver/telescop value=sma

\rm -fr combined.$sb.chi
uvredo vis=combined.$sb.bp.aver options=chi out=combined.$sb.chi
end
goto terminate


SPLIT:
foreach sb(lsb usb)
#foreach so(3c84 uranus 1751+096 smc.6 smc.1)
foreach so(3c84 3c279)
echo $so
\rm -fr "$so""_""$dt".$sb
uvaver vis=combined.$sb.chi select='so('$so')' interval=5 out="$so""_""$dt".$sb
end
end
goto terminate




POLCAL:
foreach sb(lsb usb)
gpcal vis=$polcal"_"$dt.$sb  refant=1 options=circular,qusolve interval=30 flux=1 
gpcal vis=$polcal2"_"$dt.$sb  refant=1 options=circular,qusolve interval=30 flux=1 
end
goto terminate



GCAL:
foreach sb(lsb usb)
mfcal vis=$gcal"_"$dt.$sb select='pol(ll,rr),-time(04:00,05:30)' refant=1 options=nopassol  interval=20
gpcopy vis=$gcal"_"$dt.$sb out=smc.6"_"$dt.$sb options=nopol
gpcopy vis=$polcal"_"$dt.$sb out=smc.6"_"$dt.$sb  options=nocal
gpcopy vis=$gcal"_"$dt.$sb out=smc.1"_"$dt.$sb options=nopol
gpcopy vis=$polcal"_"$dt.$sb out=smc.1"_"$dt.$sb  options=nocal
end
goto terminate

INVERT:
foreach sb(lsb usb)
\rm -fr $so.$sb.?.mp $so.$sb.bm 
set imvis=$so.$sb,../120523/"$source"_120523.$sb
set imvis=$so.$sb
invert vis=$imvis imsize=512 cell=0.125 options=systemp sup=0  \
       map=$so.$sb.i.mp,$so.$sb.q.mp,$so.$sb.u.mp \
       stokes=i,q,u beam=$so.$sb.bm robust=2.0 
#taper=1
end
goto terminate


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
set imvis=../120523/"$source"_120523.lsb,../120523/"$source"_120523.usb,../120525/"$source"_120525.lsb,../120525/"$source"_120525.usb,../120902/"$source"_120902.lsb,../120902/"$source"_120902.usb
endif

if($source == "smc.8") then
set imvis=$so.lsb,$so.usb,../120525/"$source"_120525.lsb,../120525/"$source"_120525.usb,../120523/"$source"_120523.lsb,../120523/"$source"_120523.usb
endif

if($source == "smc.1") then
set imvis=../120525/"$source"_120525.lsb,../120525/"$source"_120525.usb
endif

invert vis=$imvis  \
       map=$so.i.mp,$so.q.mp,$so.u.mp \
       stokes=i,q,u options=mfs,systemp  imsize=512 cell=0.125 \
       beam=$so.bm  sup=0 


foreach pol(i q u)
\rm -fr $so.$pol.cl $so.$pol.cm
clean map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cl region=$region niters=10000 cutoff=0.002
restor map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cm model=$so.$pol.cl
end

goto terminate



IMP:

if($source == "smc.1") set sncutI=15
if($source == "smc.6") set sncutI=20
if($source == "smc.8") set sncutI=30
if($source == "smc.1") set sigmaQ=0.004
if($source == "smc.6") set sigmaQ=0.005
if($source == "smc.8") set sigmaQ=0.0015
\rm -fr $so.poli $so.polierr $so.polm $so.polmerr $so.pa $so.paerr $so.unif
impol in=$so.q.mp,$so.u.mp,$so.i.cm sigma=$sigmaQ,$sigmaQ sncut=2.0,$sncutI \
      poli=$so.poli,$so.polierr polm=$so.polm,$so.polmerr \
      pa=$so.pa,$so.paerr
maths exp=$so.polm/$so.polm mask=$so.polm out=$so.unif

DISP:
if($source == "smc.6") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
if($source == "smc.8") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
if($source == "smc.1") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
set dev=/xw
set device="/cps"
set device="/xw"

if($device == "/cps") set dev="$so.ps""/cps"
#cgdisp in=$so.i.cm,$so.i.cm type=c,p,amp,ang \
cgdisp in=$so.i.cm,$so.poli,$so.polm,$so.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=rot90,full,beambl,wedge range=0,0.0,lin,1 \
       lines=1,2,6 vecfac=1.5,4,4,0.0 labtyp=arcsec,arcsec  \
       range=0,0.0,lin,1  slev=p,1 levs1=$levs1

# csize=1.4,0.8,0.7,0.8\
#       range=0,0.023,lin,1  
#slev=a,0.004 levs1=-100,-50,50,100,150,200,250
#if($device == "/cps") ggv "$so.ps" &




terminate:
