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

vis = 'UVDATA/iras2a.aver.usb'

miriad.uvspec({
	'vis': vis,
	'device': '1/xs',
	'interval': 9999,
	'options': 'avall,nobase',
	'nxy': '1,1',
	'stokes': 'i,v',
	'axis': 'freq,amp',
	# 'yrange': '0,0.5',
	# 'line': miriad.averageVelocityLine(vis, factor=1),

})

