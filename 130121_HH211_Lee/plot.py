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

vis = 'UVDATA/combined.usb.stokes'
# vis = 'UVDATA/combined.lsb.stokes'

miriad.uvspec({
	'vis': vis,
	'device': '2/xs',
	'interval': 9999,
	'options': 'avall,nobase',
	'nxy': '1,1',
	'stokes': 'i,v',
	'axis': 'freq,amp',
	# 'select': 'so(hh211)'
	# 'line': miriad.averageVelocityLine(vis, factor=20),
})

