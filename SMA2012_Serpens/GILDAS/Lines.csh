!
! jmg 05may99, 18apr13
!-----------------------------------
! Macro to plot Serpens SMC 6       
!  (1) I
!  (2) Q
!  (3) U
!  (4) I + Continuum polarization angles
!-----------------------------------
!
! all data at an angular resolution of 1.0x0.98, pa=60
! units in Jy
!
define real x1 y1 x2 y2
define real pi r ic ll dr1 dr2 dd1 dd2 RADIUS 
define character nom*20[4] llista1*30 llista2*30
define integer nn mm ff

pen /weight 2.0
set angle sec
set plot portrait
set character 0.50
set marker 4 1 0.6 45
tickspace 1 3 1 3 

cl pl
let pi      = 3.141593
let nom[1]   = "stki_bm1"
let llista1 = "list.smc.6"

! RMS of Q&U and of I
let r = 0.0032
let dr1 = -10.9
let dr2 =   4.1
let dd1 =  -7.8
let dd2 =   5.24

!----
! (1a)
!----
mm = 1
set box 4 16.5 2.8 15.5

image smc6_h13co+43_int.gdf /plane 2
set angle sec
limits -5.5 4.0 -5.0 4.5 /rev x
pen /col 0
lev 26 to 100 by 15  
rgm /grey 4 1 /percent 1

image smc6_co32.gdf /plane 1
set angle sec
pen /col 3
lev 0.2 to 3.0 by 0.15
rgm

image smc6_co32.gdf /plane 2
set angle sec
pen /col 1
lev 0.2 to 3.0 by 0.15 
rgm



image smc6_'nom[mm]'.gdf
set angle sec
pen /col 0
lev -2 2 5 9 13 18 to 98 by 10  
rgm /percent 1

pen /col 0 /dash 1
ellipse 1.090|2 0.944|2 90-67.0 /box 11.2 1.1 /fill 18
box   

pen /weight 4 /col 0
draw relo   -2.00  -4.4 /user
draw line   -3.20  -4.4 /user
pen /weight 1
draw text   -2.60  -4.0 " 500 AU" /user
draw text 0.5 11.3 "H\u1\u3CO\u+ 4-3 (grey) and 0.88mm dust" 9
!draw marker 18:29:49.790  01:15:20.40 /user abs
!draw marker 18:29:49.690  01:15:21.20   /user abs

pen /col 0 /dash 2 /weight 2
ll = 4.5
x1 = 49.79-(ll|15)*sin(pi*43|180)
y1 = 20.40+ll*cos(pi*43|180)
draw relocate 18:29:49.790 01:15:20.40 /user abs
draw arrow    18:29:'x1'   01:15:'y1' /user abs 
x1 = 49.79+(ll|15)*sin(pi*43|180)
y1 = 20.40-ll*cos(pi*43|180)
draw relocate 18:29:49.790 01:15:20.40 /user abs
draw arrow    18:29:'x1'   01:15:'y1' /user abs
pen /col 0 /dash 1

!---------------
! (1b) 2.0-sigma
!---------------
nn  = 38
define real dpa[nn] pol[nn]
column x 1 y 2 z 3 /file list.smc.6.paerr /lines 1 nn
dpa  = z
column x 1 y 2 z 3 /file list.smc.6.poli /lines 1 nn
pol = z
column x 1 y 2 z 3 /file list.smc.6.pa /lines 1 nn

pen /weight 4 /col 19
for i 1 to nn
ll = 0.40*pol[i]
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
!pause

!---------------
! (1c) 3-sigma
!---------------
!nn = 151
!define real dpa2['nn']
!column x 1 y 2 z 3 /file list.smc.6.paerr /lines 1 nn
!let dpa2 = z
!column x 1 y 2 z 3 /file list.smc.6.pa /lines 1 nn

!let ll = 0.70
!pen /weight 2 /col 1
!for i 1 to nn

!if (dpa2[i].eq.0.and.z[i].eq.0) then
! say 'i'":  fake value!!!"
! ff = ff+1
!else
! let x1 = x[i]+ll*sin((z[i]*pi|180)+pi|2)
! let y1 = y[i]+ll*cos((z[i]*pi|180)+pi|2)
! let x2 = x[i]-ll*sin((z[i]*pi|180)+pi|2)
! let y2 = y[i]-ll*cos((z[i]*pi|180)+pi|2)
! draw relo x1 y1 /user
! draw line x2 y2 /user
!endif
!next
!pen /weight 2 /col 0
!say " FAKE positions: "'ff'
label "\gD\ga (J2000)" /x
label "\gD\gd (J2000)" /y

!----
! (1a)
!----
mm = 1
set box 4 16.5 16.5 29.1

image smc6_h13co+43_m1.gdf
set angle sec
limits -7.5 6.2 -7.0 6.7 /rev x
pen /col 0
plot /scal lin 6 9.5

image smc6_h13co+43_int.gdf /plane 2
set angle sec
pen /col 0
lev -15 15 20 27 to 97 by 10  
rgm /percent 1

wedge right
pen /col 0 /dash 1
ellipse 1.090|2 0.944|2 90-67.0 /box 11.2 1.1 /fill 18
draw text 0.5 11.0 "H\u1\u3CO\u+ 4-3, Zero and first order moment maps" 9

box  

sic del smc6_bfield.eps
hard    smc6_bfield.eps /dev eps color
