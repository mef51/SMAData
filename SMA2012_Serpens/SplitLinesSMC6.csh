#! /bin/csh -f
#
setenv LC_NUMERIC en_EN.UTF-8

echo "========================================"
echo "SplitLines.csh LSB /USB ONLY"
echo "---------------------------------------"

# LSB  120903 & 120902 : 332.863-336.743 ; 120525 332.157-336.036  R: 332.870-336.030
# USB  120903 & 120902 : 344.760-348.639 ; 120525 344.050-347.933  R: 344.760-347.933
set uv=UV_data
set sr=smc;set n=6
set dia1=120525
set dia2=120526
set dia3=120615
set dia4=120902
set dia5=120903
set edge=5,5

set dies=$dia1" "$dia4" "$dia5
foreach dd($dies)
switch ($dd)
 case 120525:	
set wlsb='40,41,42,43,44,45,46,47,48' 	# LSB
set wusb='1,2,3,4,5,6,7,8' 		# USB
 breaksw
 case 120902:		
set wlsb='1,2,3,4,5,6,7,8' 		# LSB
set wusb='42,43,44,45,46,47,48' 	# USB
 breaksw
 case 120903: 
set wlsb='1,2,3,4,5,6,7,8' 		# LSB
set wusb='42,43,44,45,46,47,48' 	# USB
 breaksw
endsw

foreach sel($1)
#foreach sel($LSB $USB)
switch ($sel)
#---- All overlapped LSB 
 case LSB:
  set wn='-win('$wlsb')'
  set sb=l; set freq=334.5000; set lab=lsb
  set ch=vel,500,-1100,5.0,5.0;    set free=10,150,350,490
 breaksw
#---- All overlapped USB  some uncoveed channels
 case USB:
  set wn='-win('$wusb')'
  set sb=u; set freq=346.5000; set lab=usb
  set ch=vel,500,-1100,5.0,5.0;    set free=10,100,400,490 
 breaksw
endsw

set vis=$uv/smc.$n.$dd.line.$sb'sb'
\rm -fr tmp.* 
#uvaver  vis=$vis out=tmp.1 select=$wn 
uvaver  vis=$vis out=tmp.1 
#uvflag  vis=tmp.1  flagval=f edge=$edge
uvputhd vis=tmp.1  out=tmp.2  hdvar=restfreq  varval=$freq
uvredo  vis=tmp.2  out=tmp.3  options=velocity 
uvlist  vis=tmp.3 options=spec
#echo 'Return ';set rr=$<
uvaver  vis=tmp.3  out=tmp.4 line=$ch
uvlist  vis=tmp.4 options=spec
smauvspec vis=tmp.4 device=1/xs interval=1e9 stokes=i \
     axis=dfreq,both nxy=1,1
echo 'Return ';set rr=$<
\rm -rf $uv/smc.$n.$dd.$lab.lf 
uvlin vis=tmp.4 out=$uv/smc.$n.$dd.$lab.lf \
      chans=$free mode=line order=0
echo $dd'   '$lab' '$n
smauvspec vis=$uv/smc.$n.$dd.$lab.lf device=1/xs interval=1e11 \
     stokes=i axis=ch,both nxy=1,2
gpcopy vis=$uv/smc.$n.$dd.$sb'sb' out=$uv/smc.$n.$dd.$lab.lf 
end

end

goto fi
fi:
