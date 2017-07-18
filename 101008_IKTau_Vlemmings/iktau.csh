#! /bin/csh -f
#

set dt="101008"

set regdisp='arcsec,box(-10,-10,20,10)'
set regdisp='arcsec,box(-16,-16,16,16)'
set regdisp=quart
set regdisp='arcsec,box(-8,-8,8,8)'
set region='arcsec,box(-4,-4,4,4)'
set region='arcsec,box(-4,-4,4,4)'
set region=quart
set niters=4000
#set gain=0.3
#set so=1733-130_$dt
set so=IKTau_$dt

if($#argv<1) then
echo "Incorrect usage: Needs start_pt "
echo "iktau.csh DISP "
goto terminate
endif

goto $1


goto terminate


FLAG:
foreach sb(lsb usb)
#uvflag vis=combined.$sb edge=8 flagval=f
uvflag vis=combined.$sb select='time(05:08,05:19)' flagval=f
uvflag vis=combined.$sb select='time(06:00,06:15)' flagval=f
uvflag vis=combined.$sb select='time(10:49,10:51)' flagval=f
uvflag vis=combined.$sb select='time(11:07,11:12)' flagval=f
end
goto terminate

BPCAL:
foreach sb(lsb usb)
mfcal select='so(3c454.3),pol(ll,rr)' edge=8 refant=1 interval=10 vis=combined.$sb  line=ch,1536,1,4,4
end
goto terminate

APPLYBP:
foreach sb(lsb usb)
\rm -fr combined.$sb.bp
uvaver vis=combined.$sb out=combined.$sb.bp options=nocal
end
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

EVEC:
foreach sb(lsb usb)
puthd in=combined.$sb.bp.aver/evector value=0.7853
puthd in=combined.$sb.bp.aver/mount value=4
puthd in=combined.$sb.bp.aver/telescop value=sma

\rm -fr combined.$sb.chi
uvredo vis=combined.$sb.bp.aver options=chi out=combined.$sb.chi
end
goto terminate


SPLIT:
foreach sb(lsb usb)
#foreach so(3c454.3  callisto 0136+478 M33GMC5 mars)
foreach so(IKTau 3c454.3 callisto neptune 0423-013)
echo $so
\rm -fr "$so""_""$dt".$sb
uvaver vis=combined.$sb.chi select='so('$so')' interval=5 out="$so""_""$dt".$sb
end
end
goto terminate

GETCO:
set so="IKTau"
\rm -fr $so.win21
uvaver vis=combined.usb.bp out=$so.win21 select='so(IKTau),win(21)' interval=5
puthd in=$so.win21/evector value=0.7853
puthd in=$so.win21/mount value=4
puthd in=$so.win21/telescop value=sma

\rm -fr $so.win21.chi
uvredo vis=$so.win21 options=chi out=$so.win21.chi

goto terminate

GETSTOKES:
set so="IKTau"

set band=usb
set visin=combined.$band
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


POLCAL:
foreach sb(lsb usb)
gpcal vis=3c454.3"_"$dt.$sb refant=1 options=circular,qusolve interval=15 flux=1
end
goto terminate

SFLAG:
foreach sb(lsb usb)
foreach so(1733-130)
uvflag vis=$so"_"$dt.$sb flagval=f select='time(06:02,06:18)'
end
foreach so(i16293)
uvflag vis=$so"_"$dt.$sb flagval=f select='ant(2),time(00:02,02:00)'
end
end
goto terminate


GCAL:
foreach sb(lsb usb)
mfcal vis=0423-013"_"$dt.$sb refant=1 options=nopassol  interval=20
gpbreak vis=0423-013"_"$dt.$sb break=11:00,15:00,16:45
gpcopy vis=0423-013"_"$dt.$sb out=IKTau"_"$dt.$sb
gpcopy vis=3c454.3"_"$dt.$sb out=IKTau"_"$dt.$sb  options=nocal
end
gpcopy vis=0423-013"_"$dt.usb out=IKTau.win21.chi options=nopass,nopol
gpcopy vis=3c454.3"_"$dt.usb out=IKTau.win21.chi  options=nocal,nopass
goto terminate

terminate:
