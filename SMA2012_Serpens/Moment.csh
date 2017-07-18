#! /bin/csh -f
#
setenv LC_NUMERIC en_EN.UTF-8

echo "=========================================="
echo "Momment.csh r2/bm2  line"
echo "---------------------------------------"
echo ""; echo ""; echo ""
set mp=MAP_LINES
set sr=smc.6
set dust=MAP_POL/$sr.bm1.i.cm
set nch=50
switch ($2)
 case HDCO:		# 4-3
  set lab=hdco; 	set reg='arcsec,box(-9,-9,9,9)(22,27)'; set rms=0.24
 breaksw
 case H13CN:		# 4-3
  set lab=h13cn43; 	set reg='arcsec,box(-9,-9,9,9)(23,29)'; set rms=0.23
 breaksw
 case SO:		# 98-87
  set lab=so_9887;	set reg='arcsec,box(-9,-9,9,9)(23,39)'; set rms=0.30
 breaksw
 case H13CO+:	# H13CO+ 4-3
  set lab=h13co+43;	set reg='arcsec,box(-9,-9,9,9)(24,30)'; set rms=0.24
 breaksw
endsw

# RESOLUTIONS 
switch ($1)
 case bm2: 	# 1.54x1.28, 62deg   
 set rms=`echo $rms | awk '{print $1 * 1.33}'`
 breaksw
 case r2:	# 1.07x0.88, 66deg
 breaksw
endsw
set tall1=`echo $rms | awk '{print $1 * 2.0}'`
set tall2=`echo $rms | awk '{print $1 * 2.5}'`
set tall3=`echo $rms | awk '{print $1 * 3.3}'`
echo $lab"."$1".ch  RMS: "$rms"  Tall: "$tall2' '$tall1
echo 'Press return to continue               ==>  '$lab; $<
set map=$mp/$sr.$lab.$1.ch
\rm -fr $map.m* 
moment in=$map.cm region=$reg mom=0 clip=-99,$tall1 out=$map.m0
fits op=xyout in=$map.m0 out=FITS/smc6'_'$lab'_'$1'_'m0.fits
moment in=$map.cm region=$reg mom=2 clip=-99,$tall2 out=$map.m2
fits op=xyout in=$map.m2 out=FITS/smc6'_'$lab'_'$1'_'m2.fits
moment in=$map.cm region=$reg mom=1 clip=-99,$tall3 out=$map.m1 rngmsk=true
fits op=xyout in=$map.m1 out=FITS/smc6'_'$lab'_'$1'_'m1.fits

cgdisp in=$map.m0,$map.m2 type=c,p nxy=1,1 csize=0,1,0,0 \
       device=2/xs  \
       slev=a,0.6 levs1=1,2,3,4,5,6,7,9,12,15,20,25,30,35 \
       options=beambl,wedge labtyp=arcsec,arcsec olay=pos.serp


goto fi
fi:
