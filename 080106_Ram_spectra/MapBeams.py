#!/usr/bin/python3
import shutil, glob, os
import miriad

so = 'orkl_080106'
line = 'vel,43,-31,2,2'
rms = 0.3

molecule = 'CO'
if molecule == 'CO':
	freq = 345.7959
	lab = 'co3-2'
	reg = 'arcsec,box(-4,-4,4,4)'
	rms = 0.2
	rng = '0,30'

src = 'MAPSCorrect/{}.{}'.format(so, lab)

print('LL BEAM')
vis = 'UVOffsetCorrect/{}.{}.ll'.format(so, lab)
miriad.invert({
	'vis': vis,
	'line': line,
	'beam': '{}.ll.bm'.format(src),
	'map': '{0}.ll.mp'.format(src),
	'imsize': 128,
	'cell': 0.3,
	'options': 'systemp,double',
	# 'stokes': 'i,q,u,v',
	'sup': 0
})

print('RR BEAM')
vis = 'UVOffsetCorrect/{}.{}.rr'.format(so, lab)
miriad.invert({
	'vis': vis,
	'line': line,
	'beam': '{}.rr.bm'.format(src),
	'map': '{0}.rr.mp'.format(src),
	'imsize': 128,
	'cell': 0.3,
	'options': 'systemp,double',
	# 'stokes': 'i,q,u,v',
	'sup': 0
})
