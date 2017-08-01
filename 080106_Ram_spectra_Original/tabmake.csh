#!/bin/csh -f
#
set so="orkl_080106"
goto $1

start:
foreach type ( i )
\rm -fr tab.im
cp -r $so.$type.cm tab.im
\rm -f tab.im/mask
imtab in=tab.im region='arcsec,box(-10,-10,10,10)' mode=nemo format='(f6.2,5x,f6.2,5x,f7.4)' | tail +3 | grep -v 'Found'  >! "$type".txt
end

foreach type ( q u )
\rm -fr tab.im
cp -r $so.$type.cm tab.im
\rm -f tab.im/mask
imtab in=tab.im region='arcsec,box(-10,-10,10,10)' mode=nemo format='(f6.2,5x,f6.2,5x,f7.4)' | tail +3 | grep -v 'Found' | awk '{print $3}' >! "$type".txt
end

foreach type ( poli polierr polm polmerr pa paerr)
\rm -fr tab.im
cp -r $so.$type tab.im
\rm -f tab.im/mask
imtab in=tab.im region='arcsec,box(-10,-10,10,10)' mode=nemo format='(f6.2,5x,f6.2,5x,f10.5)' | tail +3 | grep -v 'Found' | awk '{print $3}' >! "$type".txt
end

paste i.txt q.txt u.txt poli.txt polierr.txt pa.txt paerr.txt polm.txt polmerr.txt | awk '{printf("%8.2f %8.2f %8.3f %8.3f %8.3f %8.3f %8.3f %9.2f %9.2f %8.3f %8.3f\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)}' >! tabledata.txt
paste i.txt q.txt u.txt poli.txt polierr.txt pa.txt paerr.txt polm.txt polmerr.txt | awk '{if($6 >0.0001) {printf("%8.2f %8.2f %8.3f %8.3f %8.3f %8.3f %8.3f %9.2f %9.2f %8.3f %8.3f\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)}}' >! tabledatacut.txt

goto terminate

mkt:
# for source A
#6.8434 -0.0348495 -0.0109144 0.0365187 0.00533633 -81.2946
echo "Stokes I, Q, U, P=sqrt(Q^2+U^2), m=p/I, PA"
echo "Totals for source A"
#set sourceAvals=`awk 'BEGIN{m=3.22;c=7.34} {x=$1; y=$2; s=m*x+c; if(s>y) {print $0}}' < tabledatacut.txt | awk 'BEGIN{icut=0.1;npts=0;sigi=0.01;sigq=0.004;beam=3.2*1.8/0.09} {if($3>icut) {npts+=1;sI+=$3;sQ+=$4;sU+=$5}} END{sqrn=sqrt(npts);print sI/beam, sQ/beam, sU/beam, sqrt(sQ*sQ+sU*sU)/beam, 100.0*sqrt(sQ*sQ+sU*sU)/sI,90.0/3.142*atan2(sU,sQ),sigi*sqrn, sigq*sqrn, sqrn*100.0*sigq/sI, sqrn*90/3.142*sigq/sqrt(sQ*sQ+sU*sU),npts}' `
set sourceAvals=`awk 'BEGIN{m=1.55;c=5.19} {x=$1; y=$2; s=m*x+c; if(s>y) {print $0}}' < tabledatacut.txt | awk 'BEGIN{icut=0.1;npts=0;sigi=0.01;sigq=0.004;beam=3.2*1.8/0.09} {if($3>icut) {npts+=1;sI+=$3;sQ+=$4;sU+=$5}} END{sqrn=sqrt(npts);print sI/beam, sQ/beam, sU/beam, sqrt(sQ*sQ+sU*sU)/beam, 100.0*sqrt(sQ*sQ+sU*sU)/sI,90.0/3.142*atan2(sU,sQ),sigi*sqrn, sigq*sqrn, sqrn*100.0*sigq/sI, sqrn*90/3.142*sigq/sqrt(sQ*sQ+sU*sU),npts}' `
echo $sourceAvals
awk 'BEGIN{m=1.55;c=5.19} {x=$1; y=$2; s=m*x+c; if(s>y) {print $0}}' < tabledatacut.txt >! tabledatacut-A.txt


# for source B
#5.24198 0.0494792 0.059919 0.0777076 0.0148241 25.2223
echo "Totals for source B"
#set sourceBvals=`awk 'BEGIN{m=3.22;c=7.34} {x=$1; y=$2; s=m*x+c; if(s<y) {print $0}}' < tabledatacut.txt | awk 'BEGIN{icut=0.1;npts=0;sigi=0.01;sigq=0.004;beam=3.2*1.8/0.09} {if($3>icut) {npts+=1;sI+=$3;sQ+=$4;sU+=$5}} END{sqrn=sqrt(npts);print sI/beam, sQ/beam, sU/beam, sqrt(sQ*sQ+sU*sU)/beam, 100.0*sqrt(sQ*sQ+sU*sU)/sI,90.0/3.142*atan2(sU,sQ),sigi*sqrn, sigq*sqrn, sqrn*100.0*sigq/sI, sqrn*90/3.142*sigq/sqrt(sQ*sQ+sU*sU),npts}'`
set sourceBvals=`awk 'BEGIN{m=1.55;c=5.19} {x=$1; y=$2; s=m*x+c; if(s<y) {print $0}}' < tabledatacut.txt | awk 'BEGIN{icut=0.1;npts=0;sigi=0.01;sigq=0.004;beam=3.2*1.8/0.09} {if($3>icut) {npts+=1;sI+=$3;sQ+=$4;sU+=$5}} END{sqrn=sqrt(npts);print sI/beam, sQ/beam, sU/beam, sqrt(sQ*sQ+sU*sU)/beam, 100.0*sqrt(sQ*sQ+sU*sU)/sI,90.0/3.142*atan2(sU,sQ),sigi*sqrn, sigq*sqrn, sqrn*100.0*sigq/sI, sqrn*90/3.142*sigq/sqrt(sQ*sQ+sU*sU),npts}'`
echo $sourceBvals
awk 'BEGIN{m=1.55;c=5.19} {x=$1; y=$2; s=m*x+c; if(s<y) {print $0}}' < tabledatacut.txt >! tabledatacut-B.txt

echo "Totals for IRAS 16293 A and B"
(echo $sourceAvals ; echo $sourceBvals) | awk '{sI+=$1;sQ+=$2;sU+=$3} END{print sI, sQ, sU, sqrt(sQ*sQ+sU*sU), sqrt(sQ*sQ+sU*sU)/sI, 90.0/3.142*atan2(sU,sQ)}'

set bothvals=`awk 'BEGIN{icut=0.1;npts=0;sigi=0.01;sigq=0.004;beam=3.2*1.8/0.09} {if($3>icut) {npts+=1;sI+=$3;sQ+=$4;sU+=$5}} END{sqrn=sqrt(npts);print sI/beam, sQ/beam, sU/beam, sqrt(sQ*sQ+sU*sU)/beam, 100.0*sqrt(sQ*sQ+sU*sU)/sI,90.0/3.142*atan2(sU,sQ),sigi*sqrn, sigq*sqrn, sqrn*100.0*sigq/sI, sqrn*90/3.142*sigq/sqrt(sQ*sQ+sU*sU),npts}' < tabledatacut.txt`
echo $bothvals

goto terminate

listab:
set cell=0.3
awk -v cell=$cell '{x=$1;y=$2; xabs=(x**2.0)**0.5; yabs=(y**2.0)**0.5; xi=int(xabs/3.0*cell);yi=int(yabs/5.0*cell); xdiff=xabs-xi*3.0*cell ; ydiff=yabs-yi*5.0*cell; if((xdiff<0.1) && (ydiff<0.1)) {print $0}}' < tabledatacut.txt >! tabpap.txt

vecolay:
set legx=10 ;  set legy=10; set legpolm=0.05
awk -v legx=$legx -v legy=$legy -v legpolm=0.05 'BEGIN{f=16.0;pi=3.14159;dtor=pi/180.0;rtod=1.0/dtor; printf("line arcsec arcsec id no %8.3f %8.3f %8.3f %8.3f\n",legx+f*legpolm,legy,legx-f*legpolm,legy);printf("clear arcsec arcsec 5%% yes %8.3f %8.3f\n",legx-f*(legpolm+0.05),legy)} {x=$1;y=$2;i=$3;q=$4;u=$5;poli=$6;sq=$7;polm=$10;polmerr=$11;pa=dtor*(90.0-$8);paerr=$9; x1=x-f*polm*cos(pa); x2=x+f*polm*cos(pa); y1=y-f*polm*sin(pa); y2=y+f*polm*sin(pa); printf("line arcsec arcsec id no %8.3f %8.3f %8.3f %8.3f\n", x1, y1, x2, y2)}' < tabpap.txt >! olayefield.txt

awk -v legx=$legx -v legy=$legy -v legpolm=0.05 'BEGIN{f=16.0;pi=3.14159;dtor=pi/180.0;rtod=1.0/dtor; printf("line arcsec arcsec id no %8.3f %8.3f %8.3f %8.3f\n",legx+f*legpolm,legy,legx-f*legpolm,legy);printf("clear arcsec arcsec 5_%% yes %8.3f %8.3f\n",legx-f*(legpolm+0.08),legy)} {x=$1;y=$2;i=$3;q=$4;u=$5;poli=$6;sq=$7;polm=$10;polmerr=$11;pa=dtor*(-$8);paerr=$9; x1=x-f*polm*cos(pa); x2=x+f*polm*cos(pa); y1=y-f*polm*sin(pa); y2=y+f*polm*sin(pa); printf("line arcsec arcsec id no %8.3f %8.3f %8.3f %8.3f\n", x1, y1, x2, y2)}' < tabpap.txt >! olaybfield.txt

tablems:
awk 'BEGIN{} {x=$1;y=$2;i=$3;q=$4;u=$5;poli=1000.0*$6;sq=$7;polm=100.0*$10;polmerr=100.0*$11;pa=$8;paerr=$9;  printf("%8.3f & %8.3f & %8.3f & %4.0f & %6.1f$\\pm$%.1f & %8.1f$\\pm$%.1f \\\\ \n", x, y, i, poli, polm, polmerr, pa, paerr)}' < tabpap.txt >! tablems-1.txt


p-vs-I:
awk '{print $3, $10, $11}' < tabledatacut-A.txt > ! data.txt
echo "15 0.0 4.5" | ~/PAPERS/iras16293/progs/bin/bindata > ! A-bin.txt
awk '{print $3, $10, $11}' < tabledatacut-B.txt > ! data.txt
echo "15 0.0 4.5" | ~/PAPERS/iras16293/progs/bin/bindata > ! B-bin.txt
awk '{print $3, $10, $11}' < tabledatacut.txt > ! data.txt
echo "15 0.0 4.5" | ~/PAPERS/iras16293/progs/bin/bindata > ! all-bin.txt
gnuplot p-vs-I.gp
ps2epsi p-vs-I.ps ~/PAPERS/iras16293/p-vs-I.eps


terminate:
