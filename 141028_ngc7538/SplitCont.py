#!/usr/bin/python3

import shutil, glob, os
import miriad

"""
Separate the continuum from molecular lines
"""

so = 'NGC7538S-s4'
dd = 'UVDATA'
vis = '{}/{}'.format(dd, so)

sideband = 'USB'

sb = 'usb'
numChannels = miriad.getNumChannels('{}.{}'.format(vis, sb))
velrange = miriad.getVelocityRange('{}.{}'.format(vis, sb))

ch = 'vel,{},{},5.0,5.0'.format((abs(velrange[0])+abs(velrange[1]))/5+2, velrange[1])
freq = 345.0
lab = 'cnt.usb'
free = '1,23,33,85,95,104,108,140,150,166,180,216,228,268,305,322,329,345'

path = '{}.{}'.format(vis, lab)
if os.path.exists(path): shutil.rmtree(path)
for path in glob.glob('tmp.*'):
	if os.path.exists(path): shutil.rmtree(path)

print("Starting with:", vis + '.' + sb)

miriad.uvaver({'vis': '{}.{}'.format(vis, sb), 'out': 'tmp.1'})
miriad.uvputhd({
	'vis': 'tmp.1',
	'out': 'tmp.2',
	'hdvar': 'restfreq',
	'varval': freq
})
miriad.uvredo({'vis': 'tmp.2', 'out': 'tmp.3', 'options': 'velocity'})

# this is because we average 5 velocity channels into 1
miriad.uvflag({'vis': 'tmp.3', 'flagval': 'f', 'edge': '5,5'})
miriad.uvaver({'vis': 'tmp.3', 'out': 'tmp.4', 'line': ch})
miriad.uvlist({'vis': 'tmp.3', 'options': 'spec'})
miriad.uvlist({'vis': 'tmp.4', 'options': 'spec'})

miriad.smauvspec({
	'vis': 'tmp.4',
	'device': '1/xw',
	'interval': '1e3',
	'stokes': 'i',
	'axis': 'ch,amp',
	'nxy': '2,3'
})

input("Return to continue")
miriad.uvlin({
	'vis': 'tmp.3',
	'out': '{}.{}'.format(vis, lab),
	'chans': free,
	'mode': 'chan0',
	'order':0
})

print("Started with:", vis +'.'+ sb)
print("Output:", vis +'.'+ lab)
