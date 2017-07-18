#! /bin/csh -f
#
setenv LC_NUMERIC en_EN.UTF-8

echo "========================================"
echo "MapCO.csh r2/bm2 v3/v10/int"
echo "SMC 1 no CO"
echo "SMC 6 "
echo "SMC 8  no CO, 120525 yes but not ready 120902"
echo "SMC 7  not ready 120526"
echo "SMC 11 not ready 120526"
echo "SMC 15 not ready 120526"
#echo -n "Enter the source number: ";set n=$<
#echo -n "Enter co32/sio87:        ";set lab=$<
echo "---------------------------------------"
set n=6;set lab=co32

echo ""; echo ""; echo ""
set dia1=120525
set dia2=120526
set dia3=120615
set dia4=120902
set dia5=120903
set uv=UV_data/smc.$n
set mp=MAP_LINES
set sr=smc.$n
set opt=systemp,double
set sel='-ant(11)'
set regdisp='arcsec,box(-11,-11,11,11)'
set reg=quart


# RESOLUTIONS 
switch ($1)
 case bm2: 	# 0.778x0.678,76   
set rob='robust=2.0 fwhm=1.0';	set mida='imsize=256 cell=0.2'
set CL='speed=-0.05'
 breaksw
 case r2:	# 0.686xx0.575, 87 
set rob='robust=2.0 fwhm=0.5';	set mida='imsize=256 cell=0.2'
set CL='speed=-0.3'
 breaksw
endsw
set disp='arcsec,box(-11,-6,8,13)'

switch ($n)
 case 1:	# 0.903x0.802, 76.1 rms=3.12(i),2.92(q),3.01(u) 
set vis=$uv.$dia1.$lab.lf,$uv.$dia4.$lab.lf,$uv.$dia5.$lab.lf
set vint=vel,3,-19,52,58
set rms=0.18;set reg=@box.sio_smc1
 breaksw
 case 6:	# 0.890x0.794, 80.5 rms=10.6(i),3.09(q),3.22(u)
set vis=$uv.$dia1.$lab.lf,$uv.$dia4.$lab.lf,$uv.$dia5.$lab.lf
set vint=vel,3,-2,10,19
set rms=0.30
 breaksw
 case 8: 	# 2.068x1.716 43.3 rms=3.74(i)1.94(q)/2.24(u)
set vis=$uv.$dia1.$lab.lf
set vint=vel,3,-19,52,58
set rms=0.35
set mida='imsize=256 cell=0.30'
 breaksw
 case 11:	# 1.984x1.870, 54.8 rms=6.02(i),5.05(q),5.48(u) 
set vis=$uv.$dia2.$lab.lf
 breaksw
 case 15:	# 1.986x1.796, 50.2 rms=5.63(i),6.00(q),5.83(u)
set vis=$uv.$dia2.$lab.lf
 breaksw
 case 7:	# 1.991x1.836, 57.6 rms=4.72(i),5.30(q),5.02(u)
set vis=$uv.$dia2.$lab.lf
 breaksw
endsw


# CHANNELS
set xy=4,3
switch ($2)
 case v3:
set si   = `echo $rms | awk '{print $1 / 1.46}'`
set tall = `echo $rms | awk '{print $1 / 0.73}'`
set line=vel,40,-50,3,3;set xy=3,2
 breaksw
 case hv:
set si   = `echo $rms | awk '{print $1 / 3.3}'`
set tall = `echo $rms | awk '{print $1 / 1.3}'`
set line=vel,50,-112,5,5;set xy=4,3
set reg=@box.$lab.$n
 breaksw
 case int:
set si   = `echo $rms | awk '{print $1 / 4.3}'`
set tall = `echo $rms | awk '{print $1 / 2.1}'`
set line=$vint;set xy=3,1
set reg=@box.$lab.$2.$n
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
       gain=0.1 $CL minpatch=231
\rm -r RESIDU
restor map=$map.mp beam=$map.bm model=$map.cl out=$map.cm 
restor map=$map.mp beam=$map.bm model=$map.cl out=RESIDU mode=residual
\rm -fr $map.cl $map.mp
imstat in=$map.cm region='box(18,20,70,240)' device=/xs
echo '   Press return to continue'; $<
imstat in=$map.cm region='quart' device=/xs
echo '  RMS and Press return to continue'; set si=$<
cgdisp in=$map.cm type=c nxy=$xy csize=0,1,0,0 \
       device=1/xs region=$regdisp range=0,1.0,lin,1 \
       slev=a,$si levs1=-4,-3,3,4,5,6,7,9,12,15,20,25,30,35 \
       options=beambl,3pix labtyp=arcsec,arcsec olay=pos.serp
echo '   Press return to continue'; $<
cgdisp in=RESIDU type=c nxy=$xy csize=0,1,0,0 \
       device=1/xs region=$regdisp \
       slev=a,$si levs1=-5,-4,-3,3,4,5 \
       options=beambl,3pix labtyp=arcsec,arcsec olay=pos.serp
Salta:
echo 'Press return to continue               ==>  '$lab; $<


goto fi
fi:
