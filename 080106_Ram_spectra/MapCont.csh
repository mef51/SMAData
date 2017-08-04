#! /bin/csh -f
#
#
set so=orkl_080106
set dd=UVDATA
set rms=0.05
set rng=0,0.7
switch($1)
 case USB:
# RMS I, Q, U, V = 0.13
  set vis=UVDATA/$so.cnt.usb
  set lab=cont.usb
  set reg='arcsec,box(-19,-19,19,19)'; set rms=0.009
 breaksw
endsw

set src=MAPS/$so.$lab
set tall=`echo $rms | awk '{print $1 * 3.0}'`
goto $2

MAP:
\rm -fr $src.*
invert vis=$vis \
    beam=$src.bm map=$src.i.mp,$src.q.mp,$src.u.mp,$src.v.mp \
    imsize=128 cell=0.3 options=systemp,double,mfs stokes=i,q,u,v sup=0
foreach stk(i q u v)
clean  map=$src.$stk.mp beam=$src.bm out=$src.$stk.cc \
       niters=1000 cutoff=$tall
restor map=$src.$stk.mp beam=$src.bm model=$src.$stk.cc out=$src.$stk.cm
end

imstat in=$src.i.cm region='box(6,6,50,122)'
echo "Press Return to continue"; set nn=$<
foreach stk(q u v)
 cgdisp type=cont,pix labtyp=arcsec,arcsec \
       device=/xs options=full,beambl,3val csize=0,1,0,0 \
       in=$src.$stk.cm,$src.i.cm range=$rng,lin,1 cols1=2 \
       slev=a,$rms levs1=-20,-16,-13,-10,-7,-5,-3,3,5,7,10,13,16,20 \
       region=$reg
 imstat in=$src.$stk.cm region='box(6,6,50,122)'
 echo "Press Return to continue"; set nn=$<
end
foreach stk(i q u v)
 imstat in=$src.$stk.cm
end
goto end
DISP:
\rm -rf $src.v-i.perc
maths exp='100*<'$src.v.cm'>/<'$src.i.cm'>' mask='<'$src.i.cm'>.gt.0.4' \
      out=$src.v-i.perc
cgdisp type=cont,pix labtyp=arcsec,arcsec \
       device=/xs options=full,beambl \
       in=$src.v-i.perc,$src.i.cm cols1=8 \
       slev=a,1,p,1 levs1=-8,-6,-4,-2,2,4,6,8 \
       region='arcsec,box(-5.5,-6,6.5,6)'
cgdisp type=cont,pixel labtyp=arcsec,arcsec \
       device=$src.eps/cps options=full,beambl \
       in=$src.v-i.perc,$src.i.cm cols1=8  \
       slev=a,1,p,1 levs1=-8,-6,-4,-2,2,4,6,8 \
       region='arcsec,box(-5.5,-6,6.5,6)'
goto end



end:
