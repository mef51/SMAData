#!/usr/bin/python3

import shutil, glob, os
import miriad

so = 'orkl_080106'
dd = 'UVDATA'
lb = 'vis.uvcal'

sideband = 'USB'

if sideband == 'LSB':
	sb = 'lsb'
	ch = 'vel,717,-2632,5.0,5.0'
	freq = 331.6
	lab = 'cnt.lsb'
	free = '1,194,203,346,355,648,659,700,709,717'
elif sideband == 'USB':
  # 65 110 200 280 300 400 580 600 620 640
	sb = 'usb'
	ch = 'vel,345,-2149,5.0,5.0'
	freq = 345.0
	lab = 'cnt.usb'
	free = '1,23,33,85,95,104,108,140,150,166,180,216,228,268,305,322,329,345'

vis = 'UVDATA/{}'.format(so)
paths = ['{}.{}'.format(vis, lab), '{}.full.{}'.format(vis, lab)]
for path in paths:
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
	'vis': 'tmp.4',
	'out': '{}.{}'.format(vis, lab),
	'chans': free,
	'mode': 'chan0',
	'order':0
})

print("Started with:", vis +'.'+ sb)
print("Output:", vis +'.'+ lab)
