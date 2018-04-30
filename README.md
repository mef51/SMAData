Squint Scripts
========

The scripts in squintscripts/ are used to perform the squint correction on the Submillimeter Array's data that has already been reduced and calibrated. This is done to remove spurious Stokes V signals. Used to obtain the results presented in Chamma et al. 2018 (in prep).

A simple custom Miriad wrapper is used that allows scripting in python and that wrapper can be found here:
https://github.com/mef51/smautils

Copy these scripts into a folder with reduced miriad data to correct for LL and RR beam squint.
The following tree is assumed inside the miriad datafolder:
/data/
	/data/MAPS/             -- maps, uncorrected for beam squint, produced by MapCont.py and MapLines.py
	/data/MAPSCorrect/      -- maps, produced by Correct_RR_LL_offset.py
	/data/UVDATA/           -- the visibility data, produced usually by idl2miriad or downloaded from the SMA archive
	/data/UVOffsetCorrect/  -- the corrected visibility data, produced by Correct_RR_LL_offset.py
	SplitCont.py            -- script that splits the continuum from lines for `selfcal`
	SplitLines.py           -- script that splits the line from continuum for integrated maps
	MapCont.py              -- script that maps the uncorrected continuum
	MapLines.py             -- script that maps the uncorrected lines
	Correct_RR_LL_offset.py -- script that corrects the visibilities using `selfcal` on the continuum then maps everything
