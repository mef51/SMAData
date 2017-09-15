#!/usr/bin/python3

import miriad

vis = 'UVDATA/NGC7538S-s4.usb'
numChannels = miriad.getNumChannels(vis)
velrange = miriad.getVelocityRange(vis)

print((abs(velrange[0])+abs(velrange[1]))/5+2)
print(velrange[1])
print(velrange[0])
miriad.uvspec({
	'vis': vis,
	'device': '1/xs',
	'interval': 9999,
	'options': 'avall,nobase',
	'nxy': '1,1',
	'stokes': 'i',
	'axis': 'vel,amp',
	# 'yrange': '0,1.0',
	# 'select': 'win(12)',
	# 'line': miriad.averageLine(numChannels, factor=1),
	'line': 'vel,{},{},5.0,5.0'
		.format((abs(velrange[0])+abs(velrange[1]))/5+2,
			velrange[1]),
})

