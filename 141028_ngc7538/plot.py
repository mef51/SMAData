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

vis = 'UVDATA/NGC7538S-s4.co3-2'
numChannels = miriad.getNumChannels(vis)
velrange = miriad.getVelocityRange(vis)

miriad.showChannels(vis)
exit()
miriad.uvspec({
	'vis': vis,
	'device': '3/xs',
	'interval': 9999,
	'options': 'avall,nobase',
	'nxy': '1,1',
	'stokes': 'i',
	'axis': 'freq,amp',
	# 'yrange': '0,0.5',
	# 'select': 'win(12)',
	# 'line': miriad.averageLine(numChannels, factor=1),
	# 'line': 'vel,{},{},5.0,5.0'
	# 	.format((abs(velrange[0])+abs(velrange[1]))/5+2,
	# 		velrange[1]),
})

