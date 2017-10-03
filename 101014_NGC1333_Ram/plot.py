#!/usr/bin/python3

import miriad

miriad.compareSpectra(
	'UVDATA/iras2a.aver.usb',
	'UVOffsetCorrect/iras2a.aver.usb.corrected.slfc',
	combineV=20,
	plotOptions={
		'title': 'IRAS2a',
		'filename':'IRAS2a.pdf',
		'figsize': (16/2,9/2),
	}
)
