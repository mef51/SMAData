#!/usr/bin/python3

import miriad

miriad.compareSpectra(
	'UVDATA/NGC7538S-s4.usb',
	'UVOffsetCorrect/NGC7538S-s4.usb.corrected.slfc',
	combineV=20,
	filterMaxPeak=True,
	plotOptions={
		'subtitle': 'NGC7538',
		'filename':'NGC7538S-s4.pdf',
		'figsize': (16/2,9/2),
	}
)
