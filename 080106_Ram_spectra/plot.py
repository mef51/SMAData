#!/usr/bin/python3

from miriad import uvspec, imspec

if __name__ == '__main__':
	imspec({
		'in': 'MAPSCorrect/orkl_080106.co3-2.v.cm',
		'region': "'abspixel,box(75,53,83,63)'",
		'device': '1/xs',
		'axes': 'spectral'
	})
