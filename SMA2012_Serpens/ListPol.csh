#! /bin/csh -f
#
#-- EXTRACT POLARIZATION DATA FROM IMAGE TO USE BY GRAPHIC
#
set cnt=MAP_POL
set c=GILDAS
set sr=smc.6
# --> R=2.0,fwhm=0.60 1.089x0.960,78 0.15x0.15

echo "ListPol.csh"
set reg=arcsec,box'(-4.5,-3.5,3.5,3.5)'
goto start



start:

foreach pes (bm1 nat)
#LOOP1
switch ($pes)
 case bm1:	# 23, 53
   set inc=4,4
   set nom=$c/list.smc6
   set nom=$c/list.smc6'_'3sgm
 breaksw
 case nat:	# 25, 68
   set inc=4,4
   set nom=$c/list.nat.smc6
   set nom=$c/list.nat.smc6'_'3sgm
 breaksw
endsw
set arx=$cnt/$sr.$pes
\rm -r tmp.*
foreach res (pa paerr)
 imsub out=tmp.$res in=$arx.$res  region=$reg incr=$inc
 imtab  in=tmp.$res log=$nom.$res format='(3f10.2)' mode=nemo   
end

foreach res (polm poli polmerr polierr)
 imsub out=tmp.$res in=$arx.$res  region=$reg incr=$inc
 imtab  in=tmp.$res log=$nom.$res format='(3f10.2)' mode=nemo \
        scale=100
end
# LOOP1
end


\rm -r tmp.*

end:
