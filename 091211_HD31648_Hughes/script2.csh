#! /bin/csh -f
#

set gcal1=0956+252
set gcal2=1337-129
set gcal3=1911-201
set gcal4=1751+096

set polcal=3c279
set polcal2=bllac

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
smalod in=091211_02:50:57/ out=test1 rxif=-1 options=circular sideband=2 refant=2 
goto terminate

COMBINE:
foreach sb(lsb usb)
\rm -fr combined.$sb 
uvaver vis=test1_rxl.$sb out=combined.$sb line=ch,6144,2,1,1
end
goto terminate


FLAG:
foreach sb(lsb usb)
uvflag vis=combined.$sb select='-pol(ll,lr,rl,rr)' flagval=f 
uvflag vis=combined.$sb select='time(06:15:00,06:28:00)' flagval=f 
uvflag vis=combined.$sb select='time(09:08:00,09:17:00)' flagval=f 
uvflag vis=combined.$sb select='ant(3),time(10:10:00,10:16:00)' flagval=f 
uvflag vis=combined.$sb select='time(14:11:00,14:43:00)' flagval=f 
uvflag vis=combined.$sb select='time(16:04:00,16:24:00)' flagval=f 

#uvflag vis=combined.$sb select='win(1,2,3,4,5,6,7,8)' edge=4 flagval=f 
#uvflag vis=combined.$sb select='win(9)' edge=8 flagval=f 
#uvflag vis=combined.$sb select='win(10,11)' edge=2 flagval=f 
#uvflag vis=combined.$sb select='win(12,13,14,15,16,17,18,19,20,21,22,23,24)' edge=4 flagval=f 
#uvflag vis=combined.$sb select='win(25,26)' edge=2 flagval=f 
#uvflag vis=combined.$sb select='win(27)' edge=8 flagval=f 
#uvflag vis=combined.$sb select='win(28,29,20,31,32,33,34,35,36,37,38,39,40,41,42)' edge=4 flagval=f 
#uvflag vis=combined.$sb select='win(43,44)' edge=2 flagval=f 
#uvflag vis=combined.$sb select='win(45)' edge=4 flagval=f 
#uvflag vis=combined.$sb select='win(46)' edge=8 flagval=f 
#uvflag vis=combined.$sb select='win(47,48)' edge=2 flagval=f 

uvflag vis=combined.$sb edge=8 flagval=f 
#uvflag vis=combined.$sb select='win(9)' edge=8 flagval=f 
#uvflag vis=combined.$sb select='win(25)' edge=8 flagval=f 
#uvflag vis=combined.$sb select='win(46)' edge=8 flagval=f 

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
mfcal select='so(3c279),pol(ll,rr)' refant=2 interval=30,30 vis=combined_tsys.$sb  
#smamfcal select='so(3c279),pol(ll,rr)' options=opolyfit polyfit=3 refant=2 interval=30,30 vis=combined_tsys.$sb  
#smamfcal select='so(3c279),pol(ll,rr)'  refant=2 interval=30,30 vis=combined_tsys.$sb  
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
uvaver vis=combined.$sb.bp out=combined.$sb.bp.aver 
##line=ch,1,1,6144
end
goto terminate
'
EVEC:
foreach sb(lsb usb)
puthd in=combined.$sb.bp.aver/evector value=0.7853
puthd in=combined.$sb.bp.aver/mount value=4
#puthd in=combined.$sb.bp.aver/telescope value=sma

\rm -fr combined.$sb.chi
uvredo vis=combined.$sb.bp.aver options=chi out=combined.$sb.chi
end
goto terminate

SPLIT:
foreach sb(lsb usb)
#foreach so(3c279 bllac titan 1751+096 smc.6 smc.8 smc.1)
foreach so(rleo whya rhya  vxsgr oh2604  xoph raql)
echo $so
\rm -fr "$so""_""$dt".$sb
uvaver vis=combined.$sb.chi select='so('$so')' interval=5 out="$so""_""$dt".$sb
end

foreach so(0956+252 3c279 1337-129 1911-201 1751+096 neptune bllac uranus)
echo $so
\rm -fr "$so""_""$dt".$sb
uvaver vis=combined.$sb.chi select='so('$so')' interval=5 out="$so""_""$dt".$sb line=ch,1,1,6144
end
end
goto terminate




POLCAL:
set refant=8
set select='-ant(1)'
foreach sb(lsb usb)
gpcal vis=$polcal"_"$dt.$sb  select=$select  refant=$refant options=circular,qusolve interval=20 flux=1 
#gpcal vis=$polcal2"_"$dt.$sb select=$select  refant=$refant options=circular,qusolve interval=20 flux=1 
mfcal vis=$polcal2"_"$dt.$sb select=$select   refant=$refant select='pol(ll,rr)' interval=5  options=nopassol
gpcopy vis=$polcal"_"$dt.$sb out=$polcal2"_"$dt.$sb  options=nocal
gpcal vis=$polcal2"_"$dt.$sb select=$select  refant=$refant options=circular,nopol,qusolve interval=20 flux=1 
end
goto terminate



GCAL:
foreach sb(lsb usb)

foreach gcal($gcal1 $gcal2 $gcal3 $gcal4)
mfcal vis=$gcal"_"$dt.$sb select='pol(ll,rr)' refant=2 options=nopassol  interval=20
end

gpcopy vis=$gcal1"_"$dt.$sb out=$gcal2"_"$dt.$sb mode=merge
gpcopy vis=$gcal2"_"$dt.$sb out=$gcal3"_"$dt.$sb mode=merge
gpcopy vis=$gcal3"_"$dt.$sb out=$gcal4"_"$dt.$sb mode=merge

foreach so(rleo whya rhya vxsgr oh2604 xoph raql)
gpcopy vis=$gcal4"_"$dt.$sb out=$so"_"$dt.$sb options=nopol
gpcopy vis=$polcal2"_"$dt.$sb out=$so"_"$dt.$sb  options=nocal
end

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
