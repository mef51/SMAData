#!/usr/bin/python3

import miriad
import miriad.squint as squint

if __name__ == '__main__':
	so = 'orkl_080106'
	uvo = 'UVDATA'
	uvc = 'UVOffsetCorrect'
	mapdir = 'MAPSCorrect'

	lines = ['co3-2', 'sio8-7', 'cnt.usb', 'usb']
	# input("Press return to split")
	# squint.split(uvo, uvc, so, lines)
	# input("Press return to selfcal")
	# squint.selfcal(so, uvc, lines)
	input("Press return to map visibilities")
	squint.mapvis(uvo, uvc, so, mapdir, lines[:],
		lineSelection=[None, None, None, None]
	)
	input("Press return to map visibilities with frequency axis")
	usbLine = miriad.averageVelocityLine('UVOffsetCorrect/orkl_080106.usb.corrected.slfc/', 8)
	squint.mapallvis(uvo, uvc, so, mapdir, lines[:],
		lineSelection=['vel,43,-31,2,2', 'vel,27,-20,2,2', None, usbLine]
	)
	input("Press return to save plots")
	squint.disp(uvo, uvc, so, mapdir,
		lines=['co3-2', 'sio8-7', 'cnt'],
		stokesVrms=[0.13, 0.06, 0.03]
	)
