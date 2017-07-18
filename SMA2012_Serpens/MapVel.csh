#! /bin/csh -f
#
setenv LC_NUMERIC en_EN.UTF-8

echo "=========================================="
echo "MapH13CO+.csh r2/r2bm1/r-1 ch/2ch/v2/int line"
echo "Run script from a xterm  NOT from Terminal"
echo "---------------------------------------"
echo ""; echo ""; echo ""
set uv=UV_data
set mp=MAP_LINES
set sr=smc.6
set d1=$uv/$sr.120525
set d4=$uv/$sr.120902
set d5=$uv/$sr.120903
set dust=MAP_POL/$sr.bm1.i.cm
set opt=systemp,double
set sel='-ant(11)'
set regdisp='arcsec,box(-10,-10,10,10)'
set reg=@box.smc.6

# LOOP BEGIN
foreach mol (SO HDCO H13CN H13CO+)
switch ($mol)
#---- LSB 
 case HDCO: 	 # 5( 1, 4)- 4( 1, 3) DONE
  set freq=335.09678; 	set lab=hdco
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
 set reg=@box.hdco.vel
 breaksw
 case H15CN:	# 4-3 DONE ONLY 120525
  set freq=344.20011; 	set lab=h15cn43
  set vis=$d1.$lab.lf
  set reg=@box.hc15n.vel
 breaksw
 case H13CN:	#  4-3
  set freq=345.33976;	set lab=h13cn43
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
  set reg=@box.h13cn.vel
 breaksw
 case SO:	# SO 98-87
  set freq=346.52848;	set lab=so_9887
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
  set reg=@box.so.vel
 breaksw
 case H13CO+:	# H13CO+ 4-3
  set freq=346.99834;	set lab=h13co+43
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
  set reg=@box.h13co+.vel
 breaksw
 case SO2_19:	# 19_1,19-18_0,18 NOTHING to heck SO emission is free of SO2
  set freq=346.65217;	set lab=so2_19t18
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
 breaksw
endsw


set rob='robust=2.0 fwhm=0.9';	set mida='imsize=256 cell=0.2'
set rms=0.18;			set CL='speed=-0.3'
set si=`echo $rms | awk '{print $1 / 1.0}'`
set tall=`echo $rms | awk '{print $1 * 1.5}'`
set line=vel,15,3,1.0,1.0; set xy=5,3

echo $lab"  RMS: "$si"  Tall: "$tall
echo 'Press return to continue               ==>  '$lab; $<
set map=$mp/$sr.$lab.vel
\rm -fr $map.mp $map.cm $map.bm $map.cl
invert vis=$vis $mida options=$opt $rob select=$sel \
       map=$map.mp beam=$map.bm stokes=i line=$line
clean  map=$map.mp beam=$map.bm \
       out=$map.cl region=$reg niters=99999 cutoff=$tall \
       gain=0.1 $CL minpatch=131
\rm -r RESIDU
restor map=$map.mp beam=$map.bm model=$map.cl out=$map.cm 
restor map=$map.mp beam=$map.bm model=$map.cl out=RESIDU mode=residual
\rm -fr $map.cl $map.mp
imstat in=$map.cm region='box(18,20,70,240)' device=/xs
echo '   Press return to continue'; $<
imstat in=$map.cm region='quart' device=/xs
echo '  RMS and Press return to continue'; set si=$<
cgdisp in=$map.cm type=c,p nxy=$xy csize=0,1,0,0 \
       device=/xs region=$regdisp range=0,1.0,lin,1 \
       slev=a,$si levs1=-4,-3,-2,2,3,4,5,6,7,9,12,15,20,25,30,35 \
       options=beambl,3pix labtyp=arcsec,arcsec olay=pos.serp
echo '   Press return to continue'; $<
cgdisp in=RESIDU type=c nxy=$xy csize=0,1,0,0 \
       device=/xs region=$regdisp \
       slev=a,$si levs1=-7,-6,-5,-4,-3,-2,2,3,4,5,6,7 \
       options=beambl,3pix labtyp=arcsec,arcsec olay=pos.serp
Salta:
echo 'Press return to continue               ==>  '$lab; $<
\rm -r $sr'_'$lab'_'ch.fits
fits op=xyout in=$map.cm out=$sr'_'$lab'_'ch.fits

# LOOP END
end

goto fi
fi:
