#! /bin/csh
set source=$1
set date=$2

set so="$source""_""$date"
echo  "rx_pair noiseq noiseu    avg  Peak_I"

echo "All data "
set noiseq=`imhist in=$so.q.mp device=/null region='box(16,16,128,480)' | grep and | awk '{printf("%.1f\n", 1000.0*$3)}'`
set noiseu=`imhist in=$so.u.mp device=/null region='box(16,16,128,480)' | grep and | awk '{printf("%.1f\n", 1000.0*$3)}'`
set imax=`imhist in=$so.i.cm device=/null region='quart'  | grep Maximum |  awk '{printf("%.1f\n", 1000.0*$3)}'`
echo $noiseq $noiseu $imax | awk '{printf("%7.1f %7.1f %7.1f %7.1f\n",$1, $2, 0.5*($1+$2), $3)}'
