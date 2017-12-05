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

uncorrectedMaps = ['{}.usb.uncorrected'.format(source) for source in sources]
correctedMaps = ['{}.usb'.format(source) for source in sources]
line = 'co3-2'
figsize = (8.5, 11)

imspectOptions = [{}, {}, {'hann': 15}, {}]
for peakStokes in ['v']:
	paperplots.plotAllSources(
		['../{}/MAPSCorrect/{}'.format(folders[i], umap) for i, umap in enumerate(uncorrectedMaps)],
		['../{}/MAPSCorrect/{}'.format(folders[i], cmap) for i, cmap in enumerate(correctedMaps)],
		sources,
		peakStokes=peakStokes,
		plotOptions={
			'title': 'All the data in peak Stokes {}'.format(peakStokes.upper()),
			'show': True,
			# 'filename':'{}.map.spec.{}peak{}.pdf'.format(title, line, peakStokes),
			'figsize': figsize,
		},
		imspectOptions=imspectOptions
	)
exit()

figsize = (11,8.5)
peakStokes = 'v'
for peakStokes in ['i', 'v']:
	# IRC+10216
	print(sources[0])
	source = sources[0]
	folder = folders[0]
	title = sourceTitles[0]
	correctedMap = correctedMaps[0]
	uncorrectedMap = uncorrectedMaps[0]
	paperplots.compareMapSpectra(
		'../{}/MAPSCorrect/{}'.format(folder, uncorrectedMap),
		'../{}/MAPSCorrect/{}'.format(folder, correctedMap),
		line,
		['i', 'v'],
		source,
		peakStokes=peakStokes,
		regionWidth=1,
		legendloc=2,
		plotOptions={
			'title': title,
			'filename':'{}.map.spec.{}peak{}.pdf'.format(title, line, peakStokes),
			'figsize': figsize,
		}
	)

	# Orion KL
	print(sources[1])
	source = sources[1]
	folder = folders[1]
	title = sourceTitles[1]
	correctedMap = correctedMaps[1]
	uncorrectedMap = uncorrectedMaps[1]
	paperplots.compareMapSpectra(
		'../{}/MAPSCorrect/{}'.format(folder, uncorrectedMap),
		'../{}/MAPSCorrect/{}'.format(folder, correctedMap),
		line,
		['i', 'v'],
		source,
		peakStokes=peakStokes,
		regionWidth=1,
		legendloc=2 if peakStokes is 'i' else 1,
		plotOptions={
			'title': title,
			'filename':'{}.map.spec.{}peak{}.pdf'.format(title, line, peakStokes),
			'figsize': figsize,
		}
	)

	# NGC7538
	print(sources[2])
	source = sources[2]
	folder = folders[2]
	title = sourceTitles[2]
	correctedMap = correctedMaps[2]
	uncorrectedMap = uncorrectedMaps[2]
	paperplots.compareMapSpectra(
		'../{}/MAPSCorrect/{}'.format(folder, uncorrectedMap),
		'../{}/MAPSCorrect/{}'.format(folder, correctedMap),
		line,
		['i', 'v'],
		source,
		peakStokes=peakStokes,
		regionWidth=5,
		plotOptions={
			'title': title,
			'filename':'{}.map.spec.{}peak{}.pdf'.format(title, line, peakStokes),
			'figsize': figsize,
		},
		imspectOptions={
			'hann': 15,
		}
	)

	# NGC1333 (IRAS2a)
	print(sources[3])
	source = sources[3]
	folder = folders[3]
	title = sourceTitles[3]
	correctedMap = correctedMaps[3]
	uncorrectedMap = uncorrectedMaps[3]
	paperplots.compareMapSpectra(
		'../{}/MAPSCorrect/{}'.format(folder, uncorrectedMap),
		'../{}/MAPSCorrect/{}'.format(folder, correctedMap),
		line,
		['i', 'v'],
		source,
		peakStokes=peakStokes,
		regionWidth=1,
		legendloc=4 if peakStokes is 'v' else 1,
		plotOptions={
			'title': title,
			'filename':'{}.map.spec.{}peak{}.pdf'.format(title, line, peakStokes),
			'figsize': figsize,
		}
	)

# for i, source in enumerate(sources):
# 	print(source)
# 	folder = folders[i]
# 	title = sourceTitles[i]
# 	correctedMap = correctedMaps[i]
# 	uncorrectedMap = uncorrectedMaps[i]
# 	paperplots.compareMapSpectra(
# 		'../{}/MAPSCorrect/{}'.format(folder, uncorrectedMap),
# 		'../{}/MAPSCorrect/{}'.format(folder, correctedMap),
# 		line,
# 		['i', 'v'],
# 		source,
# 		regionWidth=5,
#		peakStokes=peakStokes,
# 		plotOptions={
# 			'title': title,
# 			'filename':'{}.map.spec.{}peak{}.pdf'.format(title, line, peakStokes),
# 			'figsize': figsize,
# 		}
# 	)

# exit()
