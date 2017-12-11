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

# Get orion continuum maps
cgdispOptions = {
	'in': '../{0}/MAPSCorrect/{1}.cnt.uncorrected.i.cm,../{0}/MAPSCorrect/{1}.cnt.uncorrected.v.cm'.format(folders[1], sources[1]),
	'labtyp': 'arcsec,arcsec',
	'type': 'cont,cont',
	'slev': 'p,1,a,{}'.format(0.05),
	'levs1': '15,50,95',
	'levs2': '-8,-7,-6,-5,-4,-3,-2,2,3,4,5,6,7,8',
	'cols1': 2, 'cols2': 4,
	'device': 'orkl.cnt.uncorr.ps/cps',
	'options': 'blacklab'
}
miriad.cgdisp(cgdispOptions)
cgdispOptions['in'] = '../{0}/MAPSCorrect/{1}.cnt.i.cm,../{0}/MAPSCorrect/{1}.cnt.v.cm'.format(folders[1], sources[1])
cgdispOptions['device'] = 'orkl.cnt.corr.ps/cps'
cgdispOptions['slev'] = 'p,1,a,{}'.format(0.03)
miriad.cgdisp(cgdispOptions)
# exit()

for folder, source, rms in zip(folders, sources, RMSes):
	miriad.cgdisp({
		'in': '../{0}/MAPSCorrect/{1}.co3-2.i.cm,../{0}/MAPSCorrect/{1}.co3-2.v.cm'.format(folder, source),
		'labtyp': 'arcsec,arcsec',
		'type': 'cont,cont',
		'slev': 'p,1,a,{}'.format(rms),
		'levs1': '15,30,45,60,85,95',
		'levs2': '-8,-7,-6,-5,-4,-3,-2,2,3,4,5,6,7,8',
		'cols1': 2, 'cols2': 4,
		'device': '{}.co3-2.ps/cps'.format(source),
		'options': 'blacklab'
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
