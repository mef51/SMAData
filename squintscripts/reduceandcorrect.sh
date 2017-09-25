#!/bin/bash

./SplitCont.py
read -p "SplitCont.py finished. Press return to continue"
./SplitLines.py
read -p "SplitLines.py finished. Press return to continue"
./MapCont.py
read -p "MapCont.py finished. Press return to continue"
./MapLines.py
read -p "MapLines.py finished. Press return to continue"
./Correct_RR_LL_offset.py

echo 'figures:'
ls *.ps
echo 'Done.'
