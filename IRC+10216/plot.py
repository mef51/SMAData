#!/usr/bin/python3

# from miriad import uvspec, imspec
import miriad

if __name__ == '__main__':
	miriad.uvspec({
		'vis': 'UVDATA/irc+10216.co3-2,UVoffsetCORRECT/irc+10216.co3-2.corrected.slfc',
		'device': 'irc+10216_CO_BeforeAfter/cps',
		'interval': 9999,
		'options': 'avall,nobase',
		'nxy': '1,2',
		'stokes': 'v',
		'axis': 'freq,amp',
		# 'line': 'chan,15,5,8',
		'log':'co_beforeafter.dat'
	})
