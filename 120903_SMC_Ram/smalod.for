c************************************************************************
        program smalod 
        implicit none
c
c= smalod - Convert an Sma archive data (Caltech MIR) into Miriad uv format
c& jhz 
c: data transfer
c+
c       SMALOD is a MIRIAD task, which converts the standard SMA data 
c       format to Miriad format. It also automatically selects SMA
c       doubleband patch for handling 4GHz data.
c
c@ in   Name of the input MIR file.
c       There is no default.
c
c@ out
c       Name of the output Miriad uv data-set. No default.
c
c@ rxif
c       select data from one of the dual receivers/IFs: 
c       rxif=-1 for the 1st rxif band;
c       rxif=-2 for the 2nd rxif band.
c
c       select the data based on receiver id:
c       for data taken after  2006-12-28 --
c       rxif=0 for receiver id = 0 -> 230 GHz band;
c       rxif=1 for receiver id = 1 -> 340 GHz band;
c       rxif=2 for receiver id = 2 -> 400 GHz band;
c       rxif=3 for receiver id = 3 -> 690 GHz band;
c       for data taken before 2006-12-28 --
c       rxif=0 for receiver id = 0 -> 230 GHz band;
c       rxif=1 for receiver id = 1 -> 340 GHz band;
c       rxif=2 for receiver id = 2 -> 690 GHz band.
c
c       The default is rxif=-1 or the 1st rxif band.
c
c@ restfreq
c       The rest frequency, in GHz, for line observations.  By default,
c       the value in the MIR file is used.
c       we are cosidering to support the following functions: Giving a
c       value for the "restfreq" parameter overrides the MIR file value.
c       If you do set this parameter, you MUST give the same number of
c       values as the number of IFs written out. A value of 0 is used
c       for a continuum observation. For example, if you have two IFs,
c       the first of which is CO(3-2), and the second is continuum, use
c       restfreq=345.795991,0
c       Not for 4GHz data.
c
c@ vsource
c       The radial velocity of source in km/s w.r.t. the LSR or 
c       the barycenter, which was included in the online Doppler
c       track. The velocity reference frame can be selected 
c       in options. Positive velocity is away from observer.
c       Default is zero.
c       Not for 4GHz data.
c
c@ refant
c       The reference antenna. Default is 6. The reference antenna needs
c       to be present while the antenna positions are being decoded 
c       from baseline vectors stored in SMA MIR data. The geocentrical 
c       coordinates for the antennas can be retrieved from SMA sybase. 
c       For double checking the antenna positions, one can login to
c       d2o.sma.hawaii.edu (IP:128.171.116.111) and use the following
c       command:
c       dBValue -d hal9000-newdds -v dsm_dds_hal_x_v11_d -t "2004-11-16 00:00:00"
c       dBValue -d hal9000-newdds -v dsm_dds_hal_y_v11_d -t "2004-11-16 00:00:00"
c       dBValue -d hal9000-newdds -v dsm_dds_hal_z_v11_d -t "2004-11-16 00:00:00"
c       If the reference antenna is not the default value 6, one may need
c       to give the reference antenna here.
c       For 4GHz data, it uses the reference antenna given in the
c       antenna table.
c
c@ options
c       'bary'     Compute the radial velocities of the observatory, in the 
c                  direction of a source, w.r.t. the barycenter. 
c		   Default uses the on-line values.
c       'lsr'      Compute the radial velocities of the observatory, in the 
c                  direction of a source, w.r.t. the LSR. 
c                  Default uses the on-line values.
c                  The above two options might be applied only when
c                  the chunk frequency stored in the SMA raw data
c                  corresponds to the true Doppler tracked sky frequency
c                  or no online correction to the frequency has been
c                  made. 
c       'nopol'    Disable polarization. All the correlations will be
c                  labelled as XX. Default in options for polarization 
c                  is nopol.
c       'circular' when circular polarization data taken with single
c                  receivers and waveplates for each antenna. For the 
c                  circular polarization data observed before 2005-06-10, 
c                  the polarization states are swapped by the default 
c                  (RR<->LL, RL<->LR or -1 <-> -2, -3 <-> -4).
c
c       'linear'   when linear polarization data taken with dual linear feeds.
c   
c       'oldpol'   Obsoleted. 
c                  Defaults assume that non-polarization state is assigned.
c       'dospc'    reverses the order of the spectral chunks in frequency
c                  only for the first three blocks (1 2 3).
c                  frequency code vs. spectral window orders:
c                   frcode iband 
c		       	 4 1
c			 3 2
c			 2 3
c			 1 4
c			 8 5
c			 7 6
c			 6 7
c		 	 5 8
c			12 9
c			11 10
c			10 11
c			 9 12
c			13 13
c			14 14
c			15 15
c			16 16
c			17 17
c			18 18
c			19 19
c 			20 20
c	  		21 21
c			22 22
c			23 23
c			24 24 
c       'doengrd'  to read the engineer file for Tsys and LST.
c       'conjugat' to phase conjugate for lsb data.
c                  Default: 
c                  conjugate the phase of the lsb data observed before 
c                  2005-04-28;
c                  no phase flip for the data observed after 2005-04-28.
c       'noskip'   not to skip any data; the default is to skip
c                  data with source name "target" and/or "unknown".
c       'mcconfig' to handle multiple correlator configurations.
c                  The default is to handle multiple correlator configuration. 
c       'nohspr'   to turn off the high spectral resolution mode.
c                  For data taken after 2006-5-12, the default 
c                  will properly handle the hybrid high spectral 
c                  resolution mode, allowing presence of empty 
c                  spectral windows (chunks).
c       'debug'    to print out the warning messages indicating
c                  what have been fixed or skipped for the header
c                  problems. ERRreport.log is created in reporting
c                  the detailed errors. Default mutes these messages.
c       'uvwide'   to call uvwide routine to generate "wideband" data
c                  while the original uvdata files are kept. The
c                  output wideband data should be identical with
c                  the products from uvwide program with the default
c                  keyword input.
c                  The default is not to generate "wideband" data.
c       'sendian'  For little endian online data computer; 
c                  default is for big endian formatted data.
c       '2GHz'     Only check 2GHz mode (for old data before end of 2008).
c                  The default is to check both 2GHz and 4GHz mode.
c       'flagch0'  The default is to flag ch0 data in 4GHz data mode.
c       'ipoint'   An option to keep the ipointing data. The default is 
c                  to flag iPointing data with non-zero offset from source.
c
c       No extra processing options have been given yet. The default
c       works.
c
c@ rsnchan
c	This is an option for resampling SMA uvdata from higher
c	spectral resolution to lower spectral resolution or from
c	hybrid spectral resolutions across the 24 spectral windows
c       (chunks or IFs) to a uniform spectral resolution. 
c       The default or a negative is no resampling to be applied. 
c       Note that this number must be power of 2 and equal to/less 
c       than the smallest channel number in the 24 spectral windows.
c       If rsnchan is not equal to the nth power of 2, the program 
c       will take the a number of 2**n which is close to the input
c       value. If rsnchan is greater than the smallest channel  number,
c       the program will take the smallest channel number. 
c       It has not been implemented for 4GHz data.
c
c@ spskip
c       For data taken after 2006-5-12, the default will properly
c       handle the skipped windows (chunks).
c       For data taken earlier than 2006-5-12, this keyword 
c       specifies the skipping in spectral windows, e.g.:
c       spskip=21,2 means that starting at spcode (MIR) = 21, two
c       spectral chunks are skipped, i.e. no data are produced for the
c       spectral chunks with spcode=21 and 22. Then smalod will
c       move up by two spectral windows while storing the rest of
c       the chunks' data with the following mapping between MIR
c       spcode and Miriad spectral window id:
c                 MIR       Miriad
c                  1    ->    1
c                  2    ->    2
c                 ...
c                 20    ->   20
c                 21 skipped
c                 22 skipped
c                 23    ->   21
c                 24    ->   22
c       Thus, the data in Miriad format will have a total
c       of 22 spectral windows instead of 24.
c
c       In addition, spskip=-1 takes the frequency 
c       configuration from that of the first integration
c       assigned by nscans assuming that the frequency 
c       configuration for the rest of integrations does not 
c       change. 
c       
c       For old data sets (such as 2003), spskip=-2003 might be 
c       useful to handle data from an incompleted correlator.
c
c       The default is no skipping in spectral windows.
c       It has not been implemented for 4GHz data.
c 
c@ sideband
c       This is an option for separating sidebands. A value of 0 is for
c       lower sideband only, 1 for upper sideband and 2 for both.
c       The default is 0.
c
c@ nfiles
c       This gives one or two numbers, being the number of files to skip,
c       followed by the number of files to process (not yet). This is only
c       useful when the input is a tape device containing multiple files.
c       The default is 0,1 (i.e. skip none, process 1 file).
c       It has not been implemented.
c
c@ nscans
c       This gives one or two numbers, being the number of scans to skip,
c       followed by the number of scans to process. 
c       The default is to skip the 1st and the last 2 scans
c       and process the rest of scans in the file.
c       It has not been implemented for 4GHz data. For 4GHz data, it
c       loads in all the data.
c--
c  History:
c    jhz 15-jul-04 made the original version.
c    jhz 30-aug-04 add options "nopol" to disable the polarization
c    jhz 03-sep-04 add options "oldpol" to convert non-convetion
c                  SMA polariztion state labelling to the convetion
c                  that both NRAO and BIMA follow.
c    jhz 30-nov-04 implemented handling both sideband together
c    jhz  1-dec-04 implemented dual receivers
c    jhz  16-dec-04 added  checking the length of infile
c    jhz  11-jan-05 merged smauvrsample into smalod;
c    jhz  11-jan-05 added Key word rsnchan controls the resmapling vis 
c                   spectra output.  
c    jhz  28-feb-05 added option dospc
c    jhz  01-mar-05 added rx id label to the output file
c    jhz  02-mar-05 added options doengrd to read engineer data file
c    jhz  08-mar-05 added options circular to read polarization data
c                   taken from single feed with waveplates.
c    jhz  10-mar-05 decoded the antenna positions from mir baseline
c                   coordinates; converted the geocentrical coordinates
c                   to miriad coordinates.
c    jhz  10-mar-05 removed uvputvra for file name which somehow
c                   is rejected by miriad program uvlist.
c    jhz  18-mar-05 added linear in options for polarization;
c                   made default for nopol
c    jhz  18-mar-05 corrected size for mount in uvputvr
c    jhz  23-mar-05 fixed a bug in decoding antenna position
c                   for antennas with id > reference antenna's id. 
c    jhz  01-apr-05 cleaned some mess left from atlod. 
c    jhz  02-may-05 add a function to add '/' in the end of the input
c                   file name in case the slash is missing.
c    jhz  02-may-05 add an option to do phase conjugate for the lower side
c                   band data in respose to Taco's log 9288.
c    jhz  05-may-05 enable the function to calculate radial velocity
c                   on either barycentric of lsr frame.
c    jhz  02-jun-05 add input parameter vsource; and enable input
c                   parameter restfreq.
c    jhz  20-jun-05 fix a bug (pointing to a wrong v component) in calculation\
c                   of the site velocity due to the earth rotation.
c                   The error was in the sma_mirRead.c
c    jhz  21-jun-05 eliminate unused variables and subroutines
c    jhz  22-jun-05 make restfreq working
c    jhz  24-jun-05 add variable ut
c    jhz  27-jun-05 add initializing blarray in sma_mirRead.c
c    jhz  05-jul-05 update the version corresponding to
c                   remove a hidden phase flip in sma_mirRead.c
c    jhz  07-jul-05 update jyperk in sma_mirRead.c
c                   change the default of the first argument in 
c                   nscans to 1
c    jhz 07-jul-05 pasring the source name in sma_mirRead.c
c                   changing the source name if the first 8
c                   characters are identical for any of the two source
c                   name entries from mir data.
c    jhz 08-aug-05 updating the inline document for vsource;
c                   the velocity reference frame for vsource
c                   is defined using options; either bary or lsr
c                   is supported. 
c    jhz 31-aug-05 update the inline doc for option lsr and bary.
c    jhz 28-sep-05 update the inline doc for vsource.
c    jhz 11-oct-05 add on-line flagging
c    jhz 11-oct-05 add an option to read antenna positions 
c                  from the ASCII file 'antennas'.
c    jhz 13-oct-05 the sma_mirRead.c is implemented
c                  for swapping r with l for the polarization data
c                  observed before 2005-6-10.
c                  also skipping the decoding Doppler velocity
c                  because of the velocity entry in the header
c                  of MIR data appeared to be screwed up.
c    jhz 09-nov-05 add options of noskip.
c    jhz 30-nov-05 update version number according to the
c                  change made in sma_mirRead.c for
c                  storing pointing position in all the cases
c                  rather than only when pointing position
c                  differs from source catalog position
c                  (FITS convention)
c    jhz 05-dec-05 add the inline doc to options oldpol
c                  to explain the two stages in pol state
c                  conversion from MIR data to Miriad convention:
c                  1) before 2004-9-1 and 2) before 2005-6-10.
c    jhz 05-dec-05 Obsoleted options=oldpol.
c    jhz 06-dec-05 add keyword spskip.
c    jhz 30-dec-05 fix  the inconsistence
c                  of the total number of integrations
c                  in the mir header files (in_read and bl_read).
c    jhz 24-jan-06 add options for skipsp=-1
c    jhz 03-feb-06 optimize the memory requirement
c    jhz 08-feb-05 add a feature to handle multiple correlator configu.
c    jhz 06-mar-06 add a feature to handle 2003 data with incompleted
c                  correlator.
c    jhz 18-may-06 implemented hybrid high spectral resolution mode,
c                  allowing presence of empty data chunks.
c    jhz 09-jun-06 fixed a bug in sma_mirRead.c in parsing source if
c                  in the case no source information is given in
c                  mir data (an on-line bug)
c    jhz 12-jun-06 updated version date
c    jhz 09-aug-06 changed a typo in line 346
c    jhz 29-dec-06 implemented handling 400 rx
c    jhz 04-jan-07 implemented reading projectInfo fil
c    jhz 08-jan-07 store chi and chi2
c    jhz 08-jan-07 remove mount=0; back to mount=4 or
c                  sma/mount =  NASMYTH
c    jhz 10-jan-07 add evector
c    jhz 31-jan-07 changed source name length limit from 
c                  8 characters to 16.
c    jhz 07-mar-07 removed redundnt call of juliandate
c                  added percent of file reading in the prompt
c                  message.
c    jhz 07-mar-07 robustly handling antennas file.
c                  obsolete readant in the keyword input. 
c    jhz 06-jun-07 added a bug report message accoding to
c                  the new limits set by SMA hardware.
c    jhz 11-jun-07 fixed a bug in passing the values of nscans array.
c    jhz 12-jun-07 obsoleted single corr config loading mode. 
c    jhz 07-sep-07 added the 'debug' in options.
c    jhz 27-sep-07 fixed initialization problem in sma_mirRead.c
c    jhz 08-nov-07 change the extension of the output file name
c                  in the rx selection of a negative value.
c    jhz 14-nov-07 added a feature to fix the source coordinate
c                  problem in the MIR data
c    jhz 27-nov-07 added a patch to fix the frequency labelling problem
c                  in the old SMA data (before 2007-11-26) with the recipe
c                  described in the SMA operation log # 14505
c    jhz 23-jan-08 fixed a bug in rar2c and decr2c in c program
c    jhz 07-feb-08 added uvwide subroutines to generate
c                  "wide band" data in SMA data
c    jhz 12-sep-08 added sma prefix to the name of subroutines used in 
c                  Peter T.'s uvwide program. Disable the function call 
c                  for removal of the original uv data.
c    jhz 01-nov-08 doubling band implemented.
c    jhz 01-nov-09 added dbcheck routine.
c    jhz 10-nov-09 integrated dbpatch. 
c    jhz 13-nov-09 add options of flagch0.
c    jhz 24-nov-09 add a routine to check online software version.
c    jhz 27-nov-09 prepare for beta release.
c    jhz 26-Jan-10 clear the inline doc for options    
c    jhz 03-Jun-10 integrate the DRX patch
c    jhz 09-Aug-10 implemented sb=2 feature for dbpatch 
c    jhz 07-Oct-10 implemented 2GHz options.
c    jhz 13-Oct-10 get obspar for dbpatch.
c    jhz 05-Mar-11 for the data taken from dual receivers in 2010 spring
c                  and later, the new DrxPatch is used.
c    jhz 18-Mar-11 fixed a few problems in reading dual receiver 2 GHz new data
c    jhz 28-Mar-11 added options to do both sidebands simultaneously for dual rx mode
c                  added a warning message for Miriad updating.
c    jhz 25-May-12 added ipoint in options
c    jhz 08-Jun-12 added do4GHz and correct for errors in parsing 4GHz data  
c    jhz 11-Jun-12 added parsing modeInfo
c    jhz 12-jun-12 fixed initialization problem for restfreq in ubuntu
c    jhz 12-jun-12 add lendian options
c    jhz 21-jun-12 change lendian to sendian, preparing for
c                  default setting for little endian iincoming data
c    jhz 28-jun-12 add doflagch0,datEndian,iPointflag,lat1,long1,evec1
c                  in drxpatch   
c------------------------------------------------------------------------
        include 'maxdim.h'
        integer maxfiles
        parameter(maxfiles=128)
        character version*(*)
        parameter(version='SmaLod: version 3.10-beta 28-June-2012')
c
        character in(maxfiles)*64,out*64,line*64, rxc*4
        character msg*64
        parameter(msg='Loading standard SMA data ...')
        character msg2*64
        integer tno, length, len1, wmaxchan
        parameter(wmaxchan=maxchan*2)
        integer ifile,rxif,nfreq,iostat,nfiles,i
        double precision rfreq
        logical doauto,docross,docomp,dosam,relax,unflag,dohann
        logical dobary,doif,birdie,dowt,dopmps,doxyp,doop
        logical polflag,hires,nopol,sing,circular,linear,oldpol,dsb,
     *          dospc,doengrd,doconjug,dolsr,noskip,mcconfig,nohighspr,
     *          dodebug,dowide,doflagch0,iPointflag
        integer fileskip,fileproc,scanskip,scanproc,sb,dosporder
        integer doeng,spskip(2),sscanskip,sscanproc
        integer doflag1st
	integer rsNCHAN, refant, readant, antid, lIn, nspect
        double precision antpos(10*3),xyz(3)
        real vsour
        character fname*64
        integer nchan
        complex data(maxchan),wdata(wmaxchan)
        logical flags(maxchan),wflags(wmaxchan)
        double precision preamble(5)
        integer nchunk
        double precision drxjday,do4GHzjday
        parameter(do4GHzjday=2454879.5)
        logical dodrxptch,do2GHz,do4GHz 
        double precision dtemp
        double precision lat1,long1,evec1
        logicAl ok, doswap
        integer infoRX, infoCM, datEndian
c
c  Externals.
c
        character smaerr*32,itoaf*8, filebuf*64, charbuf*1
        do4GHz = .false.
        dsb = .false.
        dodrxptch = .false.
        nspect=0
c
c  Get the input parameters.
c
        call output(version)
        call keyini
        call mkeyf('in',in,maxfiles,nfiles)
        filebuf=in(1)(1:len1(in(1)))
        charbuf=in(1)(len1(in(1)):len1(in(1)))
           if(charbuf.ne."/")  
     *      in(1)=filebuf(1:len1(filebuf))//'/'
        if(nfiles.gt.1)
     *    call bug('f','Only handle one input file at once')
        if(nfiles.eq.0)
     *    call bug('f','Input name must be given')
        call keya('out',out,' ')
        if(out.eq.' ')
     *    call bug('f','Output name must be given')
         call keyi('rxif',rxif,-1)
            if(rxif==-2) rxc='_rxh'
            if(rxif==-1) rxc='_rxl'
            if(rxif==0) rxc='_rx0'
            if(rxif==1) rxc='_rx1'
            if(rxif==2) rxc='_rx2'
            if(rxif==3) rxc='_rx3'
c
         if(rxif.lt.-2.or.rxif.gt.3) then
             call output('For data taken after 2006-12-28:')
             call output('rxif = -2 -> 2nd rxif band')
             call output('rxif = -1 -> 1st rxif band')
             call output('rxif =  0 -> 230 band')
             call output('rxif =  1 -> 340 band')
             call output('rxif =  2 -> 400 band')
             call output('rxif =  3 -> 690 band')
             call output('For data taken before 2006-12-28:')
             call output('rxif = -2 -> 1st rxif band')
             call output('rxif = -1 -> 2nd rxif band')
             call output('rxif = 0 -> 230 band')
             call output('rxif = 1 -> 340 band')
             call output('rxif = 2 -> 690 band')
             call output(' ')
             call bug('f','Invalid Receiver ID.')
             end if
        call keyd('restfreq',rfreq,0.0d0)
        call keyr('vsource', vsour,0.0)
        call keyi('refant',refant,6)
        call getopt(doauto,docross,docomp,dosam,doxyp,doop,relax,
     *    sing,unflag,dohann,birdie,dobary,doif,dowt,dopmps,polflag,
     *    hires,nopol,circular,linear,oldpol,dospc,doengrd,doconjug,
     *    dolsr,noskip,mcconfig,nohighspr,dodebug,dowide,doflagch0,
     *	  iPointflag,do2GHz,doswap)
            dosporder=-1
            if(dospc) dosporder=1
            doeng =-1
            if(doengrd) doeng=1
        call keyi('rsnchan',rsnchan,-1)
       if(rsnchan.gt.0) then 
          rsnchan=2**(int(log(real(rsnchan))/log(2.)+0.5))
                        else
                        rsnchan=-1
                        end if
        call keyi('spskip',spskip(1),0)
        call keyi('spskip',spskip(2),0)
        if(spskip(1).gt.0.and.spskip(2).le.0)
     *  call bug('f','spskip(2) must > 0 if spskip(1) > 0 !')
        if(spskip(1).ge.24.or.spskip(2).ge.24)
     *  call bug('f','spskip(1) or spskip(2) must be less than 24!')
        call keyi('sideband',sb,0)
        if(sb.lt.0.or.sb.gt.2)
     *  call bug('f','Invalid SIDEBAND parameter')
        call keyi('nfiles',fileskip,0)
        call keyi('nfiles',fileproc,nfiles-fileskip)
        if(nfiles.gt.1.and.fileproc+fileskip.gt.nfiles)
     *    fileproc = nfiles - fileskip
        if(fileskip.lt.0.or.fileproc.lt.1)
     *  call bug('f','Invalid NFILES parameter')
        call keyi('nscans',scanskip,1)
        call keyi('nscans',scanproc,0)
             sscanskip=scanskip
             sscanproc=scanproc
        if(scanskip.lt.0.or.scanproc.lt.0)
     *  call bug('f','Invalid NSCANS parameter')
        call keyfin
c
c parsing data swap option
c default doswap =.true. 
c swaps big Endian data to little Endian
c 
        if(doswap)      datEndian= 1;
        if(.not.doswap) datEndian=-1;
c
c check if it is double band data with dbcheck
c
        msg2='call dbcheck look into file:'//in(1)(1:len1(in(1)))
c       call output(msg2)
        nchunk=25
        call dbcheck(nchunk,in,datEndian)
        call drxcheck(drxjday,in)
        call catupdcheck(drxjday)
c        if((nchunk.gt.25).or.(drxjday.gt.do4GHzjday)) do4GHz=.true.
c
        if(drxjday.gt.do4GHzjday) then
      
c reading modeInfo
        fname = in(1)(1:len1(in(1)))//'modeInfo'
        call txtopen(lIn,fname,'old',iostat)
            if(iostat==0) then
                call txtread(lIn,line,length,iostat)
                if(iostat.eq.-1) then
            call bug('w', 'not able to read modeInfo!')
                else
            call txtclose (lIn)
c            write(*,*) 'line=', line, 'length=', length
        open(16,file=in(1)(1:len1(in(1)))//'modeInfo',status='unknown')
        read(16,*) infoRX, infoCM
c        write(*,*) infoRX, infoCM
              close(16)
                end if
              else
            call bug('w', 'not able to open modeInfo!')
            end if 
        end if
        if(infoCM.eq.2) then
         do2GHz = .true.
         do4GHz = .false.
         else
         do4GHz = .true.
         do2GHz = .false.
         end if
         if(infoRX.eq.1) 
     &    dodrxptch = .false.
         if(infoRX.eq.2) 
     &    dodrxptch = .true.
           
        if(do2GHz) nchunk=25
c
c alternatively reading the antenna positions from
c the ASCII file antennas
c
       if((nchunk.eq.25).and.(drxjday.le.do4GHzjday)) then
c       call bug('w',
c     *   'Reading antenna positions from ASCII file antennas:')
            fname = in(1)(1:len1(in(1)))//'antennas'
            call txtopen(lIn,fname,'old',iostat)
            if(iostat.eq.0) then
            do i=1,MAXIANT 
            call txtread(lIn,line,length,iostat)
            if(iostat.eq.-1) goto 211
            end do
211         readant=i-1
            call txtclose(lIn)         
           if(readant.gt.8) then
           call bug('w', 'Number of antennas exceeded the limit 8.')
           end if
      open(16,file=in(1)(1:len1(in(1)))//'antennas',status='unknown')
            do i=1,readant
            read(16,*) antid,xyz(1),xyz(2),xyz(3)
            antpos(1+(antid-1)*3) = xyz(1)
            antpos(2+(antid-1)*3) = xyz(2)
            antpos(3+(antid-1)*3) = xyz(3)
            end do
            close(16)
            readant=i-1
c            do i=1,readant
c            write(*,100) i,antpos(1+(i-1)*3),
c     *             antpos(2+(i-1)*3),antpos(3+(i-1)*3)
c             end do
             else
        call bug('w',
     * 'found no antennas file; try solving antpos from bl vectors...')
         readant =0
             end if
             end if
100        format(i2,5x,3(f12.6,2x))

c
c    do both side bands
c
           length=len1(out)
           if(sb.eq.2) then
              dsb=.true.
              sb = 0
              end if
             
555           if(sb.eq.0) out=out(1:length)//rxc(1:4)//'.lsb'
              if(sb.eq.1) out=out(1:length)//rxc(1:4)//'.usb'
c
c handling double band data with dbpatch
c
        doflag1st=-1
c        if((nchunk.gt.25).or. (drxjday.ge.(2*2456005.5))) then
c        if(nchunk.gt.25) then
        if(.not.do2GHz) then
        if(doflagch0) doflag1st=1
c
c
c        double precision dtemp
c        double precision lat1,long1,evec1
c        logical ok
cc jhz
c
c
        call obspar('SMA','latitude', dtemp, ok)
        lat1=dtemp
        if(.not.ok)call bug('f','Could not get SMA latitude')
        call obspar('SMA','longitude',dtemp,ok)
        long1=dtemp
        if(.not.ok)call bug('f','Could not get SMA longitude')
        call obspar('SMA','evector',dtemp,ok)
        evec1 = dtemp
        if(.not.ok)call bug('f','Could not get SMA evector')
        end if
c    
        if(do4GHz) then
        call 
     &dbpatch(in,out,sb,doflagch0,datEndian,iPointflag,lat1,long1,evec1)
c     
        if(.not.dsb) then
        line = 'Output file = '//out
        if(.not.dowide)  call output(line)
        goto 666
        end if
        if(sb.eq.0) then
        sb=1
        line = 'Output file = '//out
        if(.not.dowide)  call output(line)
        call output(' ')
        call output('Handling other side band data ...')
        call output(' ')
        goto 555
        end if
        stop
        end if
c
c handling dual rx data since 2010 spring with drxpatch
c
        if(int(drxjday).ge.(2455258*2)) dodrxptch = .true.
        if(dodrxptch) then
        call drxpatch(in,out,sb,rxif,
     & doflagch0,datEndian,iPointflag,lat1,long1,evec1)
        if(.not.dsb) then
        line = 'Output file = '//out
        if(.not.dowide)  call output(line)
        goto 666
        end if
        if(sb.eq.0) then
        sb=1
        line = 'Output file = '//out
        if(.not.dowide)  call output(line)
        call output(' ')
        call output('Handling other side band data ...')
        call output(' ')
        goto 555
        end if
        stop
        end if
c
c  Open the output and initialize it.
c  
c        call output("process 2GHz mode data ....") 
        call uvopen(tno,out,'new')
        if(.not.docomp)call uvset(tno,'corr','r',0,0.,0.,0.)
        call uvset(tno,'preamble','uvw/time/baseline',0,0.,0.,0.)
        call fixed(tno,dobary)
        call hisopen(tno,'write')
        call hiswrite(tno,'SMALOD: Miriad '//version)
        call hisinput(tno,'SMALOD')
        call output(msg)
        ifile = 0
        iostat = 0
        dowhile(ifile.lt.fileskip+fileproc.and.iostat.eq.0)
          ifile = ifile + 1
          if(ifile.le.fileskip)then
            if(nfiles.eq.1)then
              call output('Skipping file '//itoaf(ifile))
              call smaskip(in(1),iostat)
            else
              call output('Ignoring file '//in(ifile))
              iostat = 0
            endif
            if(iostat.ne.0)call bug('f','Error skipping SMA-MIR file')
          else
c            call output("initialize 2GHz poke.")
            call pokeini(tno,dosam,doxyp,doop,dohann,birdie,dowt,
     *      dopmps,dobary,doif,hires,nopol,circular,linear,oldpol,
     *      rsnchan,refant,dolsr,rfreq,vsour,antpos,readant,noskip,
     *      spskip,dsb,mcconfig,nohighspr,dodebug)
            if(nfiles.eq.1)then
              i = 1
            else
              i = ifile
            endif
            if(i.ne.ifile)then
            call liner('Processing file '//itoaf(ifile))
            else
            call liner('Processing file '//in(ifile))
            endif
            scanskip=sscanskip
            scanproc=sscanproc
            call smadisp(in(i),scanskip,scanproc,doauto,docross,
     *          relax,sing,unflag,polflag,rxif,rfreq,nfreq,sb,
     *          iostat, dosporder,doeng,doconjug)
          endif
        enddo
        if(iostat.ne.0)then
        line = 'SMAMIR i/o error: '//smaerr(iostat)
        call bug('w',line)
        call bug('w','Prematurely finishing because of errors')
        call hiswrite(tno,'SMALOD: '//line)
        call hiswrite(tno,
     *    'SMALOD: Prematurely finishing because of errors')
        else
        call hiswrite(tno,
     *    'SMALOD: Ended Gracefully')
        endif
        call hisclose(tno)
        call uvclose(tno)
c
c do wideband
c
        call uvopen(tno,out,'old')
        dowhile(nchan.le.0) 
        call uvread(tno,preamble,data,flags,MAXCHAN,nchan)
c       check the flag status
        do i=1,MAXCHAN
        if(flags(i)) then
        wdata(i)=data(i)
        wflags(i)=flags(i)
        endif
        end do
        call uvrdvri(tno,'nspect',nspect,0)
        enddo
        if(nspect.eq.0) call bug('f', 'nspect = 0')
        call uvclose(tno)
        if(dowide) call smauvwide(out,nspect)
c        call rmdata(out)
        if(.not.dsb) then
        line = 'Output file = '//out
        if(.not.dowide)  call output(line)
        goto 666
        end if
        if(sb.eq.0) then
        sb=1
        line = 'Output file = '//out
        if(.not.dowide)  call output(line)
        call output('Handling other side band data ...')
        call output(' ')
        goto 555
        end if
        if(dsb) then
        line = 'Output file = '//out
        if(.not.dowide)  call output(line)
        end if
666     continue

        stop
        end
c************************************************************************
        subroutine getopt(doauto,docross,docomp,dosam,doxyp,doop,
     *  relax,sing,unflag,dohann,birdie,dobary,doif,dowt,dopmps,
     *  polflag,hires,nopol,circular,linear,oldpol,dospc,doengrd,
     *  doconjug,dolsr,noskip,mcconfig,nohighspr,dodebug,dowide,
     *  doflagch0,iPointflag,do2GHz,doswap)
c
        logical doauto,docross,dosam,relax,unflag,dohann,dobary,doop
        logical docomp,doif,birdie,dowt,dopmps,doxyp,polflag,hires,sing
        logical nopol,circular,linear,oldpol,dospc,doengrd,doconjug
        logical dolsr,noskip,mcconfig,nohighspr,dodebug,dowide
        logical doflagch0,iPointflag,do2GHz,doswap
c
c  Get the user options.
c
c  Output:
c    doauto	Set if the user want autocorrelation data.
c    docross	Set if the user wants cross-correlationdata.
c    docomp	Write compressed data.
c    dosam	Correct for sampler statistics.
c    doxyp	Correct the data with the measured xy phase.
c    doop	Correct for opacity.
c    dohann     Hanning smooth spectra
c    birdie	Discard bad channels in continuum mode.
c    doif	Map the simultaneous frequencies to the IF axis.
c    relax
c    unflag
c    dobary	Compute barycentric radial velocities.
c    dowt	Reweight the lag spectrum.
c    dopmps	Undo "poor man's phase switching"
c    polflag	Flag all polarisations if any are bad.
c    hires      Convert bin-mode to high time resolution data.
c    sing	Single dish mode.
c    nopol      Disable polarization.
c    circular   circular polarization.
c    linear     linear polarization.
c    dospc      reverse the order of spectral windows for
c               the last three blocks.
c    doengrd    read engineer file.
c    doconjug   phase conjugate for lsb data (data before 2004 April 28)
c    dolsr      Compute LSR radial velocities.
c    noskip     Do not skip any adta.
c    mcconfig   do multiple correlator configurations.
c    nohighspr  no high spectral resolution mode.
c    debug      to print out the messages indicating what have been
c               done to fix the header problems.
c    dowide     to generate "wideband" data
c    doflagch0  to leave the ch0 data in 4GHz mode data unflagged.
c    iPointflag to make ipointing off-source data.
c    do2GHz     to check 2GHz data only.
c    doswap     to swap big endian to little endian 
c------------------------------------------------------------------------
        integer nopt
        parameter(nopt=35)
        character opts(nopt)*8
        logical present(nopt)
        data opts/'noauto  ','nocross ','compress','relax   ',
     *            'unflag  ','samcorr ','hanning ','bary    ',
     *            'noif    ','birdie  ','reweight','xycorr  ',
     *            'opcorr  ','nopflag ','hires   ','pmps    ',
     *            'mmrelax ','single  ','nopol   ','circular',
     *            'linear  ','oldpol  ','dospc   ','doengrd ',
     *            'conjugat','lsr     ','noskip  ','mcconfig',
     *            'nohspr  ','debug   ','uvwide  ','flagch0 ',
     *            'ipoint  ','2ghz    ','sendian '/
        call options('options',opts,present,nopt)
        doauto  = .not.present(1)
        docross = .not.present(2)
        docomp  = present(3)
        relax   = present(4)
        unflag  = present(5)
        dosam   = present(6)
        dohann  = present(7)
        dobary  = present(8)
        doif    = .not.present(9)
        birdie  = present(10)
        dowt    = present(11)
        doxyp   = present(12)
        doop    = present(13)
        polflag = .not.present(14)
        hires   = present(15)
        dopmps  = present(16)
c
c  Option mmrelax is now ignored (set automatically!).
c	
c       mmrelax = present(17)
        sing    = present(18)
        nopol   = present(19)
        circular= present(20)
        linear  = present(21)
        oldpol  = present(22)
        dospc   = present(23)
        doengrd = present(24)
        doconjug= present(25)
        dolsr   = present(26)
        noskip  = present(27)
        mcconfig= .not.present(28)
        nohighspr = present(29)
        dodebug = present(30)
        dowide  = present(31)
        doflagch0 = .not.present(32)
        iPointflag =.not.present(33)
        do2GHz  = present(34)
        doswap  = .not.present(35)
c  oldpol obsoleted
        if(oldpol) 
     *  call bug('w', 'Hey, options=oldpol has been obsoleted!')
           oldpol  = .false.
        if(dobary.and.dolsr) 
     *  call bug('f','choose options of either bary or lsr')
        if((.not.circular.and..not.linear).and..not.oldpol) nopol=.true.
c
        if((dosam.or.doxyp.or.doop).and.relax)call bug('f',
     *    'You cannot use options samcorr, xycorr or opcorr with relax')
        end
c************************************************************************
        subroutine fixed(tno,dobary)
c
        integer tno
        logical dobary
c
c  This updates variables that never change.
c
c modified my jhz 2004-5-24 for SMA
c  Input:
c    tno	Handle of the output uv data-set.
c    dobary	Velocity restframe is the barycentre.
c------------------------------------------------------------------------
        double precision latitude,longitud,dtemp
        real chioff
        integer mount
        logical ok
        call uvputvrr(tno,'epoch',2000.,1)
        call obspar('SMA','latitude',latitude,ok)
        if(ok)call obspar('SMA','longitude',longitud,ok)
        if(ok)call obspar('SMA','evector',dtemp,ok)
        if(ok)chioff = dtemp
        if(ok)call obspar('SMA','mount',dtemp,ok)
        if(ok)mount = dtemp
        if(.not.ok)then
          call bug('w','Unable to determine telescope lat/long')
        else
        call uvputvrd(tno,'latitud',latitude,1)
        call uvputvrd(tno,'longitu',longitud,1)
        call uvputvrr(tno,'evector',chioff,1)
c
c ALTAZ=0.d0,EQUATOR=1.d0,NASMYTH=4.d0,XYEW=3.d0
c Alt-Az mount=0 based on SMA project book
c but the polarization goes extra rotation through the 
c elevation axis
c so sma/mount = NASMYTH or mount=4.d0
c
        call uvputvri(tno,'mount',mount,1)
        endif
        end
c************************************************************************
        subroutine pokeini(tno1,dosam1,doxyp1,doop1,
     *          dohann1,birdie1,dowt1,dopmps1,dobary1,
     *          doif1,hires1,nopol1,circular1,linear1,oldpol1,
     *	        rsnchan1,refant1,dolsr1,rfreq1,vsour1,antpos1,
     *          readant1,noskip1,spskip1,dsb1,mcconfig1,
     *          nohighspr1,dodebug1)
c
        integer tno1,rsnchan1,refant1,readant1,spskip1(2)
        logical dosam1,doxyp1,dohann1,doif1,dobary1,birdie1,dowt1
        logical dopmps1,hires1,doop1,nopol1,circular1,linear1,oldpol1
        logical dolsr1,noskip1,dsb1,mcconfig1,nohighspr1,dodebug1
        double precision rfreq1,antpos1(10*3)
        real vsour1
c
c  Initialise the Poke routines.
c------------------------------------------------------------------------
c
c  The common block (yuk) used to buffer up an integration.
c
        include 'maxdim.h'
cc jhz 2004-6-7: change at -> sm for the parameter
cc smif = 48
cc smant = 8

        double precision dtemp
        double precision lat1,long1,evec1
        logicAl ok
cc jhz
        kstat=1;
        call obspar('SMA','latitude', dtemp, ok)
        lat1=dtemp
        if(.not.ok)call bug('f','Could not get SMA latitude')
        call obspar('SMA','longitude',dtemp,ok)
        long1=dtemp
        if(.not.ok)call bug('f','Could not get SMA longitude')
        call obspar('SMA','evector',dtemp,ok)
        evec1 = dtemp
        if(.not.ok)call bug('f','Could not get SMA evector')

c
        call rspokeinisma(kstat,tno1,dosam1,doxyp1,doop1,
     *  dohann1,birdie1,dowt1,dopmps1,dobary1,doif1,hires1,
     *  nopol1,circular1,linear1,oldpol1,lat1,long1,evec1,rsnchan1,
     *  refant1,dolsr1,rfreq1,vsour1,antpos1,readant1,noskip1,
     *  spskip1,dsb1,mcconfig1,nohighspr1,dodebug1)
        end
c************************************************************************
        subroutine liner(string)
c
        character string*(*)
c
c------------------------------------------------------------------------
        character line*72
c
        call output(string)
        line = 'SMALOD:    '//string
        end
c************************************************************************
        subroutine pokename(in)
c
        character in*(*)
c
c------------------------------------------------------------------------
c
c  The common block (yuk) used to buffer up an integration.
c
        include 'maxdim.h'
c
        integer smif,smant,smpol,smdata,smbase,smbin,smcont
        parameter(smif=24,smant=8,smpol=4,smbase=((smant+1)*smant)/2)
        parameter(smbin=1024,smcont=33)
        parameter(smdata=24*maxchan*smbase)
        integer nifs,nfreq(smif),nstoke(smif),polcode(smif,smpol)
        double precision sfreq(smif),sdf(smif),restfreq(smif)
        double precision time
        integer tcorr
        real xtsys(smif,smant),ytsys(smif,smant),chi
        real u(smbase),v(smbase),w(smbase)
        real xyphase(smif,smant),xyamp(smif,smant)
        real xsampler(3,smif,smant),ysampler(3,smif,smant)
        complex data(smdata)
        integer pnt(smif,smpol,smbase,smbin),nbin(smif),edge(smif)
        integer bchan(smif)
        real inttime(smbase),inttim
        logical flag(smif,smpol,smbase,smbin),dosw(smbase)
        integer nused,tno,nants
        logical dosam,dohann,birdie,doif,dobary,newfreq,newsc,newpnt
        logical dowt,dopmps,doxyp,opcorr,hires
        real wts(2*smcont-2)
        real axisrms(smant),axismax(smant),mdata(5)
        logical mflag
        double precision obsra,obsdec,lat,long,ra,dec
        character sname*64
c
        common/atlodd/sname
        common/atlodc/sfreq,sdf,restfreq,time,obsra,obsdec,lat,long,
     *      ra,dec,
     *    data,
     *    xtsys,ytsys,chi,xyphase,xyamp,xsampler,ysampler,u,v,w,inttime,
     *      inttim,wts,mdata,axisrms,axismax,
     *    pnt,nbin,nused,tno,nants,nifs,nfreq,nstoke,polcode,edge,
     *      bchan,tcorr,
     *    flag,dosw,dosam,dohann,birdie,dowt,dopmps,doxyp,opcorr,
     *      doif,dobary,newfreq,hires,mflag,
     *    newsc,newpnt
        character c*1
        integer i1,i2,i
c
        integer len1
c
        i1 = 1
        i2 = len1(in)
        do i=1,i2
          c = in(i:i)
          if(index('/[]:',c).ne.0)i1 = i + 1
        enddo
        if(i1.gt.i2)i1 = 1
c        call uvputvra(tno,'name',in(i1:i2)) 
        end
c************************************************************************
        subroutine smaskip(in,iostat)
c
        character in*(*)
        integer iostat
c------------------------------------------------------------------------
        call smaopen(in,iostat)
        if(iostat.eq.0)call smaeof(iostat)
        end
c************************************************************************
        subroutine smadisp(in,scanskip,scanproc,doauto,docross,relax,
     *    sing,unflag,polflag,rxif,userfreq,nuser,sb,iostat, 
     *    dosporder,doeng,doconjug)
c
        character in*(*)
        integer scanskip,scanproc,rxif,nuser,sb,iostat,dosporder,doeng
        integer scanskip1,scanproc1
        double precision userfreq(*)
        logical doauto,docross,relax,unflag,polflag,sing,doconjug
        integer doflppha
c  jhz
c
c  Process a sma_mir file. Dispatch information to the
c  relevant Poke routine. Then eventually flush it out with PokeFlsh.
c
c  Inputs:
c    scanskip	Scans to skip.
c    scanproc	Number of scans to process. If 0, process all scans.
c    doauto     Save autocorrelation data.
c    docross    Save crosscorrelation data.
c    relax      Save data even if the SYSCAL record is bad.
c    sing
c    polflag    Flag all polarisations if any are bad.
c    unflag     Save data even though it may appear flagged.
c    ifsel      IF to select. 0 means select all IFs.
c    userfreq   User-given rest frequency to override the value in
c               the RPFITS file.
c    nuser      Number of user-specificed rest frequencies.
c    
c------------------------------------------------------------------------
c
c
        integer jstat
c
c  Information on flagging.
c
        integer kstat 
c
c  Open the SMA_MIR file.
c
        scanskip1=scanskip
        scanproc1=scanproc
        call smaopen(in,iostat)
         if(iostat.ne.0)return
c
c  Initialize.
c
        call pokename(in)
        if(doconjug) then
           doflppha = -1
           else
           doflppha = 1
           end if
        call rssmaflush(scanskip1, scanproc1, sb, rxif, 
     *       dosporder, doeng, doflppha)
             kstat= 666
         
        call rspokeflshsma(kstat);
c
        jstat =-1;
        call rsmiriadwrite(in,jstat)
        end
c************************************************************************
        subroutine smaeof(jstat)
        integer jstat
c
c  Skip to the EOF.
c
c------------------------------------------------------------------------
c
        character smaerr*32
c
c       thsi function is not used.
c
        jstat = 2
        if(jstat.eq.3)jstat = 0
        if(jstat.ne.0)call bug('w',
     *          'Error while skipping: '//smaerr(jstat))
        end
c************************************************************************
        character*(*) function smaerr(jstat)
        integer jstat
c
c------------------------------------------------------------------------
        character itoaf*8
        integer nmess
        parameter(nmess=7)
        character mess(nmess)*32
        data mess/'Operation unsuccessful          ',
     *            'Operation successful            ',
     *            'Encountered header while reading',
     *            'Probably OK ... End of scan     ',
     *            'Encountered end-of-file         ',
     *            'Encountered FG table            ',
     *            'Illegal parameter encountered   '/
c
        if(jstat.ge.-1.and.jstat.le.5)then
          smaerr = mess(jstat+2)
        else
          smaerr = 'SMA mir Data error: jstat='//itoaf(jstat)
        endif
c
        end
c************************************************************************
        subroutine smaopen(in,jstat)
        character in*(*)
        character*80 file
        integer jstat
c
c External.
c
        character smaerr*32
        file = in
c jstat=-3 -> open the input data file 
        jstat = -3
c jhz
        call rsmirread(in, jstat)
        if(jstat.ne.0) call bug('w',
     *  'Error opening SMA MIR file: '//smaerr(jstat))
        if(jstat.ne.0)return
        end
c************************************************************************
        character*(*) function pcent(frac,total)
        integer frac,total
c------------------------------------------------------------------------
        character val*5
        real x
        x = real(100*frac)/real(total)
        if(x.gt.9.99)then
          write(val,'(f5.1)')x
        else
          write(val,'(f5.2,a)')x
        endif
        pcent = val//'%'
        end
c************************************************************************
        real function getjpk(freq)
        real freq
c------------------------------------------------------------------------
        if(freq.lt.15)then
          getjpk = 13
        else if(freq.lt.30)then
          getjpk = 15
        else
          getjpk = 25
        endif
        end
c***********************************************************************
c  Recompute wide band data and/or flags from narrow band data
c
c   pjt    16apr93   Cloned off uvedit's intermediate version where
c		     we did more or less the same with options=wide
c
c   (pjt    31mar93    1) added options=wide to force recomputing wideband
c                     2) getupd now calls uvrdvrd instead of uvgetvrd because
c                     'ra' and 'dec' were converted to double (12feb93)
c                     3) what about the sign convention
c   )
c   pjt    20apr93    Added reset= and submitted
c   pjt    26apr93    allow the reverse: set flags based on wide band flags
c   pjt    22dec94    reflag wide if narrows are flagged and no out= given
c   pjt     9aug00    adding the edge= and blankf= keyword and fixed a bug
c                     where wides were computing wrong if different size
c                     spectral windows were used
c   pjt    10aug00    submitted, set default of blankf to be 0.033
c   pjt    11mar01    retrofitted the ATNF's insistence of keyf->keya
c                     they made on 08may00
c   pjt    30jan02    attempt to create widebands on the fly
c   pjt     6sep06    carma mode to to not deal with the first two wide's 
c                     (global LSB/USB)
c   pjt    30jul07    complete overhaul for CARMA (and thus more general)
c   jhz    07feb08    turn Peter's uvwide codes into subroutines 
c***********************************************************************
      subroutine smauvwide(infile,nwide)
      IMPLICIT NONE
c
c  Internal parameters.
c
      include 'maxdim.h'
      INCLUDE 'mirconst.h'
      CHARACTER PROG*(*)
      PARAMETER (PROG = 'UVWIDE')
      CHARACTER VERSION*(*)
      PARAMETER (VERSION = '30-jul-07')

c
c  Internal variables.
c
      CHARACTER Infile*64, Outfile*132, type*1
      CHARACTER*11 except(15)
      INTEGER i, k, m, lin, lout
      INTEGER nread, nwread, lastchn, nexcept, skip
      INTEGER nschan(MAXCHAN), ischan(MAXCHAN), nspect, nwide, edge
      REAL wfreq(MAXCHAN), wwidth(MAXCHAN), blankf, wt
      DOUBLE PRECISION sdf(MAXCHAN), sfreq(MAXCHAN), preamble(4), lo1
      COMPLEX data(MAXCHAN), wdata(MAXCHAN)
      LOGICAL dowide, docorr, updated, reset, donarrow, doflag
      LOGICAL newide, first, hasnone
      LOGICAL flags(MAXCHAN), wflags(MAXCHAN)
      integer length,len1
      CHARACTER line*132, cnwide*3
c
c  End declarations.
c-----------------------------------------------------------------------
c  Announce program.
c
c      CALL output(PROG // ': ' // VERSION)
c-----------------------------------------------------------------------
c
c  get the input parameters
c  determine output file name
c
                        length=len1(infile)
                        outfile=infile(1:length)//'.wide'
c  reset = .TRUE. is to make all wideband data is recomputed
                        reset=.TRUE.
c  donarrow=.FALSE. is not to re-flag the "narrow band" data
                        donarrow=.FALSE.
c  0 edge channel to discard
                        edge=0
c  0 fraction of channel to discard
                        blankf=0.0
c  nwide band channels per side band to be generated
                        if(nwide.eq.0) nwide=24
c  not flagging
       doflag = outfile.EQ.' '
c
       first  = .true.
c-----------------------------------------------------------------------
c
c  Set up tracking so that unedited items are directly copied.
c  If an item is listed in the except list, it is not copied directly
c  and, hence, needs to be written explicitly.  The first five items
c  are required because they are always written with every UVWRITE (in
c  the preamble and the correlator data).  The sixth item is also
c  required as it written with every call to UVWWRITE.
c
      except(1) = 'coord'
      except(2) = 'baseline'
      except(3) = 'time'
      except(4) = 'tscale'
      except(5) = 'corr'
      except(6) = 'wcorr'
      nexcept = 6
c
c  Open the input visibility file.
c
      CALL uvopen(lin, infile, 'old')
      CALL smatrackit(lin, except, nexcept)
      CALL uvnext(lin)
c
c  Determine if this data set has narrow and/or wide band data.
c
      CALL uvprobvr(lin, 'corr', type, k, updated)
      CALL lcase(type)
      docorr = ((type .eq. 'r') .or. (type .eq. 'j'))
      IF (.NOT. docorr) THEN
         CALL bug('f', 
     *      'No narrow band data present in ' // infile)
      ENDIF
      CALL uvprobvr(lin, 'wcorr', type, k, updated)
      CALL lcase(type)
      dowide = (type .eq. 'c')
      IF (.NOT. dowide) THEN
         newide = .TRUE.
         first = .TRUE.
         CALL uvprobvr(lin, 'lo1', type, k, updated)
         IF(.NOT.updated) lo1 = -1.0
      ELSE
         newide = .FALSE.
      ENDIF
      hasnone = .FALSE.

c
c  Open the output visibility file.
c
      IF (.NOT.doflag) THEN
         CALL uvopen(lout, outfile, 'new')
         CALL output(PROG//': Writing visibilities to: '// Outfile)
c
c  Copy the old history entries to the new file and then add a few
c  additional history entries to the new file.
c
         CALL hdcopy(lin, lout, 'history')
         CALL hisopen(lout, 'append')
         CALL hiswrite(lout, PROG // ': ' // VERSION)
         CALL hisinput(lout, PROG)
      ELSE
         CALL hisopen(lin,'append')
         CALL hiswrite(lin, PROG // ': ' // VERSION)
         CALL hisinput(lin, PROG)
      ENDIF
c
c  Begin editing the input file. 
c  First rewind input since we probed corr and wcorr before
c
         CALL uvrewind(lin)
         CALL uvread(lin, preamble, data, flags, MAXCHAN, nread)
      DO WHILE (nread.GT.0)
c
c  Copy unchanged variables to the output data set.
c
         IF (.NOT.doflag) CALL uvcopyvr(lin, lout)
c
c  Get particular headers necessary to do editing (these items have
c  already been copied, so there is no need to write them again).
c
         IF (newide) THEN
         CALL smagetcoor(lin, MAXCHAN, nspect, nschan, ischan, 
     *           sdf, sfreq)
            DO i=1,nwide
               wfreq(i)  = sfreq(i) + 0.5*(nschan(i)-1.0)*sdf(i)
               wwidth(i) = sdf(i) * nschan(i)
            ENDDO
         CALL uvputvrr(lout,'wfreq',wfreq,nwide)
         CALL uvputvrr(lout,'wwidth',wwidth,nwide)
           IF (first) THEN
           cnwide(1:2) = '24'
           line = 'Creating '//cnwide(1:2)//' new wideband ... '
         call output(line)
               IF(wwidth(1).EQ.0.0) call bug('w',
     *               'Found zero wideband bandwidth, not good')
               first = .FALSE.
            ENDIF
         ELSE
         CALL smagetwide(lin, MAXCHAN, nwide, wfreq)
         CALL smagetcoor(lin, MAXCHAN, nspect, nschan, ischan, 
     *           sdf, sfreq)
         ENDIF

         if (newide) THEN
            nwread = nwide
            DO i=1,nwide
               wflags(i) = .TRUE.
               wdata(i) = cmplx(0.0, 0.0)
            ENDDO
         ELSE
         CALL uvwread(lin, wdata, wflags, MAXCHAN, nwread)
         ENDIF
         IF (nwread .LE. 0) CALL bug('f',PROG // ' No wide band data?')
                  
c
c  Reconstruct the digital wide band data.  
c  Weight the sums by the square of the bandwidth and keep different
c  sums for the upper and lower sidebands.  Only include data that is
c  previously flagged as "good" in the narrow bands.  Also omit the
c  first and last ENDCHN channels in each window.
c
         IF (reset) THEN
            DO i=1,nwide
               wflags(i) = .TRUE.
               wdata(i) = cmplx(0.0, 0.0)
            ENDDO
         ENDIF
         IF (donarrow) THEN
            CALL bug('f',"Still in old code not converted for CARMA")
            LastChn=nread/2
            IF (.NOT.wflags(1)) THEN
               DO m=1,LastChn
                  flags(m) = .FALSE.
               ENDDO
            ENDIF
            IF (.NOT.wflags(2)) THEN
               DO m=LastChn+1,nread
                  flags(m) = .FALSE.
               ENDDO
            ENDIF
         ELSE
            DO k = 1, nspect
               IF (blankf .GT. 0.0) THEN
                  skip = nschan(k)*blankf
               ELSE
                  skip = edge
               ENDIF
               IF (skip.LT.0) CALL bug('f','Negative edge???')
               LastChn = ischan(k) + nschan(k) - 1 - skip
               wt = 0.0
               DO m = ischan(k) + skip , LastChn
                  IF (flags(m)) then
                     wdata(k) = wdata(k) + data(m) 
                     wt = wt + 1.0
                  ENDIF
               ENDDO
               IF (wt.GT.0.0) THEN
                  wdata(k) = wdata(k)/wt
               ELSE
                  wflags(k) = .FALSE.
               ENDIF
            ENDDO
         ENDIF
         IF (doflag) THEN
            CALL uvwflgwr(lin,wflags)
         ELSE
            CALL uvwwrite(lout, wdata, wflags, nwread)
            CALL uvwrite(lout, preamble, data, flags, nread)
         ENDIF
c
c  End of reading loop. Read the next scan, 
c  nread.GT.0 will continue this loop.
c
         CALL uvread(lin, preamble, data, flags, MAXCHAN, nread)
      ENDDO
c
c  Close the new history file and UV data set.
c
      IF (doflag) THEN
          CALL hisclose(lin)
      ELSE
          CALL hisclose(lout)
          CALL uvclose(lout)
      ENDIF
c
c  Close the old UV data set.
c
      CALL uvclose(lin)

c  All done !
c
      END
c
c***********************************************************************
cc= TrackIt - Internal routine to track almost all UV variables.
cc& jm
cc: calibration, uv-data
cc+
      subroutine smatrackit(lin, except, nexcept)
      implicit none
      integer lin, nexcept
      character except(nexcept)*(*)
c
c  TrackIt marks every item in the vartable to ``copy'' mode with
c  the exception of the items listed in the ``except'' array.
c
c  Input:
c    Lin     Input UV data set handle.
c    except  Character array of exception item names.
c    nexcept Number of items in the exception array.
c
c  Output:
c    none
c
c--
c-----------------------------------------------------------------------
c
c  Internal variables.
c
      character varname*11 
c     character text*80
      integer j, item, iostat
      logical track
c
      call UvNext(Lin)
      call haccess(Lin, item, 'vartable', 'read', iostat)
      if (iostat .ne. 0) then
        call Bug('w', 'TRACKIT:  Could not access the vartable.')
        call Bug('w', 'TRACKIT:  Value returned from haccess call:')
        call Bugno('f', iostat)
      endif
c
      call hreada(item, varname, iostat)
      do while (iostat.eq.0)
        track = .TRUE.
        do j = 1, nexcept
          if (varname(3:10) .eq. except(j)) track = .FALSE.
        enddo
        if (track) then
          call UvTrack(Lin, varname(3:10), 'c')
        endif
        call hreada(item, varname, iostat)
      enddo
c
      call hdaccess(item, iostat)
      if (iostat .ne. 0) then
        call Bug('w', 'TRACKIT:  Could not de-access the vartable.')
        call Bug('w', 'TRACKIT:  Value returned from hdaccess call:')
        call Bugno('f', iostat)
      endif
      call UvRewind(Lin)
      return
      end
c
c***********************************************************************
cc= GetWide - Internal routine to get the wide band frequency array.
cc& jm
cc: calibration, uv-i/o, uv-data, utilities
cc+
      subroutine smagetwide(lin, maxwide, nwide, wfreq)
      implicit none
      integer lin, maxwide, nwide
      real wfreq(maxwide)
c
c     Values returned from this routine do not change from the
c     previous call unless they get updated during the intervening
c     call to UVREAD.
c
c  Input:
c    lin      The input file descriptor.
c    maxwide  Maximum size of the ``wfreq'' array.
c
c  Input/Output:
c    nwide    The number of wide band channels.
c    wfreq    The array of wide band coorelation average frequencies.
c             This value is updated if ``nwide'' or ``wfreq'' changes.
c
c--
c-----------------------------------------------------------------------
c
c  Internal variables.
c
      character type*1
      integer length
      logical nupd, updated
c
      call UvProbvr(Lin, 'nwide', type, length, nupd)
      if (nupd) call UvRdVri(Lin, 'nwide', nwide, 0)
      call UvProbvr(Lin, 'wfreq', type, length, updated)
      if ((nupd .or. updated) .and. (nwide .gt. 0))
     *  call UvGetvrr(Lin, 'wfreq', wfreq, nwide)
      return
      end
c
c***********************************************************************
cc= GetCoor - Internal routine to get the narrow band frequency arrays.
cc& jm
cc: calibration, uv-i/o, uv-data, utilities
cc+
      subroutine smagetcoor(lin,maxn,nspect,nschan,ischan,sdf,sfreq)
      implicit none
      integer lin, maxn, nspect
      integer nschan(maxn), ischan(maxn)
      double precision sdf(maxn), sfreq(maxn)
c
c     Values returned from this routine do not change from the
c     previous call unless they get updated during the intervening
c     call to UVREAD.  If ``nspect'' is updated, then all arrays
c     are updated as well.
c
c  Input:
c    lin      The input file descriptor.
c    maxn     Maximum size of the arrays.
c
c  Input/Output:
c    nspect   The number of filled elements in the arrays.
c    nschan   The number of channels in a spectral window.
c    ischan   The starting channel of the spectral window.
c    sdf      The change in frequency per channel.
c    sfreq    Doppler tracked frequency of the first channel
c             in each window.
c-----------------------------------------------------------------------
c
c  Internal variables.
c
      character type*1
      integer length
      logical nupd, update
c
      call UvProbvr(Lin, 'nspect', type, length, nupd)
      if (nupd) call UvRdVri(Lin, 'nspect', nspect, 0)
c
      if (nspect .gt. 0) then
        call UvProbvr(Lin, 'nschan', type, length, update)
        if (nupd .or. update)
     *    call UvGetvri(Lin, 'nschan', nschan, nspect)
c
        call UvProbvr(Lin, 'ischan', type, length, update)
        if (nupd .or. update)
     *    call UvGetvri(Lin, 'ischan', ischan, nspect)
c
        call UvProbvr(Lin, 'sdf', type, length, update)
        if (nupd .or. update)
     *    call UvGetvrd(Lin, 'sdf', sdf, nspect)
c
        call UvProbvr(Lin, 'sfreq', type, length, update)
        if (nupd .or. update)
     *    call UvGetvrd(Lin, 'sfreq', sfreq, nspect)
      endif
      return
      end

