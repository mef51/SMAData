#! /bin/csh -f
#
set dt=$2
set fn=$3
set rx=rx1
set fname="$dt""_""$rx"
echo $fname
set inname=$2_$3

set regdisp='arcsec,box(-10,-10,20,10)'
set regdisp='arcsec,box(-16,-16,16,16)'
set regdisp='im(1)'
set regdisp=quart
set regdisp='arcsec,box(-8,-8,8,8)'
set region='arcsec,box(-4,-4,4,4)'
set region=@iras4a.region
set region=quart
set so=iras4a_"$dt"

if($#argv<3) then
echo "Incorrect usage: Needs start_pt dt file"
echo "script.csh DISP 060407 06:18:46"
goto terminate
endif

goto $1


SMALOD:
\rm -fr $fname.lsb $fname.usb 
smalod in=/sma/rtData/science/mir_data/$inname out=$dt rxif=1 options=circular,debug sideband=2  refant=1 


goto terminate

IPOLFLAG:
foreach sb(lsb usb)
\rm -fr $fname.$sb.flgd $fname.$sb.flgd.tmp
uvflag vis=$fname.$sb select='-pol(ll,lr,rl,rr)' flagval=f
#uvflag vis=$fname.$sb select='time(05:00,05:27)' flagval=f
uvcal vis=$fname.$sb options=unflagged out=$fname.$sb.flgd
#uvaver vis=$fname.$sb.flgd.tmp line=ch,2560,5,1,1 out=$fname.$sb.flgd
end
goto terminate


TSYSFIX:
foreach sb(lsb usb)
\rm -fr $fname.$sb.tsys
smafix vis=$fname.$sb.flgd out=$fname.$sb.tsys options=tsyscorr device=/xw  dofit=2 options=tsyscorr,dosour,tsysswap device=/xw nxy=1,1 yrange=50,600 nxy=2,4 bant=7 gant=8
end
goto terminate

FLAG:
foreach sb(lsb usb)
uvflag vis=$fname.$sb.tsys edge=4 flagval=f
#uvflag vis=$fname.$sb.tsys flagval=f select='time(01:20,04:30)'
#uvflag vis=$fname.$sb.tsys flagval=f select='time(06:17,06:32)'
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
smamfcal select='pol(ll,rr),so(3c273)' refant=1 interval=30 weight=2 vis=$fname.$sb.tsys  options=$options  line=ch,768,1,4,4
end
goto terminate

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
#foreach so(3c273 titan mars 1733-130 18089 3c454.3 neptune uranus)
foreach so(3c273 3c84 )
echo $so
\rm -fr "$so""_""$dt".$sb
uvaver vis=$fname.$sb.tsys.bp.chi select='so('$so')' interval=7 out="$so""_""$dt".$sb line=ch,1,1,3072
end

foreach so(iras4a)
echo $so
\rm -fr "$so""_""$dt".$sb "$so""_""$dt".$sb.tmp
uvaver vis=$fname.$sb.tsys.bp.chi select='so('$so')' out="$so""_""$dt".$sb.tmp line=ch,3072
uvflag vis="$so""_""$dt".$sb.tmp flagval=f line=ch,128,385,1,1
uvaver vis="$so""_""$dt".$sb.tmp  interval=7 out="$so""_""$dt".$sb line=ch,1,1,3072
end

end

goto terminate



POLCAL:
foreach sb(lsb usb)
gpcal vis=3c273"_"$dt.$sb refant=6 options=circular,qusolve interval=6 
end
goto terminate

SFLAG:
foreach sb(lsb usb)
foreach so(iras4a 3c84)
uvflag vis=$so"_"$dt.$sb flagval=f select='ant(6),time(06:50,07:25)'
end
end
goto terminate


GCAL:
foreach sb(lsb usb)
selfcal vis=3c84"_"$dt.$sb refant=1 options=amp  interval=20
gpcopy vis=3c84"_"$dt.$sb out=iras4a"_"$dt.$sb 
gpcopy vis=3c273"_"$dt.$sb out=iras4a"_"$dt.$sb options=nocal
end
goto terminate

INVERT:
foreach sb(lsb usb)
\rm -fr $so.$sb.?.mp $so.$sb.bm 
invert vis=$so.$sb imsize=512 cell=0.125 options=systemp sup=0  \
       map=$so.$sb.i.mp,$so.$sb.q.mp,$so.$sb.u.mp \
       stokes=i,q,u beam=$so.$sb.bm 
end
goto terminate


CLEAN:
foreach sb(lsb usb)
foreach pol(i q u)
\rm -fr $so.$sb.$pol.cl $so.$sb.$pol.cm
clean map=$so.$sb.$pol.mp beam=$so.$sb.bm  \
      out=$so.$sb.$pol.cl region=$region niters=8000 cutoff=0.003
restor map=$so.$sb.$pol.mp beam=$so.$sb.bm \
      out=$so.$sb.$pol.cm model=$so.$sb.$pol.cl
end
end

goto terminate

INVERTBOTHSB:
\rm -fr $so.?.mp $so.bm 
invert vis=$so.lsb,$so.usb  \
       map=$so.i.mp,$so.q.mp,$so.u.mp \
       stokes=i,q,u options=systemp sup=0 imsize=512 cell=0.125 \
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
impol in=$so.$sb.q.cm,$so.$sb.u.cm,$so.$sb.i.cm sigma=0.003,0.01 sncut=3,10 \
      poli=$so.$sb.poli,$so.$sb.polierr polm=$so.$sb.polm,$so.$sb.polmerr \
      pa=$so.$sb.pa,$so.$sb.paerr
end

\rm -fr $so.poli $so.polierr $so.polm $so.polmerr $so.pa $so.paerr
impol in=$so.q.mp,$so.u.mp,$so.i.cm sigma=0.003,0.01 sncut=3,10 \
      poli=$so.poli,$so.polierr polm=$so.polm,$so.polmerr \
      pa=$so.pa,$so.paerr

DISP:
set device="/cps"
set dev=/xw
set device="/xw"
foreach sb(lsb usb)
if($device == "/cps") set dev="$so.$sb.ps""/cps"
cgdisp in=$so.$sb.i.cm,$so.$sb.poli,$so.$sb.polm,$so.$sb.pa type=c,p,amp,ang \
       device=$dev region=$regdisp \
       options=full,beambl,wedge,rot90 range=0,0.0,lin,1 \
       lines=1,2,6 vecfac=1.0,4,4,0.0 labtyp=arcsec,arcsec \
       range=0,0.0,lin,1  slev=p,1 levs1=-20,-10,-5,-3,-2,2,3,5,10,20,30,40,50,60,70,80,90,95
#if($device == "/cps") ggv "$so.$sb.ps" &
end

if($device == "/cps") set dev="$so.ps""/cps"
#cgdisp in=$so.i.cm,$so.i.cm type=c,p,amp,ang \
cgdisp in=$so.i.cm,$so.poli,$so.polm,$so.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=full,beambl,wedge,rot90 range=0,0.0,lin,1 \
       lines=1,2,6 vecfac=1.0,4,4,0.0 labtyp=arcsec,arcsec  \
       range=0,0.0,lin,1  slev=p,1 levs1=-20,-10,-5,-2,2,5,10,20,30,40,50,60,70,80,90,95

# csize=1.4,0.8,0.7,0.8\
#       range=0,0.023,lin,1  
#slev=a,0.004 levs1=-100,-50,50,100,150,200,250
#if($device == "/cps") ggv "$so.ps" &




terminate:
