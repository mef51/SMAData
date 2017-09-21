#!/usr/bin/python3

import miriad

def plotPhase(vis, device='2/xs'):
	miriad.smauvplt({
		'vis': vis,
		'device': device,
		'interval': '1e3',
		'stokes': 'i,v',
		'axis': 'time,pha',
		'nxy': '2,2'
	})

# vis = 'UVDATA/NGC7538S-s4.usb'
vis = 'UVOffsetCorrect/NGC7538S-s4.usb.corrected.slfc'
numChannels = miriad.getNumChannels(vis)
velrange = miriad.getVelocityRange(vis)

miriad.compareSpectra(
	'UVDATA/NGC7538S-s4.usb',
	'UVOffsetCorrect/NGC7538S-s4.usb.corrected.slfc',
	combine=20,
	plotOptions={
		'title': 'NGC7538 Stokes V: Uncorrected vs. Corrected',
		'filename':'NGC7538S-s4Compare.pdf',
		'figsize': (16/2,9/2),
	}
)
