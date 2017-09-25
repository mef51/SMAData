#!/usr/bin/python3

import shutil, glob, os
import miriad

# GETSTOKES:

so="smc.8"

visin = combined.usb.
stokesout = '{}.stokes'.format(so)

if os.path.exists(stokesout): shutil.rmtree(stokesout)
miriad.uvaver({
	'vis': visin,
	'out': stokesout,
	'select': 'so({})'.format(so),
	'interval': 5
})

print("Made:", stokesout)
