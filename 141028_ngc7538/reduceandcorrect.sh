#!/bin/bash

./SplitCont.py USB
# ./SplitLines.py CO
# ./SplitLines.py SiO
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
