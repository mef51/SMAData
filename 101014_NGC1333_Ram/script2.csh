#! /bin/csh -f
#

set dt="101014"

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
set so=n1333_$dt

if($#argv<1) then
echo "Incorrect usage: Needs start_pt "
echo "script.csh DISP "
goto terminate
endif

goto $1


goto terminate

COMBINE:

# 3c454.3 callisto neptune 3c84 iras2a
foreach sb(lsb usb)
\rm -fr combined.$sb 
uvcat vis=3c454.3.$sb,neptune.$sb,callisto.$sb,3c84.$sb,iras2a.$sb out=combined.$sb
end
goto terminate


FLAG:
foreach sb(lsb usb)
uvflag vis=combined.$sb edge=8 flagval=f 
uvflag vis=combined.$sb select='time(02:37,02:49)' flagval=f
uvflag vis=combined.$sb select='time(03:03,03:18),ant(1)' flagval=f
uvflag vis=combined.$sb select='time(02:44,04:30)' flagval=f
uvflag vis=combined.$sb select='time(08:32,08:52)' flagval=f
uvflag vis=combined.$sb select='time(14:29,14:36)' flagval=f
uvflag vis=combined.$sb select='so(3c84),time(14:00:00,14:40:00),ant(1,2)' flagval=f
end
goto terminate

BPCAL:
foreach sb(lsb usb)
mfcal select='so(3c454.3),pol(ll,rr)' edge=8 refant=1 interval=1000 vis=combined.$sb  line=ch,1536,1,4,4
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
foreach so(iras2a 3c454.3 callisto neptune 3c84)
echo $so
\rm -fr "$so""_""$dt".$sb
uvaver vis=combined.$sb.chi select='so('$so')' interval=5 out="$so""_""$dt".$sb
end
end
goto terminate

GETCO:
set so="iras2a"
\rm -fr $so.win4
uvaver vis=combined.usb.bp out=$so.win4 select='so(iras2a),win(4)' interval=5
puthd in=$so.win4/evector value=0.7853
puthd in=$so.win4/mount value=4
puthd in=$so.win4/telescop value=sma

\rm -fr $so.win4.chi 
uvredo vis=$so.win4 options=chi out=$so.win4.chi

goto terminate



POLCAL:
foreach sb(lsb usb)
gpcal vis=3c454.3"_"$dt.$sb  refant=6 options=circular,qusolve interval=15 flux=1 
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
mfcal vis=3c84"_"$dt.$sb select='pol(ll,rr)' refant=2 options=nopassol  interval=30
gpbreak vis=3c84"_"$dt.$sb break=13:50 ants=2
gpbreak vis=3c84"_"$dt.$sb break=14:40
gpcopy vis=3c84"_"$dt.$sb out=iras2a"_"$dt.$sb 
gpcopy vis=3c454.3"_"$dt.$sb out=iras2a"_"$dt.$sb  options=nocal
end
gpcopy vis=3c84"_"$dt.usb out=iras2a.win4.chi options=nopass,nopol
gpcopy vis=3c454.3"_"$dt.usb out=iras2a.win4.chi  options=nocal,nopass
goto terminate

INVERT:
foreach sb(lsb usb)
\rm -fr $so.$sb.?.mp $so.$sb.bm 
set imvis=$so.$sb
#set imvis=$so.$sb,Images/i1629a.$sb.applied
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
set imvis=$so.lsb,$so.usb
#set imvis=Images/i1629a.lsb.applied,Images/i1629a.usb.applied
#set imvis=$so.lsb,Images/i1629a.lsb.applied,$so.usb,Images/i1629a.usb.applied
invert vis=$imvis  \
       map=$so.i.mp,$so.q.mp,$so.u.mp \
       stokes=i,q,u options=mfs,systemp  imsize=512 cell=0.125 \
       beam=$so.bm  robust=0.0 


foreach pol(i q u)
\rm -fr $so.$pol.cl $so.$pol.cm
clean map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cl region=$region niters=10000 cutoff=0.003
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
#foreach sb(lsb usb)
#\rm -fr $so.$sb.poli $so.$sb.polierr $so.$sb.polm $so.$sb.polmerr $so.$sb.pa $so.$sb.paerr
#impol in=$so.$sb.q.cm,$so.$sb.u.cm,$so.$sb.i.cm sigma=0.01,0.01 sncut=3,20 \
#      poli=$so.$sb.poli,$so.$sb.polierr polm=$so.$sb.polm,$so.$sb.polmerr \
#      pa=$so.$sb.pa,$so.$sb.paerr
#end

\rm -fr $so.poli $so.polierr $so.polm $so.polmerr $so.pa $so.paerr
impol in=$so.q.mp,$so.u.mp,$so.i.cm sigma=0.002,0.01 sncut=3,5 \
      poli=$so.poli,$so.polierr polm=$so.polm,$so.polmerr \
      pa=$so.pa,$so.paerr

DISP:
set device="/cps"
set dev=/xw
set device="/xw"
#foreach sb(lsb usb)
#if($device == "/cps") set dev="$so.$sb.ps""/cps"
#cgdisp in=$so.$sb.i.cm,$so.$sb.poli,$so.$sb.polm,$so.$sb.pa type=c,p,amp,ang \
#       device=$dev region=$regdisp \
#       options=full,beambl,wedge,rot90 range=0,0.0,lin,1 \
#       lines=1,2,6 vecfac=1.0,4,4,0.0 labtyp=arcsec,arcsec \
#       range=0,0.0,lin,1  slev=p,1 levs1=-20,-10,-5,-3,-2,2,3,5,10,20,30,40,50,60,70,80,90,95
##if($device == "/cps") ggv "$so.$sb.ps" &
#end

if($device == "/cps") set dev="$so.ps""/cps"
#cgdisp in=$so.i.cm,$so.i.cm type=c,p,amp,ang \
cgdisp in=$so.i.cm,$so.poli,$so.poli,$so.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=full,beambl,wedge,rot90 range=0,0.0,lin,1 \
       lines=1,2,6 vecfac=1.0,4,4,0.0 labtyp=arcsec,arcsec  \
       range=0,0.0,lin,1  slev=p,1 levs1=-20,-10,10,20,30,40,50,60,70,80,90,95

# csize=1.4,0.8,0.7,0.8\
#       range=0,0.023,lin,1  
#slev=a,0.004 levs1=-100,-50,50,100,150,200,250
#if($device == "/cps") ggv "$so.ps" &




terminate:
