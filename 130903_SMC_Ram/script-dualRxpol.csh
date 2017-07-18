#! /bin/csh -f
#

set suffix=4x4
set suffix=4x3
set suffix=3x4
set suffix=3x3

set gcal=1733-130
set gcal2=1911-201
set polcal=3c454.3

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
set region='arcsec,box(-4,-4,4,4)'
set region=@"$source".region
set regdisp='im(1)'
set regdisp='arcsec,box(-12,-10,8,10)'
set regdisp='arcsec,box(-6,-6,16,16)'
set regdisp='arcsec,box(-5,-5,5,5)'
set regdisp='arcsec,box(-12,-12,12,12)'
set regdisp='arcsec,box(-16,-16,16,16)'
set regdisp='arcsec,box(-8,-8,8,8)'
set regdisp='arcsec,box(-6,-6,6,6)'
set regdisp='arcsec,box(-4,-4,4,4)'
set regdisp='im(1)'
set regdisp=quart
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
if($suffix == "3x3") then
\rm -fr test1_rxl.?sb
smalod in=/sma/rtdata/science/mir_data/130903_03:46:51/ out=test1 rxif=-1 option
s=circular sideband=2
else
\rm -fr test1_rxh.?sb
smalod in=/sma/rtdata/science/mir_data/130903_03:46:51/ out=test1 rxif=-2 option
s=circular sideband=2
endif
goto terminate


COMBINE:
foreach sb(lsb usb)
\rm -fr combined_"$suffix".$sb 
if($suffix == "3x3") then
uvaver vis=test1_rxl.$sb  out=combined_"$suffix".$sb
else
uvaver vis=test1_rxh.$sb  out=combined_"$suffix".$sb
endif
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
goto terminate

EVEC:
foreach sb(lsb usb)
puthd in=combined_"$suffix".$sb/mount value=4
puthd in=combined_"$suffix".$sb/telescop value=sma

if($suffix == "3x3") set value=0.785398
if($suffix == "4x4") set value=-0.785398
puthd in=combined_"$suffix".$sb/evector value=$value


\rm -fr combined_"$suffix".$sb.chi
uvredo vis=combined_"$suffix".$sb options=chi out=combined_"$suffix".$sb.chi

end
goto terminate

TSYSFLAG:
foreach sb(lsb usb)
#uvflag vis=combined_"$suffix".$sb.chi edge=4 flagval=f 
#uvflag vis=combined_"$suffix".$sb.chi select='time(03:37,04:00)' flagval=f 
#uvflag vis=combined_"$suffix".$sb.chi select='time(04:06,06:15),ant(7)' flagval=f 
#uvflag vis=combined_"$suffix".$sb.chi select='time(04:10,04:27)' flagval=f 
#uvflag vis=combined_"$suffix".$sb.chi select='time(06:07,06:21)' flagval=f 
#uvflag vis=combined_"$suffix".$sb.chi select='time(08:33,08:37)' flagval=f 
#uvflag vis=combined_"$suffix".$sb.chi select='time(08:43,08:49)' flagval=f 
#uvflag vis=combined_"$suffix".$sb.chi select='time(11:23,11:30)' flagval=f 

\rm -fr combined_"$suffix"_unflgd.$sb
uvaver vis=combined_"$suffix".$sb.chi out=combined_"$suffix"_unflgd.$sb
end
goto terminate

TSYS:
foreach sb(lsb usb)
\rm -fr combined_"$suffix"_tsys.$sb
smafix vis=combined_"$suffix"_unflgd.$sb out=combined_"$suffix"_tsys.$sb device=/xw bant=2,4,5,7 gant=6 options=tsyscorr
end
goto terminate

BPFLAG:
foreach sb(lsb usb)
uvflag vis=combined_"$suffix"_tsys.$sb edge=4 flagval=f 


if($suffix == "3x3") then
# Do nothing
else
uvflag vis=combined_"$suffix"_tsys.$sb select='so(1751+096),ant(4),time(05:10,07:30)' flagval=f 
uvflag vis=combined_"$suffix"_tsys.$sb select='ant(7)(8)' line=ch,1,1600,1,1 flagval=f 
endif

end
goto terminate

BPCAL:
foreach sb(lsb usb)
#mfcal select='so(3c454.3),pol(ll,rr)' refant=2 interval=30,30 vis=combined_"$suffix"_unflgd.$sb  line=ch,768,1,4,4
#gpcopy vis=../130906/combined_"$suffix"_unflgd.$sb out=combined_"$suffix"_tsys.$sb options=nocal
selfcal select='so(1751+096),pol(ll,rr)' options=phase  refant=2 vis=combined_"$suffix"_tsys.$sb  interval=5
#line=ch,192,1,16,16

if($suffix == "3x3") then
gpbreak vis=combined_"$suffix"_tsys.$sb break=05:20
else
gpbreak vis=combined_"$suffix"_tsys.$sb break=05:20,06:00,06:40
endif

end
goto terminate

APPLYBP:
foreach sb(lsb usb)
\rm -fr combined_"$suffix".$sb.bp
uvaver vis=combined_"$suffix"_tsys.$sb out=combined_"$suffix".$sb.bp options=nocal
end
goto terminate

FLUXSC:
#
# The flux scales were obtained by inspecting the 3c454.3 data
#
if($suffix == "3x3") then
set lsbscale=1.11
set usbscale=1.25
else
set lsbscale=1.35
set usbscale=1.48
endif

\rm -fr combined_"$suffix".lsb.flux
uvcal vis=combined_"$suffix".lsb.bp scale=$lsbscale out=combined_"$suffix".lsb.flux
\rm -fr combined_"$suffix".usb.flux
uvcal vis=combined_"$suffix".usb.bp scale=$usbscale out=combined_"$suffix".usb.flux
goto terminate


#SPLIT:
#foreach sb(lsb usb)
#foreach so(1733-130 1911-201 bllac GGD27 3c454.3 neptune Neptune)
#echo $so
#\rm -fr "$so""_""$dt""_""$suffix".$sb
#uvaver vis=combined_"$suffix".$sb.bp.aver select='so('$so')' interval=5 out="$so""_""$dt"_"$suffix".$sb
#end
#end
#goto terminate

POLCAL:
foreach sb(lsb usb)
\rm -fr "$polcal""_""$dt".$sb
uvaver vis=combined_"$suffix".$sb.flux select='so('$polcal')' interval=5 out="$polcal""_""$dt"_"$suffix".$sb line=ch,1,1,3072
gpcal vis=$polcal"_""$dt"_"$suffix".$sb  refant=2 options=circular,qusolve interval=20 flux=6.1  
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
set imvis=$so.$sb,../120523/"$source"_120523.$sb
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
set imvis=$source"_""$dt"_3x3.lsb,$source"_""$dt"_3x3.usb,$source"_""$dt"_4x4.lsb,$source"_""$dt"_4x4.usb
set imvis=$source"_""$dt"_4x4.lsb,$source"_""$dt"_4x4.usb
set imvis=$source"_""$dt"_3x3.lsb,$source"_""$dt"_3x3.usb
if($suffix == "all") then
set imvis=$source"_""$dt"_3x3.lsb,$source"_""$dt"_3x3.usb,$source"_""$dt"_4x4.lsb,$source"_""$dt"_4x4.usb
else
set imvis=$source"_""$dt"_"$suffix".lsb,$source"_""$dt"_"$suffix".usb
endif


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
set sncutI=20
set sncutQ=2.0
set sigmaQ=0.002
set sigmaQ=0.005
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
