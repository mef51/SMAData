!
define character lab*25[9] pols*12[2] mol*25[9]
define integer p m n l[9] cc vv vel[12]
define real x y h v ll
set ticksize 0.14 0.07
set character 0.45
set angle sec
set plot portrait
pols[1] = "stki_bm1"

LUT gamma3.lut
m = 0
m = m+1
lab[m] = "h13co+43"
mol[m] = "H\u1\u3CO\u+ 4-3"
m = m+1
lab[m] = "so_9887"
mol[m] = "SO 9\d8-8\d7"


image smc6_'pols[1]'
set angle sec
limits -15 15 -12 15 /rev x
ll = 8.0
for j 1 to 2
for i 1 to 2
v = 25.0-ll*j
h = 2.5+ll*(i-1)
set box h h+ll v v+ll
!
limits -7 4 -4 6 /rev x
image smc6_'lab[j]'_m'i'
polygon polygon.smc6
mask out
	if (i.eq.1) then
plot /scaling lin 6.2 10.8
	else
plot /scaling lin 0.1 2.7
	endif
lev 2 4 7 to 97 by 10 
 image smc6_'pols[1]'
 pen /weight 2
 rgm /percent 1
 pen /weight 1
box n n 
 if (j.eq.1) then
wedge t
 endif
 if (i.eq.1) then
box n o  
draw relocate 2.6 7.0 
label 'mol[j]' /cent 4
 if (j.eq.2) then
box 
label "\gD\ga ('')" /x
label "\gD\gd ('')" /y
 endif
 endif
next
next
pause
sic delete smc6_moments.eps 
hard    smc6_moments.eps /dev eps color

