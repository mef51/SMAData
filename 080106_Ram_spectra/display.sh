#!/bin/bash

uvspec \
	vis=UVDATA/orkl_080106.usb,UVOffsetCorrect/orkl_080106.usb.corrected.slfc \
	device=1/xs \
	interval=9999 \
	options=avall,nobase \
	nxy=1,2 \
	stokes=i,v \
	axis=chan,amp \
	line=chan,48,1,64.0 \
	device=1/xs
	# device=stokesv_64channelaveraging.ps/ps

exit 0

uvspec \
	vis=UVDATA/orkl_080106.usb,UVOffsetCorrect/orkl_080106.usb.corrected.slfc \
	device=1/xs \
	interval=9999 \
	options=avall,nobase \
	nxy=1,2 \
	stokes=v \
	axis=freq,amp \
	line=chan,48,1,64.0 \
	device=2/xs \
	hann=15
	# device=stokesv_64channelaveraging_smooth.ps/ps \

imspec
	in=MAPSCorrect/orkl_080106.co3-2.v.cm \
	region='abspixel,box(75,53,83,63)' \
	device=1/xs \
	axes=spectral \


# rms=0.29

# cgdisp \
# 	type=cont,cont \
# 	in=MAPSCorrect/orkl_080106.co3-2.i.cm,MAPSCorrect/orkl_080106.co3-2.v.cm \
# 	options=full,beambl,3val \
# 	csize=0,1,0,0 \
# 	device=2/xs \
# 	nxy=1,1 \
# 	region='arcsec,box(-15,-15,15,15)' \
# 	chan=43,43 \
	# slev=p,1,a,$rms \
	# levs1=15,35,55,75,95 \
	# levs2=-8,-7,-6,-5,-4,-3,-2,2,3,4,5,6,7,8 \
