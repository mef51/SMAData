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
define character nom*20[4] 
define integer nn mm ff
pen /weight 2.0
set angle sec
set plot portrait
set character 0.50
set marker 4 1 0.6 45
tickspace 0.1 0.5 1 4

cl pl
let pi      = 3.141593
let nom[1]  = "nat"
let nom[2]  = "bm1"

! RMS of Q&U and of I
let r = 0.0032
let dr1 = -5.3
let dr2 =  4.2
let dd1 =  -4.8
let dd2 =   4.7

! NATURAL WEIGHTING 0.86x0.75
!----
! (1)  DUST POL and EMISSIOn
!----
mm = 1
set box 4 17.0 16.0 29.0

image smc6_stki_'nom[mm]'.gdf
set angle sec
limits dr1 dr2 dd1 dd2 /rev x
pen /col 0
lev -1.5 1.5 3 5 10 17  to 98 by 10  
rgm /percent 1

pen /col 0 /dash 1
ellipse 0.861|2 0.752|2 90-74.1 /box 1.2 1.1 /fill 18
box n  o /abs
pen /weight 4 /col 0
draw relo   -2.00  -4.4 /user
draw line   -3.20  -4.4 /user
pen /weight 1
draw text   -2.60  -4.0 " 500 AU" /user


!---------------
! (1b) 2.0-sigma
!---------------
nn  = 68
define real dpa[nn]
column x 1 y 2 z 3 /file list.nat.smc6.paerr
dpa  = z
column x 1 y 2 z 3 /file list.nat.smc6.pa 

pen /weight 2 /col 0
for i 1 to nn
ll = 0.30
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
nn  = 25
define real dpa2[nn]
column x 1 y 2 z 3 /file list.nat.smc6_3sgm.paerr
dpa2  = z
column x 1 y 2 z 3 /file list.nat.smc6_3sgm.pa 
pen /weight 4 /col 19
for i 1 to nn
ll = 0.30
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

say " FAKE positions: "'ff'




! UVTAPER NATURAL WEIGHTING 1.28x1.11
!----
! (1)  DUST POL & EMISSION
!----
mm = 2
set box 4.0 17.0 3.0 16.0

image smc6_stki_'nom[mm]'.gdf
set angle sec
limits dr1 dr2 dd1 dd2 /rev x
pen /col 0
lev -1.5 1.5 3 5 10 17  to 98 by 10  
rgm /percent 1

pen /col 0 /dash 1
ellipse 1.280|2 1.108|2 90-66.0 /box 1.2 1.1 /fill 18
box  /abs

pen /weight 4 /col 0
draw relo   -2.00  -4.4 /user
draw line   -3.20  -4.4 /user
pen /weight 1
draw text   -2.60  -4.0 " 500 AU" /user
!draw marker 18:29:49.790  01:15:20.40 /user abs
!draw marker 18:29:49.690  01:15:21.20 /user abs


!---------------
! (1b) 2.0-sigma
!---------------
nn  = 53
define real dpa0[nn]
column x 1 y 2 z 3 /file list.smc6.paerr
dpa0  = z
column x 1 y 2 z 3 /file list.smc6.pa 

pen /weight 2 /col 0
for i 1 to nn
ll = 0.30
if (dpa0[i].eq.0.and.z[i].eq.0) then
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
pause

!---------------
! (1c) 3-sigma
!---------------
nn  = 23
define real dpa02[nn]
column x 1 y 2 z 3 /file list.smc6_3sgm.paerr
dpa02  = z
column x 1 y 2 z 3 /file list.smc6_3sgm.pa 
pen /weight 4 /col 19
for i 1 to nn
ll = 0.30
if (dpa02[i].eq.0.and.z[i].eq.0) then
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

set box 4.0 17.0 3.0 21.0
label "\ga (J2000)" /x
label "\gd (J2000)" /y


sic delete smc6_bfield.eps
hard    smc6_bfield.eps /dev eps color
