#!/usr/bin/python3

import miriad

vis = 'UVDATA/NGC7538S-s4.usb'
# numChannels = miriad.getNumChannels(vis)
numChannels = 1536
miriad.uvspec({
	'vis': vis,
	'device': '1/xs',
	'interval': 9999,
	'options': 'avall,nobase',
	'nxy': '1,1',
	'stokes': 'v',
	'axis': 'chan,amp',
	'yrange': '0,0.4',
	# 'select': 'win(3,4)',
	'line': miriad.averageLine(numChannels, factor=16),
})

miriad.uvspec({
	'vis': vis,
	'device': '2/xs',
	'interval': 9999,
	'options': 'avall,nobase',
	'nxy': '1,1',
	'stokes': 'i',
	'axis': 'chan,amp',
	# 'yrange': '0,0.4',
	# 'select': 'win(3,4)',
	'line': miriad.averageLine(numChannels, factor=16),
})
