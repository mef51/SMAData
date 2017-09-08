#!/usr/bin/python3

# from miriad import uvspec, imspec
import miriad

if __name__ == '__main__':
	for sb in ['usb', 'lsb']:
		miriad.uvspec({
			'vis': 'UVDATA/irc+10216_{0}.vis.uvcal,UVoffsetCORRECT/irc+10216.{0}.corrected.slfc'.format(sb),
			'device': '{0}.ps/cps'.format(sb),
			'interval': 9999,
			'options': 'avall,nobase',
			'nxy': '1,2',
			'stokes': 'v',
			'axis': 'freq,amp',
			'line': 'chan,96,1,64.0',
		})

	exit()

	lines = ['cnt', 'co3-2', 'cs7-6', 'h13cn4-3', 'sis19-18']

	for line in lines:
		miriad.uvspec({
			'vis': 'UVDATA/irc+10216.{0},UVoffsetCORRECT/irc+10216.{0}.corrected.slfc'.format(line),
			'device': 'irc+10216_{0}Averaged.ps/cps'.format(line),
			'interval': 9999,
			'options': 'avall,nobase',
			'nxy': '1,2',
			'stokes': 'v',
			'axis': 'freq,amp',
			'line': 'chan,15,5,8',
		})

		miriad.uvspec({
			'vis': 'UVDATA/irc+10216.{0},UVoffsetCORRECT/irc+10216.{0}.corrected.slfc'.format(line),
			'device': 'irc+10216_{0}.ps/cps'.format(line),
			'interval': 9999,
			'options': 'avall,nobase',
			'nxy': '1,2',
			'stokes': 'v',
			'axis': 'freq,amp',
		})

