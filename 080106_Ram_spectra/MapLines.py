#!/usr/bin/python3

import shutil, glob, os
import miriad


so = 'orkl_080106'
dd = 'UVDATA'
line = 'vel,43,-31,2,2'
rms = 0.3

molecule = 'CO'

if molecule == 'CO':
	freq = 345.7959
	lab = 'co3-2'
	reg = 'arcsec,box(-4,-4,4,4)'
	rms = 0.2
	rng = '0,30'
elif molecule == 'SiO':
	line = 'vel,27,-20,2,2'
	freq = 347.3306
	lab = 'sio8-7'
	reg = 'arcsec,box(-4,-4,4,4)'
	rms = 0.3
	rng = '0,30'


vis = 'UVDATA/{}.{}'.format(so, lab)
src = 'MAPS/{}.{}'.format(so, lab)
tall = rms*3


# MAPS:
for path in glob.glob('{}.*'.format(src)):
	if os.path.exists(path):
		if os.path.isdir(path): shutil.rmtree(path)
		else: os.remove(path)

miriad.invert({
	'vis': vis,
	'line': line,
	'beam': '{}.bm'.format(src),
	'map': '{0}.i.mp,{0}.q.mp,{0}.u.mp,{0}.v.mp'.format(src),
	'imsize': 128,
	'cell': 0.3,
	'options': 'systemp,double',
	'stokes': 'i,q,u,v',
	'sup': 0
})

for stk in ['i', 'q', 'u', 'v']:
	miriad.clean({
		'map': '{}.{}.mp'.format(src, stk),
		'beam': '{}.bm'.format(src),
		'out': '{}.{}.cc'.format(src, stk),
		'niters': 1000,
		'cutoff': tall
	})
	miriad.restor({
		'map': '{}.{}.mp'.format(src, stk),
		'beam': '{}.bm'.format(src),
		'model': '{}.{}.cc'.format(src, stk),
		'out': '{}.{}.cm'.format(src, stk),
	})

miriad.imstat({'in': '{}.i.cm'.format(src), 'region': 'box(6,6,50,122)'})

input('Press return to continue')

for stk in ['q', 'u', 'v']:
	miriad.cgdisp({
		'type': 'cont,pix',
		'labtyp': 'arcsec,arcsec',
		'device': '/xs',
		'options': 'full,beambl,3val',
		'csize': '0,1,0,0',
		'in': '{0}.{1}.cm,{0}.i.cm'.format(src, stk),
		'range': '{},lin,1'.format(rng),
		'cols1': 2,
		'slev': 'a,{}'.format(rms),
		'levs1': '-21,-18,-15,-12,-9,-6,-3,3,6,9,12,15,18,21',
		'region': 'arcsec,box(-10,-10,10,10)',
		'nxy': '6,3'
	})
	miriad.imstat({'in': '{}.{}.cm'.format(src, stk), 'region': 'box(6,6,50,122)'})
	input('Press return to continue')

for stk in ['i', 'q', 'u', 'v']:
	miriad.imstat({'in': '{}.{}.cm'.format(src, stk)})


# DISP

path = '{}.v-i.perc'.format(src)
if os.path.exists(path): shutil.rmtree(path)

miriad.maths({
	'exp': '100*<{0}.v.cm>/<{0}.i.cm>'.format(src),
	'mask': '<{}.i.cm>.gt.2'.format(src),
	'out': '{}.v-i.perc'.format(src)
})

# for device in ['/xs', '{}.ps/cps'.format(src)]:
miriad.cgdisp({
	'type': 'cont,pix',
	'labtyp': 'arcsec,arcsec',
	'device': '/xs',
	'options': 'full,beambl,3val',
	'in': '{0}.v-i.perc,{0}.i.cm'.format(src),
	'cols1': 8,
	'slev': 'a,1,p,1',
	'levs1': '-8,-6,-4,-2,2,4,6,8',
	'region': 'arcsec,box(-5.5,-6,6.5,6)',
	'nxy': '6,3'
})
