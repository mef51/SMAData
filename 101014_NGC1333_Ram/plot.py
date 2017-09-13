#!/usr/bin/python3

# from miriad import uvspec, imspec
from miriad import *

if __name__ == '__main__':
	uvspec({
		'vis': 'UVDATA/orkl_080106.usb,UVOffsetCorrect/orkl_080106.usb.corrected.slfc',
		'device': 'averagedChannels/cps',
		'interval': 9999,
		'options': 'avall,nobase',
		'nxy': '1,1',
		'stokes': 'v',
		'axis': 'freq,amp',
		'line': 'chan,48,1,64.0',
	})
