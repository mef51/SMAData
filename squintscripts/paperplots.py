#!/usr/bin/python3

import miriad
import plawt
import subprocess

def compareSpectra(visUncorrected, visCorrected,
	combineI=1,
	combineV=10,
	plotOptions={},
	stokesVylim=None,
	stokesIylim=None,
	legendloc=1,
	filterMaxPeak=False):
	"""
	Compare spectra utility.
	Three panel plot with Stokes I, stokes V uncorrected and Stokes V corrected

	combine: the number of velocity channels to average together
	"""
	miriadDefaults = {
		'options': 'avall,nobase',
		'axis': 'freq,amp',
		'interval': 9999,
	}

	optionsI = {**miriadDefaults, **{'stokes': 'i', 'line':miriad.averageVelocityLine(visUncorrected, factor=combineI)}}
	optionsV = {**miriadDefaults, **{'stokes': 'v', 'line':miriad.averageVelocityLine(visCorrected, factor=combineV)}}

	freq1, amps1 = miriad.dumpSpec(visCorrected, optionsI)
	freq2, amps2 = miriad.dumpSpec(visUncorrected, optionsV)
	freq3, amps3 = miriad.dumpSpec(visCorrected, optionsV)

	# hack for a bad channel
	if filterMaxPeak:
		amps1[amps1.index(max(amps1))] = 0
		amps2[amps2.index(max(amps2))] = 0
		amps3[amps3.index(max(amps3))] = 0

	fontsize = 8
	subtitledict = {'verticalalignment': 'center'}
	pad = 0.05 # 5%
	if stokesVylim is None:
		upperlim = max(max(amps2), max(amps3))
		lowerlim = min(min(amps2), min(amps3))
		upperlim = upperlim + pad*upperlim
		stokesVylim = [(lowerlim, upperlim), (lowerlim, upperlim)]
	elif stokesVylim is 'separate':
		upperlim = max(max(amps2), max(amps3))
		lowerlim = min(min(amps2), min(amps3))
		upperlim = upperlim + pad*upperlim
		stokesVylim = [(lowerlim, max(amps2) + pad*max(amps2)), (lowerlim, max(amps3) + pad*max(amps3))]

	# xlim = (345.65,347.65)
	xlim = (min(freq2),max(freq2))

	defaults = {
		0: {'x': freq1, 'y': amps1, 'draw': 'steps-mid', 'line': 'k-', 'label': 'Stokes I'},
		'legend': {'loc': legendloc, 'fontsize': fontsize},
		'title': '',
		'xlabel': 'Frequency (GHz)', 'ylabel': 'Visibility Amplitude',
		'sharex': True, 'sharey': 'row',
		'hspace': 0.0,
		'ylim': stokesIylim,
		'xlim': xlim,
		'minorticks': True,
	}

	fig = plawt.plot({**defaults, **plotOptions}, {
		0: {'x': freq2, 'y': amps2, 'draw': 'steps-mid', 'line': 'k-', 'label': 'Stokes V before squint correction'},
		'legend': {'loc': legendloc, 'fontsize': fontsize},
		'ylim': stokesVylim[0],
	}, {
		0: {'x': freq3, 'y': amps3, 'draw': 'steps-mid', 'line': 'k-', 'label': 'Stokes V after squint correction'},
		'legend': {'loc': legendloc, 'fontsize': fontsize},
		'ylim': stokesVylim[1],
	})

def compareMapSpectra(uncorrectedMap, correctedMap, line, stokes, source, peakStokes='v', regionWidth=1,
	legendloc=1,
	plotOptions={},
	imspectOptions={}):
	"""
	maxfit options=abs on the corrected/uncorrected maps for each line
	reinvert the visibilities without the 'mfs' to preserve the velocity axis
	use velsw to switch from velocity to frequency:
	`velsw in=MAPSCorrect/NGC7538S-s4.co3-2.v.cm axis=FREQ`
	imspect with region='abspixel,box(x1,y1,x1,y1)' where x1,y1 is the peak found by maxfit
	I can also not use mfs at all with no line selection and get the peak with maxfit on that map.
	I then use imspec at the new peak and this gives me a better spectra.
	The map however has Stokes I and Stokes V peaks that don't align. The peaks are bigger however.

	---
	uncorrectedMap: string of the path
	correctedMap: string of the path
	line: string of line (ex 'co3-2') to find the peak of
	stokes: string, one of 'i', 'q', 'u', 'v', 'rr', 'rl', 'lr', 'll'
	source: string
	regionWidth: the width of the box to put around the peak when creating spectra
	peakStokes: string of one of the polarizations to take the spectra through the peak of.
		ex. 'i' means take the spectra through the peak of Stokes I
	"""

	# find the peak of Stokes I or V in the corrected line map
	peakLineMap = (correctedMap + '.' + peakStokes + '.full.cm').replace('usb', line)
	try:
		maxPixel = miriad.maxfit({'in': peakLineMap, 'options': 'abs'}, stdout=subprocess.PIPE).stdout
		maxPixel = str(maxPixel).split('\\n')[4]
		maxPixel = maxPixel[maxPixel.find('(')+1:maxPixel.find(')')].split(',')[0:2]
		maxPixel = list(map(int, maxPixel))
	except:
		maxPixel = [64, 64]

	# make a box around the peak (by finding a bottom left corner 'blc' and top right corner 'trc')
	blc = (maxPixel[0] - regionWidth/2, maxPixel[1] - regionWidth/2)
	blc = tuple(map(int, blc))
	trc = (maxPixel[0] + regionWidth/2, maxPixel[1] + regionWidth/2)
	trc = tuple(map(int, trc))
	region = 'abspixel,box({},{},{},{})'.format(blc[0], blc[1], trc[0], trc[1])
	# region = 'abspixel,box({0},{1},{0},{1})'.format(maxPixel[0], maxPixel[1])

	corrText = ['uncorr', 'corr']
	frequencies = []
	amplitudes = []
	for i, mapdir in enumerate([uncorrectedMap, correctedMap]):
		for stk in stokes:
			mapsuffix = '.{}.full.cm'.format(stk)
			mappath = mapdir + mapsuffix

			miriad.velsw({'in': mappath, 'axis': 'FREQ'})

			# get i and v spectra through the point where v peaks in the line map
			imspectDefaults = {
				'in': mappath,
				'region': region,
				'device': 'newfigures/{}.{}peak.{}.{}.ps/cps'.format(source, line, corrText[i], stk)
			}
			x, y, _ = miriad.dumpImspect(mappath, options={**imspectDefaults, **imspectOptions})
			frequencies.append(x)
			amplitudes.append(y)

	legendFontSize = 12
	tickParams = {'axis': 'both', 'which': 'both', 'direction': 'in', 'right': True, 'top': True, 'labelsize': 10}
	axisLabelSize = 14
	plotDefaults = {
		0: {'x': frequencies[0], 'y': amplitudes[0], 'draw': 'steps-mid', 'line': 'r-',
			'label': 'Uncorrected Stokes I'
		},
		'nrows': 2, 'ncols': 2,
		'legend': {'loc': legendloc, 'fontsize': legendFontSize},
		'xlabel': 'Frequency (GHz)', 'ylabel': 'Average Intensity (Jy/beam)',
		'xlabelsize': axisLabelSize, 'ylabelsize': axisLabelSize,
		'sharex': True, 'sharey': 'row',
		'minorticks': True,
		'tight_layout': {'pad': 3, 'h_pad': 2.0, 'w_pad': 0},
		'tick_params': tickParams,
		'titlesize': 18
	}

	plotOptions['title'] = plotOptions['title'] + ': Peak of Stokes {} through {} line'.format(
		peakStokes.upper(), line.upper()
	)

	plotOptions['subloc'] = 'left'

	fig = plawt.plot({**plotDefaults, **plotOptions}, {
		0: {'x': frequencies[2], 'y': amplitudes[2], 'draw': 'steps-mid', 'line': 'r-',
			'label': 'Corrected Stokes I'
		},
		'legend': {'loc': legendloc, 'fontsize': legendFontSize},
		'tick_params': tickParams
	}, {
		0: {'x': frequencies[1], 'y': amplitudes[1], 'draw': 'steps-mid', 'line': 'm-',
			'label': 'Uncorrected Stokes V'
		},
		'legend': {'loc': legendloc, 'fontsize': legendFontSize},
		'tick_params': tickParams
	}, {
		0: {'x': frequencies[3], 'y': amplitudes[3], 'draw': 'steps-mid', 'line': 'm-',
			'label': 'Corrected Stokes V'
		},
		'legend': {'loc': legendloc, 'fontsize': legendFontSize},
		'tick_params': tickParams
	})
