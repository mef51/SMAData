#!/bin/bash

./SplitCont.csh USB
./SplitLines.csh CO
./SplitLines.csh SiO
./MapCont.csh USB MAP
./MapLines.csh CO MAPS
./MapLines.csh SiO MAPS
./Correct_RR_LL_offset.csh SPLIT
./Correct_RR_LL_offset.csh SELFCAL
./Correct_RR_LL_offset.csh MAP
./Correct_RR_LL_offset.csh DISP

echo 'figures:'
ls *.ps
echo 'Done.'
