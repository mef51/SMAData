#!/bin/bash

# Arrange data into folders UVDATA, UVOffsetCorrect, MAPSCorrect, MAPS
# Dump old scripts into oldscripts
# Copy over the corrections scripts from ../squintscripts/
mkdir {UVDATA,UVOffsetCorrect,MAPS,MAPSCorrect,figures,oldscripts}
mv *.csh oldscripts/
mv {*.usb,*.lsb,} UVDATA/
mv {*.chi,*.aver,*.bp,*.win4} UVDATA/
mv {*.cl,*.cm,*.bm,*.mp,*.pol*} MAPS/
mv *.pa* MAPS/
mv {*.ps,*.png} figures/
cp ../squintscripts/*.py .
cp ../squintscripts/reduceandcorrect.sh .
