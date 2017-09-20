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

miriad.uvspec({
	'vis': 'UVDATA/NGC7538S-s4.usb,UVOffsetCorrect/NGC7538S-s4.usb.corrected.slfc',
	'device': '1/xs',
	'interval': 9999,
	'options': 'avall,nobase',
	'nxy': '1,2',
	'stokes': 'v',
	'axis': 'freq,phase',
	# 'yrange': '0,0.5',
	'line': miriad.averageVelocityLine(vis, factor=20),

})

