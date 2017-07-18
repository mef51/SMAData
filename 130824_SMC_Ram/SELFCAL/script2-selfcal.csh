#! /bin/csh -f
#
set dt1=130824
set begin=$2
set rx=rx1

set sub="cm"


set source=smc.6
set so="$source"_$dt1
set device="/cps"
set device="/xs"

set gain=0.1
set niters=10000
set options="options=negstop"
set options=""

set imsize=128
set cell=0.4

set regdisp='arcsec,box(-16,-16,16,16)'
set region='arcsec,box(-4,-4,4,4)'
set region=quart
set region=@smc.6.region
set regdisp='arcsec,box(-12,-12,12,12)'
set regdisp='arcsec,box(-16,-16,16,16)'
set regdisp='arcsec,box(-8,-8,8,8)'
set regdisp=quart
set regdisp='im(1)'
set niters=4000

set noisereg='box(8,8,20,120)'

set maxselfcalloops=1
set loopnum=1

set blflag="n"
#set nu=`ps -ef | grep pgx | grep linux | awk '{print $2}'`
#kill $nu

if($#argv<2) then
echo "Incorrect usage: Needs start_pt dt file"
echo "script.csh DISP 060407 06:18:46"
goto terminate
endif

goto $1

INIT:
foreach sb(lsb usb)
\rm -fr $so.$sb
uvcal vis=../$so.$sb out=$so.$sb options=nopol,nocal
\rm -fr $so.$sb.i.cl
cp -r ../$so.$sb.i.cl .
end

\rm -f rms
touch rms

goto terminate

IMSEL:
foreach sb(lsb usb)
\rm -fr $so.$sb.i.model
cp -r $so.$sb.i.cl $so.$sb.i.model
end


foreach sb(lsb usb)

if ($begin == "y") then
\rm -fr $so.$sb.applied
uvcal vis=$so.$sb out=$so.$sb.applied options=nopol 
else
echo "Not starting over"
endif

end

#goto terminate


echo "Iteration " >> rms
while ($loopnum <= $maxselfcalloops)


foreach sb(lsb usb)


\rm -fr $so.$sb.$loopnum
uvcal vis=$so.$sb.applied out=$so.$sb.$loopnum options=nopol

if($begin == "n" ) then
selfcal vis=$so.$sb.$loopnum model=$so.$sb.i.model  interval=6 \
	options=pha,relax refant=6 select='pol(ll,rr)'
else
echo "starting over"
endif

\rm -fr $so.$sb.applied
uvcal vis=$so.$sb.$loopnum out=$so.$sb.applied 
gpcopy vis=../$so.$sb out=$so.$sb.applied options=nocal
end


foreach sb (lsb usb)

\rm -fr $so.$sb.?.mp $so.$sb.bm 
invert vis=$so.$sb.applied  \
       map=$so.$sb.i.mp,$so.$sb.q.mp,$so.$sb.u.mp \
       stokes=i,q,u options=systemp,mfs,double sup=0 imsize=$imsize cell=$cell \
       beam=$so.$sb.bm line=ch,1,1,6144

foreach pol(i q u)
\rm -fr $so.$sb.$pol.cl $so.$sb.$pol.cm
clean map=$so.$sb.$pol.mp beam=$so.$sb.bm $options     \
      out=$so.$sb.$pol.cl region=$region niters=$niters gain=$gain cutoff=0.002
restor map=$so.$sb.$pol.mp beam=$so.$sb.bm \
      out=$so.$sb.$pol.cm model=$so.$sb.$pol.cl
end


set imax=`imhist in=$so.$sb.i.cm device=/xw device=/null | grep Maximum | awk '{printf("%.5f",$3) }'`
set qmax=`imhist in=$so.$sb.q.cm device=/xw device=/null | grep Maximum | awk '{printf("%.5f",$3) }'`
set umax=`imhist in=$so.$sb.u.cm device=/xw device=/null | grep Maximum | awk '{printf("%.5f",$3)}'`
set irms=`imhist in=$so.$sb.i.cm device=/null region=$noisereg | grep and | awk '{printf("%.5f",$3)}'`
set qrms=`imhist in=$so.$sb.q.cm device=/null region=$noisereg | grep and | awk '{printf("%.5f",$3)}'`
set urms=`imhist in=$so.$sb.u.cm device=/null region=$noisereg | grep and | awk '{printf("%.5f",$3)}'`
set snI=`echo $imax $irms | awk '{print $1/$2}'`
set snQ=`echo $qmax $qrms | awk '{print $1/$2}'`
set snU=`echo $umax $urms | awk '{print $1/$2}'`
echo "loopnum = " $loopnum "I = " $imax "+/-" $irms ", snI = " $snI "Q = " $qmax "+/-" $qrms ", snQ = " $snQ "U = " $umax "+/-" $urms ", snU = " $snU>> rms

#echo -n "Do another iteration (y/n)?   "; set ans=$<
#if($ans == "n") then
#goto terminate
#endif


\rm -fr $so.$sb.i.model
cp -r $so.$sb.i.cl $so.$sb.i.model

end

set begin="n"
@ loopnum++
end

goto terminate


terminate:
