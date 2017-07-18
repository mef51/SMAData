#! /bin/csh -f
#
setenv LC_NUMERIC en_EN.UTF-8

if($#argv<1) then
echo "Incorrect usage: Needs start_pt dt file"
echo "MapPol.csh DUST/POL/DISP R05/R0/NAT"
goto fi
endif
echo "Polarization map for Serpens SMA pol project"
echo "Ram map:. Peak intensities in compact array"
echo "SMC 1 : 0.44 Jy/Beam"
echo "SMC 6 : 2.04 Jy/Beam"
echo "SMC 7 : 0.08 Jy/Beam"
echo "SMC 8 : 0.33 Jy/Beam"
echo "SMC 11: 0.21 Jy/Beam"
echo "SMC 15: 0.15 Jy/Beam"
echo -n "Enter the source number: ";set n=$<

switch ($2)
 case R0:
set rob='robust=0.0'
set so=r0
 breaksw
 case NAT:
set rob='sup=0'
set so=nat
 breaksw
endsw

set dia1=120525
set dia2=120526
set dia3=120615
set dia4=120902
set dia5=120903
set vis=UV_data/smc.$n
set disp='arcsec,box(-17,-17,17,17)'

set si=0.0050; set sp=0.0045
switch ($n)
 case 1:	# 0.903x0.802, 76.1 rms=3.12(i),2.92(q),3.01(u) 
set lsbT=$vis.$dia1.lsb,$vis.$dia4.lsb,$vis.$dia5.lsb
set usbT=$vis.$dia1.usb,$vis.$dia4.usb,$vis.$dia5.usb
set mida='imsize=512 cell=0.12 fwhm=0.3'
set disp='arcsec,box(-6,-6,6,6)'
 breaksw
 case 6:	# 0.890x0.794, 80.5 rms=10.6(i),3.09(q),3.22(u)
set lsbT=$vis.$dia1.lsb,$vis.$dia4.lsb,$vis.$dia5.lsb
set usbT=$vis.$dia1.usb,$vis.$dia4.usb,$vis.$dia5.usb
set mida='imsize=512 cell=0.12 fwhm=0.3'
set si=0.011; set sp=0.0029
set disp='arcsec,box(-6,-6,6,6)'
 breaksw
 case 8: 	# 2.068x1.716 43.3 rms=3.74(i)1.94(q)/2.24(u)
set lsbT=$vis.$dia1.lsb,$vis.$dia3.lsb
set usbT=$vis.$dia1.usb,$vis.$dia3.usb
set mida='imsize=256 cell=0.3'
set si=0.0038; set sp=0.0021
set disp='arcsec,box(-7,-6,15,16)'
 breaksw
 case 11:	# 1.984x1.870, 54.8 rms=6.02(i),5.05(q),5.48(u) 
set lsbT=$vis.$dia2.lsb
set usbT=$vis.$dia2.usb
set mida='imsize=256 cell=0.3'
set si=0.0060; set sp=0.0052
set disp='arcsec,box(-11,-6,8,13)'
 breaksw
 case 15:	# 1.986x1.796, 50.2 rms=5.63(i),6.00(q),5.83(u)
set lsbT=$vis.$dia2.lsb
set usbT=$vis.$dia2.usb
set mida='imsize=256 cell=0.3'
set si=0.0056; set sp=0.0059
set disp='arcsec,box(-8,-8,8,8)'
 breaksw
 case 7:	# 1.991x1.836, 57.6 rms=4.72(i),5.30(q),5.02(u)
set lsbT=$vis.$dia2.lsb
set usbT=$vis.$dia2.usb
set mida='imsize=256 cell=0.3'
set si=0.0047; set sp=0.0052
set disp='arcsec,box(-8,-8,8,8)'
 breaksw
endsw
set region=@box.smc.$n
set map=MAP_POL/smc.$n.$so
goto $1

DUST:
set uv=$usbT,$lsbT
\rm -fr $map.*.mp 
\rm -fr $map.bm 
invert vis=$uv map=$map.i.mp,$map.q.mp,$map.u.mp beam=$map.bm \
       stokes=i,q,u options=double,mfs,systemp $rob $mida
foreach pol(i q u)
set tall=`echo $sp | awk '{print $1 * 3.0}'`
set rms=$sp
set lev='-8,-7,-6,-5,-4,-3,-2,2,3,4,5,6,7,8'
set sta='box(20,20,230,230)'
switch ($pol)
 case i:
 set tall=`echo $si | awk '{print $1 * 1.0}'`
set rms=$si
set lev='-10,-7,-4,4,7,10,15,20,25,30,35,40,45,50,60,70,80,90,100'
set sta='box(10,10,90,245)'
 breaksw
endsw
echo "Cutoff used for "$pol": "$tall
\rm -fr  $map.$pol.cl $map.$pol.cm
clean  map=$map.$pol.mp beam=$map.bm out=$map.$pol.cl minpatch=111 \
       region=$region niters=8000 cutoff=$tall gain=0.1 speed=-0.5
restor map=$map.$pol.mp beam=$map.bm out=$map.$pol.cm \
       model=$map.$pol.cl 
imhist in=$map.$pol.cm region=$sta device=3/xs options=cutoutliers,3 
echo 'Return ';set rr=$<
cgdisp in=$map.$pol.cm type=c device=3/xs region=$disp nxy=1,1 \
   labtyp=hms,dms slev=a,$rms levs1=$lev \
   options=beambl,full,3val olay=pos.serp
echo 'Return ';set rr=$<
\rm -r $map.$pol.cl $map.$pol.mp
end
goto fi

POL:
\rm -fr $map.poli $map.polierr $map.polm $map.polmerr $map.pa $map.paerr
impol in=$map.q.cm,$map.u.cm,$map.i.cm sigma=$sp,$si sncut=2,6 \
      poli=$map.poli,$map.polierr polm=$map.polm,$map.polmerr \
      pa=$map.pa,$map.paerr
goto fi

DISP:
set dev=3/xs
cgdisp in=$map.i.cm,$map.poli,$map.polm,$map.pa type=c,p,amp,ang \
  device="$dev" region=$disp range=0.0,0.025,lin,2 cols1=1 \
  slev=a,$si levs1=-8,-4,4,8,12,16,20,25,30,35,40,45,50,60,70,80,90 \
  options=beambl,wedge,rot90  olay=pos.serp \
  lines=1,3,4 vecfac=1.7,2,2,0.10 labtyp=hms,dms 

set nom=smc'_'$n'_'$so'_'pol.ps
set dev="$nom/cps"
cgdisp in=$map.i.cm,$map.poli,$map.polm,$map.pa type=c,p,amp,ang \
  device="$dev" region=$disp range=0.0,0.025,lin,3 \
  slev=a,0.01 levs1=-9,-6,-3,3,6,9,12,16,20,25,30,35,40,45,50,60,70,80,90 \
  options=beambl,wedge,rot90  olay=pos.serp \
  lines=1,1,6 vecfac=2.5,2,2,0.10 labtyp=hms,dms
gv $nom &

fi:
