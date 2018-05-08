#!/usr/bin/python3

# demo clean maps
import shutil, glob, os
import miriad

folders = ['IRC+10216']
sources = ['irc+10216']
maps = ['cm', 'mp', 'cc']

cgdispOptions = {
	'in': '../{0}/MAPSCorrect/{1}.co3-2.i.{2},../{0}/MAPSCorrect/{1}.co3-2.i.{2}'.format(folders[0], sources[0], maps[0]),
	'labtyp': 'arcsec,arcsec',
	'type': 'cont,pix',
	'slev': 'p,1',
	'levs1': '-20,20,30,40,50,60,70,80,90',
	# 'levs2': '-8,-7,-6,-5,-4,-3,-2,2,3,4,5,6,7,8',
	'cols1': 1,
	'device': 'irc+10216.co3-2.demo.{}.ps/cps'.format(maps[0]),
	'options': 'blacklab,beambl',
	'lines': '3,2,2',
	'olay': 'irc+10216.{}.olay'.format(maps[0]),
	'csize': '0,0,1.5'
}
miriad.cgdisp(cgdispOptions)

cgdispOptions['in'] = '../{0}/MAPSCorrect/{1}.co3-2.i.{2},../{0}/MAPSCorrect/{1}.co3-2.i.{2}'.format(folders[0], sources[0], maps[1])
cgdispOptions['device'] = 'irc+10216.co3-2.demo.{}.ps/cps'.format(maps[1])
cgdispOptions['olay'] = 'irc+10216.{}.olay'.format(maps[1])
# cgdispOptions['slev'] = 'p,1,a,{}'.format(0.02)
miriad.cgdisp(cgdispOptions)

cgdispOptions['in'] = '../{0}/MAPSCorrect/{1}.co3-2.i.{2},../{0}/MAPSCorrect/{1}.co3-2.i.{2}'.format(folders[0], sources[0], maps[2])
cgdispOptions['device'] = 'irc+10216.co3-2.demo.{}.ps/cps'.format(maps[2])
cgdispOptions['olay'] = 'irc+10216.{}.olay'.format(maps[2])
# cgdispOptions['slev'] = 'p,1,a,{}'.format(0.02)
miriad.cgdisp(cgdispOptions)

cgdispOptions['in'] = '../{0}/MAPSCorrect/{1}.co3-2.bm,../{0}/MAPSCorrect/{1}.co3-2.bm'.format(folders[0], sources[0], maps[2])
cgdispOptions['device'] = 'irc+10216.co3-2.demo.bm.ps/cps'
cgdispOptions['olay'] = 'irc+10216.bm.olay'.format(maps[2])
miriad.cgdisp(cgdispOptions)
