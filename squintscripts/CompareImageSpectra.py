#!/usr/bin/python3

import shutil, glob, os
import paperplots

folders = [
	'IRC+10216',
	'OrionKL',
	'NGC7538',
	'NGC1333',
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

correctedMaps = ['{}.usb'.format(source) for source in sources]
uncorrectedMaps = ['{}.usb.uncorrected'.format(source) for source in sources]
line = 'co3-2'

for i, source in enumerate(sources):
	print(source)
	folder = folders[i]
	title = sourceTitles[i]
	correctedMap = correctedMaps[i]
	uncorrectedMap = uncorrectedMaps[i]
	paperplots.compareMapSpectra(
		'../{}/MAPSCorrect/{}'.format(folder, uncorrectedMap),
		'../{}/MAPSCorrect/{}'.format(folder, correctedMap),
		line,
		['i', 'v'],
		source,
		plotOptions={
			'subtitle': title,
			'filename':'{}.map.pdf'.format(title),
			'figsize': (16/2,9/2),
		}
	)

exit()
paperplots.compareMapSpectra(
	'../{}/MAPSCorrect/{}'.format(folder, uncorrectedMap),
	'../{}/MAPSCorrect/{}'.format(folder, correctedMap),
	line,
	['i', 'v'],
	source,
	plotOptions={
		'subtitle': title,
		'filename':'{}.map.pdf'.format(title),
		'figsize': (16/2,9/2),
	}
)
