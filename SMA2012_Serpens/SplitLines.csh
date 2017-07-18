#! /bin/csh -f
#
setenv LC_NUMERIC en_EN.UTF-8

echo "========================================"
echo "SplitLines.csh CO/SO2_8/SO2_13/SO2_16/H13CO+/SiO"
echo "SMC 1 no CO"
echo "SMC 6 "
echo "SMC 8  no CO, 120525 yes but not ready 120902"
echo "SMC 7  not ready 120526"
echo "SMC 11 not ready 120526"
echo "SMC 15 not ready 120526"
echo -n "Enter the source number: ";set n=$<
echo "---------------------------------------"

set uv=UV_data
set sr=smc
set dia1=120525
set dia2=120526
set dia3=120615
set dia4=120902
set dia5=120903
set edge=5,5

switch ($n)
 case 1:	
set dies=$dia1" "$dia4" "$dia5
 breaksw
 case 6:
set dies=$dia1" "$dia4" "$dia5
 breaksw
 case 8: 
set dies=$dia1
 breaksw
 case 11:
set dies=$dia2
 breaksw
 case 15:
set dies=$dia2
 breaksw
 case 7:
set dies=$dia2
 breaksw
endsw


set LSB='SO2_8'
set USB='SO2_13 SO2_16 H13CO+ SiO'
echo 'Fins aqui'

foreach sel($1)
switch ($sel)
#---- LSB 
 case SO2_8: 	 # 8_2,6-7_1,7 DONE 
  set sb=l; set wn=1; 		set freq=334.67335; 	set lab=so2_826
  set ch=ch,3000,1000,1,1;	set free=1,15,35,50
  set vv=vel,50,-10,0.733,0.733 
 breaksw
 case SO2_4: 	 # 4(3,1)- 3(2,2) DONE ONLY 120525
  set sb=l; set wn=1; 		set freq=332.50524; 	set lab=so2_413
  set ch=ch,4100,2000,1,1;	set free=1,15,35,50
  set vv=vel,50,-10,0.733,0.733 
 breaksw
 case Met7: 	 # 7_1,7-6_1,6 DONE
  set sb=l; set wn='5,6';  	set freq=335.58200; 	set lab=ch3oh717
  set ch=ch,3000,1,1,1;		set free=1,15,35,50
  set vv=vel,50,-10.0,0.726,0.726
 breaksw
 case HDCO: 	 # 5( 1, 4)- 4( 1, 3) DONE
  set sb=l; set wn='5,6';  	set freq=335.09678; 	set lab=hdco
  set ch=ch,3000,501,1,1;		set free=1,16,62,75
  set vv=vel,75,-10.0,0.727,0.727
 breaksw
#--- USB
 case H15CN:	# 4-3 DONE ONLY 120525
  set sb=u; set wn='1,2';  	set freq=344.20011; 	set lab=h15cn43
  set ch=ch,2000,1,1,1;		set free=1,15,35,50
  set vv=vel,50,-10.0,0.708,0.708
 breaksw
 case CO:	# CO 3-2	DONE
  set sb=u; set wn=1;	set freq=345.7959	;set lab=co32
  set ch=ch,5000,1000,1,1;set free=1,20,80,100
  set vv=vel,100,-63,1.404,1.404   
 breaksw	
 case H13CN:		#  4-3 El= 24.9 K 345.33976
  set sb=u; 			set freq=345.33976;	set lab=h13cn43
  set ch=ch,2000,100,1,1;		set free=1,13,37,50
  set vv=vel,50,-10,0.73,0.73
 breaksw
 case SO2_13:		# 13_2,12-12_1,11 NO! It's H13CN 4-3 345.33976
  set sb=u; 			set freq=345.33851;	set lab=so2_13212
  set ch=ch,4000,1,1,1;		set free=1,12,41,50
  set vv=vel,50,-10,0.73,0.73
 breaksw
 case SO:		# SO 98-87
  set sb=u; set wn=2;	set freq=346.52848;	set lab=so_9887
  set ch=ch,3500,2000,1,1; set free=1,10,43,55
  set vv=vel,55,-10.0,0.703,0.703 
 breaksw
 case SO2_19:	 	# 19_1,19-18_0,18 DONE
  set sb=u; 			set freq=346.65217;	set lab=so2_19t18
  set ch=ch,4000,1000,1,1;	set free=1,15,35,50
  set vv=vel,55,-10,0.703,0.703
 breaksw
 case H13CO+:	# H13CO+ 4-3 DONE
  set sb=u; set wn=2; 	set freq=346.99834;	set lab=h13co+43
  set ch=ch,4000,2000,1,1;set free=1,25,55,70
  set vv=vel,55,-10,0.702,0.702 
 breaksw
 case SiO:	# 8-7 DONE
  set sb=u; set wn=2;	set freq=347.33082;	set lab=sio87
  set ch=ch,3000,3100,1,1;set free=1,35,165,200
  set vv=vel,200,-120,1.404,1.404 
endsw

foreach dd($dies)
set vis=$uv/smc.$n.$dd.line.$sb'sb'
\rm -fr tmp.* 
uvaver  vis=$vis out=tmp.1 line=$ch 
#uvflag  vis=tmp.1  flagval=f edge=$edge
uvputhd vis=tmp.1  out=tmp.2  hdvar=restfreq  varval=$freq
uvredo  vis=tmp.2  out=tmp.3  options=velocity 
uvlist  vis=tmp.3 options=spec
echo 'Return ';set rr=$<
uvaver  vis=tmp.3  out=tmp.4 line=$vv
uvlist  vis=tmp.4 options=spec
smauvspec vis=tmp.4 device=1/xs interval=1e9 stokes=i \
     axis=dfreq,both nxy=11
echo 'Return ';set rr=$<
\rm -rf $uv/smc.$n.$dd.$lab.lf 
uvlin vis=tmp.4 out=$uv/smc.$n.$dd.$lab.lf \
      chans=$free mode=line order=0
echo $dd'   '$lab' '$n
smauvspec vis=$uv/smc.$n.$dd.$lab.lf device=1/xs interval=1e11 \
     stokes=i axis=ch,both nxy=2,1
gpcopy vis=$uv/smc.$n.$dd.$sb'sb' out=$uv/smc.$n.$dd.$lab.lf 
end

end

goto fi
fi:
