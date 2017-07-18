#! /bin/csh -f
#

set suffix=3x3
set suffix=4x4
set suffix=4x3
set suffix=3x4

set gcal=1751+096
set polcal=3c84
set polcal2=3c279

set dt=$2
set source=$3
set suffix=$4

set so=$source"_""$dt"_"$suffix"

set separatesb="n"

set regdisp='arcsec,box(-10,-10,20,10)'
set regdisp='arcsec,box(-16,-16,16,16)'
set region=quart
set region=@"$source".region
set region='arcsec,box(-4,-4,4,4)'
set regdisp='im(1)'
set regdisp='arcsec,box(-12,-10,8,10)'
set regdisp='arcsec,box(-6,-6,16,16)'
set regdisp='arcsec,box(-5,-5,5,5)'
set regdisp='arcsec,box(-12,-12,12,12)'
set regdisp='arcsec,box(-16,-16,16,16)'
set regdisp='arcsec,box(-8,-8,8,8)'
set regdisp='arcsec,box(-6,-6,6,6)'
set regdisp='arcsec,box(-4,-4,4,4)'
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
\rm -fr combined_"$suffix".$sb
uvaver vis=3c84_"$suffix".$sb,3c279_"$suffix".$sb,ni4b_"$suffix".$sb,titan_"$suffix".$sb,callisto_"$suffix".$sb out=combined_"$suffix".$sb line=ch,1536
end
goto terminate


FLAG:
foreach sb(lsb usb)
uvflag vis=combined_"$suffix".$sb select='time(03:30,03:40)' flagval=f
uvflag vis=combined_"$suffix".$sb select='time(05:30,05:38)' flagval=f
uvflag vis=combined_"$suffix".$sb select='ant(6),time(05:57,06:10)' flagval=f
uvflag vis=combined_"$suffix".$sb select='time(07:34,07:37)' flagval=f
uvflag vis=combined_"$suffix".$sb select='ant(5),time(09:48,09:49)' flagval=f
uvflag vis=combined_"$suffix".$sb select='time(10:11,10:21)' flagval=f
uvflag vis=combined_"$suffix".$sb select='ant(2),time(13:58,14:00)' flagval=f
uvflag vis=combined_"$suffix".$sb select='ant(2),time(15:59,16:01)' flagval=f
uvflag vis=combined_"$suffix".$sb select='ant(2),time(16:51,16:54)' flagval=f
uvflag vis=combined_"$suffix".$sb select='ant(3),time(15:30,17:00)' flagval=f
\rm -fr combined_"$suffix"_unflgd.$sb
uvaver vis=combined_"$suffix".$sb out=combined_"$suffix"_unflgd.$sb
end
goto terminate


BPCAL:
foreach sb(lsb usb)
#mfcal select='so(bllac),pol(ll,rr)' refant=2 interval=30,30 vis=combined_tsys.$sb  line=ch,384,1,16,16
smamfcal select='so(3c84),pol(ll,rr)' options=opolyfit,averrll polyfit=2 refant=2 interval=30,30 vis=combined_"$suffix"_unflgd.$sb  line=ch,384,1,4,4
end
goto terminate

APPLYBP:
foreach sb(lsb usb)
\rm -fr combined_"$suffix".$sb.bp
uvaver vis=combined_"$suffix"_unflgd.$sb out=combined_"$suffix".$sb.bp options=nocal
end
goto terminate


AVER:
foreach sb(lsb usb)
\rm -fr combined_"$suffix".$sb.bp.aver
uvaver vis=combined_"$suffix".$sb out=combined_"$suffix".$sb.bp.aver line=ch,1,1,1536
end
goto terminate

EVEC:
foreach sb(lsb usb)

puthd in=combined_"$suffix".$sb.bp.aver/evector value=0.7853
puthd in=combined_"$suffix".$sb.bp.aver/mount value=4
puthd in=combined_"$suffix".$sb.bp.aver/telescop value=sma

\rm -fr combined_"$suffix".$sb.chi
uvredo vis=combined_"$suffix".$sb.bp.aver options=chi out=combined_"$suffix".$sb.chi
end
goto terminate


SPLIT:
foreach sb(lsb usb)
#foreach so(3c84 uranus 1751+096 smc.6 smc.1)
foreach so(3c84 ni4b)
echo $so
\rm -fr "$so""_""$dt""_""$suffix".$sb
uvaver vis=combined_"$suffix".$sb.chi select='so('$so')' interval=5 out="$so""_""$dt"_"$suffix".$sb
end
end
goto terminate


#### mohammed
GETSTOKES:
set suffix=3x3
# set suffix=4x4
# set suffix=4x3
# set suffix=3x4
set band=lsb
set so="ni4b"

\rm -fr "$so"_"$suffix".$band.stokes
uvaver vis=combined_"$suffix".$band.bp.aver out=$so"_"$suffix.$band.stokes select="so(${so})" interval=5
\rm -fr $so"_"$suffix.$band.stokes.chi
uvredo vis=$so"_"$suffix.$band.stokes options=chi out=$so"_"$suffix.$band.stokes.chi

echo "Made:"
echo $so"_"$suffix.$band.stokes
echo $so"_"$suffix.$band.stokes.chi

goto terminate

SPEC:

# set vis=ni4b_3x3.lsb.stokes
# set vis=ni4b_3x3.lsb.stokes.chi
# set vis=ni4b_3x3.usb.stokes
# set vis=ni4b_3x3.usb.stokes.chi
# set vis=ni4b_3x4.lsb.stokes
# set vis=ni4b_3x4.lsb.stokes.chi
# set vis=ni4b_3x4.usb.stokes
# set vis=ni4b_3x4.usb.stokes.chi
# set vis=ni4b_4x3.lsb.stokes
# set vis=ni4b_4x3.lsb.stokes.chi
# set vis=ni4b_4x4.lsb.stokes
# set vis=ni4b_4x4.lsb.stokes.chi
# set vis=ni4b_4x4.usb.stokes
# set vis=ni4b_4x4.usb.stokes.chi

uvspec device=/xw options=avall,nobase axis=fre,amp nxy=1,1 interval=1000 stokes=i,v vis=$vis

goto terminate

######




PFLAG:
foreach sb(lsb usb)
uvflag vis=$polcal"_""$dt"_"$suffix".$sb select='time(06:00,06:30)' flagval=f
end
goto terminate

POLCAL:
foreach sb(lsb usb)
gpcal vis=$polcal"_""$dt"_"$suffix".$sb  refant=2 options=circular,qusolve interval=20 flux=1  select='-time(05:30,06:30)'
#gpcal vis=$polcal2"_""$dt"_"$suffix".$sb  select='-time(14:43,14:44)' refant=2 options=circular,qusolve interval=30 flux=1
end
goto terminate



GCAL:
foreach sb(lsb usb)
#mfcal vis=$gcal"_"$dt.$sb select='pol(ll,rr),-time(04:00,05:30)' refant=1 options=nopassol  interval=20
gpcopy vis=$polcal"_""$dt"_"$suffix".$sb out=$source"_""$dt"_"$suffix".$sb  options=nocal
end
goto terminate

INVERT:
foreach sb(lsb usb)
\rm -fr $so.$sb.?.mp $so.$sb.bm
set imvis=$so.$sb,../120523/"$source"_120523.$sb
set imvis=$so.$sb
invert vis=$imvis imsize=512 cell=0.125 options=systemp   \
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
set imvis=$so.lsb,$so.usb

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

INVERTALL:
#set so=$source"_""$dt"_"all"
\rm -fr $so.?.mp $so.bm
set imvis=../061223/ni4b_061223.lsb,../061223/ni4b_061223.usb
set imvis=$source"_""$dt"_3x3.lsb,$source"_""$dt"_3x3.usb,$source"_""$dt"_3x4.lsb,$source"_""$dt"_3x4.usb,$source"_""$dt"_4x3.lsb,$source"_""$dt"_4x3.usb,$source"_""$dt"_4x4.lsb,$source"_""$dt"_4x4.usb
set imvis=../061223/ni4b_061223.lsb,../061223/ni4b_061223.usb,$source"_""$dt"_3x3.lsb,$source"_""$dt"_3x3.usb,$source"_""$dt"_3x4.lsb,$source"_""$dt"_3x4.usb,$source"_""$dt"_4x3.lsb,$source"_""$dt"_4x3.usb,$source"_""$dt"_4x4.lsb,$source"_""$dt"_4x4.usb

invert vis=$imvis  \
       map=$so.i.mp,$so.q.mp,$so.u.mp \
       stokes=i,q,u options=mfs,systemp  imsize=512 cell=0.125 \
       beam=$so.bm  robust=0


foreach pol(i q u)
\rm -fr $so.$pol.cl $so.$pol.cm
clean map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cl region=$region niters=10000 cutoff=0.002
restor map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cm model=$so.$pol.cl
end

goto terminate



IMP:

#set so=$source"_""$dt"_"all"
set sncutI=20
set sncutQ=2.0
if($suffix == "all") then
set sigmaQ=0.002
else
set sigmaQ=0.003
endif

\rm -fr $so.poli $so.polierr $so.polm $so.polmerr $so.pa $so.paerr $so.unif
impol in=$so.q.mp,$so.u.mp,$so.i.cm sigma=$sigmaQ,$sigmaQ sncut=$sncutQ,$sncutI \
      poli=$so.poli,$so.polierr polm=$so.polm,$so.polmerr \
      pa=$so.pa,$so.paerr
maths exp=$so.polm/$so.polm mask=$so.polm out=$so.unif

DISP:
set levs1=-20,-10,-5,5,10,20,30,40,50,60,70,80,90,95
set dev=/xw
set device="/cps"
set device="/xw"

if($device == "/cps") set dev="$so.ps""/cps"
#cgdisp in=$so.i.cm,$so.i.cm type=c,p,amp,ang \
cgdisp in=$so.i.cm,$so.poli,$so.poli,$so.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=rot90,beambl,wedge \
       lines=4,4,6 vecfac=1.5,4,4,0.0 labtyp=arcsec,arcsec  \
       range=0,0.0,lin,-1  slev=p,1 levs1=$levs1

# csize=1.4,0.8,0.7,0.8\
#       range=0,0.023,lin,1
#slev=a,0.004 levs1=-100,-50,50,100,150,200,250
#if($device == "/cps") ggv "$so.ps" &




terminate:
