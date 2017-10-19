#!/usr/bin/python3

import miriad
import miriad.squint as squint

if __name__ == '__main__':
	so = 'NGC7538S-s4'
	uvo = 'UVDATA'
	uvc = 'UVOffsetCorrect'
	mapdir = 'MAPSCorrect'

	lines = ['co3-2', 'ch2co17-16', 'cnt.usb', 'usb']
	# input("Press return to split")
	# squint.split(uvo, uvc, so, lines)
	# input("Press return to selfcal")
	# squint.selfcal(so, uvc, lines)
	input("Press return to map visibilities")
	squint.mapvis(uvo, uvc, so, mapdir, lines[:],
		lineSelection=['chan,1,38', None, None, None]
	)
	input("Press return to map visibilities with frequency axis")
	squint.mapallvis(uvo, uvc, so, mapdir, lines[:])
	input("Press return to save plots")
	squint.disp(uvo, uvc, so, mapdir,
		lines=['co3-2', 'ch2co17-16', 'cnt'],
		stokesVrms=[0.286, 0.0089, 0.0055]
	)

