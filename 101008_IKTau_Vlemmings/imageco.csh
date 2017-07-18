#! /bin/csh -f
#

set dt="101008"

set region=quart
set niters=4000
set so=IKTau_$dt

if($#argv<1) then
echo "Incorrect usage: Needs start_pt "
echo "script.csh DISP "
goto terminate
endif

goto $1


goto terminate


INVERTCO:
\rm -fr $so.co.?.mp $so.co.bm
set imvis=IKTau.win21.chi
set imline=vel,50,-20,2,2
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
cgdisp in=IKTau_101008.co.i.cm,IKTau_101008.co.q.mp,IKTau_101008.co.u.mp device=/xw region=quart type=p,c,c options=full,beambl,3value,wedge nxy=2,2 slev=a,0.05,a,0.05 levs1=-7,-6,-5,-4,-3,3,4,5,6,7 levs2=-7,-6,-5,-4,-3,3,4,5,6,7 device=IKTau_co.ps/cps range=0,0,lin,1 labtyp=arcsec,arcsec

terminate:
