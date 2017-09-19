#!/bin/bash

./SplitCont.py
./SplitLines.py
# ./MapCont.py USB MAP
# ./MapLines.py CO MAPS
# ./MapLines.py SiO MAPS
# ./Correct_RR_LL_offset.py SPLIT
# ./Correct_RR_LL_offset.py SELFCAL
# ./Correct_RR_LL_offset.py MAP
# ./Correct_RR_LL_offset.py DISP

echo 'figures:'
ls *.ps
echo 'Done.'
