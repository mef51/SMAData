!
define character lab*25[99] pols*12[2]
define integer nn mm ff
define integer p m n l[9] cc vv vel[12] 
define real h v ll
define real x1 y1 x2 y2

set ticksize 0.14 0.07
set character 0.52
set angle sec
set plot portrait
pols[1] = "stki_bm1"

LUT gamma3.lut
m = 0
m = m+1
lab[m] = "h13co+43"
m = m+1
lab[m] = "co32"
m = m+1
lab[m] = "sio8"

image smc6_'pols[1]'
set angle sec
ll = 16.0
for j 1 to 1
for i 0 to 0
v = 19.0-ll*j
h = 3.0+ll*i
set box h h+ll v v+ll
!
limits -6.5 4 -5 5 /rev x
 lev 2 4 7 to 97 by 10 
 image smc6_'pols[1]'
 rgm /percent 1 /grey
 lev 35 55 75 95
 image smc6_'lab[j]'_r2_m'i'
 rgm /percent 1 
 pen /col 3
 image smc6_co32.gdf /plane 1
 rgm /percent 1 
 pen /col 1
 image smc6_co32.gdf /plane 2
 rgm /percent 1 
 pen /col 15 /weigh 3
 image smc6_sio87_int.gdf 
 lev 40 60 80
 rgm /percent 1 
draw relo 10.0 1.6
draw line 10.6 1.6
 pen /col 0 /weight 1
!draw relocate 2.6 7.0 
!label 'lab[j]' /cent 4
draw relo 10.0 2.4
draw line 10.6 2.4
pen /col 1
draw relo 10.0 0.85
draw line 10.6 0.85
pen /col 3 
draw relo 10.0 0.7
draw line 10.6 0.7
pen /col 0
draw text 11 0.5 "CO 3-2"  9
draw text 11 1.3 "SiO 8-7"  9
draw text 11 2.1 "H\u1\u3CO\u+ 4-3" 9
box /abs
label "\ga (J2000)" /x
label "\gd (J2000)" /y
next
next

set angle rad
tickspace 20 100 0.1 0.5
limits -110 130 -0.25 0.64
set box 3 11 21 27
column x 1 y 2 /file spec2_sio87.smc6 /line 8
connect
box
draw text -50 0.5 "SiO 8-7" /user
label "v\\dLSR\\u (km/s)" /x
label "S (Jy/Beam) (J2000)" /y

set box 11 19 21 27
column x 1 y 3 /file spec2_sio87.smc6 /line 8
connect
pen /dash 3
draw relo  130 0 /user
draw line -350 0 /user
pen /dash 1
box p n

pause
sic delete smc6_CO.eps 
hard    smc6_CO.eps /dev eps color

clear
tickspace 0.1 0.5 1 4 
set angle sec

image smc6_'pols[1]'
set angle sec
ll = 16.0
v = 5.0
h = 3.0
set box h h+ll v v+ll
!
limits -5.5 4.0 -5.0 4.5 /rev x
limits -6.5 5.0 -6.0 5.5 /rev x

 lev 1.5 3.0 4 9 19 29 49 69 89
 image smc6_'pols[1]'
 rgm /percent 1 /grey 2
! draw marker 18:29:49.80 01:15:20.6 /user abs
! draw marker 18:29:49.69 01:15:21.2 /user abs
 image smc6_co32.gdf /plane 1
 pen /col 3
 lev 25 45 65 85
 rgm /percent 1 
 pen /col 1
 image smc6_co32.gdf /plane 2
 rgm /percent 1 
 pen /col 15 /weigh 3
 image smc6_sio87_int.gdf 
 lev 40 60 80
 rgm /percent 1 
 pen /col 0 /weight 1
!draw relo 10.0 1.6
!draw line 10.6 1.6
!pen /col 1
!draw relo 10.0 0.8
!draw line 10.6 0.8
!pen /col 3 
!draw relo 10.0 0.6
!draw line 10.6 0.6
!pen /col 0
!draw text 11 0.5 "CO 3-2"  9
!draw text 11 1.3 "SiO 8-7"  9
! Radio jet Serpens
set marker 4 1 0.5 45
draw marker 18:29:49.494  01:15:24.33 /user abs
draw marker 18:29:49.775  01:15:20.75 /user abs
draw marker 18:29:50.107  01:15:16.77 /user abs
box /abs

!---------------
! (1b) 2.0-sigma
!---------------
nn  = 62
define real dpa[nn] pol[nn]
column x 1 y 2 z 3 /file list.smc.6.paerr /lines 1 nn
dpa  = z
column x 1 y 2 z 3 /file list.smc.6.poli /lines 1 nn
pol = z
column x 1 y 2 z 3 /file list.smc.6.pa /lines 1 nn

pen /weight 2 /col 0
for i 1 to nn
ll = 0.24
if (dpa[i].eq.0.and.z[i].eq.0) then
 say 'i'":  fake value!!!"
 ff = ff+1
else
 let x1 = x[i]+ll*sin((z[i]*pi|180)+pi|2)
 let y1 = y[i]+ll*cos((z[i]*pi|180)+pi|2)
 let x2 = x[i]-ll*sin((z[i]*pi|180)+pi|2)
 let y2 = y[i]-ll*cos((z[i]*pi|180)+pi|2)
 draw relo x1 y1 /user
 draw line x2 y2 /user
endif
next
pen /weight 2 /col 0

say " FAKE positions: "'ff'
!---------------
! (1c) 3-sigma
!---------------
nn = 20
define real dpa2['nn']
column x 1 y 2 z 3 /file list.smc.6_3sgm.paerr /lines 1 nn
let dpa2 = z
column x 1 y 2 z 3 /file list.smc.6_3sgm.pa /lines 1 nn

pen /weight 4 /col 19
for i 1 to nn

if (dpa2[i].eq.0.and.z[i].eq.0) then
 say 'i'":  fake value!!!"
 ff = ff+1
else
 let x1 = x[i]+ll*sin((z[i]*pi|180)+pi|2)
 let y1 = y[i]+ll*cos((z[i]*pi|180)+pi|2)
 let x2 = x[i]-ll*sin((z[i]*pi|180)+pi|2)
 let y2 = y[i]-ll*cos((z[i]*pi|180)+pi|2)
 draw relo x1 y1 /user
 draw line x2 y2 /user
endif
next
pen /weight 2 /col 0

set box 3.5 18 5 15

label "\ga (J2000)" /x
label "\gd (J2000)" /y
say " FAKE positions: "'ff'

sic delete smc6_co_pol.eps
hard smc6_co_pol.eps /dev eps color

