#! /bin/csh -f
#
#
set so=orkl_080106
set uvo=UVDATA
set uvc=UVOffsetCorrect
set map=MAPSCorrect
set rms=0.0065
goto $1

SPLIT:
# Split in different files LL and RR
foreach stk(ll rr lr rl)
 foreach lin(co3-2 cnt.usb)
  \rm -fr $uvc/$so.$lin.$stk
  uvaver vis=$uvo/$so.$lin out=$uvc/$so.$lin.$stk select='pol('$stk')'
 end
end
goto end

SELFCAL:
# Original map used for selfcal in MAPS
# Independent step for RR and LL (u,v) files
# 1. Selcalibration of continuum
# 2. Applying selfcalibration  for continuum
# 3. Copyinggains to Line data (all in the USB)
# 4. Applying selfcalibration  for lines
# 5. Concanate LL and RR in ine file
# 6. Resort data
tall=0.01
foreach stk(ll rr)
 foreach sb(cnt.usb)
  selfcal vis=$uvc/$so.$sb.$stk  model=MAPS/$so.cont.usb.i.cc \
    refant=6 interval=8 options=phase
  gpplt vis=$uvc/$so.$sb.$stk device=1/xs yaxis=phase nxy=1,3
  echo -n "Press enter to continue   ";set rs=$<
  \rm -rf $uvc/$so.$sb.$stk.slfc
  uvaver vis=$uvc/$so.$sb.$stk out=$uvc/$so.$sb.$stk.slfc
 end
#
 foreach lin(co3-2)
  \rm -fr $uvc/$so.$lin.$stk.slfc
  gpcopy vis=$uvc/$so.cnt.usb.$stk out=$uvc/$so.$lin.$stk
  uvaver vis=$uvc/$so.$lin.$stk out=$uvc/$so.$lin.$stk.slfc
 end
end
foreach lin(co3-2 cnt.usb)
 set vis=$uvc/$so.$lin
 \rm -rf tmp.5 tmp.6 $uvc/$so.$lin.corrected.slfc
 uvcat vis=$vis.rr.slfc,$vis.ll.slfc,$vis.rl,$vis.lr out=tmp.5
 uvsort vis=tmp.5 out=tmp.6
 uvaver vis=tmp.6 out=$uvc/$so.$lin.corrected.slfc interval=5
end
goto end

MAP:
# Map
# 1. Continuum Stokes I,V Uncorrected & Corrected data
# 2. Map All lines. Corrected
# 3.i Map All lines. Uncorrected
# 4. Continuum LL and RR independently, for non-selfcal and selfcal cases

# 1.
set src=$map/$so.cnt
set rms=0.0065;set tall=0.03
\rm -fr $src.*
invert vis=$uvc/$so.cnt.usb.corrected.slfc \
   stokes=i,v beam=$src.bm map=$src.i.mp,$src.v.mp \
   imsize=128 cell=0.3 options=systemp,double,mfs  sup=0
foreach stk(i v)
  clean  map=$src.$stk.mp beam=$src.bm out=$src.$stk.cc \
      niters=3000 cutoff=$tall
  restor map=$src.$stk.mp beam=$src.bm model=$src.$stk.cc out=$src.$stk.cm
end
set src=$map/$so.cnt.uncorrected
invert vis=$uvo/$so.cnt.usb \
   stokes=i,v beam=$src.bm map=$src.i.mp,$src.v.mp \
   imsize=128 cell=0.3 options=systemp,double,mfs  sup=0
foreach stk(i v)
  clean  map=$src.$stk.mp beam=$src.bm out=$src.$stk.cc \
      niters=3000 cutoff=$tall
  restor map=$src.$stk.mp beam=$src.bm model=$src.$stk.cc out=$src.$stk.cm
end

# 2. Map corrected line data
set rms=0.13; set tall=0.50
set vel=vel,43,-31,2,2
foreach lin(co3-2)
 set src=$map/$so.$lin
 \rm -fr $src.*
 invert vis=$uvc/$so.$lin.corrected.slfc \
    stokes=i,v beam=$src.bm map=$src.i.mp,$src.v.mp \
    imsize=128 cell=0.3 options=systemp,double sup=0 line=$vel
 foreach stk(i v)
   clean  map=$src.$stk.mp beam=$src.bm out=$src.$stk.cc \
       niters=3000 cutoff=$tall
   restor map=$src.$stk.mp beam=$src.bm model=$src.$stk.cc out=$src.$stk.cm
 end
end
# 3. Map uncorrected line data with same paramenters as in 2
# set rms=0.13; set tall=0.50
# set vel=vel,43,-31,2,2
foreach lin(co3-2)
 set src=$map/$so.$lin.uncorrected
 \rm -fr $src.*
 invert vis=$uvo/$so.$lin \
    stokes=i,v beam=$src.bm map=$src.i.mp,$src.v.mp \
    imsize=128 cell=0.3 options=systemp,double sup=0 line=$vel
 foreach stk(i v)
   clean  map=$src.$stk.mp beam=$src.bm out=$src.$stk.cc \
       niters=3000 cutoff=$tall
   restor map=$src.$stk.mp beam=$src.bm model=$src.$stk.cc out=$src.$stk.cm
 end
end
# 4. nopol is for selfcal case (this option is not used!)
set rms=0.01;set tall=0.03
foreach stk(ll rr)
 set src=$map/$so.cnt.$stk
 \rm -rf $src.*
 foreach pol(nopol nocal)
  \rm -rf $src.bm
  invert vis=$uvc/$so.cnt.usb.$stk \
    beam=$src.bm map=$src.$pol.mp \
    imsize=128 cell=0.3 options=systemp,double,mfs,$pol  sup=0
  clean  map=$src.$pol.mp beam=$src.bm out=$src.$pol.cc \
      niters=3000 cutoff=$tall
  restor map=$src.$pol.mp beam=$src.bm model=$src.$pol.cc out=$src.$pol.cm
 end
end
goto end

DISP:
# 1. Plot uncorrected channel map
# 2. Plot corrected channel map
foreach lin(cnt co3-2)
 set devicetype=ps/cps
 set filename=$lin
 set src=$map/$so.$lin
 \rm -rf $src.v-i.perc $src.v-i.perc.uncorrected
 if ($lin == 'cnt') then
  set rms=0.02;set nxy=1,1
  maths exp='100*<'$src.v.cm'>/<'$src.i.cm'>' \
      mask='<'$src.i.cm'>.gt.0.4' \
      out=$src.v-i.perc
  maths exp='100*<'$src.uncorrected.v.cm'>/<'$src.uncorrected.i.cm'>' \
      mask='<'$src.uncorrected.i.cm'>.gt.0.4' \
      out=$src.v-i.perc.uncorrected
 else
  set rms=0.3;set nxy=4,2
  maths exp='100*<'$src.v.cm'>/<'$src.i.cm'>' \
      mask='<'$src.i.cm'>.gt.6' \
      out=$src.v-i.perc
  maths exp='100*<'$src.uncorrected.v.cm'>/<'$src.uncorrected.i.cm'>' \
      mask='<'$src.uncorrected.i.cm'>.gt.8' \
      out=$src.v-i.perc.uncorrected
 endif
 cgdisp type=cont,cont labtyp=arcsec,arcsec \
       device=$filename.uncorr.$devicetype options=full,beambl,3val csize=0,1,0,0 \
       in=$src.uncorrected.i.cm,$src.uncorrected.v.cm cols1=2 cols2=8 \
       slev=p,1,a,$rms \
       levs1=15,35,55,75,95 \
       levs2=-8,-7,-6,-5,-4,-3,-2,2,3,4,5,6,7,8 \
       region='arcsec,box(-15,-15,15,15)' nxy=$nxy
 imstat in=$src.i.cm region='box(3,3,50,125)'
 imstat in=$src.v.cm region='box(3,3,50,125)'
 echo "Press Return to continue"; set nn=$<
 cgdisp type=cont,cont labtyp=arcsec,arcsec \
       device=$filename.corr.$devicetype options=full,beambl,3val csize=0,1,0,0 \
       in=$src.i.cm,$src.v.cm cols1=2 cols2=8 \
       slev=p,1,a,$rms \
       levs1=15,35,55,75,95 \
       levs2=-8,-7,-6,-5,-4,-3,-2,2,3,4,5,6,7,8 \
       region='arcsec,box(-15,-15,15,15)' nxy=$nxy
 imstat in=$src.i.cm region='box(3,3,50,125)'
 imstat in=$src.v.cm region='box(3,3,50,125)'
 echo "Press Return to continue"; set nn=$<
 cgdisp type=cont,cont labtyp=arcsec,arcsec \
       device=$filename.uncorr.perc.ps/cps options=full,beambl,3val \
       in=$src.uncorrected.i.cm,$src.v-i.perc.uncorrected cols1=2 cols1=8 \
       slev=p,1,a,1 \
       levs1=15,35,55,75,95 \
       levs2=-6,-5,-4,-3,-2,-1,1,2,3,4,5,6 \
       region='arcsec,box(-5.5,-6,6.5,6)' nxy=$nxy
 echo "Press Return to continue"; set nn=$<
 cgdisp type=cont,cont labtyp=arcsec,arcsec \
       device=$filename.corr.perc.ps/cps options=full,beambl,3val \
       in=$src.i.cm,$src.v-i.perc cols1=2 cols1=8 \
       slev=p,1,a,1 \
       levs1=15,35,55,75,95 \
       levs2=-6,-5,-4,-3,-2,-1,1,2,3,4,5,6 \
       region='arcsec,box(-5.5,-6,6.5,6)' nxy=$nxy
 echo "Press Return to continue"; set nn=$<
end
goto end

PEAK:
set src=$map/$so.cnt
foreach li(ll.nocal rr.nocal ll.nopol rr.nopol)
 maxfit in=$src.$li.cm log=maxfit'_'$so.$li
end
maxfit in=$src.i.cm log=maxfit'_'$so.stokesI

goto end


end:
