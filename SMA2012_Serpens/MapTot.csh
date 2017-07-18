#! /bin/csh -f
#
setenv LC_NUMERIC en_EN.UTF-8

set uv=UV_data
set src=smc.6
set d1=120525
set d4=120902
set d5=120903
set vis=$uv/$src.$d1.$1.lf,$uv/$src.$d4.$1.lf,$uv/$src.$d5.$1.lf

set regdisp='arcsec,box(-15,-15,15,15)'
set reg=@box.smc.6
set op=systemp,double
set rms=2.00;	set lab=$1
set rob='robust=2.0 fwhm=0.5';	set mida='imsize=512 cell=0.15'

switch ($1)
 case lsb:
set lin=ch,240,5,2,2 
 breaksw
 case usb:
set lin=ch,500,1,1,1 
 breaksw
endsw

set mp=MAP_LINES/$src.$1
set tall=`echo $rms | awk '{print $1 * 2}'`
\rm -fr $mp.mp $mp.bm $mp.cl $mp.cm
invert vis=$vis $mida $rob options=$op \
       map=$mp.mp beam=$mp.bm line=$lin 
clean  map=$mp.mp beam=$mp.bm \
       out=$mp.cl region=$reg niters=9999 cutoff=$tall gain=0.2
restor map=$mp.mp beam=$mp.bm \
       model=$mp.cl out=$mp.cm
\rm -fr $mp.cl $mp.mp
imstat in=$mp.cm region='box(18,20,70,210)' device=/xs
echo '   Press return to continue'; $<
imstat in=$mp.cm region='quart' device=/xs
echo '  RMS and Press return to continue'; set si=$<
cgdisp in=$mp.cm type=c,p nxy=$xy csize=0,1,0,0 \
       device=1/xs region=$regdisp range=0,1.0,lin,1 \
       slev=a,$srms levs1=-4,-3,-2,2,3,4,5,6,7,9,11 \
       options=beambl,3pix labtyp=arcsec,arcsec olay=pos.serp
echo '   Press return to continue'; $<
 
