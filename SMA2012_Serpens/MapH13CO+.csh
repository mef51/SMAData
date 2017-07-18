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
set nch=50
set reg=@box.smc.6
switch ($3)
#---- LSB 
 case SO2_COMB: # 8_2,6-7_1,7 + 4(3,1)- 3(2,2) NOTHING
  set freq=334.67335; 	set lb=so2_826;set lb2=so2_413
  set lab=so2_comb
  set vis=$d1.$lb.lf,$d4.$lb.lf,$d5.$lb.lf,$d1.$lb2.lf
 breaksw
 case Met7: 	# 7_1,7-6_1,6 Undetected	
  set freq=335.58200; 	set lab=ch3oh717
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
 breaksw
 case HDCO: 	 # 5( 1, 4)- 4( 1, 3) DONE
  set freq=335.09678; 	set lab=hdco; set nch=75
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
 set reg=@box.hdco.ch
 breaksw
#--- USB
 case H15CN:	# 4-3 DONE ONLY 120525
  set freq=344.20011; 	set lab=h15cn43
  set vis=$d1.$lab.lf
 breaksw
 case CO:	# CO 3-2
  set freq=345.7959	;set lab=co32
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
 breaksw	
 case H13CN:	#  4-3
  set freq=345.33976;	set lab=h13cn43; set nch=50
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
  set reg=@box.h13cn.ch
 breaksw
 case SO2_13:	# 13_2,12-12_1,11 Undetected. The line seen is H13CN 4-3
  set freq=345.33851;	set lab=so2_13212; set nch=50
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
 breaksw
 case SO:	# SO 98-87
  set freq=346.52848;	set lab=so_9887;   set nch=55
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
  set reg=@box.so_9887
 breaksw
 case SO2_19:	# 19_1,19-18_0,18 Undetected
  set freq=346.65217;	set lab=so2_19t18; set nch=55
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
 breaksw
 case H13CO+:	# H13CO+ 4-3
  set freq=346.99834;	set lab=h13co+43; set nch=55
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
  set reg=@box.h13co+.ch
 breaksw
 case SiO:
  set freq=347.33082;	set lab=sio87; set nch=200
  set vis=$d1.$lab.lf,$d4.$lab.lf,$d5.$lab.lf
 breaksw
endsw


# RESOLUTIONS 
switch ($1)
 case bm2: 	# 1.54x1.28, 62deg   
set rob='robust=2.0 fwhm=1.0';	set mida='imsize=256 cell=0.2'
set rms=0.27;			set CL='speed=-0.0'
 breaksw
 case r2:	# 1.07x0.88, 66deg
set rob='robust=2.0 fwhm=0.9';	set mida='imsize=256 cell=0.2'
set rms=0.21;			set CL='speed=-0.3'
 breaksw
endsw

# CHANNELS
set xy=4,3
switch ($2)
 case ch:
set si=`echo $rms | awk '{print $1 / 1.0}'`
set tall=`echo $rms | awk '{print $1 * 1.5}'`
set line=ch,$nch,1,1,1; set xy=5,3
 breaksw
 case v2:
set si   = `echo $rms | awk '{print $1 / 1.6}'`
set tall = `echo $rms | awk '{print $1 / 1.3}'`
set line=vel,12,-4,2,2;set xy=3,2
 breaksw
 case int:
set si   = `echo $rms | awk '{print $1 / 2.0}'`
set tall = `echo $rms | awk '{print $1 / 1.5}'`
set line=vel,10,-13.0,3.5,3.5;set xy=2,2
set reg=quart
 breaksw
 case hv:
set si   = `echo $rms | awk '{print $1 / 2.1}'`
set tall = `echo $rms | awk '{print $1 / 0.7}'`
set line=vel,50,-112,5,5;set xy=2,2
set regdisp='arcsec,box(-16,-16,16,16)'
set reg=quart
 breaksw
 case xoc:
set si   = `echo $rms | awk '{print $1 / 4.8}'`
set tall = `echo $rms | awk '{print $1 / 2.4}'`
set line=vel,2,40,40,40;set xy=1,1
set regdisp='arcsec,box(-10,-10,10,14)'
set reg=@box.sio_int
 breaksw
endsw

echo $lab"."$1"."$2"  RMS: "$si"  Tall: "$tall
echo 'Press return to continue               ==>  '$lab; $<
set map=$mp/$sr.$lab.$1.$2
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


goto fi
fi:
