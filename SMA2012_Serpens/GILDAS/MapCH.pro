!
define character lab*25[9] pols*12[2] mol*28[9]
define integer  vel[12] m
define real x y h v ll sg bx[9] by[9] pa[9]
set ticksize 0.14 0.07
set character 0.35
set angle sec
set plot landscape
pols[1] = "stki_bm1"

LUT gamma3.lut
pen /col 0
sg = 0.19
m = 0
m = m+1
lab[m] = "hdco"
mol[m] = "HDCO 5\\d1,4\\u- 4\\d1,3"
bx[m] = 1.45|2
by[m] = 1.20|2
pa[m] = 64
m = m+1
lab[m] = "h13cn43"
mol[m] = "H\u1\u3CN 4-3"
bx[m] = 1.44|2
by[m] = 1.19|2
pa[m] = 63
m = m+1
lab[m] = "h13co+43"
mol[m] = "H\u1\u3CO\u+ 4-3"
bx[m] = 1.44|2
by[m] = 1.19|2
pa[m] = 63
m = m+1
lab[m] = "so"
mol[m] = "SO 9\d8-8\d7"
bx[m] = 1.44|2
by[m] = 1.19|2
pa[m] = 63


image smc6_'pols[1]'
set angle sec
ll = 3.8
	for j 1 to 4
	for i 1 to 7
v = 18.5-ll*j
h = 2.6+ll*(i-1)
set box h h+ll v v+ll
!
limits -6.5 6.5 -6.5 6.5 /rev x
lev 2 4 7 to 97 by 10 
image smc6_'pols[1]'
rgm /percent 1 /grey
lev 30 50 70 90
image smc6_'lab[j]'_ch.gdf /plane i+3
lev -3*sg 3*sg to 11*sg by 2*sg
rgm 

box n n 
 if (j.eq.4) then
  box p n 
 if (i.eq.1) then
ellipse bx[2] by[2] 90-pa[2] /box 0.5 0.5 /fill 18
 endif
 endif
 if (i.eq.1) then
box n o 
draw text 1.9 3.4 'mol[j]' 5
 endif
	next
	next
set box 3.4 5.6 3.2 6.8
label "\gD\ga ('')" /x
label "\gD\gd ('')" /y

pause
sic delete smc6_mol_ch.eps 
hard       smc6_mol_ch.eps /dev eps color

