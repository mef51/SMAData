#!/usr/bin/python3

import shutil, glob, os
import miriad

so = 'orkl_080106'
dd = 'UVDATA'
lb = 'vis.uvcal'

molecule = 'SiO'

if molecule == 'CO':
	win = '4'
	sb = 'usb'
	freq = 345.7959
	lab = 'co3-2'
	free = '1,19,48,53,69,74,93,102'
elif molecule == 'SiO':
	win = '23'
	sb = 'usb'
	freq = 347.3306
	lab = 'sio8-7'
	free = '74,124'

vis = 'UVDATA/{}'.format(so)
path = '{}.{}'.format(vis, lab)
if os.path.exists(path): shutil.rmtree(path)
for path in glob.glob('tmp.*'):
	if os.path.exists(path): shutil.rmtree(path)

print("Starting with:", vis + '.' + sb)
miriad.uvaver({
	'vis': '{}.{}'.format(vis, sb),
	'out': 'tmp.1',
	'select': 'win\({}\)'.format(win),
})

miriad.uvputhd({
	'vis': 'tmp.1',
	'out': 'tmp.2',
	'hdvar': 'restfreq',
	'varval': freq
})

miriad.uvredo({
	'vis': 'tmp.2',
	'out': 'tmp.3',
	'options': 'velocity'
})


miriad.uvlist({
	'vis': 'tmp.3',
	'options': 'spec'
})

miriad.smauvspec({
	'vis': 'tmp.3',
	'device': '1/xs',
	'interval': '1e3',
	'stokes': 'i',
	'axis': 'chan,amp',
	'nxy': '2,3'
})

input("Return to continue")

miriad.uvlin({
	'vis': 'tmp.3',
	'out': '{}.{}'.format(vis, lab),
	'chans': free,
	'mode': 'line',
	'order': 0
})

for stk in ['i', 'v']:
	miriad.smauvspec({
		'vis': '{}.{}'.format(vis, lab),
		'device': '1/xs',
		'interval': '1e3',
		'stokes': stk,
		'axis': 'ch,both',
		'nxy': '2,2'
	})

print("Started with:", vis + '.' + sb)
print("Output:", vis + '.' + lab)
