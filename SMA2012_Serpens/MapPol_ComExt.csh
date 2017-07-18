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
echo -n "Enter the source number: ";set n=$<

# SMC 6
# Cleaning @ 3-sgm Q & in Stokes I emitting region 
#	Qmax//Umax=-14.48//-9.74 rmsQ//U=2.95//3.12 snrQ//U=4.91//3.30
# Cleaning @ 2-sgm Q & in Stokes I emitting region, then @ 3-sgm open region 
#	Qmax//Umax=-11.55//8.39 rmsQ//U=2.25//2.18 snrQ//U=5.13//3.85


switch ($2)
 case TEST:  
# --> R=0.0,fwhm=0.05 0.884x0.623,-89 
# SMC 1 2.94,2.98,3.33 No; 	 SMC.6 5.1,2.9,3.1 marginal
# --> R=1.0,fwhm=0.05 0.854x0.742,81 
# SMC 1 2.76,2.88,3.00 Marginal; SMC.6 4.6,2.6,2.9 yes
# --> R=1.0,fwhm=0.30 0.909x0.799,78 
# SMC 1 2.78,2.79,3.00 Marginal; SMC.6 4.8,2.7,2.9 yes
# --> R=1.0,fwhm=0.60 1.089x0.960,78 
# SMC 1 ; 			SMC.6 5.6,2.9,3.1 yes
# --> R=1.0,fwhm=1.00 1.477x1.283,70 
# SMC 1 ; 			SMC.6 7.3,3.5,3.7 yes
# --> R=1.0,fwhm=0.80 1.354x1.121,67
# SMC 1 4.12,3.34,3.41; 	SMC.6 6.3,3.2,3.4 yes
set rob='robust=1.0'
set mida='imsize=512 cell=0.20 fwhm=0.40'
# --> R=1.0, 0-150kl 1.236x0.942,71
# SMC 1 4.12,3.34,3.41; 	SMC.6 5.8,3.4,3.5 yes
set sp=0.0034
set mida='imsize=512 cell=0.20 select=uvrange(0,150)'
set so=test
 breaksw
 case BM1:	# 1.280x1.108,65.9, RMS_IQU= 4.5,2.00,2.12
set rob='sup=0'; set so=bm1;    set mida='imsize=512 cell=0.13 fwhm=0.8' 
set si=0.0045;	 set sp=0.002; set bin=3,3
 breaksw
case NAT:	# 0.861x0.752,74.1,   RMS_IQU= 4.1,1.55,1.72
set rob='sup=0'; set so=nat; set mida='imsize=512 cell=0.09 fwhm=0.1' 
set si=0.0045;	 set sp=0.0017;  set bin=2,2
 breaksw
endsw

set dia1=120525
set dia2=120526
set dia3=120615
set dia4=120902
set dia5=120903
set vis=UV_data/smc.$n
set disp='arcsec,box(-6,-6,6,6)'

switch ($n)
 case 1:	
set lsbT=$vis.$dia1.lsb,$vis.$dia4.lsb,$vis.$dia5.lsb
set usbT=$vis.$dia1.usb,$vis.$dia4.usb,$vis.$dia5.usb
set si=0.0041
 breaksw
 case 6:
set lsbT=$vis.$dia1.lsb,$vis.$dia4.lsb,$vis.$dia5.lsb
set usbT=$vis.$dia1.usb,$vis.$dia4.usb,$vis.$dia5.usb
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
set tall1=`echo $sp | awk '{print $1 * 2.0}'`
set tall2=`echo $sp | awk '{print $1 * 3.0}'`
set rms=$sp
set lev='-8,-7,-6,-5,-4,-3,-2,2,3,4,5,6,7,8'
set sta='box(20,20,512,200)'
set neteja='gain=0.1'
switch ($pol)
 case i:
 set tall1=`echo $si | awk '{print $1 * 1.5}'`
 set tall2=`echo $si | awk '{print $1 * 5.0}'`
 set rms=$si
 set lev='-10,-7,-4,4,7,10,15,20,25,30,35,40,45,50,60,70,80,90,100'
 set sta='box(10,10,90,245)'
 set neteja='gain=0.1 speed=-0.3 phat=0.2'
 breaksw
endsw
echo "Cutoff used for "$pol": "$tall1
\rm -fr  $map.$pol.cl   $map.$pol.cl2 $map.$pol.cm
clean  map=$map.$pol.mp beam=$map.bm out=$map.$pol.cl minpatch=111 \
       cutoff=$tall1 niters=2000 $neteja region=$region
clean  map=$map.$pol.mp beam=$map.bm model=$map.$pol.cl out=$map.$pol.cl2 \
       cutoff=$tall2 niters=1000 gain=0.1
restor map=$map.$pol.mp beam=$map.bm out=$map.$pol.cm \
       model=$map.$pol.cl2
imhist in=$map.$pol.cm region=$sta device=3/xs options=cutoutliers,3.2
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
impol in=$map.q.cm,$map.u.cm,$map.i.cm sigma=$sp,$si sncut=3.0,5 \
      poli=$map.poli,$map.polierr polm=$map.polm,$map.polmerr \
      pa=$map.pa,$map.paerr
#goto fi

DISP:
set dev=3/xs
cgdisp in=$map.i.cm,$map.poli,$map.poli,$map.pa type=c,p,amp,ang \
  device="$dev" region=$disp range=0.0,0.025,lin,2 cols1=1 \
  slev=p,1 levs1=-2,2,5,9,15,25,35,45,55,65,75,85,95 \
  options=beambl,wedge,rot90  olay=pos.serp \
  lines=1,3,4 vecfac=1.0,$bin,0.01 labtyp=hms,dms 
#goto fi

set nom=smc'_'$n'_'$so'_'pol.eps
set dev="$nom/cps"
cgdisp in=$map.i.cm,$map.poli,$map.poli,$map.pa type=c,p,amp,ang \
  device="$dev" region=$disp range=0.0,0.025,lin,5 cols1=1  \
  slev=p,1 levs1=-2,2,5,9,15,25,35,45,55,65,75,85,95 \
  options=beambl,wedge,rot90  olay=pos.serp \
  lines=2,2,7 vecfac=1.7,$bin,0.01 labtyp=hms,dms
#gv $nom &

fi:
