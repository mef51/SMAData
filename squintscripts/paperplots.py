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

def compareMapSpectra(uncorrectedMap, correctedMap, line, stokes, source, plotOptions={}):
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
	"""

	# find the peak of Stokes V in the corrected line map
	vlinemap = (correctedMap + '.v.full.cm').replace('usb', line)
	maxPixel = miriad.maxfit({'in': vlinemap, 'options': 'abs'}, stdout=subprocess.PIPE).stdout
	maxPixel = str(maxPixel).split('\\n')[4]
	maxPixel = maxPixel[maxPixel.find('(')+1:maxPixel.find(')')].split(',')[0:2]
	maxPixel = list(map(int, maxPixel))

	corrText = ['uncorr', 'corr']
	for i, mapdir in enumerate([uncorrectedMap, correctedMap]):
		for stk in stokes:
			mapsuffix = '.{}.full.cm'.format(stk)
			mappath = mapdir + mapsuffix

			miriad.velsw({'in': mappath, 'axis': 'FREQ'})

			# plot i and v through the point where v peaks in the line map
			miriad.imspect({
				'in': mappath,
				'region': 'abspixel,box({0},{1},{0},{1})'.format(maxPixel[0], maxPixel[1]),
				'device': 'newfigures/{}.{}peak.{}.{}.ps/cps'.format(source, line, corrText[i], stk)
			})
