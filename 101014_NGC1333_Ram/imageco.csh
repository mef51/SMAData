#! /bin/csh -f
#

set dt="101014"

set region=quart
set niters=4000
set so=iras2a_$dt

if($#argv<1) then
echo "Incorrect usage: Needs start_pt "
echo "script.csh DISP "
goto terminate
endif

goto $1


goto terminate


INVERTCO:
\rm -fr $so.co.?.mp $so.co.bm
set imvis=iras2a.win4.chi
set imline=vel,60,-25,1,1
invert vis=$imvis  \
       map=$so.co.i.mp,$so.co.q.mp,$so.co.u.mp \
       stokes=i,q,u options=systemp  imsize=512 cell=0.125 \
       beam=$so.co.bm  robust=0.0 line=$imline 
goto terminate

CLEANCO:
foreach pol(i q u)
\rm -fr $so.co.$pol.cl $so.co.$pol.cm
clean map=$so.co.$pol.mp beam=$so.co.bm \
      out=$so.co.$pol.cl region=$region niters=10000 cutoff=0.12
restor map=$so.co.$pol.mp beam=$so.co.bm \
      out=$so.co.$pol.cm model=$so.co.$pol.cl
end

goto terminate

DISP:
set device=iras2a_co.ps/cps
set device=/xw
cgdisp in=$so.co.i.cm,$so.co.q.mp,$so.co.u.mp device=/xw region=quart type=p,c,c options=full,beambl,3value,wedge nxy=2,2 slev=a,0.1,a,0.1 levs1=-7,-6,-5,-4,-3,3,4,5,6,7 levs2=-7,-6,-5,-4,-3,3,4,5,6,7 device=$device range=0,0,lin,1 labtyp=arcsec,arcsec

terminate:
