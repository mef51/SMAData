define character m*2[3]
!fits  smc.6_h13cn43_ch.fits  to smc6_h13cn43_ch.gdf
!fits  smc.6_h13co+43_ch.fits to smc6_h13co+43_ch.gdf
!fits  smc.6_hdco_ch.fits     to smc6_hdco_ch.gdf
!fits  smc.6_so_9887_ch.fits  to smc6_so_ch.gdf

m[1] = "m0"
m[2] = "m1"
m[3] = "m2"
for i 1 to 3
 fits smc6_h13cn43_r2_'m[i]'.fits  to smc6_h13cn43_'m[i]'.gdf
 fits smc6_h13co+43_r2_'m[i]'.fits to smc6_h13co+43_'m[i]'.gdf
 fits smc6_hdco_r2_'m[i]'.fits     to smc6_hdco_'m[i]'.gdf
 fits smc6_so_9887_r2_'m[i]'.fits  to smc6_so_9887_'m[i]'.gdf
next
