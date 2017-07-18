#! /bin/csh -f
#

set gcal=1751+096
set polcal=3c84

set dt=$2
set source=$3
set so="$source"_"$dt"


set regdisp='arcsec,box(-10,-10,20,10)'
set regdisp='arcsec,box(-16,-16,16,16)'
set region='arcsec,box(-4,-4,4,4)'
set region=quart
set region=@"$source".region
set regdisp='im(1)'
set regdisp='arcsec,box(-12,-10,8,10)'
set regdisp='arcsec,box(-6,-6,16,16)'
set regdisp='arcsec,box(-12,-12,12,12)'
set regdisp='arcsec,box(-16,-16,16,16)'
set regdisp='arcsec,box(-6,-6,6,6)'
set regdisp='arcsec,box(-5,-5,5,5)'
set regdisp='arcsec,box(-8,-8,8,8)'
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
smalod in=/sma/data/science/mir_data.2012/120902_04:11:29/ out=test1 rxif=-1 options=circular,flagch0 sideband=2 refant=2 
goto terminate

COMBINE:
foreach sb(lsb usb)
\rm -fr combined.$sb 
uvaver vis=test1_rxl.$sb out=combined.$sb line=ch,6144,2,1,1
end
goto terminate


FLAG:
foreach sb(lsb usb)
uvflag vis=combined.$sb select='pol(xx)' flagval=f 
uvflag vis=combined.$sb select='time(05:21,05:26)' flagval=f 
uvflag vis=combined.$sb select='time(05:57,06:09)' flagval=f 
uvflag vis=combined.$sb select='time(10:14,10:19)' flagval=f 
uvflag vis=combined.$sb select='ant(8),time(11:59,12:02)' flagval=f 
uvflag vis=combined.$sb select='ant(7),time(12:07,12:10)' flagval=f 
uvflag vis=combined.$sb select='ant(5),time(12:59,13:02)' flagval=f 
uvflag vis=combined.$sb select='ant(2),time(14:49,14:50)' flagval=f 
uvflag vis=combined.$sb select='time(15:12,15:23)' flagval=f 
\rm -fr combined_unflgd.$sb
uvaver vis=combined.$sb out=combined_unflgd.$sb
end
goto terminate

TSYS:
foreach sb(lsb usb)
\rm -fr combined_tsys.$sb
smafix device=/xw vis=combined_unflgd.$sb out=combined_tsys.$sb options=tsyscorr
end
goto terminate


BPCAL:
foreach sb(lsb usb)
#mfcal select='so(bllac),pol(ll,rr)' refant=2 interval=30,30 vis=combined_tsys.$sb  line=ch,384,1,16,16
smamfcal select='so(3c84),pol(ll,rr)' options=opolyfit,averrll polyfit=2 refant=2 interval=30,30 vis=combined_tsys.$sb  line=ch,384,1,16,16
end
goto terminate

APPLYBP:
foreach sb(lsb usb)
\rm -fr combined.$sb.bp
uvaver vis=combined_tsys.$sb out=combined.$sb.bp options=nocal
end
goto terminate


AVER:
foreach sb(lsb usb)
\rm -fr combined.$sb.bp.aver
uvaver vis=combined.$sb.bp out=combined.$sb.bp.aver line=ch,1,1,6144
end
goto terminate

SPLIT:
foreach sb(lsb usb)
foreach so(3c84 uranus 1751+096 smc.6 smc.1)
#foreach so(3c84)
echo $so
\rm -fr "$so""_""$dt".$sb
uvaver vis=combined.$sb.bp.aver select='so('$so')' interval=5 out="$so""_""$dt".$sb
end
end
goto terminate




POLCAL:
foreach sb(lsb usb)
gpcal vis=$polcal"_"$dt.$sb  refant=1 options=circular,qusolve interval=10 flux=1 
#gpcal vis=$polcal2"_"$dt.$sb  refant=1 options=circular,qusolve interval=10 flux=1 
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
set imvis=../120902/"$source"_120902.lsb,../120902/"$source"_120902.usb
set imvis=../120523/"$source"_120523.lsb,../120523/"$source"_120523.usb,../120525/"$source"_120525.lsb,../120525/"$source"_120525.usb
set imvis=../120523/"$source"_120523.lsb,../120523/"$source"_120523.usb,../120525/"$source"_120525.lsb,../120525/"$source"_120525.usb,../130903/"$source"_130903_3x3.lsb,../130903/"$source"_130903_3x3.usb
set imvis=../130903/"$source"_130903_3x3.lsb,../130903/"$source"_130903_3x3.usb
set imvis=../120523/"$source"_120523.lsb,../120523/"$source"_120523.usb,../120525/"$source"_120525.lsb,../120525/"$source"_120525.usb,../120902/"$source"_120902.lsb,../120902/"$source"_120902.usb,../130903/"$source"_130903_3x3.lsb,../130903/"$source"_130903_3x3.usb
set imvis=../120523/"$source"_120523.lsb,../120523/"$source"_120523.usb,../120525/"$source"_120525.lsb,../120525/"$source"_120525.usb,../120902/"$source"_120902.lsb,../120902/"$source"_120902.usb
endif

if($source == "smc.8") then
set imvis=../120525/"$source"_120525.lsb,../120525/"$source"_120525.usb,../120523/"$source"_120523.lsb,../120523/"$source"_120523.usb,../120615/"$source"_120615.lsb,../120615/"$source"_120615.usb
endif

if($source == "smc.1") then
set imvis=../120525/"$source"_120525.lsb,../120525/"$source"_120525.usb
set imvis=../120525/"$source"_120525.lsb,../120525/"$source"_120525.usb,../120902/"$source"_120902.lsb,../120902/"$source"_120902.usb
endif

invert vis=$imvis  \
       map=$so.i.mp,$so.q.mp,$so.u.mp \
       stokes=i,q,u options=mfs,systemp  imsize=512 cell=0.125 \
       beam=$so.bm  robust=5.0 sup=0
#sup=0 fwhm=0.5
#sup=0
#fwhm=0.5


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
if($source == "smc.6") set sncutI=30
if($source == "smc.8") set sncutI=10
if($source == "smc.1") set sigmaQ=0.003
if($source == "smc.6") set sigmaQ=0.004
if($source == "smc.8") set sigmaQ=0.015
echo  "rx_pair noiseq noiseu    avg  Peak_I"

echo "All data "
set noiseq=`imhist in=$so.q.mp device=/null region='box(16,16,128,480)' | grep and | awk '{printf("%.1f\n", 1000.0*$3)}'`
set noiseu=`imhist in=$so.u.mp device=/null region='box(16,16,128,480)' | grep and | awk '{printf("%.1f\n", 1000.0*$3)}'`
set noisei=`imhist in=$so.i.cm device=/null region='box(16,16,128,480)' | grep and | awk '{printf("%.1f\n", 1000.0*$3)}'`
set imax=`imhist in=$so.i.cm device=/null region='quart'  | grep Maximum |  awk '{printf("%.1f\n", 1000.0*$3)}'`
echo $noiseq $noiseu $imax | awk '{printf("%7.1f %7.1f %7.1f %7.1f\n",$1, $2, 0.5*($1+$2), $3)}'

set sigmaQ=`echo $noiseq | awk '{print $1/1000}'`
set sigmaI=`echo $noisei | awk '{print $1/1000}'`
set sncutQ=2.0
set sncutI=2.0
set sncutI=`echo $noiseq $noiseu $imax | awk '{print 0.1*$3/(0.5*($1+$2))}'`
\rm -fr $so.poli $so.polierr $so.polm $so.polmerr $so.pa $so.paerr $so.unif
impol in=$so.q.mp,$so.u.mp,$so.i.cm sigma=$sigmaQ,$sigmaQ sncut=$sncutQ,$sncutI \
      poli=$so.poli,$so.polierr polm=$so.polm,$so.polmerr \
      pa=$so.pa,$so.paerr
maths exp=$so.polm/$so.polm mask=$so.polm out=$so.unif

DISP:
if($source == "smc.6") set levs1=-20,-10,-5,5,10,20,30,40,50,60,70,80,90,95
if($source == "smc.6") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
if($source == "smc.8") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
if($source == "smc.1") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
if($source == "smc.1") set levs1=-30,30,40,50,60,70,80,90,95
set dev=/xw
set device="/xw"
set device="/cps"

set cellsize=`grep "cell" $so.i.cm/history | tail -1 | awk 'BEGIN{FS="="} {printf("%f\n",$2)}'`
grep "Beam" $so.i.cm/history | tail -1 | awk -v cellsize=$cellsize '{printf("1.0,%d,%d,0.0,%f,%f\n",$4/2.0/cellsize,$6/2.0/cellsize,$4,$6)}'
set vecfac=`grep "Beam" $so.i.cm/history | tail -1 | awk -v cellsize=$cellsize '{printf("1.0,%.0f,%.0f\n",$4/2.0/cellsize,$6/2.0/cellsize)}'`
#set vecfac=0.8,2,2,0.0
echo $vecfac

if($device == "/cps") set dev="$so.ps""/cps"
#cgdisp in=$so.i.cm,$so.i.cm type=c,p,amp,ang \
cgdispN in=$so.i.cm,$so.poli,$so.polm,$so.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=rot90,full,beambl,wedge,noepoch range=0,0.0,lin,1 \
       lines=1,4,6 vecfac=$vecfac labtyp=arcsec,arcsec  \
       range=0,0.0,lin,-1  slev=p,1 levs1=$levs1

# csize=1.4,0.8,0.7,0.8\
#       range=0,0.023,lin,1  
#slev=a,0.004 levs1=-100,-50,50,100,150,200,250
#if($device == "/cps") ggv "$so.ps" &




terminate:
