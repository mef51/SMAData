#! /bin/csh -f
#

set dt="101008"

set region='arcsec,box(-4,-4,4,4)'
set region='arcsec,box(-4,-4,4,4)'
set region=quart
set niters=4000
set so=IKTau_$dt

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
       stokes=i,q,u beam=$so.$sb.bm robust=2.0 
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
       beam=$so.bm  robust=0.0 


foreach pol(i q u)
\rm -fr $so.$pol.cl $so.$pol.cm
clean map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cl region=$region niters=10000 cutoff=0.003
restor map=$so.$pol.mp beam=$so.bm \
      out=$so.$pol.cm model=$so.$pol.cl
end

goto terminate





terminate:
