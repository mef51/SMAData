#! /bin/csh -f
#
setenv LC_NUMERIC en_EN.UTF-8

echo "Polarization map for Serpens SMA pol project"
echo "Ram map:. Peak intensities in compact array"
echo "SMC 1 : 0.44 Jy/Beam"
echo "SMC 6 : 2.04 Jy/Beam"
echo "SMC 7 : 0.08 Jy/Beam"
echo "SMC 8 : 0.33 Jy/Beam"
echo "SMC 11: 0.21 Jy/Beam"
echo "SMC 15: 0.15 Jy/Beam"

set dia1=120525
set dia2=120526
set dia3=120615
set dia4=120902
set dia5=120903
set cm=MAPES_POL
set disp='arcsec,box(-11,-11,-14,14)'

foreach n(1 2 6 7 8 11 15)
set nom=$c/smc.$n
switch ($n)
 case 1:	
set arx=`echo $nom.com.i.cm`
 breaksw
 case 6:	
set arx=`echo $nom.com.i.cm`
 breaksw
 case 8: 
set arx=`echo $nom.nat.i.cm`
 breaksw
 case 11:
set arx=`echo $nom.nat.i.cm`
 breaksw
 case 15:
set arx=`echo $nom.nat.i.cm`
 breaksw
 case 7:
set arx=`echo $nom.nat.i.cm`
 breaksw
endsw
goto $1

foreach map()
linmos in=$map out=$mp.pb
cgdisp in=$map.pb,$map.pb type=c,p device=3/xs region=$disp \
  range=0.0,1.5,lin,2 labtyp=hms,dms options=beambl,wedge olay=pos.serp
  slev=a,0.01 levs1=-9,-6,-3,3,6,9,12,16,20,25,30,35,40,45,50,60,70,80,90
end

end

fi:
