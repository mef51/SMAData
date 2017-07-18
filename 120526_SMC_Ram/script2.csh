#! /bin/csh -f
#

set gcal=1751+096
set polcal=bllac

set dt=$2
set source=$3
set so="$source"_"$dt"

set separatesb="n"

set regdisp='arcsec,box(-10,-10,20,10)'
set region=quart
set region='arcsec,box(-4,-4,4,4)'
set region=@"$source".region
set regdisp='im(1)'
set regdisp='arcsec,box(-12,-10,8,10)'
set regdisp='arcsec,box(-8,-8,8,8)'
set regdisp='arcsec,box(-16,-16,16,16)'
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
smalod in=/sma/rtdata/science/mir_data/120526_07:28:50/ out=test1 rxif=-1 options=circular,flagch0 sideband=2 refant=2
goto terminate

COMBINE:
foreach sb(lsb usb)
\rm -fr combined.$sb 
uvcat vis=test1_rxl.$sb out=combined.$sb
end
goto terminate


FLAG:
foreach sb(lsb usb)
uvflag vis=combined.$sb select='pol(xx)' flagval=f 
uvflag vis=combined.$sb select='time(15:10,15:27)' flagval=f 
uvflag vis=combined.$sb select='ant(5),time(11:54,12:12)' flagval=f 
\rm -fr combined_unflgd.$sb
uvaver vis=combined.$sb line=ch,6144,2,1,1 out=combined_unflgd.$sb
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
smamfcal select='so(3c279),pol(ll,rr)' options=opolyfit,averrll polyfit=3 refant=2 interval=5,5 vis=combined_tsys.$sb  line=ch,384,1,16,16
end
goto terminate

APPLYBP:
foreach sb(lsb usb)
\rm -fr combined.$sb.bp
#uvaver vis=combined_tsys.$sb out=combined.$sb.bp options=nocal
uvaver vis=combined_tsys.$sb out=combined.$sb.bp 
end
goto terminate

GETCO:
set so=$source
\rm -fr $so.win4
uvaver vis=combined.usb.bp out=$so.win4 select='so('"$source"'),win(4)' interval=5
puthd in=$so.win4/evector value=0.7853
puthd in=$so.win4/mount value=4
puthd in=$so.win4/telescop value=sma

\rm -fr $so.win4.chi 
uvredo vis=$so.win4 options=chi out=$so.win4.chi

goto terminate

RMLINE:
uvflag vis=combined.usb.bp line=ch,64,425 flagval=f
goto terminate

AVER:
foreach sb(lsb usb)
\rm -fr combined.$sb.bp.aver
uvaver vis=combined.$sb.bp out=combined.$sb.bp.aver line=ch,1,1,6144
end
goto terminate

#EVEC:
#foreach sb(lsb usb)
#puthd in=combined.$sb.bp.aver/evector value=0.7853
#puthd in=combined.$sb.bp.aver/mount value=4
#puthd in=combined.$sb.bp.aver/telescop value=sma
#
#\rm -fr combined.$sb.chi
#uvredo vis=combined.$sb.bp.aver options=chi out=combined.$sb.chi
#end
#goto terminate


SPLIT:
foreach sb(lsb usb)
#foreach so(3c454.3  callisto 0136+478 M33GMC5 mars)
foreach so(3c279 bllac titan 1751+096 smc.7 smc.11 smc.15)
echo $so
\rm -fr "$so""_""$dt".$sb
uvaver vis=combined.$sb.bp.aver select='so('$so')' interval=5 out="$so""_""$dt".$sb
end
end
goto terminate




POLCAL:
foreach sb(lsb usb)
#gpcopy vis=../120430/3c279_120430.$sb options=nocal out=$polcal"_"$dt.$sb options=nocal
#gpcal vis=$polcal"_"$dt.$sb  refant=1 options=circular,nopol,qusolve interval=15 flux=1 select='-ant(7)'
gpcal vis=$polcal"_"$dt.$sb  refant=1 options=circular,qusolve interval=10 flux=1 
end
goto terminate



GCAL:
foreach sb(lsb usb)
mfcal vis=$gcal"_"$dt.$sb select='pol(ll,rr)' refant=5 options=nopassol  interval=20
gpbreak vis=$gcal"_"$dt.$sb break=15:10
gpbreak vis=$gcal"_"$dt.$sb break=11:54 ants=5
foreach so1 (7 11 15)
gpcopy vis=$gcal"_"$dt.$sb out=smc."$so1""_"$dt.$sb options=nopol
gpcopy vis=../120525/$polcal"_"120525.$sb out=smc."$so1""_"$dt.$sb  options=nocal
end
end
goto terminate

INVERT:
foreach sb(lsb usb)
\rm -fr $so.$sb.?.mp $so.$sb.bm 
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
set imvis=$so.lsb,$so.usb,../120523/"$source"_120523.lsb,../120523/"$source"_120523.usb
set imvis=$so.lsb,$so.usb
invert vis=$imvis  \
       map=$so.i.mp,$so.q.mp,$so.u.mp \
       stokes=i,q,u options=mfs,systemp  imsize=512 cell=0.125 \
       beam=$so.bm  robust=0.0 


foreach pol(i q u)
\rm -fr $so.$pol.cl $so.$pol.cm
clean map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cl region=$region niters=10000 cutoff=0.005
restor map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cm model=$so.$pol.cl
end

goto terminate


INVERTCO:
\rm -fr $so.co.?.mp $so.co.bm
set imvis=IKTau.win21.chi
set imline=vel,32,0,2,2
invert vis=$imvis  \
       map=$so.co.i.mp,$so.co.q.mp,$so.co.u.mp \
       stokes=i,q,u options=systemp  imsize=512 cell=0.125 \
       beam=$so.co.bm  robust=0.0 line=$imline 
goto terminate

CLEANCO:
foreach pol(i q u)
\rm -fr $so.co.$pol.cl $so.co.$pol.cm
clean map=$so.co.$pol.mp beam=$so.co.bm \
      out=$so.co.$pol.cl region=$region niters=10000 cutoff=0.12
restor map=$so.co.$pol.mp beam=$so.co.bm \
      out=$so.co.$pol.cm model=$so.co.$pol.cl
end

goto terminate

IMP:
if($source == "smc.7") set sncutI=8
if($source == "smc.11") set sncutI=8
if($source == "smc.15") set sncutI=8
if($source == "smc.7") set sigmaQ=0.006
if($source == "smc.11") set sigmaQ=0.006
if($source == "smc.15") set sigmaQ=0.006
foreach sb(lsb usb)
\rm -fr $so.$sb.poli $so.$sb.polierr $so.$sb.polm $so.$sb.polmerr $so.$sb.pa $so.$sb.paerr
impol in=$so.$sb.q.cm,$so.$sb.u.cm,$so.$sb.i.cm sigma=0.005,0.005 \
      sncut=2,$sncutI \
      poli=$so.$sb.poli,$so.$sb.polierr polm=$so.$sb.polm,$so.$sb.polmerr \
      pa=$so.$sb.pa,$so.$sb.paerr
end

\rm -fr $so.poli $so.polierr $so.polm $so.polmerr $so.pa $so.paerr
impol in=$so.q.mp,$so.u.mp,$so.i.cm sigma=$sigmaQ,$sigmaQ sncut=3,$sncutI \
      poli=$so.poli,$so.polierr polm=$so.polm,$so.polmerr \
      pa=$so.pa,$so.paerr

DISP:
if($source == "smc.7") set levs1=-20,20,30,40,50,60,70,80,90,95
if($source == "smc.11") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
if($source == "smc.15") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
set device="/cps"
set dev=/xw
set device="/xw"
if($separatesb == "y") then
foreach sb(lsb usb)
if($device == "/cps") set dev="$so.$sb.ps""/cps"
cgdisp in=$so.$sb.i.cm,$so.$sb.poli,$so.$sb.polm,$so.$sb.pa type=c,p,amp,ang \
       device=$dev region=$regdisp \
       options=full,beambl,wedge range=0,0.0,lin,1 \
       lines=1,2,6 vecfac=1.0,4,4,0.0 labtyp=arcsec,arcsec \
       range=0,0.0,lin,1  slev=p,1 \
       levs1=-20,-10,-5,-3,3,5,10,20,30,40,50,60,70,80,90,95
#if($device == "/cps") ggv "$so.$sb.ps" &
end
endif

if($device == "/cps") set dev="$so.ps""/cps"
#cgdisp in=$so.i.cm,$so.i.cm type=c,p,amp,ang \
cgdisp in=$so.i.cm,$so.poli,$so.polm,$so.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=full,beambl,wedge range=0,0.0,lin,1 \
       lines=1,2,6 vecfac=1.0,4,4,0.0 labtyp=arcsec,arcsec  \
       range=0,0.0,lin,1  slev=p,1 levs1=$levs1

# csize=1.4,0.8,0.7,0.8\
#       range=0,0.023,lin,1  
#slev=a,0.004 levs1=-100,-50,50,100,150,200,250
#if($device == "/cps") ggv "$so.ps" &




terminate:
