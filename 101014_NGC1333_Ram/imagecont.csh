#! /bin/csh -f
#

set dt="101014"

set region='arcsec,box(-4,-4,4,4)'
set regdisp=quart
set regdisp='arcsec,box(-10,-10,10,10)'
set regdisp='arcsec,box(-6,-7,8,7)'
set region=quart
set region='arcsec,box(-4,-4,4,4)'
set region='arcsec,box(-8,-8,8,8)'
set region=@iras2a.region
set niters=4000
set so=iras2a_$dt

if($#argv<1) then
echo "Incorrect usage: Needs start_pt "
echo "example: imagecont.csh INVERT "
goto terminate
endif

goto $1





INVERT:
foreach sb(lsb usb)
\rm -fr $so.$sb.?.mp $so.$sb.bm 
set imvis=$so.$sb
invert vis=$imvis imsize=512 cell=0.125 options=systemp sup=0  \
       map=$so.$sb.i.mp,$so.$sb.q.mp,$so.$sb.u.mp \
       stokes=i,q,u beam=$so.$sb.bm robust=0.5 
end
goto terminate


CLEAN:
foreach sb(lsb usb)
foreach pol(i q u)
\rm -fr $so.$sb.$pol.cl $so.$sb.$pol.cm
clean map=$so.$sb.$pol.mp beam=$so.$sb.bm  \
      out=$so.$sb.$pol.cl region=$region niters=$niters cutoff=0.004
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
       beam=$so.bm  robust=0.5 


foreach pol(i q u)
\rm -fr $so.$pol.cl $so.$pol.cm
clean map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cl region=$region niters=10000 cutoff=0.002
restor map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cm model=$so.$pol.cl
end

goto terminate

IMP:
#foreach sb(lsb usb)
#\rm -fr $so.$sb.poli $so.$sb.polierr $so.$sb.polm $so.$sb.polmerr $so.$sb.pa $so.$sb.paerr
#impol in=$so.$sb.q.cm,$so.$sb.u.cm,$so.$sb.i.cm sigma=0.0019,0.01 sncut=2,5 \
#      poli=$so.$sb.poli,$so.$sb.polierr polm=$so.$sb.polm,$so.$sb.polmerr \
#      pa=$so.$sb.pa,$so.$sb.paerr 
#end
#
\rm -fr $so.poli $so.polierr $so.polm $so.polmerr $so.pa $so.paerr
impol in=$so.q.mp,$so.u.mp,$so.i.cm sigma=0.0013,0.01 sncut=3,5 \
      poli=$so.poli,$so.polierr polm=$so.polm,$so.polmerr \
      pa=$so.pa,$so.paerr


DISP:
set dev=/xw
set device="/xw"
set device="/cps"
#foreach sb(lsb usb)
#if($device == "/cps") set dev="$so.$sb.ps""/cps"
#cgdisp in=$so.$sb.i.cm,$so.$sb.poli,$so.$sb.polm,$so.$sb.pa type=c,p,amp,ang \
#       device=$dev region=$regdisp \
#       options=full,beambl,wedge,rot90 range=0,0.0,lin,1 \
#       lines=1,2,6 vecfac=1.0,4,4,0.0 labtyp=arcsec,arcsec \
#       range=0,0.0,lin,1  slev=p,1 \
#       levs1=-20,-10,-5,-3,3,5,10,20,30,40,50,60,70,80,90,95
#if($device == "/cps") ggv "$so.$sb.ps" &
#end

if($device == "/cps") set dev="$so.ps""/cps"
cgdisp in=$so.i.cm,$so.poli,$so.polm,$so.pa type=c,p,amp,ang \
       device="$dev" region=$regdisp \
       options=beambl,wedge,rot90,full range=0,0.0,lin,-4 \
       lines=4,4,6 vecfac=1.3,4,4,0.0 labtyp=hms,dms  \
       range=0,0.0,lin,-1  slev=p,1 levs1=-20,-10,-5,-3,3,5,10,20,30,40,50,60,70,80,90,95

# csize=1.4,0.8,0.7,0.8\
#       range=0,0.023,lin,1  
#slev=a,0.004 levs1=-100,-50,50,100,150,200,250
#if($device == "/cps") ggv "$so.ps" &





terminate:
