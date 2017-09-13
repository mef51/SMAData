#!/bin/bash

# Arrange data into folders UVDATA, UVOffsetCorrect, MAPSCorrect, MAPS
mkdir {UVDATA,UVOffsetCorrect,MAPS,MAPSCorrect,figures}
mv {*.usb,*.lsb,} UVDATA/
mv {*.chi,*.aver,*.bp,*.win4} UVDATA/
mv {*.cl,*.cm,*.bm,*.mp,*.pol*} MAPS/
mv *.pa* MAPS/
mv {*.ps,*.png} figures/
