#! /bin/csh -f
#


set gcal=3c84
set polcal=3c84

set dt=141028
set source=NGC7538S

set so=$source"_""$dt"
set imsel='-ant(6)'

set separatesb="n"

set imsize=512
set cell=0.25

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
set regdisp='im(1)'
set regdisp=quart
set regdisp='arcsec,box(-4,-4,4,4)'
set regdisp='arcsec,box(-3,-3,3,3)'
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


COMBINE:
foreach sb(lsb usb)
\rm -fr combined.$sb
uvcal vis=bllac-c.$sb,NGC7538S-c.$sb,Uranus-c.$sb,3c84-c.$sb  out=combined.$sb
#uvcal vis=3c84.$sb  out=combined.$sb
end
goto terminate


EVEC:
foreach sb(lsb usb)
puthd in=combined.$sb/mount value=4
puthd in=combined.$sb/telescop value=sma
puthd in=combined.$sb/evector value=0.785398

\rm -fr combined.$sb.chi temp.swap
uvredo vis=combined.$sb options=chi out=combined.$sb.chi
#uvredo vis=combined.$sb options=chi out=temp.swap
#uvswap vis=temp.swap out=combined.$sb.chi options=xyswap

end
#goto terminate

FLAG:
foreach sb(lsb usb)
#uvflag vis=combined.$sb.chi flagval=f
#uvflag vis=combined.$sb.chi flagval=f line=ch,64,641 select='ant(8)'
end
#goto terminate

FLUXSC:
# The flux scales were obtained by inspecting the 3c454.3 data
#
set lsbscale=1.00
set usbscale=1.00

\rm -fr combined.lsb.flux
uvcal vis=combined.lsb.chi scale=$lsbscale out=combined.lsb.flux
\rm -fr combined.usb.flux
uvcal vis=combined.usb.chi scale=$usbscale out=combined.usb.flux
#goto terminate


SPLIT:
foreach sb(lsb usb)
foreach sou( 3c84 bllac NGC7538S Uranus)
echo $sou
\rm -fr "$sou""_""$dt".$sb
uvcal vis=combined.$sb.flux select='so('$sou')' out="$sou""_""$dt".$sb
end
end
#goto terminate



POLCAL:
foreach sb(lsb usb)
gpcal vis=$polcal"_""$dt".$sb  refant=2 options=circular,qusolve interval=20 flux=8.0
#line=ch,1,1,1536
end
#goto terminate


GCAL:
foreach sb(lsb usb)
gpcopy vis=$polcal"_""$dt".$sb out=$source"_""$dt".$sb  options=nocal
end
goto terminate

LINES:
\rm -fr HH211.co_3-2
uvaver vis=$so.usb line=ch,64,80 out=HH211.co_3-2
\rm -fr HH211.sio_8-7
uvaver vis=$so.usb line=ch,64,1281 out=HH211.sio_8-7
\rm -fr HH211.c17o_3-2
uvaver vis=$so.lsb line=ch,64,385 out=HH211.c17o_3-2

FLAGLINES:
foreach sb(lsb usb)
if($sb == "usb") uvflag vis=$so.$sb line=ch,64,80 flagval=f
if($sb == "usb") uvflag vis=$so.$sb line=ch,64,1281 flagval=f
if($sb == "lsb") uvflag vis=$so.$sb line=ch,64,385 flagval=f
end
goto terminate

INVERTSB:
foreach sb(lsb usb)
\rm -fr $so.$sb.?.mp $so.$sb.bm
set imvis=$so.$sb
invert vis=$imvis imsize=$imsize cell=$cell options=systemp,mfs   \
       map=$so.$sb.i.mp,$so.$sb.q.mp,$so.$sb.u.mp \
       stokes=i,q,u beam=$so.$sb.bm robust=2.0 select=$imsel
#       line=ch,1,1,1536
#taper=1
end


CLEANSB:
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
       stokes=i,q,u options=mfs,systemp  imsize=$imsize cell=$cell \
       beam=$so.bm  sup=0 select=$imsel


CLEAN:
foreach pol(i q u)
\rm -fr $so.$pol.cl $so.$pol.cm
clean map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cl region=$region niters=10000 cutoff=0.002
restor map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cm model=$so.$pol.cl
end

goto terminate



IMPSB:

foreach sb(lsb usb)
set sncutI=40
set sncutQ=3.0
set sigmaQ=0.004
\rm -fr $so.$sb.poli $so.$sb.polierr $so.$sb.polm $so.$sb.polmerr $so.$sb.pa $so.$sb.paerr $so.$sb.unif
impol in=$so.$sb.q.mp,$so.$sb.u.mp,$so.$sb.i.cm sigma=$sigmaQ,$sigmaQ sncut=$sncutQ,$sncutI \
      poli=$so.$sb.poli,$so.$sb.polierr polm=$so.$sb.polm,$so.$sb.polmerr \
      pa=$so.$sb.pa,$so.$sb.paerr
maths exp=$so.$sb.polm/$so.$sb.polm mask=$so.$sb.polm out=$so.$sb.unif
end


DISPSB:
foreach sb(lsb usb)
set levs1=-20,-10,-5,-3,3,5,10,20,30,40,50,60,70,80,90,95
set dev=/xw
set device="/xw"
set device="/cps"

if($device == "/cps") set dev="$so.$sb.ps""/cps"
cgdisp in=$so.$sb.i.cm,$so.$sb.poli,$so.$sb.poli,$so.$sb.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=full,rot90,beambl,wedge,blacklab cols1=1 \
       lines=4,4,6 vecfac=1.0,4,4,0.0 labtyp=arcsec,arcsec  \
       range=0,0.0,lin,1  slev=p,1 levs1=$levs1
end

goto terminate

IMP:

#set so=$source"_""$dt"_"all"
set sncutI=80
set sncutQ=3.0
set sigmaQ=0.0025
\rm -fr $so.poli $so.polierr $so.polm $so.polmerr $so.pa $so.paerr $so.unif
impol in=$so.q.mp,$so.u.mp,$so.i.cm sigma=$sigmaQ,$sigmaQ sncut=$sncutQ,$sncutI \
      poli=$so.poli,$so.polierr polm=$so.polm,$so.polmerr \
      pa=$so.pa,$so.paerr
maths exp=$so.polm/$so.polm mask=$so.polm out=$so.unif

DISP:
set levs1=-20,-10,-5,-3,3,5,10,20,30,40,50,60,70,80,90,95
set dev=/xw
set device="/xw"
set device="/cps"

if($device == "/cps") set dev="$so.ps""/cps"
#cgdisp in=$so.i.cm,$so.i.cm type=c,p,amp,ang \
cgdisp in=$so.i.cm,$so.poli,$so.poli,$so.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=full,rot90,beambl,wedge,blacklab cols1=1 \
       lines=4,4,6 vecfac=1.0,4,4,0.0 labtyp=arcsec,arcsec  \
       range=0,0.0,lin,1  slev=p,1 levs1=$levs1

# csize=1.4,0.8,0.7,0.8\
#       range=0,0.023,lin,1
#slev=a,0.004 levs1=-100,-50,50,100,150,200,250
#if($device == "/cps") ggv "$so.ps" &


GETSTOKES:
set so="bllac"

set band=lsb
set visin=bllac.$band
set stokesout=$so.$band.stokes
set chiout=$stokesout.chi

echo 'Starting with ' $visin

\rm -fr $stokesout
uvaver vis=$visin out=$stokesout select="so(${so})" interval=5
\rm -fr $chiout
uvredo vis=$stokesout options=chi out=$chiout

echo "Made:"
echo $stokesout
echo $chiout

goto terminate

SPEC:

# set vis=bllac.lsb.stokes
# set vis=bllac.lsb.stokes.chi
set vis=bllac.usb.stokes
# set vis=bllac.usb.stokes.chi

uvspec device=/xw options=avall,nobase axis=fre,amp nxy=1,1 interval=1000 stokes=i,v vis=$vis

goto terminate

terminate:
