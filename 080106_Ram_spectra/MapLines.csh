#! /bin/csh -f
#
#
set so=orkl_080106
set dd=UVDATA
# set line=vel,87,-31,1,1
set line=vel,43,-31,2,2
set rms=0.3
switch($1)
 case CO:
  set freq=345.7959;		set lab=co3-2
  set reg='arcsec,box(-4,-4,4,4)'; set rms=0.2
 set rng=0,30
 breaksw
 case SiO:
  set line=vel,27,-20,2,2
  set freq=347.3306;    set lab=sio8-7
  set reg='arcsec,box(-4,-4,4,4)'; set rms=0.3
 set rng=0,30
 breaksw
endsw

set vis=UVDATA/$so.$lab
set src=MAPS/$so.$lab
set tall=`echo $rms | awk '{print $1 * 3.0}'`
goto $2

MAPS:
\rm -fr $src.*
invert vis=$vis line=$line \
    beam=$src.bm map=$src.i.mp,$src.q.mp,$src.u.mp,$src.v.mp \
    imsize=128 cell=0.3 options=systemp,double stokes=i,q,u,v sup=0
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
       slev=a,$rms levs1=-21,-18,-15,-12,-9,-6,-3,3,6,9,12,15,18,21 \
       region='arcsec,box(-10,-10,10,10)' nxy=6,3
 imstat in=$src.$stk.cm region='box(6,6,50,122)'
 echo "Press Return to continue"; set nn=$<
end
foreach stk(i q u v)
 imstat in=$src.$stk.cm
end

DISP:
\rm -r $src.v-i.perc
maths exp='100*<'$src.v.cm'>/<'$src.i.cm'>' mask='<'$src.i.cm'>.gt.2' \
      out=$src.v-i.perc
cgdisp type=cont,pix labtyp=arcsec,arcsec \
       device=/xs options=full,beambl,3val \
       in=$src.v-i.perc,$src.i.cm cols1=8 \
       slev=a,1,p,1 levs1=-8,-6,-4,-2,2,4,6,8 \
       region='arcsec,box(-5.5,-6,6.5,6)' nxy=6,3
cgdisp type=cont,pixel labtyp=arcsec,arcsec \
       device=$src.ps/cps options=full,beambl,3val \
       in=$src.v-i.perc,$src.i.cm cols1=8  \
       slev=a,1,p,1 levs1=-8,-6,-4,-2,2,4,6,8 \
       region='arcsec,box(-5.5,-6,6.5,6)' nxy=6,3

