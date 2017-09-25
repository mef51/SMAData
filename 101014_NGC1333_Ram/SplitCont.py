#!/usr/bin/python3

import shutil, glob, os
import miriad

"""
Separate the continuum from molecular lines
"""

so = 'iras2a.aver'
dd = 'UVDATA'
vis = '{}/{}'.format(dd, so)

sb = 'usb'
numChannels = miriad.getNumChannels('{}.{}'.format(vis, sb))
ch = miriad.averageVelocityLine('{}.{}'.format(vis, sb), 5)

freq = 345.8
lab = 'cnt.usb'
free = '6,434,465,1582,1590,2333,2336,6139'

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
	'axis': 'freq,amp',
	'nxy': '2,3'
})

input("Return to continue")
miriad.showChannels('tmp.3', subtitle='SplitCont')
miriad.uvlin({
	'vis': 'tmp.3',
	'out': '{}.{}'.format(vis, lab),
	'chans': free,
	'mode': 'chan0', # this says 'store a single average value only'
	'order': 0
})

miriad.smauvplt({
	'vis': '{}.{}'.format(vis, lab),
	'device': '2/xs',
	'stokes': 'i,v',
	'axis': 'time,pha',
	'nxy': '2,2'
})

print("Started with:", vis +'.'+ sb)
print("Output:", vis +'.'+ lab)
