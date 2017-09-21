#!/bin/bash

./SplitCont.py
./SplitLines.py
./MapCont.py
./MapLines.py
./Correct_RR_LL_offset.py

echo 'figures:'
ls *.ps
echo 'Done.'
