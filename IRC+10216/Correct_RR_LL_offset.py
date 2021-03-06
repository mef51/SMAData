#!/usr/bin/python3

import miriad
import miriad.squint as squint

if __name__ == '__main__':
	so = 'irc+10216'
	uvo = 'UVDATA'
	uvc = 'UVOffsetCorrect'
	mapdir = 'MAPSCorrect'

	lines = ['cs7-6', 'sis19-18', 'h13cn4-3', 'co3-2', 'cnt.usb', 'usb']
	# input("Press return to split")
	# squint.split(uvo, uvc, so, lines)
	# input("Press return to selfcal")
	# squint.selfcal(so, uvc, lines)
	# input("Press return to map visibilities")
	# squint.mapvis(uvo, uvc, so, mapdir, lines[:],
	# 	lineSelection=[None, None, None, None]
	# )
	input("Press return to map visibilities with frequency axis")
	lsels = ['vel,8,-40,4,4' for l in lines]
	selects = ['uvrange(0,80)' if l == 'co3-2' else None for l in lines]

	lsels[lines.index('usb')] = miriad.averageVelocityLine('UVOffsetCorrect/irc+10216.usb.corrected.slfc', 17)
	squint.mapallvis(uvo, uvc, so, mapdir, lines[:],
		lineSelection=lsels,
		selects=selects
	)
	# input("Press return to save plots")
	# vrms = 0.13
	# squint.disp(uvo, uvc, so, mapdir,
	# 	lines=['cs7-6', 'sis19-18', 'h13cn4-3', 'co3-2', 'cnt'],
	# 	stokesVrms=[vrms for l in lines]
	# )
