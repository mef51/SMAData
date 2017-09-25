#!/usr/bin/python3

import shutil, glob, os
import miriad

so = 'NGC7538S-s4'
dd = 'UVDATA'

molecules = ['CO', 'CH2CO']

for molecule in molecules:
	input('Splitting {}, press return to continue'.format(molecule))
	if molecule == 'CO':
		win = '3'
		sb = 'usb'
		freq = 345.7959
		lab = 'co3-2'
		free = '1,25,52,65'
	elif molecule == 'CH2CO':
		win = '12'
		sb = 'usb'
		freq = 346.603
		lab = 'ch2co17-16'
		free = '2,21,37,63'

	vis = 'UVDATA/{}'.format(so)
	path = '{}.{}'.format(vis, lab)
	if os.path.exists(path): shutil.rmtree(path)
	for path in glob.glob('tmp.*'):
		if os.path.exists(path): shutil.rmtree(path)

	print("Starting with:", vis + '.' + sb)
	miriad.uvaver({
		'vis': '{}.{}'.format(vis, sb),
		'out': 'tmp.1',
		'select': 'win({})'.format(win),
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

	miriad.showChannels('tmp.3', subtitle='SplitLines')
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
