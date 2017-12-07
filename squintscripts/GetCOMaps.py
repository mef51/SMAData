#!/usr/bin/python3

# get CO maps for each object for the paper

import shutil, glob, os
import paperplots
import miriad

folders = [
	'IRC+10216',
	'OrionKL',
	'NGC7538',
	'NGC1333',
]

sources = [
	'irc+10216',
	'orkl_080106',
	'NGC7538S-s4',
	'iras2a.aver'
]

RMSes = [
	0.0521,
	0.144,
	0.253,
	0.00597,
]

for folder, source, rms in zip(folders, sources, RMSes):
	miriad.cgdisp({
		'in': '../{0}/MAPSCorrect/{1}.co3-2.i.cm,../{0}/MAPSCorrect/{1}.co3-2.v.cm'.format(folder, source),
		'labtyp': 'arcsec,arcsec',
		'type': 'cont,cont',
		'slev': 'p,1,a,{}'.format(rms),
		'levs1': '15,50,95',
		'levs2': '-8,-7,-6,-5,-4,-3,-2,2,3,4,5,6,7,8',
		'cols1': 2, 'cols2': 4,
		'device': '{}.ps/cps'.format(source)
	})

def getRMSes():
	"""
	Runs these commands in the terminal:
	imstat in=IRC+10216/MAPSCorrect/irc+10216.co3-2.v.cm
	imstat in=OrionKL/MAPSCorrect/orkl_080106.co3-2.v.cm
	imstat in=NGC7538/MAPSCorrect/NGC7538S-s4.co3-2.v.cm
	imstat in=NGC1333/MAPSCorrect/iras2a.aver.co3-2.v.cm
	"""
	for folder, source in zip(folders, sources):
		miriad.imstat({'in': '../{}/MAPSCorrect/{}.co3-2.v.cm'.format(folder, source)})
