#!/usr/bin/python3

# from miriad import uvspec, imspec
from miriad import *

if __name__ == '__main__':
	uvspec({
		'vis': 'UVDATA/orkl_080106.usb,UVOffsetCorrect/orkl_080106.usb.corrected.slfc',
		'device': 'averagedChannels/cps',
		'interval': 9999,
		'options': 'avall,nobase',
		'nxy': '1,2',
		'stokes': 'v',
		'axis': 'freq,amp',
		'line': 'chan,48,1,64.0',
	})
	# imspec({
	# 	'in': 'MAPSCorrect/orkl_080106.co3-2.v.cm',
	# 	'region': "'abspixel,box(75,53,83,63)(1)'",
	# 	'device': '1/xs',
	# 	'axes': 'spectral'
	# })


	# cgcurs({
	# 	'in': 'MAPSCorrect/orkl_080106.co3-2.v.cm ',
	# 	'device': '2/xs ',
	# 	'options': 'cursor',
	# 	'labtyp': 'hms,dms'
	# })
