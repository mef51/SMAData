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
annotsize = 20

# orion Kl sio plot
# sio8-7.full.v.cm has peak at 124, 75
# sio8-7.v.cm has peak at 122, 10
line = 'sio8-7'
peakStokes = 'v'
idx = 0
sioMaxFitOptions = {
	'options': 'abs'
}

siodata = exec(open('siodata.snip.py').read())

paperplots.compareMapSpectra(
	'../{}/MAPSCorrect/{}'.format(folders[idx], uncorrectedMaps[idx]),
	'../{}/MAPSCorrect/{}'.format(folders[idx], correctedMaps[idx]),
	line,
	['i', 'v'],
	sources[idx],
	peakStokes=peakStokes,
	regionWidth=1,
	legendloc=1,
	useFull=False,
	plotOptions={
		'title': sourceTitles[idx],
		'filename':'{}.map.spec.{}peak{}.pdf'.format(sourceTitles[idx], line, peakStokes),
		'figsize': figsize,
		'text': [{'x':345.9, 'y': 3, 's':'CO $(J=3 \\rightarrow 2)$', 'fontsize':annotsize},
				 {'x':347.08, 'y': 0.45, 's':'SiO $(J=8 \\rightarrow 7)$', 'fontsize':annotsize}],
	},
	maxfitOptions=sioMaxFitOptions,
	data=siodata
)
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
			'text': [{'x':345.85, 'y': 7.8, 's':'CO $(J=3 \\rightarrow 2)$', 'fontsize':annotsize},
					 {'x':346.57, 'y': 5.8, 's':'(blended lines)', 'fontsize':annotsize},
					 {'x':347.05, 'y': 3, 's':'SiO $(J=8 \\rightarrow 7)$', 'fontsize':annotsize}],
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
			'text': {'x':345.9, 'y': 2.5, 's':'CO $(J=3 \\rightarrow 2)$', 'fontsize':annotsize},
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
		legendloc=2,
		plotOptions={
			'title': title,
			'filename':'{}.map.spec.{}peak{}.pdf'.format(title, line, peakStokes),
			'figsize': figsize,
			'text': [{'x':345.58, 'y': 1.35, 's':'CO $(J=3 \\rightarrow 2)$', 'fontsize':annotsize},
					 {'x':342.55, 'y': 0.3, 's':'CS $(J=7 \\rightarrow 6)$', 'fontsize':annotsize},
					 {'x':344.1, 'y': 1.9, 's':'SiS $(J=19 \\rightarrow 18)$', 'fontsize':annotsize},
					 {'x':345.43, 'y': 2.5, 's':'H$^{13}$CN $(J=4 \\rightarrow 3)$', 'fontsize':annotsize}],
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
		legendloc=4 if peakStokes is 'v' else 1,
		plotOptions={
			'title': title,
			'filename':'{}.map.spec.{}peak{}.pdf'.format(title, line, peakStokes),
			'figsize': figsize,
			'text': {'x':345.85, 'y': -0.3, 's':'CO $(J=3 \\rightarrow 2)$', 'fontsize':annotsize},
			# 'ylabelpad':20
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
			'title': 'Stokes V Spectra before and after squint correction'.format(peakStokes.upper()),
			'show': False,
			'filename':'stokesv.map.spec.{}peak{}.pdf'.format(line, peakStokes),
			'figsize': figsize,
		},
		imspectOptions=imspectOptions
	)
