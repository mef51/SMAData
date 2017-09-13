#!/usr/bin/python3

import miriad

if __name__ == '__main__':
	miriad.uvspec({
		'vis': 'UVDATA/orkl_080106.usb,UVOffsetCorrect/orkl_080106.usb.corrected.slfc',
		'device': '2/xs',
		'interval': 9999,
		'options': 'avall,nobase',
		'nxy': '1,2',
		'stokes': 'v',
		'axis': 'chan,amp',
		'line': 'chan,48,1,64.0',
	})
