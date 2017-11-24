#!/usr/bin/python3

import shutil, glob, os
import miriad
import paperplots

folders = [
	'IRC+10216',
	'080106_Ram_spectra',
	'141028_ngc7538',
	'101014_NGC1333_Ram',
]

sourceTitles = [
	'IRC+10216',
	'Orion KL',
	'NGC7538',
	'IRAS2a'
]

sources = [
	'irc+10216',
	'orkl_080106',
	'NGC7538S-s4',
	'iras2a.aver'
]

# 40, 32
channelsToMerge = [40, 40, 20, 40]
uncorrVisibilities = ['{}.usb'.format(source) for source in sources]
corrVisibilities = ['{}.usb.corrected.slfc'.format(source) for source in sources]
filterMaxPeak = [False, False, True, False]
ylimV = ['separate', None, None, None]
legendlocs = [2,1,1,1]

for i, source in enumerate(sources):
	print(source)
	folder = folders[i]
	title = sourceTitles[i]
	uncorrVisibility = uncorrVisibilities[i]
	corrVisibility = corrVisibilities[i]

	miriad.prthd({
		'in': '../{}/UVOffsetCorrect/{}'.format(folder, corrVisibility)
	})
	continue
	paperplots.compareSpectra(
		'../{}/UVDATA/{}'.format(folder, uncorrVisibility),
		'../{}/UVOffsetCorrect/{}'.format(folder, corrVisibility),
		combineV=channelsToMerge[i],
		filterMaxPeak=filterMaxPeak[i],
		stokesVylim=ylimV[i],
		legendloc=legendlocs[i],
		plotOptions={
			'subtitle': title,
			'filename':'{}.pdf'.format(title),
			'figsize': (16/2,9/2),
		}
	)
