#!/usr/bin/python3

import miriad

# Stokes V
miriad.compareSpectra(
	'UVDATA/NGC7538S-s4.usb',
	'UVOffsetCorrect/NGC7538S-s4.usb.corrected.slfc',
	combine=20,
	options={'stokes': 'v'},
	plotOptions={
		'title': 'NGC7538 Stokes V: Uncorrected vs. Corrected',
		'filename':'NGC7538S-s4CompareV.pdf',
		'figsize': (16/2,9/2),
	}
)

# Stokes I
miriad.compareSpectra(
	'UVDATA/NGC7538S-s4.usb',
	'UVOffsetCorrect/NGC7538S-s4.usb.corrected.slfc',
	combine=1,
	options={'stokes': 'i'},
	plotOptions={
		'title': 'NGC7538 Stokes I: Uncorrected vs. Corrected',
		'filename':'NGC7538S-s4CompareI.pdf',
		'figsize': (16/2,9/2),
	}
)
