#!/usr/bin/python3

import shutil, glob, os
import miriad

folders = [
	'IRC+10216',
	'080106',
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

correctedMaps = ['{}.usb'.format(source) for source in sources]
uncorrectedMaps = ['{}.usb.uncorrected'.format(source) for source in sources]

for i, source in enumerate(sources):
	print(source)
	folder = folders[i]
	title = sourceTitles[i]
	correctedMap = correctedMaps[i]
	uncorrectedMap = uncorrectedMaps[i]
	miriad.compareMapSpectra(
		'../{}/MAPSCorrect/{}'.format(folder, uncorrectedMap),
		'../{}/MAPSCorrect/{}'.format(folder, correctedMap),
		'v',
		source,
		plotOptions={
			'subtitle': title,
			'filename':'{}.map.pdf'.format(title),
			'figsize': (16/2,9/2),
		}
	)
