#! /bin/csh -f
#

set gcal=1751+096
set polcal=3c84

set dt=$2
set source=$3
set so="$source"_"$dt"

set imsel='-ant(1)'
set imsel='-time(04:11,04:30),-time(05:15,05:32),-time(08:05,08:35),-time(09:45,10:00)'
set separatesb="n"
set imsize=256
set cell=0.4
set robust=-20.0

set regdisp='arcsec,box(-10,-10,20,10)'
set region='arcsec,box(-4,-4,4,4)'
set region=@"$source"_2.region
set region=@"$source"_3.region
set region=@"$source"_4.region
set region=@"$source"_5.region
set region='arcsec,box(-8,-8,8,8)'
set region=@"$source".region
set region=@"$source"_1.region
set region=@"$source"_6.region
set region=@"$source"_7.region
set region=@"$source"_8.region
set region=@"$source"_9.region
set region=@"$source"_10.region
set region=@"$source"_11.region
set region=@"$source"_12.region
set region=quart
set regdisp='arcsec,box(-16,-16,16,16)'
set regdisp='arcsec,box(-8,-8,8,8)'
set regdisp='arcsec,box(-20,-20,20,20)'
set regdisp=quart
set regdisp='im(1)'
set niters=4000

if($#argv<1) then
echo "Incorrect usage: Needs start_pt "
echo "script.csh DISP "
goto terminate
endif

goto $1


goto terminate

GETDATA:
#
# GETDATA FROM IDL2MIRIAD
#
#\rm -fr test1_rxl.?sb test2_rxl.?sb
#smalod in=/sma/data/science/mir_data.2013/130824_02:45:01/ out=test1 rxif=-2 options=circular,flagch0 sideband=2 refant=2 
#smalod in=/sma/rtdata/science/mir_data/130824_06:55:26/ out=test2 rxif=-1 options=circular,flagch0 sideband=2 refant=2 
#goto terminate

COMBINE:
foreach sb(lsb usb)
\rm -fr combined.$sb 
uvcal vis=titan.$sb,1751+096.$sb,smc.6.$sb,neptune.$sb,uranus.$sb,3c84.$sb out=combined.$sb 
end
goto terminate

EVEC:
foreach sb(lsb usb)
puthd in=combined.$sb/mount value=4
puthd in=combined.$sb/telescop value=sma
#
# Evector value for the 400 GHz Rx is -pi/4
# But do we need uvswap?
# Ans: probably 
#
puthd in=combined.$sb/evector value=-0.785398

\rm -fr combined.$sb.chi
uvredo vis=combined.$sb options=chi out=combined.$sb.chi
end
goto terminate


FLAG:
foreach sb(lsb usb)
uvflag vis=combined.$sb.chi edge=8 flagval=f 
uvflag vis=combined.$sb.chi select='pol(xx)' flagval=f 
# Pointing  None
# Badness None
end
goto terminate

TSYS:
foreach sb(lsb usb)
# Nothing to FLAG 
\rm -fr combined_unflgd.$sb
uvaver vis=combined.$sb.chi out=combined_unflgd.$sb
\rm -fr combined_tsys.$sb
#smafix device=/xw vis=combined_unflgd.$sb out=combined_tsys.$sb options=tsyscorr
# TSYS WAS ALREADY DONE IN MIR/IDL
uvcal vis=combined_unflgd.$sb out=combined_tsys.$sb
end
goto terminate


BPCAL:
foreach sb(lsb usb)
mfcal select='so(3c84),pol(ll,rr)' refant=2 interval=30,30 vis=combined_tsys.$sb  line=ch,1536,1,4,4 
end
goto terminate

APPLYBP:
foreach sb(lsb usb)
\rm -fr combined.$sb.bp
uvcal vis=combined_tsys.$sb out=combined.$sb.bp options=nocal
end
goto terminate

FLUXSC:
#
# The flux scales were obtained by inspecting the uranus and neptune data
# compared to the expected models from the SMA Planetary Visibility Calc
#
set lsbscale=0.93
set usbscale=0.96
\rm -fr combined.lsb.flux
uvcal vis=combined.lsb.bp scale=$lsbscale out=combined.lsb.flux
\rm -fr combined.usb.flux
uvcal vis=combined.usb.bp scale=$usbscale out=combined.usb.flux
goto terminate


POLCAL:
# 3c84
foreach sb(lsb usb)
\rm -fr "$polcal""_""$dt".$sb
uvaver vis=combined.$sb.flux select='so('$polcal')' interval=5 out="$polcal""_""$dt".$sb line=ch,1,1,6144
gpcal vis=$polcal"_"$dt.$sb  refant=2 options=circular,qusolve interval=20 flux=6.64
end
goto terminate


#uvflag vis=combined.$sb select='time(02:59:44,03:20:51)' flagval=f 
#uvflag vis=combined.$sb select='time(03:57:08,04:33:09)' flagval=f 
#uvflag vis=combined.$sb select='time(05:14:10,05:35:17)' flagval=f 
#uvflag vis=combined.$sb select='time(06:37:49,07:19:35)' flagval=f 
#uvflag vis=combined.$sb select='time(08:01:57,08:35:38)' flagval=f 
#uvflag vis=combined.$sb select='time(09:35:52,09:42:08)' flagval=f 
#uvflag vis=combined.$sb select='time(10:23:32,10:40:53)' flagval=f 
#uvflag vis=combined.$sb select='time(11:13:45,11:41:18)' flagval=f 

GCAL:
foreach sb(lsb usb)
uvflag vis=combined.$sb.flux select='so('$gcal'),time(02:59:44,03:20:51)' flagval=f 
uvflag vis=combined.$sb.flux select='so('$gcal'),time(03:57:08,04:08:50)' flagval=f 
uvflag vis=combined.$sb.flux select='so('$gcal'),ant(7),time(03:20:51,04:08:50)' flagval=f 
uvflag vis=combined.$sb.flux select='so('$gcal'),time(07:11:37,07:19:24)' flagval=f 
uvflag vis=combined.$sb.flux select='so('$gcal'),time(09:35:52,09:42:08)' flagval=f 
\rm -fr "$gcal""_""$dt".$sb
uvaver vis=combined.$sb.flux select='so('$gcal')' interval=5 out="$gcal""_""$dt".$sb line=ch,1,1,6144
mfcal vis=$gcal"_"$dt.$sb select='pol(ll,rr)' refant=2 options=nopassol  interval=20
#selfcal vis=$gcal"_"$dt.$sb select='pol(ll,rr)' refant=2 options=phase  interval=20
gpbreak vis=$gcal"_"$dt.$sb break=04:08:50,05:20:00,07:00:00,08:28:51,09:42:08
end
goto terminate


CALAPPLY:
foreach sb(lsb usb)
uvflag vis=combined.$sb.flux select='so('$source'),ant(7),time(02:59:44,04:08:50)' flagval=f 
uvflag vis=combined.$sb.flux select='so('$source'),time(05:29:34,05:34:46)' flagval=f 
\rm -fr "$source""_""$dt".$sb
uvaver vis=combined.$sb.flux select='so('$source')' interval=5 out="$source""_""$dt".$sb 
gpcopy vis=$gcal"_"$dt.$sb out=$source"_"$dt.$sb options=nopol
gpcopy vis=$polcal"_"$dt.$sb out=$source"_"$dt.$sb options=nocal
end
goto terminate

INVERT:
foreach sb(lsb usb)
\rm -fr $so.$sb.?.mp $so.$sb.bm 
set imvis=$so.$sb,../120523/"$source"_120523.$sb
set imvis=SELFCAL/$so.$sb.applied
set imvis=$so.$sb
invert vis=$imvis imsize=$imsize cell=$cell options=systemp,mfs,double  \
       map=$so.$sb.i.mp,$so.$sb.q.mp,$so.$sb.u.mp \
       stokes=i,q,u beam=$so.$sb.bm robust=$robust line=ch,1,1,6144 select=$imsel
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

set imvis=SELFCAL/$so.lsb.applied,SELFCAL/$so.usb.applied
set imvis=$so.lsb,$so.usb
invert vis=$imvis  \
       map=$so.i.mp,$so.q.mp,$so.u.mp \
       stokes=i,q,u options=mfs,systemp,double  imsize=$imsize cell=$cell \
       beam=$so.bm  line=ch,1,1,6144 select=$imsel robust=$robust sup=$imsize


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
if($source == "smc.6") set sncutI=25
if($source == "smc.8") set sncutI=30
if($source == "smc.1") set sigmaQ=0.004
if($source == "smc.6") set sigmaQ=0.006
if($source == "smc.8") set sigmaQ=0.0015
foreach sb(lsb usb)
\rm -fr $so.$sb.poli $so.$sb.polierr $so.$sb.polm $so.$sb.polmerr $so.$sb.pa $so.$sb.paerr $so.$sb.unif
impol in=$so.$sb.q.mp,$so.$sb.u.mp,$so.$sb.i.cm sigma=$sigmaQ,$sigmaQ sncut=2.0,$sncutI \
      poli=$so.$sb.poli,$so.$sb.polierr polm=$so.$sb.polm,$so.$sb.polmerr \
      pa=$so.$sb.pa,$so.$sb.paerr
maths exp=$so.$sb.polm/$so.$sb.polm mask=$so.$sb.polm out=$so.$sb.unif
end

goto terminate


IMPBOTHSB:

if($source == "smc.1") set sncutI=15
if($source == "smc.6") set sncutI=40
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

DISP:
if($source == "smc.6") set levs1=-20,-10,-5,5,10,20,30,40,50,60,70,80,90,95
if($source == "smc.8") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
if($source == "smc.1") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
set device="/cps"
set device="/xw"
set dev=$device

foreach sb(lsb usb)
if($device == "/cps") set dev="$so.$sb.ps""/cps"
cgdisp in=$so.$sb.i.cm,$so.$sb.i.cm,$so.$sb.unif,$so.$sb.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=rot90,full,beambl,wedge range=0,0.0,lin,1 \
       lines=1,2,6 vecfac=0.5,8,8,0.0 labtyp=arcsec,arcsec  \
       range=0,0.0,lin,1  slev=p,1 levs1=$levs1
end
goto terminate

DISPBOTHSB:
if($source == "smc.6") set levs1=-20,-10,-5,5,10,20,30,40,50,60,70,80,90,95
if($source == "smc.8") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
if($source == "smc.1") set levs1=-20,-10,10,20,30,40,50,60,70,80,90,95
set device="/cps"
set device="/xw"
set dev=$device

if($device == "/cps") set dev="$so.ps""/cps"
cgdisp in=$so.i.cm,$so.i.cm,$so.unif,$so.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=rot90,full,beambl,wedge range=0,0.0,lin,1 \
       lines=1,2,6 vecfac=0.5,8,8,0.0 labtyp=arcsec,arcsec  \
       range=0,0.0,lin,1  slev=p,1 levs1=$levs1

# csize=1.4,0.8,0.7,0.8\
#       range=0,0.023,lin,1  
#slev=a,0.004 levs1=-100,-50,50,100,150,200,250
#if($device == "/cps") ggv "$so.ps" &




terminate:
