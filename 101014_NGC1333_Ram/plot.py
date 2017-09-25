#!/usr/bin/python3

import miriad

# Stokes V
miriad.compareSpectra(
	'UVDATA/iras2a.aver.usb',
	'UVOffsetCorrect/iras2a.aver.usb.corrected.slfc',
	combine=80,
	options={'stokes': 'v'},
	plotOptions={
		'title': 'IRAS2a Stokes V: Uncorrected vs. Corrected',
		'filename':'IRAS2aCompareV.pdf',
		'figsize': (16/2,9/2),
	}
)

# Stokes I
miriad.compareSpectra(
	'UVDATA/iras2a.aver.usb',
	'UVOffsetCorrect/iras2a.aver.usb.corrected.slfc',
	combine=1,
	options={'stokes': 'i'},
	plotOptions={
		'title': 'IRAS2a Stokes I: Uncorrected vs. Corrected',
		'filename':'IRAS2aCompareI.pdf',
		'figsize': (16/2,9/2),
	}
)
