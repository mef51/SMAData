#!/usr/bin/python3

import shutil, glob, os
import paperplots

folders = [
	'OrionKL',
	'NGC7538',
	'IRC+10216',
	'NGC1333',
]

sourceTitles = [
	'Orion KL',
	'NGC7538',
	'IRC+10216',
	'IRAS2a'
]

sources = [
	'orkl_080106',
	'NGC7538S-s4',
	'irc+10216',
	'iras2a.aver'
]

uncorrectedMaps = ['{}.usb.uncorrected'.format(source) for source in sources]
correctedMaps = ['{}.usb'.format(source) for source in sources]
figsize = (11,8.5)

# orion Kl sio plot
# line = 'co3-2'
# peakStokes = 'v'
# idx = 0
# paperplots.compareMapSpectra(
# 	'../{}/MAPSCorrect/{}'.format(folders[idx], uncorrectedMaps[idx]),
# 	'../{}/MAPSCorrect/{}'.format(folders[idx], correctedMaps[idx]),
# 	line,
# 	['i', 'v'],
# 	sources[idx],
# 	peakStokes=peakStokes,
# 	regionWidth=1,
# 	legendloc=2,
# 	plotOptions={
# 		'title': sourceTitles[idx],
# 		'filename':'{}.map.spec.{}peak{}.pdf'.format(sourceTitles[idx], line, peakStokes),
# 		'figsize': figsize,
# 	}
# )
# exit()

line = 'co3-2'
for peakStokes in ['v']:
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
		legendloc=1,
		plotOptions={
			'title': title,
			'filename':'{}.map.spec.{}peak{}.pdf'.format(title, line, peakStokes),
			'figsize': figsize,
		}
	)

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
		legendloc=1 if peakStokes is 'i' else 1,
		useFull=False,
		plotOptions={
			'title': title,
			'filename':'{}.map.spec.{}peak{}.notfull.pdf'.format(title, line, peakStokes),
			'figsize': figsize,
		},
		imspectOptions={
			'hann': 15,
		}
	)

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
	)

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
		legendloc=1 if peakStokes is 'v' else 1,
		plotOptions={
			'title': title,
			'filename':'{}.map.spec.{}peak{}.pdf'.format(title, line, peakStokes),
			'figsize': figsize,
		}
	)

# exit()
figsize = (8.5, 11)
imspectOptions = [{}, {}, {'hann':1}, {}]
for peakStokes in ['v']:
	paperplots.plotAllSources(
		['../{}/MAPSCorrect/{}'.format(folders[i], umap) for i, umap in enumerate(uncorrectedMaps)],
		['../{}/MAPSCorrect/{}'.format(folders[i], cmap) for i, cmap in enumerate(correctedMaps)],
		sources,
		peakStokes=peakStokes,
		plotOptions={
			'title': 'Stokes V Map Spectra before and after squint correction'.format(peakStokes.upper()),
			'show': True,
			'filename':'stokesv.map.spec.{}peak{}.pdf'.format(line, peakStokes),
			'figsize': figsize,
		},
		imspectOptions=imspectOptions
	)
