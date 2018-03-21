#!/usr/bin/python3
"""
Like SplitCont.py, but works on the corrected visibility and saves the continuum instead of the average
"""
import shutil, glob, os
import miriad

so = 'irc+10216'
dd = 'UVOffsetCorrect'

sideband = 'USB'
if sideband == 'USB':
  # 65 110 200 280 300 400 580 600 620 640
	sb = 'usb.corrected.slfc'
	ch = 'vel,689,-1312.5,5.0,5.0'
	freq = 345.0
	lab = 'cnt.usb.corrected.full'
	free = '1,61,69,115,125,193,204,291,302,393,401,585,592,605,613,621,631,636,643,689'

vis = '{}/{}'.format(dd, so)
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
	'mode': 'continuum',
	'order':0
})

print("Started with:", vis +'.'+ sb)
print("Output:", vis +'.'+ lab)
