#!/usr/bin/python3

import miriad

if __name__ == '__main__':
	miriad.uvspec({
		'vis': 'UVDATA/iras2a.win4',
		'device': 'ngc1333co.ps/cps',
		'interval': 9999,
		'options': 'avall,nobase',
		'nxy': '1,1',
		'stokes': 'i,v',
		'axis': 'freq,amp',
		# 'line': 'chan,16,1,8',
	})
	miriad.uvlist({'vis': 'UVDATA/iras2a.win4'})
