#!/usr/bin/python3

import shutil, glob, os
import miriad

def split(uvo, uvc, so):
	""" Split in different files LL and RR """
	stks = ['ll', 'rr', 'lr', 'rl']
	lins = ['co3-2', 'sio8-7', 'cnt.usb']
	for stk in stks:
		for lin in lins:
			path = '{}/{}.{}.{}'.format(uvc, so, lin, stk)
			if os.path.exists(path): shutil.rmtree(path)
			miriad.uvaver({
				'vis' : '{}/{}.{}'.format(uvo, so, lin),
				'out' : '{}/{}.{}.{}'.format(uvc, so, lin, stk),
				'select' : 'pol({})'.format(stk)
			})

		path = '{}/{}.usb.{}'.format(uvc, so, stk)
		if os.path.exists(path): shutil.rmtree(path)

		miriad.uvaver({
			'vis' : '{}/{}.usb'.format(uvo, so),
			'out' : '{}/{}.usb.{}'.format(uvc, so, stk),
			'stokes' : stk
		})

def selfcal(so, uvc):
	"""
	Original map used for selfcal in MAPS
	Independent step for RR and LL (u,v) files
	1. Selcalibration of continuum
	2. Applying selfcalibration  for continuum
	3. Copyinggains to Line data (all in the USB)
	4. Applying selfcalibration  for lines
	5. Concanate LL and RR in ine file
	6. Resort data
	"""
	for stk in ['ll', 'rr']:
		for sb in ['cnt.usb']:
			miriad.selfcal({
				'vis' : '{}/{}.{}.{}'.format(uvc, so, sb, stk),
				'model' : 'MAPS/{}.cont.usb.i.cc'.format(so),
				'refant' : 6,
				'interval' : 8,
				'options' : 'phase'
			})
			miriad.gpplt({
				'vis' : '{}/{}.{}.{}'.format(uvc, so, sb, stk),
				'device' : '1/xs',
				'yaxis' : 'phase',
				'nxy' : '1,3'
			})
			input("Press enter to continue...    ")

			path = '{}/{}.{}.{}.slfc'.format(uvc, so, sb, stk)
			if os.path.exists(path): shutil.rmtree(path)

			miriad.uvaver({
				'vis' : '{}/{}.{}.{}'.format(uvc, so, sb, stk),
				'out' : '{}/{}.{}.{}.slfc'.format(uvc, so, sb, stk)
			})
		for lin in ['co3-2', 'sio8-7', 'usb']:
			path = '{}/{}.{}.{}.slfc'.format(uvc, so, lin, stk)
			if os.path.exists(path): shutil.rmtree(path)

			miriad.gpcopy({
				'vis' : '{}/{}.cnt.usb.{}'.format(uvc, so, stk),
				'out' : '{}/{}.{}.{}'.format(uvc, so, lin, stk),
			})
			miriad.uvaver({
				'vis' : '{}/{}.{}.{}'.format(uvc, so, lin, stk),
				'out' : '{}/{}.{}.{}.slfc'.format(uvc, so, lin, stk),
			})

	for lin in ['co3-2', 'sio8-7', 'cnt.usb', 'usb']:
		vis = '{}/{}.{}'.format(uvc, so, lin)
		for folder in ['tmp.5', 'tmp.6', '{}/{}.{}.corrected.slfc'.format(uvc, so, lin)]:
			if os.path.exists(folder): shutil.rmtree(folder)

		miriad.uvcat({
			'vis' : '{0}.rr.slfc,{0}.ll.slfc,{0}.rl,{0}.lr'.format(vis),
			'out' : 'tmp.5',
		})
		miriad.uvsort({
			'vis' : 'tmp.5',
			'out' : 'tmp.6',
		})
		miriad.uvaver({
			'vis' : 'tmp.6',
			'out' : '{}/{}.{}.corrected.slfc'.format(uvc, so, lin),
			'interval' : 5
		})

def mapvis(uvo, uvc, so, mapdir):
	"""
	Make a map from visibilities
	1. Continuum Stokes I,V Uncorrected & Corrected data
	2. Map All lines. Corrected
	3. Map All lines. Uncorrected
	4. Continuum LL and RR independently, for non-selfcal and selfcal cases
	"""

	# 1.
	src = '{}/{}.cnt'.format(mapdir, so)
	rms = 0.0065
	tall = 0.03

	for path in glob.glob('{}.*'.format(src)):
		if os.path.exists(path): shutil.rmtree(path)

	vis = '{}/{}.cnt.usb.corrected.slfc'.format(uvc, so)
	for src in ['{}/{}.cnt'.format(mapdir, so), '{}/{}.cnt.uncorrected'.format(mapdir, so)]:
		miriad.invert({
			'vis': vis,
			'stokes': 'i,v',
			'beam': '{}.bm'.format(src),
			'map': '{0}.i.mp,{0}.v.mp'.format(src),
			'imsize': 128,
			'cell': 0.3,
			'options': 'systemp,double,mfs',
			'sup': 0
		})

		for stk in ['i', 'v']:
			miriad.clean({
				'map': '{}.{}.mp'.format(src, stk),
				'beam': '{}.bm'.format(src),
				'out': '{}.{}.cc'.format(src, stk),
				'niters': 3000,
				'cutoff': tall
			})
			miriad.restor({
				'map': '{}.{}.mp'.format(src, stk),
				'beam': '{}.bm'.format(src),
				'model': '{}.{}.cc'.format(src, stk),
				'out': '{}.{}.cm'.format(src, stk),
			})
		vis = '{}/{}.cnt.usb'.format(uvo, so)

	# 2. Map corrected line data
	# 3. Map uncorrected line data with same paramenters as in 2
	rms = 0.13
	tall = 0.50
	vel = 'vel,43,-31,2,2'

	for lin in ['co3-2', 'sio8-7']:
		vis = '{}/{}.{}.corrected.slfc'.format(uvc, so, lin)
		for src in ['{}/{}.{}'.format(mapdir, so, lin), '{}/{}.{}.uncorrected'.format(mapdir, so, lin)]:
			if lin == 'co3-2':
				vel = 'vel,43,-31,2,2'
			elif lin == 'sio8-7':
				vel = 'vel,27,-20,2,2'
			for path in glob.glob('{}.*'.format(src)):
				if os.path.exists(path): shutil.rmtree(path)

			miriad.invert({
				'vis': vis,
				'stokes': 'i,v',
				'beam': '{}.bm'.format(src),
				'map': '{0}.i.mp,{0}.v.mp'.format(src),
				'imsize': 128,
				'cell': 0.3,
				'options': 'systemp,double,mfs',
				'sup': 0,
				#'line': vel
			})

			for stk in ['i', 'v']:
				miriad.clean({
					'map': '{}.{}.mp'.format(src, stk),
					'beam': '{}.bm'.format(src),
					'out': '{}.{}.cc'.format(src, stk),
					'niters': 3000,
					'cutoff': tall
				})
				miriad.restor({
					'map': '{}.{}.mp'.format(src, stk),
					'beam': '{}.bm'.format(src),
					'model': '{}.{}.cc'.format(src, stk),
					'out': '{}.{}.cm'.format(src, stk),
				})
			vis = '{}/{}.{}'.format(uvo, so, lin)

	# 4. nopol is for selfcal case (this option is not used!)
	rms = 0.01
	tall = 0.03

	for stk in ['ll', 'rr']:
		src = '{}/{}.cnt.{}'.format(mapdir, so, stk)
		for path in glob.glob('{}.*'.format(src)):
			if os.path.exists(path): shutil.rmtree(path)
		for pol in ['nopol', 'nocal']:
			path = '{}.bm'.format(src)
			if os.path.exists(path): shutil.rmtree(path)

			miriad.invert({
				'vis': '{}/{}.cnt.usb.{}'.format(uvc, so, stk),
				'beam': '{}.bm'.format(src),
				'map': '{}.{}.mp'.format(src, pol),
				'imsize': 128,
				'cell': 0.3,
				'options': 'systemp,double,mfs,{}'.format(pol),
				'sup': 0
			})
			miriad.clean({
				'map': '{}.{}.mp'.format(src, pol),
				'beam': '{}.bm'.format(src),
				'out': '{}.{}.cc'.format(src, pol),
				'niters': 3000,
				'cutoff': tall
			})
			miriad.restor({
				'map': '{}.{}.mp'.format(src, pol),
				'beam': '{}.bm'.format(src),
				'model': '{}.{}.cc'.format(src, pol),
				'out': '{}.{}.cm'.format(src, pol),
			})

def disp(uvo, uvc, so, mapdir):
	"""
	1. Plot uncorrected channel map
	2. Plot corrected channel map
	"""
	for lin in ['cnt', 'co3-2', 'sio8-7']:
		devicetype = 'ps/cps'
		filename = lin
		src = '{}/{}.{}'.format(mapdir, so, lin)
		nxy = '1,1'

		path = '{}.v-i.perc'.format(src)
		if os.path.exists(path): shutil.rmtree(path)
		path = '{}.v-i.perc.uncorrected'.format(src)
		if os.path.exists(path): shutil.rmtree(path)

		if lin == 'cnt':
			rms = 0.03
			for suffix in ['', 'uncorrected.']:
				opts = {
					'exp': '100*\<{0}.{1}v.cm\>/\<{0}.{1}i.cm\>'.format(src, suffix),
					'mask': '\<{}.{}i.cm\>.gt.0.4'.format(src, suffix),
				}
				suffix = '.uncorrected' if suffix != '' else ''
				opts['out'] =  '{}.v-i.perc{}'.format(src, suffix)
				miriad.maths(opts)
		else:
			if lin == 'co3-2':  rms = 0.13
			if lin == 'sio8-7': rms = 0.06
			for suffix in ['', 'uncorrected.']:
				val = 6 if suffix == '' else 8
				opts = {
						'exp': '100*\<{0}.{1}v.cm\>/\<{0}.{1}i.cm\>'.format(src, suffix),
						'mask': '\<{}.{}i.cm\>.gt.{}'.format(src, suffix, val),
					}
				suffix = '.uncorrected' if suffix != '' else ''
				opts['out'] =  '{}.v-i.perc{}'.format(src, suffix)
				miriad.maths(opts)

		for datatype in ['uncorr', 'corr']:
			cgdispOpts = {
				'type': 'cont,cont',
				'labtyp': 'arcsec,arcsec',
				'options': 'full,beambl,3val',
				'csize': '0,1,0,0',
				'cols1': 2, 'cols2': 8,
				'levs1': '15,35,55,75,95',
				'nxy': nxy,
			}

			if datatype is 'uncorr':
				# flux plot
				cgdispOpts['slev'] = 'p,1,a,{}'.format(rms)
				cgdispOpts['device'] = '{}.uncorr.{}'.format(filename, devicetype)
				cgdispOpts['in'] = '{0}.uncorrected.i.cm,{0}.uncorrected.v.cm'.format(src)
				cgdispOpts['levs2'] = '-8,-7,-6,-5,-4,-3,-2,2,3,4,5,6,7,8'
				miriad.cgdisp(cgdispOpts)
				miriad.imstat({'in': '{}.i.cm'.format(src), 'region':'box\(3,3,50,125\)'})
				miriad.imstat({'in': '{}.v.cm'.format(src), 'region':'box\(3,3,50,125\)'})
				input("Press enter to continue...")

				# v/i plot
				cgdispOpts['slev'] = 'p,1,a,1'
				cgdispOpts['device'] = '{}.uncorr.perc.{}'.format(filename, devicetype)
				cgdispOpts['in'] = '{0}.uncorrected.i.cm,{0}.v-i.perc.uncorrected'.format(src)
				cgdispOpts['levs2'] = '-6,-5,-4,-3,-2,-1,1,2,3,4,5,6'
				miriad.cgdisp(cgdispOpts)
				input("Press enter to continue...")
			else:
				# flux plot
				cgdispOpts['slev'] = 'p,1,a,{}'.format(rms)
				cgdispOpts['device'] = '{}.corr.{}'.format(filename, devicetype)
				cgdispOpts['in'] = '{0}.i.cm,{0}.v.cm'.format(src)
				cgdispOpts['levs2'] = '-8,-7,-6,-5,-4,-3,-2,2,3,4,5,6,7,8'
				miriad.cgdisp(cgdispOpts)
				miriad.imstat({'in': '{}.i.cm'.format(src), 'region':'box\(3,3,50,125\)'})
				miriad.imstat({'in': '{}.v.cm'.format(src), 'region':'box\(3,3,50,125\)'})
				input("Press enter to continue...   ")

				# v/i plot
				cgdispOpts['slev'] = 'p,1,a,1'
				cgdispOpts['device'] = '{}.corr.perc.{}'.format(filename, devicetype)
				cgdispOpts['in'] = '{0}.i.cm,{0}.v-i.perc'.format(src)
				cgdispOpts['levs2'] = '-6,-5,-4,-3,-2,-1,1,2,3,4,5,6'
				miriad.cgdisp(cgdispOpts)
				input("Press enter to continue...   ")

def peak(so, mapdir):
	src = '{}/{}.cnt'.format(mapdir, so)
	for li in ['ll.nocal', 'rr.nocal', 'll.nopol', 'rr.nopol']:
		miriad.maxfit({'in': '{}.{}.cm'.format(src, li), 'log': 'maxfit_{}.{}'.format(so, li)})
	miriad.maxfit({'in': '{}.i.cm'.format(src), 'log': 'maxfit_{}.stokesI'.format(so)})

if __name__ == '__main__':
	so = 'orkl_080106'
	uvo = 'UVDATA'
	uvc = 'UVOffsetCorrect'
	mapdir = 'MAPSCorrect'
	rms = '0.0065'

	# split(uvo, uvc, so)
	# selfcal(so, uvc)
	mapvis(uvo, uvc, so, mapdir)
	# disp(uvo, uvc, so, mapdir)
