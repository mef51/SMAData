#! /bin/csh -f
#
set region=quart
set regdisp='arcsec,box(-10,-10,20,10)'
set regdisp='arcsec,box(-6,-6,6,6)'
set region=@box.dust
set so=irc+10216
set bpcal=3c454
set dd=UVDATA
set pp=PlotsCAL
set mm=MAPS

if($#argv<1) then
echo "Incorrect usage: Needs start_pt dt file"
echo "script.csh DISP"
goto terminate
endif

echo;echo
echo "==========================================="
echo "    Script for IRC+10216 track 091124"
echo "Data converted from idl2miriad, 25ago10"
echo "Tsys correction done from MIR-IDL by Nimesh"
echo "      Antenna available: 1 2 4 6 7 8"
echo "      ----> version 26ago10 <-----"
echo "==========================================="
echo;echo

goto $1

IPOLFLAG:
echo "------------------------------------>"
echo "No uv data with wrong pol definitions"
echo "  ===> This section is skipped <===  "
echo "-------------------------------------"
echo
goto terminate
foreach font(0854+201 1058+015 3c273 mars titan $so)
foreach sb(lsb usb)
set nom=$dd/$font'_'$sb.vis
\rm -fr $nom.flgd
uvflag vis=$nom select='-pol(ll,lr,rl,rr)' flagval=f
uvcal  vis=$nom options=unflagged out=$nom.flgd
end
end
#goto terminate

TSYSFIX:
echo "------------------------------------>"
echo "  Tsys already corrected in MIR-IDL  "
echo "  ===> This section is skipped <===  "
echo "-------------------------------------"
goto terminate
foreach font(0854+201 1058+015 3c273 mars titan $so)
foreach sb(lsb usb)
set nom=$dd/$font'_'$sb.vis
\rm -fr $nom.tsys
echo;echo
echo  "JMG NOTE: Polynomial FIT does not work at 19-20 hrs"
echo;echo
smafix vis=$nom out=$nom.tsys device=/xw nxy=1,1 \
       yrange=100,700 options=tsyscorr
end
end
goto terminate

## REDCUTION PROCESS STARTS HERE ----->

BPCAL:
echo;echo
echo  "JMG NOTE: 128 channels, better to flag 10 channels at edges"
echo  "JMG 26ago10: smamfcal does not handle 48chuncks yet, so used mfcal"
echo  "JMG 26ago10: smauvspec does not handle 48chuncks yet, so used uvspec"
echo;echo
echo "I flux density LSB=16.56  USB=15.71"
echo;echo
foreach sb(lsb usb)
set nom=$dd/$bpcal'_'$sb.vis
set options=averrll
mfcal select='pol(ll,rr)' refant=4 interval=3 weight=2 \
      vis=$nom edge=4 line=ch,1536,1,4,4
#options=$options
echo
echo -n "Return to continue .......";set dv=$<
# Plots
foreach pol(ll rr)
foreach yy(amp pha)
uvspec vis=$nom select='pol('$pol')' axis=freq,$yy \
 device=$bpcal'_'$sb'_'$pol'_'$yy'_nobp.ps'/cps nxy=2,4 interval=9999 \
 options=nopass
uvspec vis=$nom select='pol('$pol')' axis=freq,$yy \
 device=$bpcal'_'$sb'_'$pol'_'$yy'_bp.ps'/cps   nxy=2,4 interval=9999 
mv $bpcal*ps $pp
end
end
# Fi plots
end

APPLYBP:
foreach sb(lsb usb)

foreach font(0854+201 1058+015 3c273 titan)
set nom=$dd/$font'_'$sb.vis
\rm -r $nom.bp
gpcopy vis=$dd/$bpcal'_'$sb.vis out=$nom options=nocal,nopol
uvaver vis=$nom out=tmp     options=nocal 
uvaver vis=tmp  out=$nom.bp options=nocal line=ch,1,1,6144,6144
\rm -r tmp
end

foreach font(mars $so)
set nom=$dd/$font'_'$sb.vis
\rm -r $nom.bp
gpcopy vis=$dd/$bpcal'_'$sb.vis out=$nom options=nocal,nopol
uvaver vis=$nom out=$nom.bp options=nocal
end

set nom=$dd/$bpcal'_'$sb.vis
\rm -r $nom.bp
uvaver vis=$nom out=$nom.bp options=nocal

end
goto terminate


EVEC:
foreach font(0854+201 1058+015 3c273 titan $so mars 3c454)
foreach sb(lsb usb)
set nom=$dd/$font'_'$sb.vis
puthd in=$nom.bp/evector value=0.7853
puthd in=$nom.bp/mount value=4

\rm -fr $nom.bp.chi
uvredo vis=$nom.bp options=chi out=$nom.bp.chi
end
end
goto terminate

FLUX:
echo "##------------------------------------------------------>"
echo "Scaling by LSB: 1.37  USB: 1.06"
foreach sb(lsb usb)
# -------
set flx=$dd/titan'_'$sb.vis
smaflux vis=$flx.bp.chi select='pol(ll,rr)' mirhome=$MIR
\rm -r $flx.bp.chi.flux
uvaver vis=$flx.bp.chi out=$flx.bp.chi.flux interval=5
# --------
foreach font(0854+201 1058+015 3c273 titan $so 3c454)
set nom=$dd/$font'_'$sb.vis
gpcopy vis=$flx.bp.chi out=$nom.bp.chi
\rm -r $nom.bp.chi.flux
uvaver vis=$nom.bp.chi out=$nom.bp.chi.flux interval=5
end
# --------
end
goto terminate


GCAL:
foreach sb(lsb usb)
foreach cal(0854+201 1058+015)
set nom=$dd/$cal'_'$sb.vis.bp.chi.flux
mfcal vis=$nom refant=4 options=amp select='pol(ll,rr)' interval=5,10 \
      options=nopassol
gpplt vis=$nom device=1/xs yaxis=amp nxy=1,2
pause
gpplt vis=$nom device=2/xs yaxis=pha nxy=1,2
pause
end
gpcopy  vis=$nom out=$dd/$so"_"$sb.vis.bp.chi.flux mode=copy
gpcopy  vis=$nom out=$dd/$so"_"$sb.vis.bp.chi.flux mode=merge
end
goto terminate


AVER:
foreach sb(lsb usb)
set nom=$dd/$so'_'$sb.vis
\rm -fr $nom.uvcal
uvaver vis=$nom.bp.chi.flux  out=$nom.uvcal
end
goto terminate

POLCAL:
foreach sb(lsb usb)
gpcal vis=$dd/3c454"_"$sb.vis.bp.chi.flux refant=4 \
      options=noxy,circular,qusolve interval=5 flux=16.5
gpcopy vis=$dd/3c454"_"$sb.vis.bp.chi.flux \
       out=$dd/$so"_"$sb.vis.uvcal mode=nocal
end
goto terminate

MAPCAL:
## POL CAL
set font=$mm/3c454
set rms=0.004
\rm -r $font.*
invert vis=$dd/3c454_lsb.vis.bp.chi.flux,$dd/3c454_usb.vis.bp.chi.flux \
    beam=$font.bm map=$font.i.mp,$font.q.mp,$font.u.mp,$font.v.mp \
    imsize=128 cell=0.3 options=mfs,systemp,double stokes=i,q,u,v sup=0
clean  map=$font.i.mp beam=$font.bm clean=$font.i.cc out=$font.i.cc
restor map=$font.i.mp beam=$font.bm model=$font.i.cc out=$font.i.cm  
foreach stk(q u v) 
 clean  map=$font.$stk.mp beam=$font.bm clean=$font.$stk.cc out=$font.$stk.cc niters=30
 restor map=$font.$stk.mp beam=$font.bm model=$font.$stk.cc out=$font.$stk.cm 
end
imstat in=$font.i.cm region='box(6,6,50,122)'
echo "Press Return to continue"; set nn=$<
foreach stk(q u v)
 cgdisp type=cont,pix labtyp=arcsec,arcsec \
       device=/xs options=full,beambl csize=0,1,0,0 \
       in=$font.$stk.cm,$font.i.cm \
       slev=a,$rms levs1=-21,-18,-15,-12,-9,-6,-3,3,6,9,12,15,18,21 \
       region='arcsec,box(-15,-15,15,15)' nxy=1,1
 imstat in=$font.$stk.cm region='box(6,6,50,122)'
 echo "Press Return to continue"; set nn=$<
end
foreach stk(i q u v)
 imstat in=$font.$stk.cm
end
# --- GAIN CAL
set font=$mm/0854+201
set rms=0.0039
\rm -r $dd/0854+201"_"*sb.vis.cal
uvaver vis=$dd/0854+201"_"lsb.vis.bp.chi.flux out=$dd/0854+201"_"lsb.vis.cal average=5
uvaver vis=$dd/0854+201"_"usb.vis.bp.chi.flux out=$dd/0854+201"_"usb.vis.cal average=5
\rm -r $font.*
invert vis=$dd/0854+201_lsb.vis.cal,$dd/0854+201_usb.vis.cal \
    beam=$font.bm map=$font.i.mp,$font.v.mp \
    imsize=128 cell=0.3 options=mfs,systemp,double stokes=i,v sup=0
clean  map=$font.i.mp beam=$font.bm clean=$font.i.cc out=$font.i.cc
restor map=$font.i.mp beam=$font.bm model=$font.i.cc out=$font.i.cm          
clean  map=$font.v.mp beam=$font.bm clean=$font.v.cc out=$font.v.cc niters=10
restor map=$font.v.mp beam=$font.bm model=$font.v.cc out=$font.v.cm  
cgdisp type=cont,pix labtyp=arcsec,arcsec \
      device=/xs options=full,beambl csize=0,1,0,0 \
      in=$font.v.cm,$font.i.cm \
      slev=a,$rms levs1=-6,-4,-2,2,4,6 \
      region='arcsec,box(-15,-15,15,15)' nxy=1,1
imstat in=$font.v.cm 
echo "Press Return to continue"; set nn=$<
imstat in=$font.i.cm region='box(6,6,50,122)'
maxfit in=$font.i.cm

echo "3c454 Bandpass and pol calibrator"
echo "   Stokes I     Q      U      V"
echo " Peak:  16421  90.7 -335.0  <68.0"
echo " RMS :      8   3.8    4.0   16.8"
echo " Percentage:  0.55%  2.04% <0.41%"
echo "0854+210 Gain calibrator"
echo "   Stokes I      V"
echo " Peak:  4958.0  <15.6"
echo " RMS :    14.9    3.9"
echo " Percentage:   <0.31%"
goto terminate


terminate:
