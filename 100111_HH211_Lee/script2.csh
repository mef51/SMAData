#! /bin/csh -f
#
set dt=$2
set fn=$3
set rx=rx0
set fname="$dt""_""$rx"
echo $fname
set inname=$2_$3

set regdisp='arcsec,box(-10,-10,20,10)'
set regdisp='arcsec,box(-16,-16,16,16)'
set regdisp='im(1)'
set regdisp=quart
set regdisp='arcsec,box(-8,-8,8,8)'
set region='arcsec,box(-4,-4,4,4)'
set region=@3c273jet.region
set region=@3c273.region
set region='arcsec,box(-4,-4,4,4)'
set region=quart
set so=0102+584_"$dt"
set so=Cas_A_N_"$dt"
set so1=../090906/Cas_A_N_090906
set so=Cas_A_W_"$dt"
set so1=../090906/Cas_A_W_090906

if($#argv<3) then
echo "Incorrect usage: Needs start_pt dt file"
echo "script.csh DISP 060407 06:18:46"
goto terminate
endif

goto $1


SMALOD:
\rm -fr $fname.lsb $fname.usb 
smalod in=/sma/data/science/mir_data/$inname out=$dt refant=4 rxif=-1 options=debug


goto terminate

IPOLFLAG:
foreach sb(lsb usb)
\rm -fr $fname.$sb.flgd $fname.$sb.flgd.tmp
uvflag vis=$fname.$sb select='-pol(ll,lr,rl,rr)' flagval=f
uvflag vis=$fname.$sb flagval=f select='time(06:30,06:31)'
uvcal vis=$fname.$sb options=unflagged out=$fname.$sb.flgd
end
goto terminate


TSYSFIX:
foreach sb(lsb usb)
\rm -fr $fname.$sb.tsys
smafix vis=$fname.$sb.flgd out=$fname.$sb.tsys device=/xw   options=tsyscorr,dosour device=/xw nxy=1,1 yrange=50,400 nxy=2,4 
end
goto terminate

FLAG:
foreach sb(lsb usb)
uvflag vis=$fname.$sb.tsys edge=8 flagval=f
uvflag vis=$fname.$sb.tsys select='ant(6),time(07:16:00,07:23:00)' flagval=f
uvflag vis=$fname.$sb.tsys select='time(08:55:00,09:05:00)' flagval=f
uvflag vis=$fname.$sb.tsys select='ant(1),time(14:16:00,14:33:00)' flagval=f
end
goto terminate

BPCAL:
foreach sb(lsb usb)
set options=averrll
smamfcal select='so(3c454.3),pol(ll,rr)' refant=4 interval=10 weight=2 smooth=5 vis=$fname.$sb.tsys  options=$options  line=ch,768,1,8,8
end
goto terminate

APPLYBP:
foreach sb(lsb usb)
\rm -fr $fname.$sb.tsys.bp
uvaver vis=$fname.$sb.tsys out=$fname.$sb.tsys.bp options=nocal
end
goto terminate


EVEC:
#foreach sb(lsb usb)
#puthd in=$fname.$sb.tsys.bp/evector value=0.7853
#puthd in=$fname.$sb.tsys.bp/mount value=4
#puthd in=$fname.$sb.tsys.bp/telescope value=sma

#\rm -fr $fname.$sb.tsys.bp.chi
#uvredo vis=$fname.$sb.tsys.bp options=chi out=$fname.$sb.tsys.bp.chi
#end
#goto terminate

SPLIT:
foreach sb(lsb usb)
#foreach so(3c454.3  callisto 0136+478 M33GMC5 mars)
foreach so(3c454.3)
echo $so
\rm -fr "$so""_""$dt".$sb
uvaver vis=$fname.$sb.tsys.bp select='so('$so')' interval=5 out="$so""_""$dt".$sb line=ch,1,1,6144
end
end


goto terminate



POLCAL:
foreach sb(lsb usb)
gpcal vis=3c454.3"_"$dt.$sb refant=3 options=circular,qusolve interval=15 flux=1 
end
goto terminate

#SFLAG:
#foreach sb(lsb usb)
#foreach so(iras4a 3c84)
#uvflag vis=$so"_"$dt.$sb flagval=f select='ant(6),time(06:50,07:25)'
#end
#end
#goto terminate


GCAL:
foreach sb(lsb usb)
selfcal vis=2202+422"_"$dt.$sb refant=1 options=amp  interval=20
selfcal vis=0102+584"_"$dt.$sb refant=1 options=amp  interval=20
gpcopy vis=2202+422"_"$dt.$sb out=0102+584"_"$dt.$sb mode=merge
gpcopy vis=0102+584"_"$dt.$sb out=Cas_A_N"_"$dt.$sb 
gpcopy vis=0102+584"_"$dt.$sb out=Cas_A_W"_"$dt.$sb 
gpcopy vis=3c454.3"_"$dt.$sb out=Cas_A_N"_"$dt.$sb  options=nocal
gpcopy vis=3c454.3"_"$dt.$sb out=Cas_A_W"_"$dt.$sb  options=nocal
end
goto terminate

INVERT:
foreach sb(lsb usb)
\rm -fr $so.$sb.?.mp $so.$sb.bm 
#invert vis=$so.$sb imsize=256 cell=0.125 options=systemp sup=0  \
#       map=$so.$sb.i.mp,$so.$sb.q.mp,$so.$sb.u.mp \
#       stokes=i,q,u beam=$so.$sb.bm 
invert vis=$so.$sb imsize=256 cell=0.125 options=systemp sup=0  \
       map=$so.$sb.i.mp \
       stokes=i beam=$so.$sb.bm 
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
invert vis=$so.lsb,$so.usb,$so1.lsb,$so1.usb  \
       map=$so.i.mp,$so.q.mp,$so.u.mp \
       stokes=i,q,u options=mfs,systemp sup=0 imsize=1024 cell=0.125 \
       beam=$so.bm 

goto terminate

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
impol in=$so.$sb.q.cm,$so.$sb.u.cm,$so.$sb.i.cm sigma=0.01,0.01 sncut=3,20 \
      poli=$so.$sb.poli,$so.$sb.polierr polm=$so.$sb.polm,$so.$sb.polmerr \
      pa=$so.$sb.pa,$so.$sb.paerr
end

\rm -fr $so.poli $so.polierr $so.polm $so.polmerr $so.pa $so.paerr
impol in=$so.q.mp,$so.u.mp,$so.i.cm sigma=0.007,0.01 sncut=3,20 \
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
