#!/usr/bin/python3

import shutil, glob, os
import miriad

sources = [
	# 'IRC+10216_Part1',
	# 'IRC+10216_Part2',
	'Orion KL',
	'NGC7538',
	'IRAS2a'
]

folders = [
	# 'IRC+10216',
	# 'IRC+10216',
	'080106_Ram_spectra',
	'141028_ngc7538',
	'101014_NGC1333_Ram',
]

uncorrVisibilities = [
	# 'irc+10216_usb.vis.uvcal',
	# 'irc+10216_lsb.vis.uvcal',
	'orkl_080106.usb',
	'NGC7538S-s4.usb',
	'iras2a.aver.usb'
]

corrVisibilities = [
	# 'irc+10216.usb.corrected.slfc',
	# 'irc+10216.lsb.corrected.slfc',
	'orkl_080106.usb.corrected.slfc',
	'NGC7538S-s4.usb.corrected.slfc',
	'iras2a.aver.usb.corrected.slfc'
]

for i, source in enumerate(sources):
	print(source)
	folder = folders[i]
	uncorrVisibility = uncorrVisibilities[i]
	corrVisibility = corrVisibilities[i]
	miriad.compareSpectra(
		'../{}/UVDATA/{}'.format(folder, uncorrVisibility),
		'../{}/UVOffsetCorrect/{}'.format(folder, corrVisibility),
		combineV=20,
		# filterMaxPeak=True,
		plotOptions={
			'subtitle': source,
			'filename':'{}.pdf'.format(source),
			'figsize': (16/2,9/2),
		}
	)
