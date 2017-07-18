; IDL Version 8.3 (linux x86_64 m64)
; Journal File for rrao@hilodr2
; Working directory: /sma/reduction/rrao/SMA/science/polar/130824
; Date: Tue Mar 18 12:59:25 2014
 
history
; % Attempt to call undefined procedure/function: 'HISTORY'.
select,/p,/re
select
;All Sources:   titan 1751+096 smc.6 bllac  bllac 1751+096 smc.6 neptune uranus 3c84
;All Baselines:  2-4 2-5 2-6 2-7 4-5 4-6 4-7 5-6 5-7 6-7 2-4 2-5 2-6 2-7 4-5 4-6 4-7 5-6 5-7
;6-7
;All Recs:  230 345 400 690
;All Bands:  c1 s01 s02 s03 s04 s05 s06 s07 s08 s09 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19
;s20 s21 s22 s23 s24 s25 s26 s27 s28 s29 s30 s31 s32 s33 s34 s35 s36 s37 s38 s39 s40 s41 s42
;s43 s44 s45 s46 s47 s48
;All Sidebands :  l u
;All Polarization states:  hh vv hv vh
;All Integrations: 0-2254
select,/p,/re
idl2miriad,source='titan',dir='titan.usb',polar=1,sideband='u'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO LSB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT           18  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
;--- Closing up data directory ---
idl2miriad,source='titan',dir='titan.lsb',polar=1,sideband='l'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO USB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT           18  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
;--- Closing up data directory ---
idl2miriad,source='1751+096',dir='1751+096.usb',polar=1,sideband='u'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO LSB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
; ### NOTE: NO TSYS DATA FOR ANT            2 AT INT          685  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
;--- Closing up data directory ---
idl2miriad,source='1751+096',dir='1751+096.lsb',polar=1,sideband='l'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO USB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
; ### NOTE: NO TSYS DATA FOR ANT            2 AT INT          685  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
;--- Closing up data directory ---
idl2miriad,source='smc.6',dir='smc.6.usb',polar=1,sideband='u'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO LSB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT           95  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT           96  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT           97  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT           98  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT           99  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          100  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          101  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          102  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          103  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          104  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          105  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          106  SIDEBAND u ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
;--- Closing up data directory ---
idl2miriad,source='smc.6',dir='smc.6.lsb',polar=1,sideband='l'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO USB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT           95  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT           96  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT           97  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT           98  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT           99  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          100  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          101  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          102  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          103  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          104  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          105  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
; ### NOTE: NO TSYS DATA FOR ANT            7 AT INT          106  SIDEBAND l ###
;Arbitrary system temperature of 400 K is inserted for this antenna
;and data on associated baselines will be flagged bad
;--- Closing up data directory ---
idl2miriad,source='bllac',dir='bllac.usb',polar=1,sideband='u'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO LSB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
; % CALL_EXTERNAL: Variable is undefined: THISPOL.
idl2miriad,source='bllac',dir='bllac.lsb',polar=1,sideband='l'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO USB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
; % CALL_EXTERNAL: Variable is undefined: THISPOL.
idl2miriad,source='neptune',dir='neptune.usb',polar=1,sideband='u'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO LSB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
;No solution for wideband u at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        0 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        1 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        2 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        3 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        4 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        5 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        6 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        7 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        8 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        9 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       10 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       11 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       12 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       13 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       14 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       15 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       16 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       17 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       18 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       19 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       20 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       21 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       22 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       23 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       24 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       25 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       26 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       27 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       28 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       29 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       30 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       31 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       32 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       33 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       34 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       35 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       36 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       37 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       38 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       39 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       40 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       41 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       42 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       43 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       44 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       45 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       46 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       47 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for wideband u at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        0 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        1 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        2 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        3 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        4 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        5 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        6 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        7 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        8 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        9 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       10 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       11 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       12 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       13 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       14 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       15 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       16 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       17 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       18 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       19 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       20 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       21 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       22 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       23 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       24 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       25 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       26 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       27 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       28 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       29 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       30 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       31 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       32 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       33 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       34 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       35 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       36 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       37 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       38 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       39 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       40 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       41 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       42 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       43 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       44 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       45 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       46 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       47 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;--- Closing up data directory ---
idl2miriad,source='neptune',dir='neptune.lsb',polar=1,sideband='l'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO USB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
;No solution for wideband l at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        0 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        1 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        2 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        3 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        4 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        5 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        6 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        7 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        8 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        9 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       10 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       11 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       12 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       13 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       14 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       15 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       16 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       17 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       18 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       19 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       20 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       21 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       22 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       23 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       24 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       25 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       26 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       27 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       28 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       29 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       30 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       31 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       32 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       33 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       34 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       35 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       36 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       37 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       38 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       39 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       40 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       41 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       42 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       43 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       44 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       45 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       46 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       47 at integration         1190.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for wideband l at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        0 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        1 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        2 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        3 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        4 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        5 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        6 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        7 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        8 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband        9 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       10 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       11 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       12 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       13 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       14 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       15 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       16 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       17 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       18 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       19 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       20 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       21 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       22 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       23 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       24 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       25 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       26 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       27 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       28 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       29 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       30 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       31 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       32 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       33 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       34 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       35 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       36 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       37 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       38 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       39 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       40 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       41 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       42 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       43 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       44 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       45 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       46 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;No solution for narrowband       47 at integration         1256.
;Arbitrary system temperature of 400 K is inserted for all antennas
;and data will be flagged bad
;--- Closing up data directory ---
idl2miriad,source='uranus',dir='uranus.usb',polar=1,sideband='u'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO LSB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
;--- Closing up data directory ---
idl2miriad,source='uranus',dir='uranus.lsb',polar=1,sideband='l'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO USB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
;--- Closing up data directory ---
idl2miriad,source='3c84',dir='3c84.usb',polar=1,sideband='u'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO LSB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
;--- Closing up data directory ---
idl2miriad,source='3c84',dir='3c84.lsb',polar=1,sideband='l'
; *********************** NOTICE ***********************
; THIS IS THE BETA VERSION OF IDL2MIRIAD FOR CONVERTING
; SMA DATA FROM MIR/IDL FORMAT INTO MIRIAD FORMAT. BE
; SURE TO MAKE A MIR_SAVED BACKUP COPY BEFORE PROCEEDING
; IN CASE THIS PROGRAM FAILS AND CORRUPTS YOUR DATA.
; USAGE: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',band='s1',edge_trim=0.1,polar=0,/verbose)
;    or: idl>idl2miriad,dir='outputdir',source='sourcename'
;          (,sideband='u',/cont,edge_trim=0.1,polar=0,/verbose)
; ALL DATA SATISFYING THE FILTER SETUP AND SELECTION
; CRITERIA WILL BE OUTPUT. BAD (NEG. WEIGHT) DATA WILL
; BE FLAGGED AS BAD (FALSE) IN MIRIAD DATASET. TO
; EXCLUDE THOSE DATA BEING OUTPUT, PLEASE USE FILTER
; WITH /POS_WT SETUP BEFORE RUNNING IDL2MIRIAD.
; CONTINUUM BAND DATA WILL ALWAYS BE OUTPUT. BY DEFAULT,
; AT LEAST ONE NARROW SPECTRAL WINDOW NEEDS TO EXIST IN
; THE FILTERED DATASET OR TO BE SPECIFIED FOR PROPER
; OUTPUT OF THE SPECTRAL DATA. ON THE OTHER HAND, ONE
; CAN USE THE /cont FLAG TO OUTPUT ONLY CONTINUUM DATA
; AS SPECTRAL CHANNEL(S). IN EITHER CASE, PSEUDO CONTINUUM
; CHANNEL(S) WILL BE CREATED USING DATA FROM THE NARROW
; SPECTRAL WINDOWS(CHUNKS). EDGE CHANNELS (10% ON EACH SIDE)
; IN EACH CHUNK ARE TRIMMED OUT WHEN COMPUTING THE PSEUDO
; CONTINUUM WITH SPECTRAL CHUNK DATA. THIS TRIMMING FRACTION
; CAN BE MODIFIED WITH THE EDGE_TRIM KEYWORD.
; IF READY, PRESS ANY KEY TO CONTINUE......
;The polarization codes in MIR data are considered as circularly polarization.
;Likely NO USB Continuum Data Present.
;--- Creating/Opening new data directory ---
;--- Writing brief history entry ---
;--- Inserting observer header info ---
;--- Inserting observatory specific header info ---
;--- Inserting source header info ---
;--- Inserting observing setup header info ---
;---         wide band channel header info ---
;---       narrow band channel header info ---
;---              polarization header info ---
;---              fake antpos/corr header info ---
;--- READY TO CYCLE THROUGH ALL INTEGRATIONS ---
;--- Closing up data directory ---
