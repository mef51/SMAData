#! /bin/csh -f
#


set gcal=1751+096
set gcal2=1911-201
set polcal=3c84

set dt=$2
set source=$3
set suffix=$4

set so=$source"_""$dt"_"$suffix"
set imsel='-ant(1)'

set separatesb="n"

set imsize=256
set cell=0.5

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
set regdisp=quart
set regdisp='im(1)'
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


COMBINE:
foreach sb(lsb usb)
\rm -fr combined_"$suffix".$sb 
uvaver vis=3C84_"$suffix"_$sb,0102_"$suffix"_$sb,1751_"$suffix"_$sb,1927_"$suffix"_$sb,B335_"$suffix"_$sb,CB230_"$suffix"_$sb,L1157_"$suffix"_$sb,L14482A_"$suffix"_$sb,L1448N_"$suffix"_$sb,titan_"$suffix"_$sb out=combined_"$suffix".$sb 
end
goto terminate

SWAP:
if($suffix == "4x4") then
foreach sb(lsb usb)
\rm -fr combined_"$suffix".$sb.tmp
uvcal vis=combined_"$suffix".$sb out=combined_"$suffix".$sb.tmp
\rm -fr combined_"$suffix".$sb
uvswap2 vis=combined_"$suffix".$sb.tmp out=combined_"$suffix".$sb options=xyswap
end

endif 
#goto terminate

EVEC:
foreach sb(lsb usb)

if($suffix == "3x3") then
puthd in=combined_"$suffix".$sb/evector value=0.7853
else
puthd in=combined_"$suffix".$sb/evector value=-0.7853
endif

puthd in=combined_"$suffix".$sb/mount value=4
puthd in=combined_"$suffix".$sb/telescop value=sma

\rm -fr combined_"$suffix".$sb.chi
uvredo vis=combined_"$suffix".$sb options=chi out=combined_"$suffix".$sb.chi

\rm -fr combined_"$suffix"_swapevec.$sb
uvaver vis=combined_"$suffix".$sb.chi out=combined_"$suffix"_swapevec.$sb
end
#goto terminate

FLAG:
foreach sb(lsb usb)
uvflag vis=combined_"$suffix".$sb.chi edge=3 flagval=f 
#uvflag vis=combined_"$suffix".$sb.chi select='ant(2)' flagval=f 
uvflag vis=combined_"$suffix".$sb.chi select='ant(2),time(13:45,14:15)' flagval=f 
uvflag vis=combined_"$suffix".$sb.chi select='time(16:20,20:00)' flagval=f 
uvflag vis=combined_"$suffix".$sb.chi select='ant(4)(2,5,6),time(12:15,13:30)' flagval=f 
uvflag vis=combined_"$suffix".$sb.chi select='ant(5)(6),time(12:15,13:30)' flagval=f 
uvflag vis=combined_"$suffix".$sb.chi select='time(13:55,14:00)' flagval=f 
uvflag vis=combined_"$suffix".$sb.chi select='time(14:35,14:40)' flagval=f 

\rm -fr combined_"$suffix"_unflgd.$sb
uvaver vis=combined_"$suffix".$sb.chi out=combined_"$suffix"_unflgd.$sb select='so(3c84)'

end
#goto terminate


BPCAL:
foreach sb(lsb usb)
smamfcal select='so(3c84),pol(ll,rr)' options=opolyfit,averrll polyfit=2 refant=4 interval=30,30 vis=combined_"$suffix"_unflgd.$sb  line=ch,768,1,2,2
end
#goto terminate

APPLYBP:
foreach sb(lsb usb)
\rm -fr combined_"$suffix".$sb.bp
uvaver vis=combined_"$suffix"_unflgd.$sb out=combined_"$suffix".$sb.bp options=nocal
end
#goto terminate


AVER:
foreach sb(lsb usb)
\rm -fr combined_"$suffix".$sb.bp.aver
uvaver vis=combined_"$suffix".$sb.bp out=combined_"$suffix".$sb.bp.aver line=ch,1,1,1536
end
#goto terminate




SPLIT:
foreach sb(lsb usb)
foreach so(3c84)
echo $so
\rm -fr "$so""_""$dt""_""$suffix".$sb
uvaver vis=combined_"$suffix".$sb.bp.aver select='so('$so')' interval=5 out="$so""_""$dt"_"$suffix".$sb
end
end
#goto terminate

POLCAL:
foreach sb(lsb usb)
gpcal vis=$polcal"_""$dt"_"$suffix".$sb  refant=4 options=circular,qusolve interval=10 flux=6.5
end
goto terminate



GCAL:
foreach sb(lsb usb)
mfcal vis=$gcal"_"$dt"_"$suffix.$sb select='pol(ll,rr)' refant=2 options=nopassol  interval=20
mfcal vis=$gcal2"_"$dt"_"$suffix.$sb select='pol(ll,rr)' refant=2 options=nopassol  interval=20
gpcopy vis=$gcal"_"$dt"_"$suffix.$sb out=$gcal2"_"$dt"_"$suffix.$sb mode=merge
gpcopy vis=$gcal2"_"$dt"_"$suffix.$sb out=$source"_""$dt"_"$suffix".$sb options=nopol
gpcopy vis=$polcal"_""$dt"_"$suffix".$sb out=$source"_""$dt"_"$suffix".$sb  options=nocal
end
goto terminate

INVERT:
foreach sb(lsb usb)
\rm -fr $so.$sb.?.mp $so.$sb.bm 
set imvis=$so.$sb
invert vis=$imvis imsize=$imsize cell=$cell options=systemp   \
       map=$so.$sb.i.mp,$so.$sb.q.mp,$so.$sb.u.mp \
       stokes=i,q,u beam=$so.$sb.bm robust=2.0 select=$imsel
#taper=1
end
goto terminate


CLEAN:
foreach sb(lsb usb)
foreach pol(i q u)
if($source == "3c84") set cutoff=0.012
\rm -fr $so.$sb.$pol.cl $so.$sb.$pol.cm
clean map=$so.$sb.$pol.mp beam=$so.$sb.bm  \
      out=$so.$sb.$pol.cl region=$region niters=$niters cutoff=$cutoff
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
       stokes=i,q,u options=mfs,systemp  imsize=$imsize cell=$cell \
       beam=$so.bm  sup=0 select=$imsel


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
set imvis=$source"_""$dt"_4x4.lsb,$source"_""$dt"_4x4.usb
set imvis=$source"_""$dt"_3x3.lsb,$source"_""$dt"_3x3.usb
set imvis=$source"_""$dt"_3x3.lsb,$source"_""$dt"_3x3.usb,$source"_""$dt"_4x4.lsb,$source"_""$dt"_4x4.usb


invert vis=$imvis  \
       map=$so.i.mp,$so.q.mp,$so.u.mp \
       stokes=i,q,u options=mfs,systemp  imsize=$imsize cell=$cell \
       beam=$so.bm  robust=0 select=$imsel


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
set sncutI=400
set sncutQ=3.0
set sigmaQ=0.002
set sigmaQ=0.008
if($source == "3c84") set sigmaQ=0.012
foreach sb(lsb usb)
\rm -fr $so.$sb.poli $so.$sb.polierr $so.$sb.polm $so.$sb.polmerr $so.$sb.pa $so.$sb.paerr $so.$sb.unif
impol in=$so.$sb.q.mp,$so.$sb.u.mp,$so.$sb.i.cm sigma=$sigmaQ,$sigmaQ sncut=$sncutQ,$sncutI \
      poli=$so.$sb.poli,$so.$sb.polierr polm=$so.$sb.polm,$so.$sb.polmerr \
      pa=$so.$sb.pa,$so.$sb.paerr
#maths exp='(<'$so.$sb.polm'>'/'<'$so.$sb.polm'>'')' mask=$so.$sb.polm out=$so.$sb.unif
end
goto terminate


IMPBOTHSB:

#set so=$source"_""$dt"_"all"
set sncutI=20
set sncutQ=2.0
set sigmaQ=0.002
set sigmaQ=0.008
\rm -fr $so.poli $so.polierr $so.polm $so.polmerr $so.pa $so.paerr $so.unif
impol in=$so.q.mp,$so.u.mp,$so.i.cm sigma=$sigmaQ,$sigmaQ sncut=$sncutQ,$sncutI \
      poli=$so.poli,$so.polierr polm=$so.polm,$so.polmerr \
      pa=$so.pa,$so.paerr
maths exp=$so.polm/$so.polm mask=$so.polm out=$so.unif

DISP:
set levs1=-20,-10,-5,5,10,20,30,40,50,60,70,80,90,95
set dev=/xw
set device="/xw"
set device="/cps"

foreach sb(lsb usb)
if($device == "/cps") set dev="$so.$sb.ps""/cps"
#cgdisp in=$so.$sb.i.cm,$so.$sb.i.cm type=c,p,amp,ang \
cgdisp in=$so.$sb.i.cm,$so.$sb.poli,$so.$sb.polm,$so.$sb.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=full,rot90,beambl,wedge \
       lines=4,4,6 vecfac=1.5,8,8,0.0 labtyp=arcsec,arcsec  \
       range=0,0.0,lin,-1  slev=p,1 levs1=$levs1

# csize=1.4,0.8,0.7,0.8\
#       range=0,0.023,lin,1  
#slev=a,0.004 levs1=-100,-50,50,100,150,200,250
#if($device == "/cps") ggv "$so.ps" &
end
goto terminate

DISPBOTHSB:
set levs1=-20,-10,-5,5,10,20,30,40,50,60,70,80,90,95
set dev=/xw
set device="/xw"
set device="/cps"

if($device == "/cps") set dev="$so.ps""/cps"
#cgdisp in=$so.i.cm,$so.i.cm type=c,p,amp,ang \
cgdisp in=$so.i.cm,$so.poli,$so.poli,$so.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=full,rot90,beambl,wedge \
       lines=4,4,6 vecfac=1.5,8,8,0.0 labtyp=arcsec,arcsec  \
       range=0,0.0,lin,-1  slev=p,1 levs1=$levs1

# csize=1.4,0.8,0.7,0.8\
#       range=0,0.023,lin,1  
#slev=a,0.004 levs1=-100,-50,50,100,150,200,250
#if($device == "/cps") ggv "$so.ps" &




terminate:
