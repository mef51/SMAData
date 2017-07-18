// sma_mirRead + dbpatch (JHZ for exporting)
// jhz - may2004  
// 2004-5    propose the development of SMA code unde miriad
// 2004-5    start to write the SMAmir2Miriad code (SMALOD)
// 2004-7-15 read/write out all vis data 
// 2004-7-16 write lst 
// 2004-7-17 correct for spectral order based on s sequence 
// 2004-7-19 source information 
// 2004-7-20 sideband separation 
// 2004-7-22 fix coordinates for j2000 and apparent (observing) 
// 2004-7-23 fix skip beginning and ending scans 
// 2004-7-24 check and correct the flagging 
// 2004-7-25 add a variable sourceid 
// 2004-7-26 Tsys EL AZ information 
// 2004-8-2  Instrument, telescope, observer version 
// 2004-8-4  flip the phase for lsb 
// 2004-11-30 added a function of retrieving daul rx/if.
// 2004-12-10 rename header file for miriad 4.0.4 - pjt 
// 2004-12-16 increased length of pathname from 36 to 64
//            increased length of location from 64 to 81
// 2005-01-11 merged sma_Resample.c to sma_mirRead.c
//            sma_mirRead.c handle both original correlator
//            configuration and resample the spectra to
//            lower and uniform resolution.
// 2005-02-15 decoded veldop from mir file and fix the
//            the reference channel for miriad.
// 2005-02-22 decoded Tsys from mir antenna based file.
// 2005-02-28 read dual receiver data.
// 2005-03-01 added a function to fix the spectral chunk order
//            which is a temporal problem in the mir file
// 2005-03-02 added an option to read engineer file.
// 2005-03-07 changed the chunk order in frequnecy for the first
//            three blocks in the data observed during the
//            690 campaign spring 2005
// 2005-03-07 added the polarization options circular for waveplates
//            and default for linear
// 2005-03-08 changed the options name cirpol to circular
//            to match the same options in miriad program elsewhere.
// 2005-03-08 decoded antenna positions from mir baseline coordinates
//            converted the geocentrical coordinates to Miriad
//            coordinates system. 
// 2005-03-10 made the consistent array lengths for the variables 
//            required by miriad programs such as bee, uvlist etc.
// 2005-03-17 added linear in options for linear polarization;
//            made the default in options for polarization to be
//            nopol.
// 2005-03-18 decoded velocity type from mir.
// 2005-03-18 fixed problems of el and az in uvput
// 2005-03-21 added integration skip in the process of
//            decoding antenna position from baseline vectors.
// 2005-03-23 fixed a bug in decoding antenna positions for
//            the antenna id > reference antenna's id.
// 2005-03-23 fixed a bug in baseline pntr (last bl of
//            the 1st rx overlapping with that of 2nd).
// 2005-03-29 fixed problem in decoding antenna coordinates
//            in the case missing antenna in a random place.
// 2005-03-31 trim the junk tail in source name.
//            the source name truncates to 8 char.
// 2005-04-05 fixed the polarization label conversion for circular case
//            fixed the uv coordinates scaling (by the base frequency fsky[0]);
// 2005-04-28 change the phase conjugate scheme according Taco's log.
// 2005-05-05 add options of computeing radial velocity wrt either barycenter
//            or lsr.
// 2005-05-11 read spectral configuration from the integration
//            that users want to start (nscans).
// 2005-05-23 (PJT) added prototypes from miriad.h (via sma_data.h) 
//             and cleaned up some code because of this, sans indent
// 2005-06-01 (JHZ) fixed a few bugs in incompatible pointer type.
//                  stat in slaCldj is initialized and added  
//                  stat parse after return.
// 2005-06-02 (JHZ) implemented vsource and restfreq from users
//                  inputs.
// 2005-06-08 (JHZ) implemented a feature of handling
//                  arbitary frequency configuration 
//                  for each of the receivers in the case
//                  of dual recievers.
// 2005-06-20 (JHZ) fixed a bug (pointing to a wrong component) in calculate 
//                  site velocity.
// 2005-06-21 (JHZ) fixed a bug  in the status handle of rspokeflshsma_c
// 2005-06-22 (JHZ) fixed all the loose ends (warnings from compilers)
// 2005-06-22 (JHZ) add a feature allowing user' input of restfrequency
// 2005-06-23 (JHZ) add ut var
// 2005-06-27 (JHZ) add initializing blarray
// 2005-07-05 (JHZ) remove a hidden phase flip for the lsb data
// 2005-07-07 (JHZ) updated aperture efficiency and jyperk
// 2005-07-07 (JHZ) add  parsing source name and changing the source
//                  name if the first 8 chars are identical in
//                  any two source name entries from mir data.
// 2005-08-03 (JHZ) fixed a bug in the channel pntr in the
//                  case of resampling the data to a lower channel resolution.
// 2005-08-03 (JHZ) change the apperture efficiency to 0.5 for 340 GHz
// 2005-09-01 (JHZ) add smaveldop in the structure smlodd. 
//                  see the comment around line 1610. the chunk frequency
//                  stored in the header of MIR data appears to be not the
//                  sky frequency that is actually Doppler tracked by the 
//                  on-line system. The chunk frequency is the sky frequency to 
//                  which the part of Doppler velocity (diurnal term and part 
//                  of the annual term) has been corrected.
//                  smaveldop is the residual veldop after taking out the part
//                  that have been corrected to the chunk frequency.
//                  smaveldop will be specially stored in a variable
//                  called velsma. A special patch in the uvredo (miriad task)
//                  is required to compute the "SMA veldop" for other sources
//                  corresponding to the SMA "sky frequency".
//                  So that, the users can use the rest of Miriad task
//                  to properly reduce the SMA data avoiding the problem 
//                  of smearing spectral lines.  
// 2005-09-01 (JHZ) Removed lines for storing velsma;
//                  The residual Doppler velocity can be stored in veldop. 
// 2005-09-25 (JHZ) removed unused variables.
// 2005-09-29 (JHZ) added vsource (from users input) back to veldop.
// 2005-10-10 (JHZ) added online flagging pntr (convert negative wt to
//                  to online-flagging state of 0).
// 2005-10-11 (JHZ) added option of reading antenna positions from
//                  the ASCII file 'antennas'. 
// 2005-10-13 (JHZ) added swapping polarization states (RR<->LL, LR<->RL)
//                  for the circular polarization data taken before
//                  2005-06-10 or julian date 2453531.5
//                  (asked by dan marrone).
// 2005-10-13 (JHZ) add skipping decoding Doppler velocity
//                  for the polarization data old than 2005-06-10
//                  because the velocity entry in the Mir header
//                  was screwed up.
// 2005-10-13 (JHZ) add options of noskip
// 2005-11-30 (JHZ) store J2000 coordinates of the true
//                  pointing position for all the cases other than stored
//                  the true pointing position only
//                  when the true pointing position differs from
//                  the J2000 coordinates of source catalog
//                  position.
// 2005-12-5  (JHZ) obsoleted options=oldpol;
//                  unified the pol-state conversion using
//                  the function ipolmap.
// 2005-12-6  (JHZ) implemented a feature skipping spectral
//                  windows (spskip).
// 2005-12-30 (JHZ) in the new MIR data sets (230/690
//                  observation 051214_05:48:56 for example),
//                  the the number of inregrations (inhid)
//                  in the integration header (in_read) differs from 
//                  that in the baseline header (bl_read).
//                  The baseline header stores additional
//                  integration in the end of the file; this
//                  bug (spotted for the first time)
//                  causes the segmentation fault in smalod.
//                  The problem has been fixed by adding
//                  a parsing sentence for selecting
//                  the smaller  number of total integrations
//                  from the header files (in_read and bl_read).
// 2006-01-9 (JHZ)  The LONG_MAX used in function mfsize
//                  is a system variable depending on the WORDSIZE
//                  of the computers. The function mfsize worked
//                  only for LONG_MAX=2147483647L, 
//                  the value for 32bits computer.
//                  The LONG_MAX is replaced by SMA_LONG_MAX which
//                  is defined to 2147483647L. 
// 2006-01-18 (JHZ) add instruction print out in case
//                  the option rxif is not properly set.
// 2006-01-24 (JHZ) add the options spskip=-1 to take the frequency
//                  configuration of the first integration and
//                  skip the rest of the frequency configuration.
//                  This assumes that the frequency configuration
//                  does not change during the observing run.
//                  This is for loading the old SMA data. 
// 2006-02-03 (JHZ) optimized the memory requirements.
//                  for wts structure and double sideband loading.
// 2006-02-09 (JHZ) added a feature to handle multiple correlator configuration.
// 2006-03-13 (JHZ) added a feature to handle 2003 incompleted-correlator
//                  data.
// 2006-04-07 (JHZ) added an instruction message for properly using nscan.
// 2006-05-19 (JHZ) implemented feature to handle hybrid high spectral
//                  resolution frequency configuration, allowing
//                  presence of empty chunks.
// 2006-06-08 (JHZ) fixed a bug in parsing the source id in the case
//                  no source information given in the mir data
//                  (an on-line bug).
// 2006-06-09 (JHZ) fixed two warning bugs seen from 32bits:
//                  removed zero-length printf and added parathesis
//                  for if-else around line 2534.
// 2006-08-02 (JHZ) changed bytepos from signed long to unsigned long:
//                  double the limit of max bytes in a vis file
//                  (sch_read in MIR)
// 2006-09-19 (JHZ) added parsing sentences to filter out the
//                  corrupted integrations (for bad baseline code
//                  and bad integration time).
// 2006-12-29 (JHZ) added a feature to handle 4 rx bands,
//                  230,340,400,690 GHz
//                  rx id convention has been changed 
//                  since 2006 12 29 based on Taco
// 2007-01-05 (JHZ) implemented a feature of handling
//                  porjectInfo that contains observer's
//                  name.
// 2007-01-08 (JHZ) store chi and chi2
// 2007-01-10 (JHZ) change wtt from float to short
// 2007-01-11 (JHZ) add evector to smabuffer.
// 2007-01-31 (JHZ) changed source length limit from
//                  8 characters to 16.
// 2007-03-06 (JHZ) delete redundant juliandate calls.
//                  add percentage of the file that has been
//                  read.
// 2007-03-07 (JHZ) suppress the debugging msg when multiple
//                  correlator configs are allowed.
// 2007-06-6  (JHZ) added several check points based on
//                  new software limits set by the SMA hardware.
// 2007-06-11 (JHZ) added a check points for excluding corrupted
//                  frequency header.
// 2007-06-12 (JHZ) obsolete the single corr config loading mode.
// 2007-06-15 (JHZ) added instruction message in case of corruped ending
// 2007-09-07 (JHZ) added function to skip the corrupted-header integrations
//                  in the beginning of a fill and added options debugs
//                  for printing out the message indicating what have been
//                  done by this program.
// 2007-09-10 (JHZ) added function to create ERRreport.log file.
// 2007-09-11 (JHZ) claimed static variable array for blid_intchng
//                  to solve the initialization problem.
// 2007-09-12 (JHZ) added initialization to spn->nch
//                  short search set range by 1.
// 2007-10-30 (JHZ) added a checkup to assure that the reference
//                  chunk for calculating doppler velocity is not empty. 
// 2007-11-14 (JHZ) added a feature to skip the problematic integration in
//                  parsing the source parameter header.
// 2007-11-27 (JHZ) reset the source id array from id=1 to higher number
//                  and check the inhset is smaller than nsets[0]-1
//                  in parsing the source information.
// 2007-11-27 (JHZ) added a patch to fix the frequency labelling problem
//                  in the old SMA data (before 2007-11-26) with the recipe
//                  described in the SMA operation log # 14505
// 2008-01-23 (JHZ) set static variable to target and unknown
//                  updated rar2c and decr2c array size  
// 2008-02-11 (JHZ) add wideband data
//                  update smalod to version 3.0  
// 2008-10-17 (JHZ) Implemented for doubling band 
//                  (total 96 windows of both sideband).                                
// 2009-11-15 (JHZ) Integrated the patch for the 4GHz bandwidth double data.
// 2010-02-25 (JHZ) Updated the standard singleband (2GHz) for
//                  the error message of inconsistent BL header in
//                  data 100219_08:09:27 with 2 rx cases.
// 2010-03-03 (JHZ) Change MAXBAS to 180 upon Dan Marrone's requirement.
// 2010-05-04 (JHZ) Fixed some of the compatibility  warnings.
// 2010-07-24 (JHZ) lookup hostname.
// 2010-07-27 (JHZ) fix the chan0 flag state's problem for Glen P's
//                  pipeline script program.
// 2010-08-09 (JHZ) implement sb=2 features for dbpatch.
// 2010-10-13 (JHZ) implement variables antaz, antel, chi, lst, freq
//                  in dbpatch
// 2010-10-27 (JHZ) change version length from 16 to 64
// 2010-12-07 (JHZ) alter the global variable testlev to a local variable.
// 2010-12-08 (JHZ) fixed Segmentation fault occured in some computers 
//                  for strcpy(str1,str2) when str2 becomes NULL pointer.
// 2011-02-28 (JHZ) fixed Segmentation fault occured in running the beta
//                  for old HiRes data.
// 2011-04-01 (JHZ) updated smauvplt for checking pol states with distinguished
//                  color. Fixed the bugs for pol states labelling.
// 2011-04-06 (JHZ) updated smablflag for checking pol states with distinguished
//                  color and identifying for the bad vis for flagging. Fixed the 
//                  bugs for pol states labelling.
// 2011-04-07 (JHZ) disable the function for flagging cross polarization.
// 2011-05-11 (JHZ) correct pol states mapping between Mir-formatted bl.ipol
//                  and the pol states in Miriad.
// 2011-05-11 (JHZ) make beta 3.0 for 4 GHz polarization code.
// 2011-05-19 (JHZ) update sma/mount = NASMYTH or mount=4 for 4GHz mode data.
// 2011-09-11 (JHZ) disable the function of checking online software updating
// 2011-11-15 (JHZ) added a pacth for handling a new correlator setup mode (some
//                  of the chunks with a zero number of channels.
// 2011-12-13 (JHZ) added a pacth to account numbers of IF1 spectra and IF2 spectra.
//                  fixed a hole in case the number of IF1 < 24 and missing 
//                  edge chunks
//                  for the data produced from ad hoc correlator mode. 
// 2012-01-23 (JHZ) added original SMA correlator Configuration information
//                  to history file. 
// 2012-03-15 (JHZ) added a patch to read 2455926.5 and 2455925.5 datasets
//                  in which the blhid in sp file offset from that in bl file.
// 2012-03-25 (JHZ) parse the source name rejecting unknown and target
//                  in coordinates check
// 2012-05-05 (JHZ) add tau0 variable
// 2012-05-29 (JHZ) add iPointing flag
// 2012-05-30 (JHZ) add write status and message for surpassing size limit
// 2012-06-06 (JHZ) start debug for ubuntu 10.10
// 2012-06-07 (JHZ) replace strcpy with strncpy to get rid of overflow
//                  problem
// 2012-06-08  (JHZ) added a warning msg for dropping bad integrations
// 2012-06-11  (JHZ) fixed memory overflow problems of strng handling
//                   routines for 2GHz mode data 
// 2012-06-12  (JHZ) fixed resfreq overflow on ubuntu
// 2012-06-15  (JHZ) debugging for Ubuntu12.04
//                   fixed a buffer overflow problem in sprintf()
// 2012-06-19  (JHZ) change tau0 to tau230
//**************************************************************************
#include <math.h>
#include <rpc/rpc.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <fcntl.h>
#include <time.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include "sma_data.h"
#define OK         0
// define SMA_LONG_MAX 
#define SMA_LONG_MAX  2147483647L
#define SMIF2GHz 24
#define DSLIMIT   1.0E-5
// extern variable while read mir data 
char apathname[36];
char observer[16];
char logfile[20];
char logstr[88];
static FILE *logout; 
static FILE* fpin[7];
int nsets[6];
double jday; // julian day 
struct inh_def   **inh;
struct blh_def   **blh;
struct codeh_def **cdh;
struct ant_def   **enh;
struct sch_def   **sch;


// declare the externals struct which is the same to
// the common blocks, atlodd and atlodc 

char sname[64];
smlodd smabuffer;
// initialize 

struct vis { float real;
             float imag;
           };
// DATE of using THE 400 RX 
double rx400jday=2454097.0;
unsigned long mfsize(FILE *);
struct inh_int_def {
  int  a[512];
};


// prototypes of everything used here 

void rsmirread_c(char *datapath, char *jst[]);
void rsmiriadwrite_c(char *datapath, char *jst[]);
void rssmaflush_c(int scanskip, int scanproc, int sb, int rxif, 
    int dosporder, int doeng, int doflppha);
void rspokeinisma_c(char *kst[], int tno1, 
    int *dosam1, int *doxyp1, int *doop1, int *dohann1, 
    int *birdie1, int *dowt1, int *dopmps1, 
    int *dobary1, int *doif1, int *hires1, int *nopol1, 
    int *circular1, int *linear1, int *oldpol1, 
    double lat1, double long1, double evec1, int rsnchan1, 
    int refant1, int *dolsr1, double rfreq1, float *vsour1, 
    double *antpos1, int readant1, int *noskip1, int *spskip1, 
    int *dsb1, int*mcconfig1, int*nohighspr, int*dodebug1);
void rspokeflshsma_c(char *kst[]);


int rsgetdata(float smavis[2*7681], 
    int smaflags[7681], int *smanchan, 
    int p, int bl, int sb, int rx);
int spdecode(struct codeh_def *specCode[]);
float juliandate(struct codeh_def *refdate[],int doprt);
double slaCldj(int iy, int im, int id, int sj);
void precess(double jday1, double ra1, double dec1, 
     double jday2, double *ra2pt, double *dec2pt);
void nutate(double jday, double rmean, double dmean, 
     double *rtrueptr, double *dtrueptr);
void nuts(double jday, double *dpsiptr, double *depsptr);
double mobliq(double jday);
void aberrate(double jday, double ra, double dec, 
     double *rappptr, double *dappptr);
void vearth(double jday, double pos[3], double vel[3]);
void elazchi(int tno);
void tsysStore(int tno);
double velrad(short dolsr, double time, double raapp, 
     double decapp, double raepo, double decepo, double lst, double lat);
struct lmn *sph2lmn(double ra, double dec);
struct vel *vsite(double phi, double st);
void vsun(double *VEL);
short ipolmap(short input_ipol);
struct pols *rscntstokes(int npol, int bl, int sb, int rx);
int rsmir_Read(char *datapath, int jstat);
struct inh_def inh_read(FILE *fpinh);
struct blh_def blh_read(FILE *fpblh);
unsigned long mfsize(FILE *fp);
struct sph_def sph_read(FILE *fpsph);
struct codeh_def *cdh_read(FILE *fpcodeh);
struct ant_def *enh_read(FILE *fpeng);
struct sch_def *sch_head_read(FILE *fpsch);
int sch_data_read(FILE *fpsch, long int datalength, short int *data);
char *rar2c(double ra); 
char *decr2c(double dec);

// interface between fortran and c 
void rsmirread_c(char *datapath, char *jst[])
{ 
  int jstat;
   strncpy(apathname,datapath,36);
   jstat= (int)*jst;
   jstat = rsmir_Read(apathname,jstat);
  *jst = (char *)jstat; 
}

void rsmiriadwrite_c(char *datapath, char *jst[])
{ 
  int jstat;
    jstat=-1;
// open mir files 
   jstat = rsmir_Read(apathname,jstat);
  *jst = (char *)jstat;
// then start to read and write data if the files are ok.
  if (jstat==0) {
    jstat=0;
    jstat = rsmir_Read(apathname,jstat);
         } else {
    fprintf(stderr,"file problem\n");
         }
}

void rssmaflush_c(int scanskip,int scanproc,int sb,int rxif,int dosporder,int doeng,int doflppha)
{ 
// flush mir-data
  char *kst[4];
  int kstat=-1;  
  int tno;
  char telescope[4];
  char instrument[4];
  char version[64];
  tno = smabuffer.tno;
  smabuffer.scanskip=scanskip;
  smabuffer.scanproc=scanproc;
  smabuffer.sb = sb;
  smabuffer.rxif= rxif;
  smabuffer.doChunkOrder = dosporder;
  smabuffer.doeng = doeng;
  smabuffer.doConjugate = doflppha;
  *kst = (char *)&kstat;
//  read header  
    rspokeflshsma_c(kst);  
//  write antenna numbers 
  if(smabuffer.nants!=0) {
//  write telescope name and other description parameters 
    sprintf(telescope,"SMA");
    sprintf(instrument,"SMA");
//  sprintf(observer,"SmaUser");
    sprintf(version, "390 version 3.1: 2010-02-25%s","\0");
         fprintf(stderr,
              "single-band standard................%s\n", version);
    uvputvra_c(tno, "telescop", telescope);
    uvputvra_c(tno, "instrume", instrument);
    uvputvra_c(tno, "observer", observer);
    uvputvra_c(tno, "version", version);
                         }
}

void rspokeinisma_c(char *kst[], int tno1, int *dosam1, int *doxyp1,
		    int *doop1, int *dohann1, 
                    int *birdie1, int *dowt1, int *dopmps1,
		    int *dobary1, int *doif1, int *hires1, 
                    int *nopol1, int *circular1,
		    int *linear1, int *oldpol1, double lat1, 
                    double long1, double evec1, int rsnchan1, 
		    int refant1, int *dolsr1, double rfreq1, float *vsour1,
		    double *antpos1, int readant1, int *noskip1, int *spskip1,
	            int *dsb1, int *mcconfig1, int *nohighspr1,
                    int *dodebug1)
{ 
  int buffer, i;
// initialize the external buffers   
  strncpy(sname, " ",1);
  smabuffer.tno      = tno1;
  smabuffer.rsnchan  = rsnchan1;
// printf("rsnchan1=%d smabuffer.rsnchan=%d\n", rsnchan1, smabuffer.rsnchan);
  smabuffer.dosam    = *dosam1;
  smabuffer.doxyp    = *doxyp1;
  smabuffer.opcorr   = *doop1;
  smabuffer.dohann   = *dohann1;
  smabuffer.doif     = *doif1;
  smabuffer.dobary   = *dobary1;
  smabuffer.birdie   = *birdie1;
  smabuffer.dowt     = *dowt1;
  smabuffer.dopmps   = *dopmps1;
  smabuffer.hires    = *hires1;
  smabuffer.nopol    = *nopol1;
  smabuffer.circular = *circular1;
  smabuffer.linear   = *linear1;
  smabuffer.oldpol   = *oldpol1;
  smabuffer.lat      = lat1;
  smabuffer.longi    = long1;
  smabuffer.evec     = evec1;
  smabuffer.refant   = refant1;
  smabuffer.dolsr    = *dolsr1;
  smabuffer.noskip   = *noskip1;
  smabuffer.vsource= *vsour1;
  smabuffer.dsb    = *dsb1;
  smabuffer.juldate= -10.00;
  smabuffer.spskip[0] = spskip1[0];
  smabuffer.spskip[1] = spskip1[1];
  smabuffer.mcconfig  = *mcconfig1;
  smabuffer.mcconfig  = 1;
  smabuffer.highrspectra = *nohighspr1;
  smabuffer.debug = *dodebug1;
  if(SMIF>49) bug_c('f',"SMIF>49 ....");
        if(dodebug1>0) {
//
// create ACSII file for error reporting
//
            strncpy (logfile, "ERRreport.log", 13);
//            logout = fopen(logfile,"w");
                       }
//      fprintf(stderr,"User's input vSource = %f km/s\n", smabuffer.vsource);
      if(rfreq1 > DSLIMIT || rfreq1 < -DSLIMIT) {
             for (i=0; i<SMIF+1; i++)           {
             smabuffer.restfreq[i] = rfreq1;
                                                 }
            smabuffer.dorfreq = -1;
      fprintf(stderr,"User's input RestFrequency = %f GHz\n", rfreq1);
                                                 } else {
             smabuffer.dorfreq =  1;
                                                 }
             smabuffer.antpos[0] = antpos1[0];
             smabuffer.readant   = readant1;
             for (i=1; i<readant1*3+1; i++)     {
             smabuffer.antpos[i]=antpos1[i-1];
                                                }
  if(smabuffer.dowt>0) {
// process weights here. 
                       }
  smabuffer.newsc = FALSE;
  smabuffer.newfreq = FALSE;
  smabuffer.nants = 0;
  smabuffer.nifs = 0;
  smabuffer.nused = 0;
  smabuffer.tcorr = 0;
  buffer=(int)*kst;
  *kst= OK;
  }

void rspokeflshsma_c(char *kst[])
{ 
  int tno;
  int i1, i2, ifs, p, bl, sb, rx, nchan, nspect;
  int npol,ipnt,ischan[SMIF];
  int tbinhi,ibuff;
  double preamble[5], tdash;
  long int dummy;
  float jyperk, eta, eta_c, eta_a, r_ant=3, pi;
  float vis[2*MAXCHAN];
  int flags[MAXCHAN]; 
  struct pols *polcnt;
  char telescope[4];
  char instrument[4];
  char version[64];
// initialization:
  eta_a=0.75;
  tno = smabuffer.tno;
  sb = smabuffer.sb; // sb=0 for lsb; sb=1 for usb; sb=2 for both 
  rx = smabuffer.rxif;
  if(smabuffer.nused==0) 
    return;
//  put ants to uvdata 
  if(smabuffer.nants!=0) {
    uvputvri_c(tno,"nants",&(smabuffer.nants),1);
//  write telescope name and other description parameters 
    sprintf(telescope,"SMA");
    sprintf(instrument,"SMA");
//  sprintf(observer,"SmaUser");
    sprintf(version, "511 version 3.1: 2010-02-25%s","\0");
    uvputvra_c(tno, "telescop", telescope);
    uvputvra_c(tno, "instrume", instrument);
    uvputvra_c(tno, "observer", observer);
    uvputvra_c(tno, "version", version);
                          }
  if(smabuffer.newfreq>0) {
     if(smabuffer.doif>0) {
      for (ifs=1; ifs < smabuffer.nifs; ifs++) {
	if(smabuffer.nstoke[ifs-1]!=smabuffer.nstoke[0]) 
 bug_c('f',"Number of polarisations differ between IFs. Use options=noif.\n"); 
    for (p=1; p< smabuffer.nstoke[ifs-1]; p++) {
	  if(smabuffer.polcode[ifs-1][p-1][0]!=smabuffer.polcode[0][p-1][0]) 
 bug_c('f',"Polarisation types differ between IFs. Use options=noif.\n");
                                        	}
                                                }
                          }
                          } else {
    if(smabuffer.hires > 0) 
      for (ifs=1; ifs<smabuffer.nifs; ifs++){
	if (smabuffer.nbin[ifs]!=smabuffer.nbin[0]) 
 bug_c('f', "Number of bins in different IFs must agree for options=hires\n");
                                            }
                                  } 
  tdash  = smabuffer.time;
  tbinhi = 1;
// convert julian date to ut and store ut 
// ut and julian date on 2000 julian2000=2451544.5
// julain date = 2451544.5 + day of the yr + fraction of day from 0h UT 
// determine julian date
     if(smabuffer.juldate < -1.) { 
     dummy =  (long int) (smabuffer.time);
     smabuffer.juldate = (double) dummy + 0.5;
                                 }
// convert juldate to ut in radians
     smabuffer.ut = smabuffer.time - smabuffer.juldate;
     smabuffer.ut = smabuffer.ut*DPI*2.0;
// store ut
     uvputvrd_c(tno,"ut",&(smabuffer.ut),1);
// store apparent LST 
     uvputvrd_c(tno,"lst",&(smabuffer.lst),1);
// store elaz and chi data 
     elazchi(tno);
// store radial velocity of the observatory w.r.t. the rest frame 
  uvputvrr_c(tno,"veldop",&(smabuffer.veldop),1);
// store the source velocity w.r.t. the rest frame
  uvputvrr_c(tno,"vsource",&(smabuffer.vsource),1);
//
// antenna aperture efficiency from TK
// nearly no elevation dependence at EL > 20 deg
// at 690 GHz there have been no proper measurements yet
// 0.4 would be number assumed.  07-jul-05
//
   if(smabuffer.juldate>rx400jday) {
  switch(smabuffer.rxif) {  
  case 0: eta_a=0.75;    // jyperk=139. assuming eta_a=0.7 d=6m
                         // 230 
          break;
  case 1: eta_a=0.6;     // jyperk=194. assuming eta_a=0.6 d=6m
                         // 340    
          break;
  case 2: eta_a=0.5;     // jyperk=???. assuming eta_a=??? d=6m
                         // 400
          break;
  case 3: eta_a=0.4;     // jyperk=242. assuming eta_a=0.4 d=6m 
                         // 690  
          break;
                         }
                         } else {
  switch(smabuffer.rxif) {
  case 0: eta_a=0.75;    // jyperk=139. assuming eta_a=0.7 d=6m
                         // 230
          break;
  case 1: eta_a=0.6;     // jyperk=194. assuming eta_a=0.5 d=6m
                         // 340
          break;
  case 2: eta_a=0.4;     // jyperk=242. assuming eta_a=0.4 d=6m
                         // 690
          break;
                         }
                         }
   eta_c = 0.88;
   eta   = eta_a*eta_c;
   pi    = (float) DPI;
// calculate jyperk
   jyperk=2.* 1.38e3/pi/(eta*r_ant*r_ant);
   uvputvrr_c(tno,"jyperk", &jyperk,1);
// Handle the case of writing the multiple 
// IFs (chunks) out as multiple records (not implemented yet). 
    if(smabuffer.doif!=1&&smabuffer.nifs>1) {
    nspect =ischan[0]= 1;
    for(ifs=0; ifs < smabuffer.nifs; ifs++) {
      printf(" writing headers\n");
      uvputvri_c(tno,"nspect",&nspect,1);
      printf(" search\n");
      uvputvri_c(tno,"npol",  &(smabuffer.nstoke[ifs]),1);
      uvputvri_c(tno,"nschan",&(smabuffer.nfreq[ifs]),1);
      uvputvri_c(tno,"ischan",&ischan[0],1);
      uvputvrd_c(tno,"sfreq", &(smabuffer.sfreq[ifs]),1);
      uvputvrd_c(tno,"sdf",   &(smabuffer.sdf[ifs]),  1);
//      fprintf(stderr, "smabuffer.restfreq[%d]=%f\n", ifs, smabuffer.restfreq[ifs]); 
      uvputvrd_c(tno,"restfreq",&(smabuffer.restfreq[ifs]),1);
      bl=0;
      for(i2=1; i2<smabuffer.nants+1; i2++) {
	for(i1=1; i1<i2+1; i2++)            {
	  preamble[0] = smabuffer.u[bl];
	  preamble[1] = smabuffer.v[bl];
	  preamble[2] = smabuffer.w[bl];
	  preamble[3] = tdash;
	  preamble[4] = 256*i1 + i2;
	  for(p=0; p<smabuffer.nstoke[ifs]; p++) {
          ipnt = smabuffer.pnt[ifs][p][bl][0][0];
          printf("ipnt=%d\n", ipnt);
	  if(ipnt>0) 
	  uvputvrr_c(tno,"inttime",&smabuffer.inttime[bl],1);
	  if(smabuffer.opcorr==0) {
	                          }
	                                           }
	  bl++;
	                                     }
                                             }
                                             }
                                             } else {
//
// Handle the case of writing the multiple IFs (chunks) out as a single record.
// This way is adopted to store SMA data in Miriad format.
//
    if(smabuffer.newfreq>0) {
      ischan[0] = 1;
//
// counting total number of spectral channels
//
      for (ifs = 1; ifs < smabuffer.nifs; ifs++) {
	ischan[ifs] = ischan[ifs-1] + smabuffer.nfreq[ifs];
                                                 }
      uvputvri_c(tno,"nspect",&(smabuffer.nifs),1);
      uvputvri_c(tno,"ischan",&(ischan),smabuffer.nifs);
      uvputvri_c(tno,"nschan",&(smabuffer.nfreq),smabuffer.nifs);
      uvputvrd_c(tno,"sfreq",&(smabuffer.sfreq),smabuffer.nifs);
      uvputvrd_c(tno,"sdf",&(smabuffer.sdf),smabuffer.nifs);
//      fprintf(stderr, "smabuffer.restfreq[%d]=%f nifs=%d\n", ifs, 
//               smabuffer.restfreq[ifs], smabuffer.nifs);
      uvputvrd_c(tno,"restfreq",&(smabuffer.restfreq),smabuffer.nifs);
      uvputvrr_c(tno,"veldop",&(smabuffer.veldop),1);
                            }
    uvputvri_c(tno,"tcorr",&(smabuffer.tcorr),1);
//
// store system temperature 
//
    tsysStore(tno); 
//
// store the random parameters and the visibility data
//
    bl=0;
    for(i2=1; i2<smabuffer.nants+1; i2++) {
      for(i1=1; i1<i2+1; i1++){
	preamble[0] = smabuffer.u[bl];
	preamble[1] = smabuffer.v[bl];
	preamble[2] = smabuffer.w[bl];
	preamble[3] = smabuffer.time; 
	preamble[4] = (double)smabuffer.blcode[bl]; 
	polcnt = rscntstokes(npol, bl, sb, rx);
	npol = polcnt->npol;
	if(npol>0) {
	uvputvri_c(tno,"npol",&npol,1);
	for(p=polcnt->polstart; p<polcnt->polend+1; p++) {
	    nchan = rsgetdata(vis,flags,&nchan, p, bl, sb, rx);    
	    if(nchan>0) {
	    ibuff = smabuffer.polcode[0][p][bl];
	    uvputvri_c(tno,"pol",&ibuff,1);
	    uvputvrr_c(tno,"inttime",&smabuffer.inttime[bl],1);
	    uvwrite_c(tno,preamble,vis,flags,nchan);
//
// write wide band data
//          uvwwrite_c(tno,wdata,wflags,nwread);
// tno    -> file handle
// wdata  -> wideband data
// wflags -> wideband flags
// nwread -> number of wideband data         
//
	                }
	                                                  }
                   }               
	bl++;
                              }
                                            }
        }
//
// reset the frequency processing handle
//
  smabuffer.newfreq=-1;
//
// re-initialize the pntr
//
       if(SMIF>49) bug_c('f',"SMIF>49 ...."); 
  for (ifs=0; ifs<SMIF; ifs++) {
    for (p=0; p<SMPOL; p++)     {
      for (bl=0; bl<SMBAS; bl++) {
	for (sb=0; sb<SMSB; sb++) {
	  for (rx=0; rx<SMRX; rx++){
	    smabuffer.pnt[ifs][p][bl][sb][rx]=0;
            smabuffer.flag[ifs][p][bl][sb][rx]=-1;
                               	   }
	                          }
                                 }
                                }
                               }
}

int rsgetdata(float smavis[2*MAXCHAN], int smaflags[MAXCHAN], int *smanchan, int p, int bl, int sb, int rx)
{  
//
// Construct a visibility record buffer from multiple IFs (chunks). 
//
  int nifs=smabuffer.nifs;
  float fac[nifs];
  int n,ipnt,i,nchand, nchan; 
  nchan = 0;
  nchand = 0;
  for (n=0; n<nifs; n++) {
    ipnt = smabuffer.pnt[n][p][bl][sb][rx]; 
      if(ipnt>0)       {
      if(nchan<nchand)   {
	for (i=nchan; i<nchand; i++) {
	  smaflags[i] = -1;
	  smavis[2*i] = 0;
	  smavis[2*i+1] = 0;
	                             }     
	nchan = nchand;
                         }
      for (i=nchan; i< nchan+smabuffer.nfreq[n]; i++){
	fac[n]=1000000.;

	smavis[2*i]   =  fac[n]*smabuffer.data[ipnt].real;
	smavis[2*i+1] =  fac[n]*smabuffer.data[ipnt].imag;
        smaflags[i] =  smabuffer.flag[n][p][bl][sb][rx];       
	ipnt++;    
                                                      }
      if(smabuffer.bchan[n]>=1&&smabuffer.bchan[n]<=smabuffer.nfreq[n])
	smaflags[nchan+smabuffer.bchan[n]] = smabuffer.flag[n][p][bl][sb][rx]; 
        nchan = nchan + smabuffer.nfreq[n];
                      }
    nchand = nchand + smabuffer.nfreq[n];
                           }
  
  if(nchan<nchand&&nchan>0) {
    for(i=nchan+1; i< nchand+1; i++) {
      smaflags[i] = smabuffer.flag[n][p][bl][sb][rx]; 
      smavis[2*i] = 0;
      smavis[2*i+1] = 0;
                                      }
    nchan = nchand;
                            }
  *smanchan=nchan;
  return nchan;
}

struct pols *rscntstokes(int npol, int bl, int sb, int rx)
{ 
//
// Determine the number of valid Stokes records in this record.
//
  int nifs = SMIF;
  int nstoke = SMPOL;
  short valid;
  int p, p1, p2, ifs;
  static struct pols polcnts;

  npol =0;
  p1=-1;
  p2=1;
  for (p=0; p< nstoke; p++) {
    valid = -1;
    for ( ifs =0; ifs<nifs; ifs++) {
      valid = valid;
      if(smabuffer.pnt[ifs][p][bl][sb][rx] > 0) valid = 1;
                                   }
    if(valid>0&&p1==-1) {p1=p; p2=p1;}
    if(valid>0) {npol++; if(p>p1) p2=p1+1;}
                            }
  polcnts.npol=npol;
  polcnts.polstart=p1;
  polcnts.polend=p2;
  return &polcnts;
}          

int rsmir_Read(char *datapath, int jstat)
{
  char location[7][81];
  char pathname[64];
  char filename[7][36];
  char sours[9], smasours[33];
  int  set, readSet;
  int  file,nfiles = 6;
  int  headerbytes[6];
  smEng **smaEngdata;
  int  i,j,k,l,m,i0,i1;
  int  kk,iinset,lastinset,ireset,reset_id[10];
  unsigned long imax,bytepos,nbytes,datalength;
  long *data_start_pos;
  int  firstbsl;
  int  numberBaselines=0;
  int  numberSpectra,numberSidebands,numberRxif;
  int  numberChannels;
  int  blhid,firstsp,lastsp;
  int  inhset,blhset,sphset,inhset1st;
  int  spcode[25], frcode[25];
  short int scale;
  short int *shortdata;
  double r,cost,sint,z0,tmp, rar, decr;
  double sfoff[SMIF+1];
  double antpos[3*MAXANT+1];
  int tno, ipnt, max_sourid;
  int kstat, dopvelRefChunk=12;
  char *kst[4];
  static char target[7];
  static char unknown[8];
  char skipped[8];
  int ntarget;
  time_t  startTime, endTime;
  float trueTime;
  blvector blarray[MAXANT][MAXANT];
  station  antenna[MAXANT];
  source   multisour[MAXSOURCE];
  struct xyz   antxyz[MAXANT];
  int sourceID, phaseSign;
  short oka,okb,okc,okd;
  correlator smaCorr;
  frequency  smaFreq[2];
  uvwPack **uvwbsln;
  visdataBlock  visSMAscan;
  int sphSizeBuffer;
  int nnants, flush;
  int ifpnt, polpnt, blpnt, sbpnt, rxpnt, sblpnt;
  int nomsg;
  int avenchan,miriadsp[SMIF+1];
  int utcd=0;
  int utch=0;
  int utcm=0;
  int doprt;
  float utcs=0.0;
  static int blid_intchng[MAXINT];  
               // the baseline id right after integration change 
  int rxlod;   // the rx to load rxlod=0 -> smabuffer.rx1        
               //                rxlod=1 -> smabuffer.rx2        
  static int fix_rsnchan;
  float avereal, aveimag;
  extern struct inh_def   **inh;
  extern struct blh_def   **blh;
  static struct blh_config **bln;
  static struct sph_def   **sph;
  static struct sph_def   *sph1;
  static struct sph_config **spn;
  extern struct codeh_def **cdh;
  extern struct ant_def   **enh;
  extern struct sch_def   **sch;
  struct bltsys    **tsys;
  struct anttsys   **atsys;
  struct wtt    **wts;
  char version[64];
//
// print out version 
//
      sprintf(version, "version 3.3: 2012-06-11%s","\0");
//
// initialize
//
  startTime = time(NULL);
  phaseSign = 1;
  flush     = 1;
  polpnt    = 1;
  blpnt     = 1;
  rxlod     = 0;
  lastinset = 0;
  ireset    = 0;
  visSMAscan.blockID.ints=0;
  visSMAscan.blockID.inhid=0;
  visSMAscan.time.intTime=0.0;
//  
  strncpy(pathname,datapath,64);
  strncpy(filename[0],"in_read\0",8);
  strncpy(filename[1],"bl_read\0",8);
  strncpy(filename[2],"sp_read\0",8);
  strncpy(filename[3],"codes_read\0",11);
  strncpy(filename[4],"eng_read\0",9);
  strncpy(filename[5],"sch_read\0",9);
  strncpy(filename[6],"projectInfo\0",12);
  strncpy(target,"target\0",7);
  strncpy(unknown,"unknown\0",8);
  strncpy(skipped,"skipped!",8);
  ntarget=0;
  
// number of bytes in each type of header. 
// sch is variable number of bytes 
  headerbytes[0] = 132;
  headerbytes[1] = 118;
  headerbytes[2] = 100;
  headerbytes[3] = 42;
  headerbytes[4] = 188;
  headerbytes[5] = 0;
  if(smabuffer.mcconfig>0) nomsg=1; // suppress the debugging msg
  switch(jstat) {
  case -3:
// Open all the files
     fprintf(stderr,"\n");
     fprintf(stderr,
              "single-band standard (2GHz)................%s\n", 
                         version); 
      for (file=0;file<nfiles;file++){
      strncpy(location[file],pathname, 64); 
      strncat(location[file],filename[file],36);
// open the mir files
      fpin[file] = fopen(location[file],"r");
             if (fpin[file] == NULL) {
	fprintf(stderr,"Problem opening the file %s\n",location[file]);
	perror("file open problem");
	exit(-1);
                                     } else {
	fprintf(stderr,"Found file %s\n",location[file]);
                                            }
                                      }
// Get the size of each file and compute the number of headers 
      for (file=0;file<nfiles;file++){
        if(file < 5 ){
	imax = mfsize(fpin[file]);
	nsets[file] = imax / headerbytes[file];
                     }
                                     }
      strncpy(location[6],pathname,64);
      strncat(location[6],filename[6],36);
      fpin[6] = fopen(location[6],"r");
             if (fpin[6] == NULL) {
        fprintf(stderr,"Do not find %s\n",location[6]);
                    sprintf(observer,"SmaUser%s","\0"); 
                    printf("Observer: %s\n",observer);
                                     } else {
        fprintf(stderr,"Found file %s\n",location[6]);
              fread(&observer,sizeof(observer),1,fpin[6]);
                 printf("Observer: %s",observer);
                                            }
  break;
  case 0:   
//read header & vis 
       startTime = time(NULL);
       if(nsets[0]>MAXINT) {
       fprintf(stderr,"ERROR: Number of integration scans exceeded the limit %d.\n", MAXINT);
         exit(-1);
         }
// Allocate memory to store  the headers 
      inh = (struct inh_def **) malloc(nsets[0]*sizeof( struct inh_def *));
      for (set=0;set<nsets[0];set++) {
      inh[set] = (struct inh_def *)malloc(sizeof(struct inh_def ));
      if (inh[set] == NULL ){
      fprintf(stderr,"ERROR: Memory allocation for inh failed trying to allocate %d bytes\n", 
(int) (nsets[0]*sizeof(struct inh_def)));
	exit(-1);
                            }
                                      }
      if (smabuffer.scanproc==0||smabuffer.scanproc<0)
      smabuffer.scanproc = nsets[0] - smabuffer.scanskip-2;
      blh = (struct blh_def **) malloc(nsets[1]*sizeof( struct blh_def *));
      for (set=0;set<nsets[1];set++) {
      blh[set] = (struct blh_def *)malloc(sizeof(struct blh_def ));
      if (blh[set] == NULL )     {
      fprintf(stderr,"ERROR: Memory allocation for blh failed trying to allocate %d bytes\n", 
  (int) (nsets[1]*sizeof(struct blh_def)));
	exit(-1);
                                 }
                                      }
//
// allocate memory for cdh
//
    cdh = (struct codeh_def **) malloc(nsets[3]*sizeof( struct codeh_def *));
    for (set=0;set<nsets[3];set++) {
      cdh[set] = (struct codeh_def *)malloc(sizeof(struct codeh_def ));
      if (cdh[set] == NULL ){
      fprintf(stderr,"ERROR: Memory allocation for cdh failed for %d bytes.\n",
             (int)(nsets[3]*sizeof(struct codeh_def)));
      exit(-1);
                            }
                                    }
    for (set=0;set<nsets[3];set++){
      *cdh[set] = *(cdh_read(fpin[3]));
      if (SWAP_ENDIAN) {
      cdh[set]=swap_cdh(cdh[set]);
                       }
// decode the julian date for from the observing date
     if((cdh[set]->v_name[0]=='r'&&cdh[set]->v_name[1]=='e')&&
         cdh[set]->v_name[2]=='f')           {
         doprt=-1;
         jday = juliandate(&cdh[set],doprt); }
                                   } 
// new baseline buffer used for configuring spectra.
// the array length of bln is the same as the total number
// of integration sets in the mir file.
    bln = (struct blh_config **) malloc(nsets[0]*sizeof( struct blh_config *));
    for (set=0;set<nsets[0];set++) {
      bln[set] = (struct blh_config *)malloc(sizeof(struct blh_config ));
      if (bln[set] == NULL ){
      fprintf(stderr,"ERROR: Memory allocation for blh failed trying to allocate %d bytes\n", 
     (int) (nsets[0]*sizeof(struct blh_def)));
	exit(-1);
                            }
                                   }
// baseline coordinate buffer.
    uvwbsln = (struct uvwPack **) malloc(nsets[0]*sizeof( struct uvwPack));
    for (set=0;set<nsets[0];set++) {
      uvwbsln[set] = (struct uvwPack *)malloc(sizeof(struct uvwPack));
      if (uvwbsln[set] == NULL ){
      fprintf(stderr,"ERROR: Memory allocation for uvwbsln failed for %d bytes\n",
       (int) (nsets[0]*sizeof(struct uvwPack)));
	exit(-1);
                                 }
                                    }
// Read the headers 
    for (set=0;set<nsets[0];set++) {
//   *inh[set] = *(inh_read(fpin[0]));
        *inh[set] = (inh_read(fpin[0])); 
      if (SWAP_ENDIAN) {
	inh[set] = swap_inh(inh[set]);
                       } 
                                   }
    if (SWAP_ENDIAN) {
      printf("FINISHED READING  IN HEADERS (endian-swapped)\n");
                     } else {
      printf("FINISHED READING  IN HEADERS\n");
                            }
    for (set=0;set<nsets[1];set++) {
      *blh[set] = (blh_read(fpin[1]));
      if (SWAP_ENDIAN) {
	blh[set] =  swap_blh(blh[set]);
                       }
                                   }
// count sidebands
    numberSidebands = 1;
    for (set=0; set<nsets[1]-1; set++) {
      if( blh[set]->inhid == inh[smabuffer.scanskip]->inhid
	  &&  blh[set]->isb != blh[set+1]->isb) {
	numberSidebands = 2;
	break; 
                                     }
                                                }
    fprintf(stderr,"NUMBER OF SIDEBANDS =%d\n",numberSidebands);
// count receivers
    smaCorr.no_rxif = 1;
    for (set=0; set<nsets[1]-1; set++) {
      smabuffer.rx1=smabuffer.rx2=blh[set]->irec;
      if( blh[set]->inhid == inh[smabuffer.scanskip]->inhid
	  &&  blh[set]->irec != blh[set+1]->irec) {
        smabuffer.rx2=blh[set+1]->irec;
	smaCorr.no_rxif = 2;
	break;
                                                  }
                                      }
    fprintf(stderr,"NUMBER OF RECEIVERS =%d \n",smaCorr.no_rxif);
    if(smabuffer.rxif==-1) smabuffer.rxif=smabuffer.rx1;
    if(smaCorr.no_rxif==2&&smabuffer.rxif==-2) smabuffer.rxif=smabuffer.rx2;
    if(smaCorr.no_rxif==1&&smabuffer.rxif==-2) {
    fprintf(stderr,"ERROR: No 2nd receiver data are found.\n");
     exit(-1);
                                               }
     
   if (jday<rx400jday)          {
   switch(smabuffer.rx1)        {
   case 0: printf("rx1->230\n"); break;
   case 1: printf("rx1->340\n"); break;
   case 2: printf("rx1->690\n"); break;
                                }
                                } else {
   switch(smabuffer.rx1)               {
   case 0: printf("rx1->230\n"); break;
   case 1: printf("rx1->340\n"); break;
   case 2: printf("rx1->400\n"); break;
   case 3: printf("rx1->690\n"); break;
                                       }
                                       }
   if(smaCorr.no_rxif == 2){
    if (jday<rx400jday)    {
   switch(smabuffer.rx2)   {
   case 0: printf("rx2->230\n"); break;
   case 1: printf("rx2->340\n"); break;
   case 2: printf("rx2->690\n"); break;
                           } 
                           }else{
   switch(smabuffer.rx2)        {
   case 0: printf("rx2->230\n"); break;
   case 1: printf("rx2->340\n"); break;
   case 2: printf("rx2->400\n"); break;
   case 3: printf("rx2->690\n"); break;
                                }
                                }    
                           }
    if(smabuffer.sb==0) fprintf(stderr,"Processing LSB\n");
    if(smabuffer.sb==1) fprintf(stderr,"Processing USB\n");
 
    numberRxif = smaCorr.no_rxif;
// check if the receiver  smabuffer.rxif is there
    if(smabuffer.rxif==-1) goto foundTheRx;
    for (set=0; set<nsets[1]; set++)    {
      if( blh[set]->inhid == inh[smabuffer.scanskip]->inhid
	  &&  blh[set]->irec == smabuffer.rxif) 
	  goto foundTheRx;              } 
    fprintf(stderr,"ERROR: there is no receiver %d in this data set.\n",
	   smabuffer.rxif);
    if(smaCorr.no_rxif == 1)
    fprintf(stderr,"       please try it again with rxif=%d\n", smabuffer.rx1);
     if(smaCorr.no_rxif == 2)
    fprintf(stderr,"       please try it again with rxif=%d or rxif=%d\n", 
    smabuffer.rx1,  smabuffer.rx2);
    exit(-1);
foundTheRx:
// assign the rx id to load in the case of dual rx
      if(smabuffer.rxif==-1||smaCorr.no_rxif==1) { rxlod=0;
                                                 } else {
      if(smabuffer.rxif==smabuffer.rx1) rxlod=0;
      if(smabuffer.rxif==smabuffer.rx2) rxlod=1;
                                                         }

    tsys = (struct bltsys **) malloc(nsets[1]*sizeof( struct bltsys *));
    for (set=0;set<nsets[1];set++) {
      tsys[set] = (struct bltsys *)malloc(sizeof(struct bltsys ));
      if (tsys[set] == NULL )      {
  fprintf(stderr,"ERROR: Memory allocation for tsys failed trying to allocate %d bytes\n",
(int) (nsets[1]*sizeof(struct bltsys)));
	exit(-1);
                                   }
                                   }
    atsys = (struct anttsys **) malloc(nsets[0]*sizeof( struct anttsys *));
    for (set=0;set<nsets[0];set++)  {
      atsys[set] = (struct anttsys *)malloc(sizeof(struct anttsys ));
      if (atsys[set] == NULL )      {
	fprintf(stderr,"ERROR: Memory allocation for atsys failed trying to allocate %d bytes\n",
(int) (nsets[0]*sizeof(struct anttsys)));
	exit(-1);
                                    }
                                    }
//  allocate memory for wts once in the case of do both sb
//  if(smabuffer.dsb!=1||(smabuffer.dsb==1&&smabuffer.sb==0)){
    wts = (struct wtt **) malloc(nsets[0]*sizeof( struct wtt *));
    for (set=0;set<nsets[0];set++)  {
      wts[set] = (struct wtt *)malloc(sizeof(struct wtt ));
      if (wts[set] == NULL )        {
        fprintf(stderr,"ERROR: Memory allocation for wts failed trying to allocate %d bytes. Try 64bits.\n",
      (int) (nsets[0]*sizeof(struct wtt)));
        exit(-1);
                                    }
                                    }                            
             //  }


// loading baselines 
    blhset =0;
    { 
      int blnset;
      int blset;
      int inhid_hdr;
      int blhid_hdr;
      blhid_hdr = 0;
      inhid_hdr = inh[0]->inhid;
      blnset = 0;
      if (smabuffer.rxif!=-1) {

           if(jday<rx400jday) {
       switch(smabuffer.rxif) {
   case 0: printf("to load rx->230 visdata\n"); break;
   case 1: printf("to load rx->340 visdata\n"); break;
   case 2: printf("to load rx->690 visdata\n"); break;
                              } 
                              } else {
   switch(smabuffer.rxif) {
   case 0: printf("to load rx->230 visdata\n"); break;
   case 1: printf("to load rx->340 visdata\n"); break;
   case 2: printf("to load rx->400 visdata\n"); break;
   case 3: printf("to load rx->690 visdata\n"); break;
                          }
                                     }
                              } else {
	fprintf(stderr,"to load data for all receivers.\n");
                                     } 
//
// bln will be used in configuring spectra
//
      set=0;
      for (blset=0; blset < nsets[1]; blset++)      { 
// loading baseline based structure
	tsys[blset]->blhid=blh[blset]->blhid;
	tsys[blset]->inhid=blh[blset]->inhid;
        tsys[blset]->blsid=blh[blset]->blsid;
	tsys[blset]->isb  =blh[blset]->isb;
	tsys[blset]->irec =blh[blset]->irec;
        tsys[blset]->ipol =ipolmap(blh[blset]->ipol);
	tsys[blset]->itel1=blh[blset]->itel1;
	tsys[blset]->itel2=blh[blset]->itel2;
	
// assign baseline id handr
	if(blset==0) blhid_hdr = blset;
	if(blh[blset]->inhid!=inh[set]->inhid) {
	set++;
	blhid_hdr = blset;  
	                                       }
// check if set exceeds nsets[0]
        if(set==nsets[0]) goto handling_blarray;        
// select side band 
	if(blh[blset]->inhid==inh[set]->inhid) {
// get the baseline id for the first bl after rx changes in the new integration
        if(blh[blset]->inhid>blh[0]->inhid){
        if(smaCorr.no_rxif==2&&blh[blset-1]->irec==smabuffer.rx1
        &&blh[blset]->irec==smabuffer.rx2) {
        blid_intchng[set] = blh[blset]->blhid;
//        sprintf(logstr,"blid_intchng=%d blh[blset]->blhid=%d set=%d blset=%d rx1=%d rx2=%d\n",
//        blid_intchng[set],
//        blh[blset]->blhid,
//        set, blset, smabuffer.rx1, smabuffer.rx2);
//fputs(logstr, logout);
                                          }}
// choose rx
	if(blh[blset]->irec==smabuffer.rxif||smabuffer.rxif==-1) {
// for the first set of integration, take the 1st baseline
        if(set==0&&blh[blset]->isb==smabuffer.sb) {
	      bln[set]->inhid = blh[blset]->inhid;
	      bln[set]->blhid = blh[blset]->blhid;
	      bln[set]->isb   = blh[blset]->isb;
	      bln[set]->irec  = blh[blset]->irec; 
	      inhid_hdr       = blh[blset]->inhid;
	                                              }
// for the successive integration set, take the 1st baseline
// right after change of integration.
	    if(blh[blset]->inhid>inhid_hdr&&blh[blset]->isb==smabuffer.sb){
	      bln[set]->inhid = blh[blset]->inhid;
	      bln[set]->blhid = blh[blset]->blhid;
	      bln[set]->isb   = blh[blset]->isb;
	      bln[set]->irec  = blh[blset]->irec;
	      inhid_hdr       = blh[blset]->inhid;
	                                                                 }
	                                                              }


// loading data to baseline coordinate structure
// convert ovro sign convention to miriad convention
// by multiplying a negative sign to uvw coordinates
	  uvwbsln[set]->uvwID[blset-blhid_hdr].u = -blh[blset]->u;
	  uvwbsln[set]->uvwID[blset-blhid_hdr].v = -blh[blset]->v;
	  uvwbsln[set]->uvwID[blset-blhid_hdr].w = -blh[blset]->w;
	  uvwbsln[set]->inhid = blh[blset]->inhid;
	  uvwbsln[set]->uvwID[blset-blhid_hdr].blhid = blh[blset]->blhid;
	  uvwbsln[set]->uvwID[blset-blhid_hdr].blsid = blh[blset]->blsid;
	  uvwbsln[set]->uvwID[blset-blhid_hdr].blcode =
	    blh[blset]->itel1*256+blh[blset]->itel2;
	  uvwbsln[set]->uvwID[blset-blhid_hdr].isb = blh[blset]->isb;
	  uvwbsln[set]->uvwID[blset-blhid_hdr].irec = blh[blset]->irec;
// polarization
        uvwbsln[set]->uvwID[blset-blhid_hdr].ipol = ipolmap(blh[blset]->ipol);
// counting baseline for each integration set
	  uvwbsln[set]->n_bls++;
	                                           }
	numberBaselines=uvwbsln[set]->n_bls;
//        fprintf(stderr,"numberBaselines=",numberBaselines);
     if(jday<2455247.0&&numberBaselines>112) {
            if(jday>2455246.0&&jday<2455247.0) {
      fprintf(stderr,"ERROR: inconsistent baseline header.\n");
                 exit(-1);
                        }
           fprintf(stderr,
            "ERROR: Number of baselines exceeded the limit %d .\n", MAXBAS);
      exit(-1);
                            }
     if(numberBaselines>MAXBAS) {
      fprintf(stderr,"ERROR: Number of baselines exceeded the limit %d .\n", MAXBAS);
      exit(-1);
                            }

                                                  } // blset 
    }
           fprintf(stderr,"numberBaselines=%d\n",numberBaselines);
handling_blarray:
// set antennas 
   {
      int bset;
// initialize blarray

            for (i=0; i< MAXANT; i++) {
             for (j=0; j< MAXANT; j++)  {
          blarray[i][j].ee = 0.0;
           blarray[i][j].nn = 0.0;
            blarray[i][j].uu = 0.0;
             blarray[i][j].itel1 = 0;
              blarray[i][j].itel2 = 0;
               blarray[i][j].blid  = 0;
                                      } }
      bset = smabuffer.scanskip*numberBaselines;
      blarray[blh[bset]->itel1][blh[bset]->itel2].ee = blh[bset]->ble ;
      blarray[blh[bset]->itel1][blh[bset]->itel2].nn = blh[bset]->bln ;
      blarray[blh[bset]->itel1][blh[bset]->itel2].uu = blh[bset]->blu ;
      smabuffer.nants=1;
      for (set=bset+1;set<nsets[1];set++) {
	if(blarray[blh[bset]->itel1][blh[bset]->itel2].ee != blh[set]->ble) {
	  blarray[blh[set]->itel1][blh[set]->itel2].ee = blh[set]->ble;
	  blarray[blh[set]->itel1][blh[set]->itel2].nn = blh[set]->bln;
	  blarray[blh[set]->itel1][blh[set]->itel2].uu = blh[set]->blu;
	  blarray[blh[set]->itel1][blh[set]->itel2].itel1 = blh[set]->itel1;
	  blarray[blh[set]->itel1][blh[set]->itel2].itel2 = blh[set]->itel2;
	  blarray[blh[set]->itel1][blh[set]->itel2].blid  = blh[set]->blsid;
	  smabuffer.nants++;                                               }
	else
	    {smabuffer.nants = (int)((1+sqrt(1.+8.*smabuffer.nants))/2);
	  printf("mirRead: number of antenna =%d are found.\n", smabuffer.nants);
	  goto blload_done;            
                  } 
                                        } // set 
    }
  blload_done:
    free(blh);
    
    if (SWAP_ENDIAN) {
      fprintf(stderr,"FINISHED READING  BL HEADERS (endian-swapped)\n");
                     } else {
      fprintf(stderr,"FINISHED READING  BL HEADERS\n");
                            }
// assign memory to enh
    enh = (struct ant_def **) malloc(nsets[4]*sizeof( struct ant_def *));
    for (set=0;set<nsets[4];set++) {
      enh[set] = (struct ant_def *)malloc(sizeof(struct ant_def ));
      if (enh[set] == NULL )       {
      fprintf(stderr,"ERROR: Memory allocation for enh failed for %d bytes\n",
(int) (nsets[4]*sizeof(struct ant_def)));
	exit(-1);
                                   }
                                   }
// make sma engineer data buffer
    smaEngdata = (struct smEng **) malloc(nsets[0]*sizeof( struct smEng *));
    for (set=0;set<nsets[0];set++) {
      smaEngdata[set] = (struct smEng *)malloc(sizeof(struct smEng ));
      if (smaEngdata[set] == NULL ){
     fprintf(stderr,"ERROR: Memory allocation for smaEngdata failed for %d bytes\n",
(int) ( nsets[0]*sizeof(struct smEng)));
	exit(-1);
                                   }
                                   }
// skip engineer data reading because the engineer
// file was problem for the two receivers case. 05-2-25
    if (smabuffer.doeng!=1) {
      goto engskip;
                              } else      {
// read engineer data
      for (set=0;set<nsets[4];set++) {
	*enh[set] = *(enh_read(fpin[4]));
        if (SWAP_ENDIAN) {
	  enh[set]=swap_enh(enh[set]);
                         }           } 
// store sma engineer data to smaEngdata 
      inhset=0;
      for (set=0;set<nsets[4];set++) {
        if(enh[set]->inhid!=inh[inhset]->inhid) inhset++;
        if(inhset<nsets[0]) {
	  smaEngdata[inhset]->inhid = enh[set]->inhid;
	  smaEngdata[inhset]->ints  = enh[set]->ints;
	  smaEngdata[inhset]->antpad_no[enh[set]->antennaNumber]
	    = enh[set]->padNumber;
	  smaEngdata[inhset]->antenna_no[enh[set]->antennaNumber]
	    = enh[set]->antennaNumber;
	  smaEngdata[inhset]->lst   = enh[set]->lst;
	  smaEngdata[inhset]->dhrs  = enh[set]->dhrs;
	  smaEngdata[inhset]->ha    = enh[set]->ha;
	  smaEngdata[inhset]->el[enh[set]->antennaNumber]
	    = enh[set]->actual_el;
	  smaEngdata[inhset]->az[enh[set]->antennaNumber]
	    = enh[set]->actual_az;
	  smaEngdata[inhset]->tsys[enh[set]->antennaNumber]
	    = enh[set]->tsys;
	  smaEngdata[inhset]->tamb[enh[set]->antennaNumber]
	    = enh[set]->ambient_load_temperature;
	                   } 
                                     }
                                                }
    if (SWAP_ENDIAN) {
     fprintf(stderr,"FINISHED READING EN HEADERS (endian-swapped)\n");
    } else {
     fprintf(stderr,"FINISHED READING EN HEADERS\n");
    }
  engskip:
// free(smaEngdata);
    free(enh);
// initialize the antenna positions
    smabuffer.nants=8;
    for (i=1; i < smabuffer.nants+1; i++) {
      antenna[i].x = 0.;
      antenna[i].y = 0.;
      antenna[i].z = 0.;
      antenna[i].x_phs = 0.;
      antenna[i].y_phs = 0.;
      antenna[i].z_phs = 0.;
      antenna[i].axisoff_x = 0.;
      antenna[i].axisoff_y = 0.;
      antenna[i].axisoff_z = 0.;
                                           }
    
// set up the reference antenna
    antenna[smabuffer.refant].x = 0.;
    antenna[smabuffer.refant].y = 0.;
    antenna[smabuffer.refant].z = 0.;
    
// derive antenna position in local coordinate system
// mir stores the position in float
    for (i=1; i < smabuffer.nants+1; i++) {
      if(i<smabuffer.refant) {
	antenna[i].x = (double)blarray[i][smabuffer.refant].ee 
	  - antenna[smabuffer.refant].x;
	antenna[i].y = (double)blarray[i][smabuffer.refant].nn 
	  - antenna[smabuffer.refant].y;
	antenna[i].z = (double)blarray[i][smabuffer.refant].uu 
	  - antenna[smabuffer.refant].z;
                             } else {
         if(i==smabuffer.refant) {
         antenna[smabuffer.refant].x = 0.;
         antenna[smabuffer.refant].y = 0.;
         antenna[smabuffer.refant].z = 0.;
                                 } else {

	
	antenna[i].x = (double)blarray[smabuffer.refant][i].ee
	  - antenna[smabuffer.refant].x;
	antenna[i].x = - antenna[i].x;
	antenna[i].y = (double)blarray[smabuffer.refant][i].nn
	  - antenna[smabuffer.refant].y;
	antenna[i].y = - antenna[i].y;
	antenna[i].z = (double)blarray[smabuffer.refant][i].uu
	  - antenna[smabuffer.refant].z;
	antenna[i].z = - antenna[i].z;
                                        }
                                    }
                                            }
//    
// calculate the geocentric coordinates from local 
// coordinates
//
    {
      struct xyz geocxyz[MAXANT];
      for (i=1; i < smabuffer.nants+1; i++) {
	geocxyz[i].x = (antenna[i].z)*cos(smabuffer.lat)
	  - (antenna[i].y)*sin(smabuffer.lat);
	geocxyz[i].y = (antenna[i].x);
	geocxyz[i].z = (antenna[i].z)*sin(smabuffer.lat)
	  + (antenna[i].y)*cos(smabuffer.lat);
                                            }
      fprintf(stderr,"NUMBER OF ANTENNAS =%d\n", smabuffer.nants);
//
// maximum antenna number for the array is 8 
//
      smabuffer.nants = 8;   
      for (i=1; i < smabuffer.nants+1; i++) {
	sprintf(antenna[i].name, "AN%d", i);
                                            }     
// the positions of antennas need to check  
// antpos on 2005 feb 16
      antxyz[1].x = 4.4394950000000000e+00;
      antxyz[2].x = -5.7018977000000000e+00;
      antxyz[3].x = -5.0781509999999996e-01;
      antxyz[4].x = 5.2273398999999996e+00;
      antxyz[5].x = -1.7918341999999999e+01;
      antxyz[6].x = 0.0000000000000000e+00;
      antxyz[7].x = -1.6564844999999998e+01;
      antxyz[8].x = -6.4019909999999998e+00;
      
      antxyz[1].y = -6.3875615000000003e+01; 
      antxyz[2].y = -1.8985175000000002e+01;
      antxyz[3].y = -2.5154143000000001e+01;
      antxyz[4].y = -2.0077679000000000e+01;
      antxyz[5].y = -5.9557980000000001e+01;
      antxyz[6].y =  0.0000000000000000e+00;
      antxyz[7].y = -2.7025637000000000e+01;
      antxyz[8].y = -6.8001356999999999e+01;
      
      antxyz[1].z = -2.1837547000000001e+01; 
      antxyz[2].z = 1.5609299999999999e+01;
      antxyz[3].z =  1.2797959999999999e+00; 
      antxyz[4].z = -1.4844139000000000e+01;
      antxyz[5].z = 3.0068384999999999e+01;
      antxyz[6].z = 0.0000000000000000e+00;
      antxyz[7].z = 3.0769280999999999e+01;
      antxyz[8].z = 3.6370589999999998e+00;

// reading antenna position from ASCII file
      if(smabuffer.readant > 0) {
double xyzpos;
       for (i=1; i < smabuffer.readant+1; i++) {
         geocxyz[i].x = smabuffer.antpos[1+(i-1)*3];
         geocxyz[i].y = smabuffer.antpos[2+(i-1)*3];
         geocxyz[i].z = smabuffer.antpos[3+(i-1)*3];
         xyzpos = geocxyz[i].x+geocxyz[i].y+geocxyz[i].z;
      if(xyzpos==0) smabuffer.refant = i;
                                               }
                                }

 fprintf(stderr,
     "Geocentrical coordinates of antennas (m), reference antenna=%d\n",
          smabuffer.refant); 
      for (i=1; i < smabuffer.nants+1; i++) {
       
 fprintf(stderr,"ANT x y z %s %11.4f %11.4f %11.4f\n",
	       antenna[i].name,
	       geocxyz[i].x,
	       geocxyz[i].y,
	       geocxyz[i].z);
                             }
//
// convert geocentrical coordinates to equatorial coordinates
// of miriad system y is local East, z is parallel to pole
// Units are nanosecs. 
// write antenna dat to uv file 
//
 fprintf(stderr,"Miriad coordinates of antennas (nanosecs), reference antenna=%d\n", smabuffer.refant);
      r = sqrt(pow(geocxyz[smabuffer.refant].x,2) + 
	       pow(geocxyz[smabuffer.refant].y,2));
      if(r>0) {
	cost = geocxyz[smabuffer.refant].x / r;
	sint = geocxyz[smabuffer.refant].y / r;
	z0   = geocxyz[smabuffer.refant].z; 
              } else {
	cost = 1;
	sint = 0;
	z0 = 0; 
                     }
      
      for (i=1; i < smabuffer.nants+1; i++) {      
	tmp  = ( geocxyz[i].x) * cost + (geocxyz[i].y)*sint - r;
	antpos[i-1] 
	  = (1e9/DCMKS) * tmp;
 fprintf(stderr,"ANT x y x %s %11.4f ", antenna[i].name, antpos[i-1]);
	tmp  = (-geocxyz[i].x) * sint + (geocxyz[i].y) * cost;
	antpos[i-1+smabuffer.nants] 
	  = (1e9/DCMKS) * tmp;
 fprintf(stderr,"%11.4f ", antpos[i-1 + smabuffer.nants]);
	antpos[i-1+2*smabuffer.nants] 
	  = (1e9/DCMKS) * (geocxyz[i].z-z0);
 fprintf(stderr,"%11.4f\n", antpos[i-1+2*smabuffer.nants]);
                                             }
      
                }
    
    tno  = smabuffer.tno;
    nnants = 3*smabuffer.nants;
    uvputvrd_c(tno,"antpos", antpos, nnants);
// setup source 
    if (SWAP_ENDIAN) {
      fprintf(stderr,"FINISHED READING  CD HEADERS (endian-swapped)\n");
                     } else {
      fprintf(stderr,"FINISHED READING  CD HEADERS\n");
                            }
    sourceID = 0;
    for (set=0;set<nsets[3];set++)   {
// decode the ids 
      if((cdh[set]->v_name[0]=='b'&&cdh[set]->v_name[1]=='a')&&
        cdh[set]->v_name[2]=='n')   {
        if(smabuffer.spskip[0]==0) { 
	spcode[cdh[set]->icode]=spdecode(&cdh[set]);
                                   } else { 
           if(cdh[set]->icode < smabuffer.spskip[0]) {
            spcode[cdh[set]->icode]=spdecode(&cdh[set]);
                                                     } else {
        spcode[cdh[set]->icode]
        =spdecode(&cdh[set])-smabuffer.spskip[1];
                                                            }
                                           }
                                    }
// decode the julian date for from the observing date 
     if((cdh[set]->v_name[0]=='r'&&cdh[set]->v_name[1]=='e')&&
	 cdh[set]->v_name[2]=='f'){
        doprt=-1;
//	jday = juliandate(&cdh[set],doprt);      
                                  }
                                      }
    printf("decode velocity type\n");
// decode velocity type 
// 2 CODE NAME vctype  STRING vlsr  icode 0 ncode 1
// 3 CODE NAME vctype  STRING cz    icode 1 ncode 1
// 4 CODE NAME vctype  STRING vhel  icode 2 ncode 1
// 5 CODE NAME vctype  STRING pla   icode 3 ncode 1
    
    if(inh[1]->ivctype==0)
      strncpy(multisour[sourceID].veltyp, "VELO-LSR", 8);
      
    if(inh[1]->ivctype==2)
      strncpy(multisour[sourceID].veltyp, "VELO-HEL", 8);
    if(inh[1]->ivctype!=0 && inh[1]->ivctype!=2) {
     fprintf(stderr,"ERROR: veltype ivctype=%d is not supported.\n",
	     inh[1]->ivctype);
      exit(-1); 
                                                 }
    uvputvra_c(tno,"veltype", multisour[sourceID].veltyp);
    printf("decode the source information\n");
// decode the source information 
    for (set=0;set<nsets[3];set++)  {
    if(cdh[set]->v_name[0]=='s'&&cdh[set]->v_name[1]=='o') {
        sourceID = cdh[set]->icode;
// parsing the source name and trim the junk tail
	for(i=0; i<17; i++) {
	  sours[i]=cdh[set]->code[i];
	  if(cdh[set]->code[i]==32||cdh[set]->code[i]==0||i==16)
	    sours[i]='\0';
                  }
// copy source name to the multiple source array with source ID
// as the array argument 
          sprintf(multisour[sourceID].name, "%s", sours);
// now check up if the new sours name has been used in the
// multiple source array          
          for(i=2; i< sourceID; i++) {
          if(strcmp(multisour[i].name, sours)==0) {
// if the name has been used then the last character need to be changed
// copy the original source name to smasours
          for(i1=0; i1<33; i1++) {
          smasours[i1]=cdh[set]->code[i1];
          if(cdh[set]->code[i1]==32||cdh[set]->code[i1]==0||i1==32)
            smasours[i]='\0';
                              }
         
          oka=okb=okc=okd=0;
          if(multisour[sourceID].name[15]=='a') oka=-1;
          if(multisour[sourceID].name[15]=='b') okb=-1;
          if(multisour[sourceID].name[15]=='c') okc=-1;
          if(multisour[sourceID].name[15]=='d') okd=-1; 
          if(oka==0) {  sours[15]='a';
          sprintf(multisour[sourceID].name, "%s", sours);
                     } else {           
          if(okb==0)   {sours[15]='b';
          sprintf(multisour[sourceID].name, "%s", sours);
                       } else {
          if(okc==0)  {sours[15]='c';
          sprintf(multisour[sourceID].name, "%s", sours);
                      } else {
          if(okd==0) {sours[15]='d';
          sprintf(multisour[sourceID].name, "%s", sours);              
                     }
                             }
                               }
                             }

    fprintf(stderr,"Warning: The original name: '%s' is renamed to '%s'\n", 
    smasours, multisour[sourceID].name);
                                          }
                                                 }
    multisour[sourceID].sour_id = cdh[set]->icode;
    inhset=0;
//    printf("looking for the 1st inhset corresponding to  sour_id\n");
// looking for the 1st inhset corresponding to  sour_id 
    while (inh[inhset]->souid!=multisour[sourceID].sour_id)
	inhset++;   
	multisour[sourceID].ra  = inh[inhset]->rar;
	multisour[sourceID].dec = inh[inhset]->decr;
// check source id and coordinates
        if(strncmp(multisour[sourceID].name,target,6)!=0) { 
        smabuffer.skipsrc=-1;
        for (i=1; i<sourceID+1; i++) {
        if(inh[inhset]->souid!=multisour[i].sour_id&&
        (multisour[i].ra==inh[inhset]->rar&&
         multisour[i].dec==inh[inhset]->decr)){
//fprintf(stderr,
//"Warning: %s has the source id (%d) different from that (%d) of %s \n",
//multisour[sourceID].name,multisour[sourceID].sour_id,
//multisour[i].sour_id,multisour[i].name);

//sprintf(logstr,
//"Warning: %s has the source id (%d) different from that (%d) of %s \n", 
//multisour[sourceID].name,multisour[sourceID].sour_id,
//multisour[i].sour_id,multisour[i].name);
//fputs(logstr, logout);
//sprintf(logstr,
//"but their coordinates are the same:\n RA=%13s", 
//(char *)rar2c(multisour[sourceID].ra));
   fprintf(stderr,
"but their coordinates are the same:\n RA=%13s",
(char *)rar2c(multisour[sourceID].ra));
//fputs(logstr, logout);
fprintf(stderr,"  Dec=%14s\n",
(char *)decr2c(multisour[sourceID].dec));

//sprintf(logstr,"  Dec=%14s\n",
//(char *)decr2c(multisour[sourceID].dec));
//fputs(logstr, logout);
//repeat the warning on screen:
fprintf(stderr, "Warning: %s has the source id (%d) different from that (%d) of %s \n",
multisour[sourceID].name,multisour[sourceID].sour_id,
multisour[i].sour_id,multisour[i].name);
fprintf(stderr,
"but their coordinates are the same:\n RA=%13s",
(char *)rar2c(multisour[sourceID].ra));
fprintf(stderr,"  Dec=%14s\n", (char *)decr2c(multisour[sourceID].dec));
        if(inhset< (nsets[0]-1)) { inhset++; smabuffer.skipsrc=1;} }
                                   }
        if(smabuffer.skipsrc==1)  {
        while (inh[inhset]->souid!=multisour[sourceID].sour_id) 
        inhset++;
//sprintf(logstr, "Warning: found the next integration for %s of id=%d at inhset=%d ",
//multisour[sourceID].name, inh[inhset]->souid, inhset);
//fputs(logstr, logout);

        multisour[sourceID].ra  = inh[inhset]->rar;
        multisour[sourceID].dec = inh[inhset]->decr;
//sprintf(logstr,
//"with coordinates:\n RA=%13s",
//(char *)rar2c(multisour[sourceID].ra));
//fputs(logstr, logout);

//sprintf(logstr,"  Dec=%14s\n",
//(char *)decr2c(multisour[sourceID].dec));
//fputs(logstr, logout);

//sprintf(logstr, "Update the coordinates for %s of id=%d\n",
//multisour[sourceID].name, inh[inhset]->souid);
//fputs(logstr, logout);
//
// repeat the warning message on the screen
//
fprintf(stderr, "Warning: found the next integration for %s of id=%d at inhset=%d ",
multisour[sourceID].name, inh[inhset]->souid, inhset);
fprintf(stderr,
"with coordinates:\n RA=%13s",
(char *)rar2c(multisour[sourceID].ra));
fprintf(stderr," Dec=%14s\n",
(char *)decr2c(multisour[sourceID].dec));
fprintf(stderr, "Update the coordinates for %s of id=%d\n\n",
multisour[sourceID].name, inh[inhset]->souid);
                                   }   
               }
//      printf("EQUINOX(jday)=%f\n", jday);
        if(jday<2455733.5) {
	sprintf(multisour[sourceID].equinox, "%f", inh[inhset]->epoch);
          } else {
        if(inh[inhset]->epoch == 2000.0)
        strncpy(multisour[sourceID].equinox, "2000.0\0", 6);
        if(inh[inhset]->epoch != 2000.0)
        fprintf(stderr, "Warning: not J2000.0 Equinox!?\n");
        } 
//      printf("done with  EQUINOX!\n");
	multisour[sourceID].freqid =-1;
	multisour[sourceID].inhid_1st=inh[inhset]->inhid;
// calculate the apparent position coordinates from j2000 coordinates 
	{ 
	  double obsra,obsdec,r1,d1;
	  double julian2000=2451544.5;
	  precess(julian2000,
		  multisour[sourceID].ra,
		  multisour[sourceID].dec, jday, &obsra, &obsdec);
	  nutate(jday,obsra,obsdec,&r1,&d1);
	  aberrate(jday,r1,d1,&obsra,&obsdec);
	  multisour[sourceID].ra_app   = obsra;
	  multisour[sourceID].dec_app  = obsdec;
	  multisour[sourceID].qual     = 0;
	  multisour[sourceID].pmra     = 0.;
	  multisour[sourceID].pmdec    = 0.;
	  multisour[sourceID].parallax = 0.;
	  strncpy(multisour[sourceID].veldef, "radio", 5);
	  strncpy(multisour[sourceID].calcode, "c", 1);
	   }
      }
    }
             if(sourceID> MAXSOURCE) {
 fprintf(stderr,"ERROR: Number of sources exceeded the limit %d\n", MAXSOURCE);
             exit(-1);
                                     }
// setup correlator  
// sph1 is a single set of spectra, assign memory to it.    
   sph1 = (struct sph_def *) malloc(sizeof( struct sph_def ));
// spn is a buffer for configuring spectra with an array length
// of the total number of integration sets.
   spn  = (struct sph_config **) malloc(nsets[0]*sizeof( struct sph_config *));
    for (set=0; set<nsets[0]; set++) {
   spn[set] = (struct sph_config *)malloc(sizeof(struct sph_config ));
      if (spn[set] == NULL ){
 fprintf(stderr,"ERROR: Memory allocation for sph_config failed for %d bytes\n",
(int) (	nsets[0]*sizeof(struct sph_config)));
	exit(-1);
      }
    }
//
// determine if perform high resolution mode:
// data obtained earlier than 2006-may-12 is to be done
// with a low resolution mode;
// data obtained later than  2006-may-12 is handled in the high
// resolution mode unless this mode turned off by options=nohspr
//
    if(smabuffer.highrspectra==0&&jday>2453867) {
      smabuffer.highrspectra = 1;
           } else { smabuffer.highrspectra =-1; }

    
    { 
      int inhid_hdr;
      int blhid_hdr;
      int sphid_hdr;
      int blset;
      int inset;
      int nspectra;
      int end_iband=0;
      nspectra=0;
      blset     =  0;
      sphid_hdr =  0;
      blhid_hdr = -10;
      inhid_hdr = -10;
      firstsp   = -1;
      lastsp    = -1;
      numberSpectra = 0;
//
// initialize spn->nch
//
         for (set=0; set<nsets[0]; set++) {
         for (i=0; i< 49; i++) {
         spn[set]->nch[i][0] =0;
         spn[set]->nch[i][1] =0;
                               }
                                          }
// define baseline id used in pursing the spectral
// configuration. 
// integration set = smabuffer.scanskip
// blhset=1, the second baseline of the integration
      blhset=1;
      blhid = uvwbsln[smabuffer.scanskip]->uvwID[blhset].blhid;
// spn starts from 0; rewind the file to the begining,
// counting the number of spectra from the second baseline
      rewind(fpin[2]);
      inset = smabuffer.scanskip;
      for (set=0; set<nsets[2]; set++) {
         *sph1 = (sph_read(fpin[2]));
      if (SWAP_ENDIAN) {
         sph1 =  swap_sph(sph1);
                        }
      if(sph1->blhid==uvwbsln[smabuffer.scanskip]->uvwID[blhset].blhid) 
         {numberSpectra++;
          end_iband=sph1->iband;
          }
      if(sph1->blhid>uvwbsln[smabuffer.scanskip]->uvwID[blhset].blhid){
      if(numberSpectra>0) 
                 {
           goto foundsphid_hdr;}
            else {
           //numberSpectra=25;
           smabuffer.scanskip++;
           inset = smabuffer.scanskip;
                               }}
                             }  
foundsphid_hdr:
      fprintf(stderr,"Actual numberSpectra=%d end_iband=%d\n", numberSpectra,end_iband);
        if(numberSpectra >25) bug_c ('f', "numberSpectra >25 ....");
// rewind sph file 
       rewind(fpin[2]);
// start from sphid_hdr=0 
      for (set=sphid_hdr;set<nsets[2]; set++) {
	*sph1 = (sph_read(fpin[2]));
	if (SWAP_ENDIAN) {
	  sph1 =  swap_sph(sph1);
                  	}
// load baseline-based tsys values to the tsys structure
if(sph1->blhid==tsys[0]->blhid) nspectra++;
if(sph1->blhid==tsys[blset]->blhid&&sph1->inhid==tsys[blset]->inhid) {
 tsys[blset]->tssb[sph1->iband] = sph1->tssb;
// loading online flagging information
if(tsys[blset]->ipol < -4&&sph1->iband!=0) {
     if(fabs(sph1->wt) > 0)     {
     wts[inset]->wt[sph1->iband-1][-4-tsys[blset]->ipol][tsys[blset]->blsid][tsys[blset]->isb][tsys[blset]->irec] = (short) (sph1->wt/fabs(sph1->wt)); 
                      }else{
        wts[inset]->wt[sph1->iband-1][-4-tsys[blset]->ipol][tsys[blset]->blsid][tsys[blset]->isb][tsys[blset]->irec] = -1;
                         }
         }else {
         if(sph1->iband!=0) {
        if(fabs(sph1->wt) > 0) {
 wts[inset]->wt[sph1->iband-1][-tsys[blset]->ipol][tsys[blset]->blsid][tsys[blset]->isb][tsys[blset]->irec] = (short) (sph1->wt/fabs(sph1->wt));
                               }else{
        wts[inset]->wt[sph1->iband-1][-tsys[blset]->ipol][tsys[blset]->blsid][tsys[blset]->isb][tsys[blset]->irec] = -1;
                       }
                  }
    }  
// end of tsys and wt loading
//
// increment of the baseline cursor based on spectral modes
// 
	if(smabuffer.highrspectra!=1){  
        if(sph1->iband==nspectra-1) blset++;
                                      } else {
        if(sph1->iband==end_iband) blset++;
                                             }
	                                                                      }
// purse the spectral configuration
// check up inhid making sure to work on the same set of integration 
// increment of the integration cursor
//
   if(sph1->inhid>inh[inset]->inhid) inset++ ;
//
// check up inhid and blhid assuring to work on the same integration set
// and the baseline set with the sidebband and rx as
// is desired.
//	
   if(sph1->inhid==inh[inset]->inhid&&sph1->blhid==bln[inset]->blhid){
	  spn[inset]->sphid                = sph1->sphid;
	  spn[inset]->inhid                = sph1->inhid;
	  spn[inset]->iband[sph1->iband]   = sph1->iband;
//	  
// velocity with respect to the rest frame
// given by the SMA on-line system. This is 
// only meaningful to the line transition at the
// rest frequency
// 
	  spn[inset]->vel[sph1->iband]     = sph1->vel;
	  spn[inset]->vres[sph1->iband]    = sph1->vres;
	  spn[inset]->ivtype               = sph1->ivtype;
//
// sky frequency (which has been corrected for a part of the Doppler
// velocity, the diurnal term and a part of the annual term) 
//	 
          spn[inset]->fsky[sph1->iband]    = sph1->fsky;
	  spn[inset]->fres[sph1->iband]    = sph1->fres;
//
// single rx case, assign the channel number for each spectral chunk
//
      if(smaCorr.no_rxif!=2) spn[inset]->nch[sph1->iband][0] = sph1->nch;

	  spn[inset]->dataoff              = sph1->dataoff;
	  spn[inset]->rfreq[sph1->iband]   = sph1->rfreq;
	  spn[inset]->isb                  = bln[inset]->isb;
	  spn[inset]->irec                 = bln[inset]->irec;
	  spn[inset]->souid                = inh[inset]->souid;
//
// assign the base frequency
//
      if(sph1->iband==0) spn[inset]->basefreq = sph1->fsky;
            }
//
// assign the channel number in the case of 2 rx involved.
//                
// assuring to work on the same integration
      if(smaCorr.no_rxif==2&&sph1->inhid==inh[inset]->inhid) {
//
// locate the baseline id where the rx2 starts
      if(sph1->blhid==(blid_intchng[inset]))
        spn[inset]->nch[sph1->iband][1] = sph1->nch;    
//
// locate the baseline id where the rx1 starts        
      if(sph1->blhid==(blid_intchng[inset]-1))
        spn[inset]->nch[sph1->iband][0] = sph1->nch; 
                                                             }
//  sprintf(logstr,"inset=%d nchan=%d chunk=%d inhid=%d rx=%d sph1->blhid=%d blid_intchng[inset]=%d \n",inset, spn[inset]->nch[sph1->iband][0],
//              sph1->iband, inset, rxlod,sph1->blhid,blid_intchng[inset]);
//           fputs(logstr, logout);
          lastinset=inset;
	if(inset==smabuffer.scanskip+smabuffer.scanproc) { 
	  goto sphend; 
	                                                  }
                                                              }
                            }
sphend:
     if (smabuffer.scanskip+smabuffer.scanproc>nsets[0]) {
fprintf(stderr,"Hits the end of integration %d\n", nsets[0]);
fprintf(stderr,"Reset 'nscans=%d, ' and run it again.\n",smabuffer.scanskip);
         exit(-1);
                  }
// handling 2003 incompleted correlator data
if (smabuffer.spskip[0]==-2003) {
double spfreq[49];
double spfreqo[49];
int nchunk=0;
int minspID=49;
         for (i=1;i<SMIF2GHz+1;i++) {
         if (spn[smabuffer.scanskip]->fsky[i]>0.0) {
         nchunk++;
         spfreq[nchunk]=spn[smabuffer.scanskip]->fsky[i];
                            }
                }
         for (i=1;i<SMIF2GHz+1;i++) {
         if(spfreq[i]<100.0) {
         spfreq[i]=0.0;
         spcode[i]=0;        }
         spfreqo[i] =  spfreq[i];
         if (spcode[i]!=0&&spcode[i]<minspID) minspID=spcode[i];
                           }
         for (i=1;i<SMIF2GHz+1;i++) {
          spcode[i]=spcode[i]-minspID+1;
                           }
goto dat2003; }
                
              lastinset=lastinset-1;
              reset_id[0]= smabuffer.scanskip;
              for (iinset=smabuffer.scanskip;
                   iinset < lastinset;
                   iinset++) {
              for (i=0;i<SMIF2GHz+1;i++) {
              if (spn[iinset]->nch[i][0]
               !=spn[iinset+1]->nch[i][0]) {
      if(nomsg>1)  printf("Warning: The correlator was reconfigured at integrations=%d\n",
                   iinset+1);
                          ireset++;
                    reset_id[ireset] = iinset+1;
      if(nomsg>1)   printf("From    -> To\n");
                    for (i=1;i<SMIF2GHz+1;i++) {
      if(nomsg>1)   printf("s%2d:%3d -> :%3d\n", i, spn[iinset]->nch[i][0],
                 spn[iinset+1]->nch[i][0]);
                                       }
                                           }
                                 }
                              }

//           if(smabuffer.mcconfig==0) {
//           for (i=1;i<ireset+1;i++) {
//           if(smabuffer.scanskip< reset_id[i]) {
//    fprintf(stderr,"Suggesttion:\n");
//    fprintf(stderr,"For a single correlator configuration per loading (recommended),\n");
//    fprintf(stderr,"reset nscans=%d,%d for the set of the first configuration data;\n", smabuffer.scanskip, reset_id[i]-1);
//    fprintf(stderr,"reset nscans=%d, for the set of the second configuration data.\n",  reset_id[i]);
//    fprintf(stderr,"Or choose options=mcconfig for multiple correlator configurations per loading (not recommended).\n");
//    fprintf(stderr,"Try it again.\n");
//         exit(-1);
//        }
//                                    }
//                                     }
dat2003:                                                                           
    fprintf(stderr,"\n");
    fprintf(stderr,"number of non-empty Spectra = %d\n", numberSpectra);
// reset number of spectra
    if(smabuffer.highrspectra==1) numberSpectra=25;
    if (SWAP_ENDIAN) {
    fprintf(stderr,"FINISHED READING SP HEADERS (endian-swapped)\n");
    } else {
    fprintf(stderr,"FINISHED READING SP HEADERS\n");
    }
// solve for tsys
    {
      int refant;
      int done;
      int pair1;
      int pair2;
      int blset;
// solve for tsys of a reference ante
      set=0;
      refant=0;
      pair1=0;
      pair2=0;
      blset=1;
      for(blset=0; blset<nsets[1]; blset++) {
	if(set==nsets[0]-1) goto next;
	if(tsys[blset]->inhid!=inh[set]->inhid) {set++; refant=0;}
// choose rx
	if(tsys[blset]->irec==smabuffer.rxif||smabuffer.rxif==-1) {
	  if(tsys[blset]->inhid==inh[set]->inhid&&tsys[blset]->isb==0) {
	    if(refant==0) {
	      refant=100;
	      atsys[set]->refant = tsys[blset]->itel1;
	      atsys[set]->tssb[atsys[set]->refant]=tsys[blset]->tssb[0];
	      atsys[set]->refpair1  = tsys[blset]->itel2;
	    }
	  }
	}
      }
    next:
      done=0;
      set=0;
      for(blset=0; blset<nsets[1]; blset++) {
	if(set==nsets[0]-1) goto nextnext;
	if(tsys[blset]->inhid!=inh[set]->inhid) {set++;done=0;}
	if(tsys[blset]->irec==smabuffer.rxif||smabuffer.rxif==-1) {
	  if(tsys[blset]->inhid==inh[set]->inhid&&tsys[blset]->isb==0) {
	    if(done==0) {
	      if(tsys[blset]->itel1==atsys[set]->refant&&atsys[set]->refpair1!=tsys[blset]->itel2) {
		atsys[set]->refpair2=tsys[blset]->itel2;
		atsys[set]->tssb[atsys[set]->refant] *=
		  tsys[blset]->tssb[0];
		done=100;
	      }
	    }
	  }
	}
      }
    nextnext:
      set=0;
      for(blset=0; blset<nsets[1]; blset++) {
	if(set==nsets[0]-1) goto nextnextnext;
	if(tsys[blset]->inhid!=inh[set]->inhid) {set++; refant=0;}
	if(tsys[blset]->irec==smabuffer.rxif||smabuffer.rxif==-1) {
	  if(tsys[blset]->inhid==inh[set]->inhid&&tsys[blset]->isb==0) {
	    if((tsys[blset]->itel1==atsys[set]->refpair2&&tsys[blset]->itel2==atsys[set]->refpair1)||
	       (tsys[blset]->itel2==atsys[set]->refpair2&&tsys[blset]->itel1==atsys[set]->refpair1)) {
	      atsys[set]->tssb[atsys[set]->refant] =
		atsys[set]->tssb[atsys[set]->refant]/tsys[blset]->tssb[0];
	    }
	  }
	}
      }
    nextnextnext:
      set=0;
      for(blset=0; blset<nsets[1]; blset++) {
	if(set==nsets[0]-1) goto nnextnextnext;
	if(tsys[blset]->inhid!=inh[set]->inhid) {set++;}
	if(tsys[blset]->irec==smabuffer.rxif||smabuffer.rxif==-1) {
	  if(tsys[blset]->inhid==inh[set]->inhid&&tsys[blset]->isb==0) {
	    if(tsys[blset]->itel1==atsys[set]->refant) {
	      atsys[set]->tssb[tsys[blset]->itel2] =
		tsys[blset]->tssb[0]*tsys[blset]->tssb[0]
		/ atsys[set]->tssb[atsys[set]->refant];
	    }
	    if(tsys[blset]->itel2==atsys[set]->refant) {
	      atsys[set]->tssb[tsys[blset]->itel1] =
		tsys[blset]->tssb[0]*tsys[blset]->tssb[0]
		/atsys[set]->tssb[atsys[set]->refant];
	    }
	  }
	}
      }
    nnextnextnext:
    fprintf(stderr,"Decoded baseline-based Tsys\n");
    }
// decode the doppler velocity

 if (jday <2453531.5 && smabuffer.circular == 1) {
      printf("Skip decoding the Doppler velocity\n");
     } else {
      double vabsolute;
      double fratio;
//  assure the reference channel for doppler velocity calculation
//  does not correspond to the empty chunk.
      for(set= smabuffer.scanskip; 
	  set < smabuffer.scanskip+smabuffer.scanproc+1; set++){
        if(spn[set]->nch[dopvelRefChunk][rxlod]==0) {
          for (i=1;i<SMIF2GHz;i++) {
             if(spn[set]->nch[i][rxlod]!=0) dopvelRefChunk = i;
                    }
                        }  
// calculate doppler velocity from chunk 1; 
// the rest chunk give the same value.
// absolute velocity is based on form (2-229)
// Astrophysical Formulae by K. R. Lang (Springer-Verlag 1974)
// p194 
	fratio = (spn[set]->fsky[dopvelRefChunk]/spn[set]->rfreq[dopvelRefChunk]);
	vabsolute = (1. - fratio*fratio ) / (1. + fratio*fratio );
	vabsolute = vabsolute*DCMKS/1000.;
// Derive the Doppler velocity from observer to the LSR
// by taking out the Radial velocity (at chunk 1) of the source 
// w.r.t. the LSR or HEL.
// Based on the information from Taco after the discussion with
// Dan Marrone and Jim Moran on 05aug26's meeting,
// There are two operation modes that we have supported:
// 1) non-planet source and 2) planet source;
// For mode 1) the chunk frequency recorded in the MIR data header
// is the sky frequency at the transit of the source being Doppler
// tracked, i.e., the recorded frequency is the true sky frequency 
// only corrected for the diurnal term due to the earth rotation.
// Then, Jun-Hui started to build a patch in UVREDO for handling
// this SMA specification and he found that additional amount
// correction for the part of annual term that has been made to 
// the sky frequency by the SMA online system. Then he tried to
// decode the reference time corresponding to a zero value that 
// the online system uses to take out the steady variation in 
// the sky frequnecy due to the annual term. Jun-Hui further consulted 
// with Taco on 05Aug31. Taco commented that it should be the 
// time at the source transit but he could be
// wrong. Based on the observation on 2005Aug01 for the SgrB2 track,
// Jun-Hui tried to figure out the reference time using veldop calculated
// from UVREDO and the SMA veldop decoded from the MIR header.
// Apparently, using the reference time at the source transit,
// it gives large difference between result from Miriad and
// the value of the veldop decoded from the SMA data. There are other
// possible times for the reference: 1) the time at which 
// the DopplerTrack command issued by the operator 
// (Mon Aug  1 04:06:14 2005 (brownd)
// for the SgrB2 observation; 2) the time at which the project command
// is issued by the operator. (in the SgrB2 observations, the project
// command was issued towice at Mon Aug  1 04:50:35 2005 (brownd)
// and at Mon Aug  1 05:35:48 2005 (brownd). Among the three possible time,
// the time 05:35:48 appears to be the closest to the reference time
// (which gives precision in velocity of 0.0015 km/s). Therefore 
// two approaches are used to implement the patch in uvredo to calculate
// the residual Doppler velocity: 
// a) Giving the reference time from which the offset in the annual 
// term that has been corrected to the chunk frequency;
// b) Using veldop decoded from the MIR header (the sky frequency/the 
// radial velocity at a channel and the corresponding rest frequency). 
// The value of decoded veldop is to be stored
// in the variable 'veldop' but it is not the Tracked Doppler velocity;
// In other document (users guide), it is called as residual Doppler
// velocity.
//  
// For mode 2) the chunk frequency recorded in the MIR data header
// is the sky frequency corrected for the radial velocity of the planet
// at the moment when the dopplerTrack command is issued.
//   
        spn[set]->veldop = vabsolute - spn[set]->vel[dopvelRefChunk];
//
// add back the radial velocity of the source
//
        spn[set]->veldop = spn[set]->veldop + smabuffer.vsource;
        spn[set]->smaveldop = vabsolute - spn[set]->vel[dopvelRefChunk]+ 
                 smabuffer.vsource;
      }
    fprintf(stderr,"Decoded the Doppler velocity\n");
    }                   
// rewind the data file
    rewind(fpin[5]);
// start from the inhset = smabuffer.scanskip 
    inhset = smabuffer.scanskip;
    numberBaselines=  uvwbsln[inhset]->n_bls,
   fprintf(stderr,"here we are!\n");
//
// parsing to handle spectral chunk data assuming
// 24 spectral chunks handled online regardless
// some of the chunks may be skipped;
// or only partial (< 24) chunks handled online
// (early days' data for exmaple).
//
   if(smabuffer.highrspectra==1) {
   smaCorr.n_chunk = SMIF2GHz;
    } else { 
// take out 1 for eliminating the continuum channel
   smaCorr.n_chunk = numberSpectra -1;
    }
// end of spectral configuration loading.
    
// initialize system velocity
    for (j=1; j<sourceID+1; j++) {
      for (i=1; i<smaCorr.n_chunk+1; i++) {
	multisour[j].sysvel[i] = 0.0;
      }           
    }
// print out sources observed
    max_sourid=0;
    for (i=1; i< sourceID+1; i++) {
      if(multisour[i].sour_id==0) 
        strncpy(multisour[i].name, "skipped!", 8);
      fprintf(stderr,"source: %-21s id=%2d RA=%13s ", 
	     multisour[i].name,
	     multisour[i].sour_id, 
	     (char *)rar2c(multisour[i].ra));
      fprintf(stderr,"DEC=%12s\n", (char *)decr2c(multisour[i].dec));
    if(multisour[i].sour_id>max_sourid) max_sourid=multisour[i].sour_id;
    }


    
// now loading the smabuffer, parameters for headers
// initialize Tsys
    for (i=1; i<smabuffer.nants+1; i++){
      smabuffer.tsys[i-1]=0;
    } 
    
// initialize the polcode
    for(j=1;j<smaCorr.n_chunk+1;j++) {
           smabuffer.nstoke[j-1]=4;
      for(i=1; i<smabuffer.nstoke[j-1]; i++) {
	for (k=1; k<SMBAS+1; k++) {
	  smabuffer.polcode[j-1][i-1][k-1] = -5;
	}
      }
    }
// initialize the tsys for the polarization components
    for(j=1;j<smabuffer.nants+1;j++) {
      for(i=1;i<smaCorr.n_chunk+1;i++) {
	smabuffer.xtsys[i-1][j-1]=0.;
	smabuffer.ytsys[i-1][j-1]=0.;
	smabuffer.xyphase[i-1][j-1]=0.;
	smabuffer.xyamp[i-1][j-1]=1.;
      }
    }
    
// initialize the sampler for the polarization components

    for(k=0; k<3; k++) {
      for(j=1;j<smabuffer.nants+1;j++) {
	for(i=1;i<smaCorr.n_chunk+1;i++) {
	  smabuffer.xsampler[i-1][j-1][k]=0.;
	  smabuffer.ysampler[i-1][j-1][k]=0.;
	}
      }
    }
// assign actual number of spectral chunks to smabuffer  
     smabuffer.nifs = numberSpectra-1;
// initialize pnt flags 
    for (i=1; i<SMIF2GHz+1; i++)  {
      for (j=1; j<SMPOL+1; j++) {
	for (k=1; k<SMBAS+1; k++) {
	  for (l=1; l<3; l++) { 
	    for (m=1; m<SMRX+1; m++) {
              smabuffer.flag[i-1][j-1][k-1][l-1][m-1]=-1;
	       smabuffer.pnt[i-1][j-1][k-1][l-1][m-1]= 0;
	    }
	  }
	}
      }
    }
// reverse the spectral chunk order for blocks 1 2 3 4 
    if(smabuffer.doChunkOrder==1) {
      frcode[1]=4;
      frcode[2]=3;
      frcode[3]=2;
      frcode[4]=1;
      
      frcode[5]=8;
      frcode[6]=7;
      frcode[7]=6;
      frcode[8]=5;
      
      frcode[9]=12;
      frcode[10]=11;
      frcode[11]=10;
      frcode[12]=9;
      
      frcode[13]=13;
      frcode[14]=14;
      frcode[15]=15;
      frcode[16]=16;
      
      frcode[17]=17;
      frcode[18]=18;
      frcode[19]=19;
      frcode[20]=20;
      
      frcode[21]=21;
      frcode[22]=22;
      frcode[23]=23;
      frcode[24]=24;
    }
    
// print the side band to be processed
    switch(smabuffer.sb) {
    case 0:
      fprintf(stderr,"LSB only\n");
      break;
    case 1:
      fprintf(stderr,"USB only\n");
    }

// initializing the number vis points to be read    
    smabuffer.nused=0;
    free(cdh);
    free(sph);
    rewind(fpin[3]);
    rewind(fpin[2]);
    rewind(fpin[5]);
    sch = (struct sch_def **) malloc(nsets[0]*sizeof( struct sch_def *));
    for (set=0; set<nsets[0];set++) {
      sch[set] = (struct sch_def *)malloc(sizeof(struct sch_def ));
      if (sch[set] == NULL ){
     fprintf(stderr,"ERROR: Memory allocation for sch failed for %d bytes\n",
(int) (nsets[0]*sizeof(struct sch_def)));
	exit(-1);
      }
    }
// Need an array to hold the starting byte for each integration of data 
// allocate the memory for data_start_pos
    data_start_pos = (long int*)malloc(nsets[0]*sizeof(long int));
    inhset=smabuffer.scanskip;
    inhset=0;

    for (set=inhset;
      set<smabuffer.scanskip+smabuffer.scanproc; set++) {
      data_start_pos[set] = ftell(fpin[5]);
      *sch[set] = *(sch_head_read(fpin[5]));
      if (SWAP_ENDIAN) {
	sch[set]=swap_sch(sch[set]);
      }
      i = fseek(fpin[5],(long int)sch[set]->nbyt,SEEK_CUR);
    }
// rewind vis data file
    rewind(fpin[5]);  
// initilize the handles for baseline, spectral, integration 
    blhset  = -1;
    sphset  =  0;
    readSet =  1;
    numberBaselines = uvwbsln[smabuffer.scanskip]->n_bls;
// print the information on # of baselines,
//                          # of spectral windows,
//                          # of sidebands,
//                          # of receivers to be processed 
 fprintf(stderr,"#Baselines=%d #Spectra=%d  #Sidebands=%d #Receivers=%d\n",
   numberBaselines/2, numberSpectra, numberSidebands, 
   numberRxif);
    if(smabuffer.dobary==1) fprintf(stderr,"Compute radial velocity wrt barycenter\n");
    if(smabuffer.dolsr==1) fprintf(stderr,"Compute radial velocity wrt LSR\n");
    sphSizeBuffer = numberSpectra*numberBaselines; 
//sphSizeBuffer: a number of total spectral sets for usb and lsb together 
//               in each of the integration sets
    firstsp = sphset;
    firstbsl= blhset;
// initialize the vis point handle
    ipnt=1;
// assign the start integration set to be processed
  if(smabuffer.scanskip!=0) inhset=smabuffer.scanskip-1;
  if(smabuffer.scanproc!=0&&(nsets[0]>(smabuffer.scanskip+smabuffer.scanproc)))
     nsets[0]=smabuffer.scanskip+smabuffer.scanproc;
// start the processing loop
    while(inhset<(nsets[0]-1)) {
// progressing the integration set
  SkipOneIntegration:      
      inhset++;
      visSMAscan.blockID.ints = inh[inhset]->ints;
      visSMAscan.blockID.inhid = inh[inhset]->inhid;
      
      visSMAscan.blockID.sourID = inh[inhset]->souid;
      visSMAscan.blockID.freqID = smaFreq[0].freqid;
      visSMAscan.time.UTCtime = jday+inh[inhset]->dhrs/24.000; /*hrs*/
      utch = inh[inhset]->dhrs;
      if(utch>24 || utch==24) {
          utcd =1;
            } else {
          utcd =0;
            }
      utcm = (inh[inhset]->dhrs-utch)*60;
      utcs = ((inh[inhset]->dhrs-utch)*60.0 - utcm)*60;
// loading smabuffer 
      smabuffer.currentscan=inhset-smabuffer.scanskip;
      smabuffer.time = visSMAscan.time.UTCtime;
// handle source information 
      sourceID = visSMAscan.blockID.sourID;
      smabuffer.obsra = multisour[sourceID].ra_app;
      smabuffer.obsdec = multisour[sourceID].dec_app;
      smabuffer.ra = multisour[sourceID].ra;
      smabuffer.dec = multisour[sourceID].dec;
      {
// calculate lst
//  printf("chk:calculate lst\n");
    if (smabuffer.doeng!=1) {
	smabuffer.lst =(double) inh[inhset]->ha*DPI/12.0 + smabuffer.obsra;
      } else {
	smabuffer.lst = smaEngdata[inhset]->lst*DPI/12.0;
      }
//loading el az and tsys to smabuffer
      for (i=0; i<smabuffer.nants; i++) {
//mir inh file gives the mean el and mean az
	smabuffer.el[i] = inh[inhset]->el;
	smabuffer.az[i] = inh[inhset]->az;
	if (smabuffer.doeng!=1) {
	  smabuffer.tsys[i]=atsys[inhset]->tssb[i+1];
	} else {
	  smabuffer.tsys[i] = smaEngdata[inhset]->tsys[i+1];
	}
        }
        }
        
// write source to uvfile 
        if(strncmp(multisour[sourceID].name,skipped,8)!=0)
        if(((strncmp(multisour[sourceID].name,target,6)!=0)&&
        (strncmp(multisour[sourceID].name,unknown,7)!=0))||
          smabuffer.noskip==1) {
// jhz source
	char sour[17];
	strncpy(sour, multisour[sourceID].name, 17);
// uvputvra_c(tno,"source",multisour[sourceID].name);
        uvputvra_c(tno,"source", sour);
	uvputvrd_c(tno,"ra",&(smabuffer.ra),1);
	uvputvrd_c(tno,"dec",&(smabuffer.dec),1);
// store the true pointing position 
	rar = inh[inhset]->rar;
	  uvputvrd_c(tno,"pntra", &rar, 1);
	decr = inh[inhset]->decr;
        uvputvrd_c(tno,"pntdec",&decr,1);
	uvputvrd_c(tno,"obsra",&(smabuffer.obsra),1);
	uvputvrd_c(tno,"obsdec",&(smabuffer.obsdec),1);
	uvputvra_c(tno,"calcode",multisour[sourceID].calcode);
	uvputvri_c(tno,"sourid", &sourceID, 1);
      }
// configure the frequency for each of the integration set
      smabuffer.newfreq =1;
      smabuffer.veldop = (float) spn[inhset]->veldop;
      smabuffer.smaveldop = (float) spn[inhset]->smaveldop;
// printf("chk:calculate radial velocity\n");
// calculate radial velocity to replace the on-line value
      { 
	short dolsr;
	double time   = smabuffer.time;
	double raapp  = smabuffer.obsra;
	double decapp = smabuffer.obsdec;
	double raepo  = smabuffer.ra;
	double decepo = smabuffer.dec;
	double lst    = smabuffer.lst;
	double lat    = smabuffer.lat;
//
// recalculate the radial velocity
//
	if(smabuffer.dolsr==1) {
  dolsr   = 1;
smabuffer.veldop=(float)velrad(dolsr,time, raapp,decapp,raepo,decepo,lst,lat);
	}
	if(smabuffer.dobary==1) {
	  dolsr   = -1;
smabuffer.veldop = (float)velrad(dolsr,time, raapp,decapp,raepo,decepo,lst,lat);
	}
        }
//printf("chk:1\n");
//
// get vsource which is source radial velocity w.r.t the LSR
// it is difficult to decode vsource from the MIR data
// unless given enough information in the Doppler tracking
// (sideband, chunk, and channel) from the users.  
// smabuffer.vsource = spn[inhset]->vel[12];
// checkup skipped sp chunks
//
    for(i=1;i<SMIF2GHz+1;i++) {
        miriadsp[i]=0;
                      }
        i0=0;
        for(i=1;i<SMIF2GHz+1;i++) {
        if (spn[inhset]->nch[i][rxlod]!=0) {
// miriadsp: an integer array; if the chunk i
// is empty, miriadsp[i]=0, otherwise miriadsp[i]=i. 
        miriadsp[i]= i;
          } }
// printf("chk:2\n");
// 07-11-27 add a patch to fix the frequency labelling problem in the SMA
// data before 07-11-26 (JDay 2454430.500000)
// Mark has worked out a sequence of MIR commands which will
// correct the labelling problem in old data sets:
// select,/p,/re,band=['s01','s02','s05','s06','s09',
//         's10','s13','s14','s17','s18','s21','s22']
// sp[psf].fsky = sp[psf].fsky + 5.e-4*sp[psf].fres
// sp[psf].vel = sp[psf].vel + 5.e-1*sp[psf].vres
// select,/p,/re,band=['s03','s04','s07','s08','s11',
//         's12','s15','s16','s19','s20','s23','s24']
// sp[psf].fsky = sp[psf].fsky - 5.e-4*sp[psf].fres
// sp[psf].vel = sp[psf].vel - 5.e-1*sp[psf].vres
           if (jday < 2454430.500000 ) {
              sfoff[1] =  0.5e-3*spn[inhset]->fres[1];
              sfoff[2] =  0.5e-3*spn[inhset]->fres[2];
              sfoff[5] =  0.5e-3*spn[inhset]->fres[5];
              sfoff[6] =  0.5e-3*spn[inhset]->fres[6];
              sfoff[9] =  0.5e-3*spn[inhset]->fres[9];
             sfoff[10] =  0.5e-3*spn[inhset]->fres[10];
             sfoff[13] =  0.5e-3*spn[inhset]->fres[13];
             sfoff[14] =  0.5e-3*spn[inhset]->fres[14];
             sfoff[17] =  0.5e-3*spn[inhset]->fres[17];
             sfoff[18] =  0.5e-3*spn[inhset]->fres[18];
             sfoff[21] =  0.5e-3*spn[inhset]->fres[21];
             sfoff[22] =  0.5e-3*spn[inhset]->fres[22];
              sfoff[3] = -0.5e-3*spn[inhset]->fres[3];
              sfoff[4] = -0.5e-3*spn[inhset]->fres[4];
              sfoff[7] = -0.5e-3*spn[inhset]->fres[7];
              sfoff[8] = -0.5e-3*spn[inhset]->fres[8];
             sfoff[11] = -0.5e-3*spn[inhset]->fres[11];
             sfoff[12] = -0.5e-3*spn[inhset]->fres[12];
             sfoff[15] = -0.5e-3*spn[inhset]->fres[15];
             sfoff[16] = -0.5e-3*spn[inhset]->fres[16];
             sfoff[19] = -0.5e-3*spn[inhset]->fres[19];
             sfoff[20] = -0.5e-3*spn[inhset]->fres[20];
             sfoff[23] = -0.5e-3*spn[inhset]->fres[23];
             sfoff[24] = -0.5e-3*spn[inhset]->fres[24];
               } else {

                for(i=1;i<smaCorr.n_chunk+1; i++) {
                 sfoff[i] = 0.0; 
                      } }

//
// now handle the frequency configuration for
// each of the integration sets
//
// printf("chk:3\n");
//         printf("chk:smabuffer.rsnchan=%d\n", smabuffer.rsnchan);

      numberChannels=0;
// printf("smaCorr.n_chunk=%d\n", smaCorr.n_chunk);

      for(i=1;i<smaCorr.n_chunk+1; i++) {
// the reference channel is the first channel in each chunk in miriad
// the reference channel is the center (nch/2+0.5) in each chunk in MIR
// conversion => nch/2+0.5 - 1 = nch-0.5


         if(smabuffer.spskip[0]!=-1) {
         if(smabuffer.doChunkOrder==1) {
//
// spcode[i]:
// for the last three blocks (4,5,6), the chunk order is normal in each block.
// for the first three blocks (1,2,3), the chunk order is reversed 
// in each block.
// 4 3 2 1, 8 7 6 5, 12 11 10 9, 13 14 15 16, 17 18 19 20, 21 22 23 24 
// reverse chunk order for the frequency only using 
// conversion code frcode defined early:
//
	  smabuffer.sfreq[frcode[i]-1] = spn[inhset]->fsky[i]
      - spn[inhset]->fres[i]/1000.0*
	    (spn[inhset]->nch[i][rxlod]/2-0.5) + sfoff[i];
   	                                } else {
	  smabuffer.sfreq[spcode[i]-1] = spn[inhset]->fsky[i]
      - spn[inhset]->fres[i]/1000.0*
	    (spn[inhset]->nch[i][rxlod]/2-0.5) + sfoff[i];
	                                       }
//
// handle rest frequency
//
// printf("chk:4\n");
	if(smabuffer.dorfreq==1) 
        {
   smabuffer.restfreq[spcode[i]-1] = spn[inhset]->rfreq[i];
//         fprintf(stderr, "A:smabuffer.restfreq[%d]=%f\n", 
//         spcode[i]-1, smabuffer.restfreq[spcode[i]-1]);
         }
//
// parsing the resampling option
//
        fix_rsnchan = smabuffer.rsnchan;
        if(smabuffer.rsnchan<0) {
        smabuffer.sdf[spcode[i]-1]   = spn[inhset]->fres[i]/1000.0;
        smabuffer.nfreq[spcode[i]-1] = spn[inhset]->nch[i][rxlod];
	                        } else {
//
// re-sample the channel
//
// printf("chk:5\n");
        smabuffer.sdf[spcode[i]-1]   = spn[inhset]->fres[i]/1000.0*
  	spn[inhset]->nch[i][rxlod]/smabuffer.rsnchan;
	smabuffer.nfreq[spcode[i]-1] = smabuffer.rsnchan;
                                     	}
	smabuffer.basefreq = spn[inhset]->basefreq;
           } else {
//
// take the frequency configuration from the 1st integration set
// assuming no frequency configuration change during the 
// observing track.
//
// printf("chk:5\n");
          inhset1st=smabuffer.scanskip;
// parsing the option for chunk order reversing
          if(smabuffer.doChunkOrder==1) {
// reversing the chunk order
          smabuffer.sfreq[frcode[i]-1] = spn[inhset1st]->fsky[i]
            - spn[inhset1st]->fres[i]/1000.0*
            (spn[inhset1st]->nch[i][rxlod]/2-0.5) + sfoff[i];
        } else {
          smabuffer.sfreq[spcode[i]-1] = spn[inhset1st]->fsky[i]
            - spn[inhset1st]->fres[i]/1000.0*
          (spn[inhset1st]->nch[i][rxlod]/2-0.5) + sfoff[i];
        }
// processing the rest frequency
// printf("chk:7\n");
        if(smabuffer.dorfreq==1)
        smabuffer.restfreq[spcode[i]-1] = spn[inhset1st]->rfreq[i];
//    fprintf(stderr, "B:smabuffer.restfreq[%d]=%f\n", spcode[i]-1, smabuffer.restfreq[spcode[i]-1]);
// parsing the resampling option
//        printf("chk:smabuffer.rsnchan=%d\n", smabuffer.rsnchan);
        if(smabuffer.rsnchan<0) {
        smabuffer.sdf[spcode[i]-1] = spn[inhset1st]->fres[i]/1000.0;
        smabuffer.nfreq[spcode[i]-1] = spn[inhset1st]->nch[i][rxlod];
        } else {
// re-sample the channel
        smabuffer.sdf[spcode[i]-1] = spn[inhset1st]->fres[i]/1000.0*
        spn[inhset1st]->nch[i][rxlod]/smabuffer.rsnchan;
        smabuffer.nfreq[spcode[i]-1] = smabuffer.rsnchan;
        }
// assign the base frequency
        smabuffer.basefreq = spn[inhset1st]->basefreq;
          }
// printf("chk:8\n");
// assign the rest of the header parameters
	smabuffer.bchan[spcode[i]-1]=1;
	smabuffer.nstoke[spcode[i]-1]=4;
	smabuffer.edge[spcode[i]-1]=0;
	smabuffer.nbin[spcode[i]-1]=1;
        numberChannels = numberChannels + spn[inhset]->nch[i][rxlod];
// printf("nchan=%d chunk=%d inhid=%d rx=%d\n",spn[inhset]->nch[i][rxlod],
//              i, inhset, rxlod);
// printf("numberChannels = %d\n", numberChannels);
//
//sprintf(logstr,"nchan=%d chunk=%d inhid=%d rx=%d\n",spn[inhset]->nch[i][rxlod],
//              i, inhset, rxlod);
//fputs(logstr, logout);

      if(numberChannels>MAXCHAN+1) {
      if(smabuffer.debug) {
fprintf(stderr,"ERROR: Number of channels %d exceeded the limit %d. Try larger nscans[1].\n", numberChannels, MAXCHAN);
fprintf(stderr,"Number of integration skipped %d\n", inhset);
sprintf(logstr,"ERROR: Number of channels %d exceeded the limit %d.\n", numberChannels, MAXCHAN);
fputs(logstr, logout);
sprintf(logstr,"Number of integration skipped %d\n", inhset);
fputs(logstr, logout);
      }
// printf("chk:9\n");
           goto SkipOneIntegration;
           }
      if(spn[inhset]->nch[i][rxlod] < 0) {
      if(smabuffer.debug) {
fprintf(stderr,"ERROR: Corrupted frequency header. Try larger nscans[1]\n");
fprintf(stderr,"Number of integration skipped %d\n", inhset);
sprintf(logstr,"ERROR: Corrupted frequency header: nchan < 0 at chunk=%d inhid=%d rx=%d\n", 
              i, inhset, rxlod);
fputs(logstr, logout);
sprintf(logstr,"Number of integration skipped %d\n", inhset);
fputs(logstr, logout);
                          }
// printf("chk:10\n");
           goto SkipOneIntegration;
           }
// printf("chk:11\n");
// if 2003 data skip the spcode examination
        if(smabuffer.spskip[0]!=-2003)  
// check the spectral window skipping in MIR data
        if(smabuffer.highrspectra!=1) {
// printf("chk:12\n");
        if(smabuffer.spskip[0]!=-1) {
// printf("chk:13\n");
//
// when only one skipping gap occurred
//
   if(spcode[i]!=spn[inhset]->iband[i]) {
fprintf(stderr,"\n");
   if(smabuffer.spskip[0]==0) {
fprintf(stderr,"Spotted skipping in spectral chunks starting at spcode=%d iband=%d\n", spcode[i], spn[inhset]->iband[i]);
fprintf(stderr,"Try smalod with keyword spskip=%d,%d again.\n",
    spn[inhset]->iband[i], spcode[i]-spn[inhset]->iband[i]);
       } else {
fprintf(stderr,"The skipping parameter spskip =%d,%d is inconsistent with\n",
           spcode[i], spn[inhset]->iband[i]);
fprintf(stderr,"the spectral chunks skipped in the MIR data!\n");
        }
   bug_c( 'f', "spcode must match with iband!\n");
      }
      }
      }
//printf("chk:14 i=%d\n", i);
      }
//printf("chk:15\n");
// printf("chk:smabuffer.highrspectra=%d\n",smabuffer.highrspectra);
//
// handling multiple chunk skip gaps
//
// printf("chk:multiple chunk skip\n");
// reconfigure 
   if(smabuffer.highrspectra==1) 
   for(i=1;i<SMIF2GHz+1; i++) {
   if(spn[inhset]->nch[i][rxlod]==0) {
// for those empty chunks, padding frequency
// header parameters with artifical numbers.
   smabuffer.sdf[spcode[i]-1]=0.104*pow(-1,smabuffer.sb+1);       
   smabuffer.sfreq[spcode[i]-1]=
   spn[inhset]->basefreq+0.084*(spcode[i]-11.5)*pow(-1,smabuffer.sb+1);
   smabuffer.restfreq[spcode[i]-1]=spn[inhset]->basefreq;
   smabuffer.nfreq[spcode[i]-1]=1;
                         }
                                    }       
         flush=1;
   for(j=0; j < numberBaselines; j++) {
	{
	  sblpnt=j;
	  blhset++;
	  visSMAscan.uvblnID = uvwbsln[inhset]->uvwID[j].blcode;
          if(visSMAscan.uvblnID < 258) flush=-1;
	  visSMAscan.blockID.sbid = uvwbsln[inhset]->uvwID[j].isb; 
	  visSMAscan.blockID.polid = uvwbsln[inhset]->uvwID[j].ipol;
	  sbpnt = visSMAscan.blockID.sbid;
	  rxpnt = uvwbsln[inhset]->uvwID[j].irec;

   if(smabuffer.rxif==uvwbsln[inhset]->uvwID[j].irec||smabuffer.rxif==-1) 
        {
   switch(sbpnt) {
      case 0: blpnt=uvwbsln[inhset]->uvwID[j].blsid;
	      phaseSign=1;
// if required by users
// if data observed earlier than JD 2453488.5 (2005 4 28)
      if(smabuffer.doConjugate==-1||jday<2453488.5) phaseSign=-1;
      if(smabuffer.sb==0) {
smabuffer.u[blpnt] = uvwbsln[inhset]->uvwID[j].u/smabuffer.basefreq*1000.;
smabuffer.v[blpnt] = uvwbsln[inhset]->uvwID[j].v/smabuffer.basefreq*1000.;
smabuffer.w[blpnt] = uvwbsln[inhset]->uvwID[j].w/smabuffer.basefreq*1000.;
	                   }
      break;
      case 1: blpnt=uvwbsln[inhset]->uvwID[j].blsid;
      phaseSign= 1;
      if(smabuffer.sb==1) {
   smabuffer.u[blpnt] = uvwbsln[inhset]->uvwID[j].u/smabuffer.basefreq*1000.;
   smabuffer.v[blpnt] = uvwbsln[inhset]->uvwID[j].v/smabuffer.basefreq*1000.;
   smabuffer.w[blpnt] = uvwbsln[inhset]->uvwID[j].w/smabuffer.basefreq*1000.;
	                  }
      break;
        	    }
       }
// flush=1;
      if(smabuffer.nopol==1) visSMAscan.blockID.polid=-5;
	  switch(visSMAscan.blockID.polid)  {
	  case  0: polpnt=0; break;
	  case -1: polpnt=1; break;
	  case -2: polpnt=2; break;
	  case -3: polpnt=3; break;
	  case -4: polpnt=4; break;
	  case -5: polpnt=1; break;
	  case -6: polpnt=2; break;
	  case -7: polpnt=3; break;
	  case -8: polpnt=4; break;         }
// skip those vis with pol state=0
      if(polpnt==0) {flush=-1;
      printf("skip vis with illegal polarization.\n");
                    }
// loading smabuffer uvw
  smabuffer.blcode[blpnt] = (float) visSMAscan.uvblnID;
// read sph for a complete spectral records assuming that the correlator
// configuration is not changed during the observation 
  if(readSet<= 1&&j==0) { 
    sph = (struct sph_def **) malloc(sphSizeBuffer*sizeof( struct sph_def *));
    for (set=0; set < sphSizeBuffer; set++) {
    sph[set] = (struct sph_def *)malloc(sizeof(struct sph_def ));
    if (sph[set] == NULL ){
   fprintf(stderr,"ERROR: Memory allocation for sph failed for %d bytes\n",
      (int) (sphSizeBuffer*sizeof(struct sph_def)));
      exit(-1);
	                  }
	                                    }
    for (set=0; set< sphSizeBuffer; set++) {
      *sph[set] = (sph_read(fpin[2]));
      if (SWAP_ENDIAN) {
       sph[set] =  swap_sph(sph[set]);
	               }
	                                   }
// set the dataoff for the first spectrum is 0	    
	    sph[0]->dataoff = 0;
                        }

// for single rx case
            numberChannels = 0;
            for (i=0;i<smaCorr.n_chunk+1;i++) 
            {
            sph[i]->nch = spn[inhset]->nch[i][0];
            numberChannels = numberChannels + sph[i]->nch;
            }
            if(numberChannels>MAXCHAN+1) {
    fprintf(stderr,"ERROR: Number of channels %d exceeded the limit %d.\n", numberChannels, MAXCHAN);
            exit(-1);
                                         }
            numberChannels = 0;
// separate frequency configuration for rx1 and rx2 in dual rx case
          if(smaCorr.no_rxif==2)
          for (i=0;i<smaCorr.n_chunk+1;i++) {
           if(rxpnt==smabuffer.rx1) 
              sph[i]->nch = spn[inhset]->nch[i][0];
           if(rxpnt==smabuffer.rx2)
              sph[i]->nch = spn[inhset]->nch[i][1];
              numberChannels = numberChannels + sph[i]->nch;
                                            }
            if(numberChannels>MAXCHAN+1) {
            fprintf(stderr,"ERROR: Number of channels %d exceeded the limit %d.\n", numberChannels, MAXCHAN);
            exit(-1);

                               }
// The data for this spectrum consists of a 5 short int record header 
// and the data  which is a short for each real and a short for 
// each imag vis 
// for the ch0 
	  datalength = 5 + 2*sph[0]->nch;
// Get some memory to hold the data 
	  shortdata = (short int* )malloc(datalength*sizeof(short int));
// Here is the starting byte for the data for this spectrum 
// The 16 is to skip over the data integration header which precedes 
// all the records. We already read this data integration header 
// with sch_head_read. 
// inhset has the integration id 
	  bytepos = 16 + data_start_pos[inhset] + sph[0]->dataoff; 
	  bytepos = bytepos * (sblpnt+1);
// Move to this position in the file and read the data by
// skipping the first a few integration 
	  if(j<1) fseek(fpin[5],bytepos,SEEK_SET);
	  nbytes = sch_data_read(fpin[5],datalength,shortdata);
//          printf("nbytes=%d shortdata[0]=%d\n",nbytes, shortdata[0]);
	  if (SWAP_ENDIAN) {
	    shortdata=swap_sch_data(shortdata, datalength);
	                   }
// take a look at the record header 
// intTime in sec, integration time
	  visSMAscan.time.intTime = (double) (shortdata[0]/10.);
   if(visSMAscan.time.intTime<0) flush=-1;
//   printf("datalength=%u shortdata[0]=%d intTime=%f bytepos=%u \n", 
//             datalength*sizeof(short int), shortdata[0],
//             visSMAscan.time.intTime, bytepos);
// loading smabuffer intTime 
	  smabuffer.inttime[j]= visSMAscan.time.intTime;
	  smabuffer.inttim = visSMAscan.time.intTime;
// There is a different scale factor for each record (spectrum) 
	  scale = shortdata[4];
// Now the data: There is only one channel for the continuum
// which can recalculated and are not stored in Miriad data
	  visSMAscan.bsline.continuum.real = 
          pow(2.,(double)scale)*shortdata[5];
	  visSMAscan.bsline.continuum.imag = 
	  pow(2.,(double)scale)*(-shortdata[6]*phaseSign);
	  free(shortdata);
	  sphset++;  
// The file is positioned at the record header for the next spectrum. 
// There is no 16 byte integration header between records 
	  ifpnt=0;
//	  for (kk=1;kk<numberSpectra; kk++) {
          for (kk=1;kk<smaCorr.n_chunk+1; kk++) {
// assign sp pointr:
	    ifpnt = spcode[kk]-1;
	   datalength = 5 + 2*sph[kk]->nch;
// 5 short in header of each spectral visibility data 
// 2 shorts for real amd imaginary 
// sph[sphset]->nch number of channel in each spectral set
// Get some memory to hold the data 
// memory size = datalength*sizeof(short)) 
//    if(smabuffer.highrspectra==1&&miriadsp[kk]==0) goto chunkskip;
//    shortdata = (short int* )malloc(datalength*sizeof(short int));
//	    nbytes = sch_data_read(fpin[5],datalength,shortdata);
//	    if (SWAP_ENDIAN) {
//	      shortdata=swap_sch_data(shortdata, datalength);
//	    }
     
// There is a different scale factor for each record (spectrum) 
//	    scale = shortdata[4];
// update polcode and pnt to smabuffer  
//
// swapping pol state (RR<->LL, RL<->LR) before 2005-6-10 or 
//                     -1<->-2,-3<->-4
// julian day 2453531.5
// 
            if (jday <2453531.5 && smabuffer.circular == 1) {
            if(visSMAscan.blockID.polid == -1) 
                 smabuffer.polcode[ifpnt][polpnt][blpnt]=-2;
            if(visSMAscan.blockID.polid == -2)
                 smabuffer.polcode[ifpnt][polpnt][blpnt]=-1;
            if(visSMAscan.blockID.polid == -3)
                 smabuffer.polcode[ifpnt][polpnt][blpnt]=-4;
            if(visSMAscan.blockID.polid == -4)
                 smabuffer.polcode[ifpnt][polpnt][blpnt]=-3;
                                                           } else {
	    smabuffer.polcode[ifpnt][polpnt][blpnt]=visSMAscan.blockID.polid;
                                                                  }
	    smabuffer.pnt[ifpnt][polpnt][blpnt][sbpnt][rxpnt] = ipnt;
        if(wts[inhset]->wt[ifpnt][polpnt][blpnt][sbpnt][rxpnt] < 0)
            smabuffer.flag[ifpnt][polpnt][blpnt][sbpnt][rxpnt] = 0;
            if(smabuffer.highrspectra==1&&miriadsp[kk]==0)
            smabuffer.flag[ifpnt][polpnt][blpnt][sbpnt][rxpnt] = 0;

    if(smabuffer.highrspectra==1&&miriadsp[kk]==0) goto chunkskip;
    shortdata = (short int* )malloc(datalength*sizeof(short int));
          nbytes = sch_data_read(fpin[5],datalength,shortdata);
          if (SWAP_ENDIAN) {
            shortdata=swap_sch_data(shortdata, datalength);
                           }

// There is a different scale factor for each record (spectrum)
          scale = shortdata[4];

// Now the channel data.
// Make pseudo continuum 
	    avenchan = 0;
	    avereal  = 0.;
	    aveimag  = 0.;
//            printf("chk 12: smabuffer.rsnchan %d\n", smabuffer.rsnchan);
	    for(i=0;i<sph[kk]->nch;i++){
              if(smabuffer.rsnchan!=fix_rsnchan) smabuffer.rsnchan=fix_rsnchan; 
//            printf("chk 13:i=%d smabuffer.rsnchan %d\n",i, smabuffer.rsnchan);
	      if (smabuffer.rsnchan > 0) {
              if(sph[kk]->nch < smabuffer.rsnchan) {
 fprintf(stderr, "Error: rsnchan=%d is greater than %d, the number of channels in a chunk,\n",
              smabuffer.rsnchan, sph[kk]->nch);
 fprintf(stderr, "       redo it with a smaller rsnchan.\n");
              exit(-1);
                                                  }
// average the channel to the desired resolution 
  avereal = avereal+(float)pow(2.,(double)scale)*shortdata[5+2*i];
// convert ovro sign convention to miriad
  aveimag = aveimag+(float)pow(2.,(double)scale)*(-shortdata[6+2*i]*phaseSign);
	    avenchan++;
            if(avenchan==(sph[kk]->nch/smabuffer.rsnchan)) {
		  avereal = avereal/avenchan;
		  aveimag = aveimag/avenchan;
		  smabuffer.data[ipnt].real=avereal;
		  smabuffer.data[ipnt].imag=aveimag;
		  ipnt++;
		  avenchan = 0;
                  avereal  = 0.;
                  aveimag  = 0.;
	                                                   }
	                                            } else {
// loading the original vis with no average 
// convert ovro sign convention to miriad
	smabuffer.data[ipnt].real=(float)pow(2.,(double)scale)*shortdata[5+2*i];
	smabuffer.data[ipnt].imag=
		  (float)pow(2.,(double)scale)*(-shortdata[6+2*i]*phaseSign);
		ipnt++;                                    }
//             printf("chk 14:kk=%d i=%d smabuffer.rsnchan %d\n",kk, i, smabuffer.rsnchan);
	                                              }
            free(shortdata);
	    chunkskip:
    if(smabuffer.highrspectra==1&&miriadsp[kk]==0) {
            smabuffer.data[ipnt].real=0.0001;
            smabuffer.data[ipnt].imag=0.;
            ipnt++;  
                                                   }
	    sphset++;  
// count for each spectral chunk 
//            printf("chk 14:sphset=%d kk=%d i=%d smabuffer.rsnchan %d\n",
//                             sphset, kk, i, smabuffer.rsnchan);
	                                        }
      firstsp = sphset;
                                          }
                                              }
      readSet++;
      smabuffer.nused=ipnt;
// re-initialize vis point for next integration 
      ipnt=1;
      if(flush==1) {
      if (fmod((readSet-1), 100.)<0.5||(readSet-1)==1)
 fprintf(stderr,"set=%4d ints=%4d inhid=%4d time(UTC)= %1dd%02d:%02d:%04.1f int= %04.1f percent=%03d \n",
               readSet-1,
               visSMAscan.blockID.ints,
               visSMAscan.blockID.inhid,
               utcd,utch,utcm,utcs,
               visSMAscan.time.intTime,(int)(readSet*100.0/nsets[0]));
// call rspokeflshsma_c to store databuffer to uvfile 
	kstat = -1;
	*kst = (char *)&kstat;
//         printf("chk 15: skipped =%s\n",multisour[sourceID].name);
        strncpy(skipped,"skipped!", 8);
        if(smabuffer.noskip!=1) {
//          printf("chk 16:\n");
        if(strncmp(multisour[sourceID].name,skipped,8)==0)
 printf("Warnning: one scan is skipped at %9.5f due to insufficient source information.\n",visSMAscan.time.UTCtime);
        if(strncmp(multisour[sourceID].name,skipped,8)!=0) {
//        printf("chk 17:\n"); 
        if((strncmp(multisour[sourceID].name,target,6)!=0)&&
        (strncmp(multisour[sourceID].name,unknown,7)!=0)) {
//        printf("chk 18:\n");
	rspokeflshsma_c(kst);
//       printf("chk 19:\n");
	                 } else {
                         ntarget++;
	                        }      }
                                } else {
         rspokeflshsma_c(kst);
                      }
      }
    }
   fprintf(stderr,"set=%4d ints=%4d inhid=%4d time(UTC)= %1dd%02d:%02d:%04.1f int= %04.1f percent=%03d  \n",
               readSet-1,
               visSMAscan.blockID.ints,
               visSMAscan.blockID.inhid,
               utcd,utch,utcm,utcs,
               visSMAscan.time.intTime,(int)(readSet/nsets[0]*100.0));

   fprintf(stderr,"skipped %d integration scans on `target&unknown'\n",ntarget);
   avenchan=smabuffer.rsnchan;
         for (i=0; i<ireset+1; i++) {
             if(i>0) smabuffer.scanskip = reset_id[i];
   if (smabuffer.rsnchan>0) {
int nnpadding;
   fprintf(stderr,"converted vis spectra from the original correlator configuration\n");
   fprintf(stderr,"to low and uniform resolution spectra:\n");
   fprintf(stderr,"(starting at integrations=%d)\n", smabuffer.scanskip);
   fprintf(stderr,"         input     output\n");
      for (kk=1; kk<numberSpectra; kk++) {
 if(smabuffer.highrspectra==1&&spn[smabuffer.scanskip]->nch[kk][rxlod]==0)
{
   nnpadding = 1-avenchan;
   fprintf(stderr,"warning: each of the empty chunks is padded with one flagged channel.\n");

} else {
       nnpadding = 0;
}

        if(smabuffer.spskip[0]==0) {
fprintf(stderr,"  s%02d     %4d  =>  s%02d %4d\n",kk, 
        spn[smabuffer.scanskip]->nch[kk][rxlod], kk, avenchan+nnpadding);
          } else {
        if(kk < smabuffer.spskip[0]) {
fprintf(stderr,"  s%02d     %4d  =>  s%02d %4d\n",kk,
        spn[smabuffer.scanskip]->nch[kk][rxlod], kk, avenchan+nnpadding);
          } else {
fprintf(stderr,"  s%02d     %4d  =>  s%02d %4d\n",kk+smabuffer.spskip[1],
        spn[smabuffer.scanskip]->nch[kk][rxlod], kk, avenchan+nnpadding);
           }
           }
      }
    } else {
int npadding=0;
      printf("vis spectra from the original correlator configuration: \n");
      printf("(starting at integrations=%d)\n", smabuffer.scanskip);
      printf("         input     output\n");
      for (kk=1; kk<numberSpectra; kk++) {
 if(smabuffer.highrspectra==1&&spn[smabuffer.scanskip]->nch[kk][rxlod]==0)
                     { 
       npadding = 1; 
printf("warning: each of the empty chunks is padded with one flagged channel.\n" );

                      } else { 
       npadding = 0;
                              }   
       if(smabuffer.spskip[0]==0) {
        printf("  s%02d     %4d  =>  s%02d %4d\n",kk, 
        spn[smabuffer.scanskip]->nch[kk][rxlod], kk, 
        spn[smabuffer.scanskip]->nch[kk][rxlod]+npadding);
                                   } else {
        if(kk < smabuffer.spskip[0]) {
        printf("  s%02d     %4d  =>  s%02d %4d\n",kk,
        spn[smabuffer.scanskip]->nch[kk][rxlod], kk,
        spn[smabuffer.scanskip]->nch[kk][rxlod]+npadding); 
                                     } else {
        printf("  s%02d     %4d  =>  s%02d %4d\n",
        kk+smabuffer.spskip[1],
        spn[smabuffer.scanskip]->nch[kk][rxlod], kk,
        spn[smabuffer.scanskip]->nch[kk][rxlod]+npadding);
                                             }
                                           }
                                            } 
                               }
     }
    if(smabuffer.spskip[0]!=-2003) {
    if(smabuffer.spskip[0]!=0&&smabuffer.spskip[0]!=-1)
     printf("The MIR s%02d - s%02d contain no data and are skipped!\n",
        smabuffer.spskip[0],
        smabuffer.spskip[0]+smabuffer.spskip[1]-1);
                                   } else {
     printf("The MIR s%d contains incompleted-correlator data!\n",
       -smabuffer.spskip[0]);
                                   } 
    printf("Done with data conversion from mir to miriad!\n");
    free(spn);
    free(bln);
    free(sph1);
    free(tsys);
    free(wts);
    free(inh);
    free(uvwbsln);
    free(atsys);
    free(smaEngdata);
    free(sch);
    free(data_start_pos);
  }
  /* ---------------------------------------------------------------------- */
  endTime = time(NULL);
  trueTime = difftime(endTime, startTime);
  if(jstat==0) fprintf(stderr,
		       "Real time used =%f sec.\n",
	  	       trueTime);
  rewind(fpin[1]);
  rewind(fpin[2]);
  rewind(fpin[3]);
  rewind(fpin[4]);
  rewind(fpin[5]);
  jstat=0;
  return jstat;
} 
/* end of main */



/* This function reads the integration header */
struct inh_def inh_read(FILE * fpinh)
{
  int nbytes;   /* counts number of bytes written */
  int nobj;     /* the number of objects written by each write */
  
  struct inh_def inh;
//  struct inh_def *inhptr;
 
  nbytes = 0;
  nobj = 0;

  /* read first data in set and check for end of file */
  
  nobj += fread(&inh.conid,sizeof(inh.conid),1,fpinh);
  if (nobj == 0) {
    printf("Unexpected end of file in_read\n");
    exit(-1);
  }
  nbytes += sizeof(inh.conid);
  nobj += fread(&inh.icocd,sizeof(inh.icocd),1,fpinh);
  nbytes += sizeof(inh.icocd);
  nobj += fread(&inh.traid,sizeof(inh.traid),1,fpinh);
  nbytes += sizeof(inh.traid);
  nobj += fread(&inh.inhid,sizeof(inh.inhid),1,fpinh);
  nbytes += sizeof(inh.inhid);
  nobj += fread(&inh.ints,sizeof(inh.ints),1,fpinh);
  nbytes += sizeof(inh.ints);
  nobj += fread(&inh.itq,sizeof(inh.itq),1,fpinh);
  nbytes += sizeof(inh.itq);
  nobj += fread(&inh.az,sizeof(inh.az),1,fpinh);
  nbytes += sizeof(inh.az);
  nobj += fread(&inh.el,sizeof(inh.el),1,fpinh);
  nbytes += sizeof(inh.el);
  nobj += fread(&inh.ha,sizeof(inh.ha),1,fpinh);
  nbytes += sizeof(inh.ha);
  nobj += fread(&inh.iut,sizeof(inh.iut),1,fpinh);
  nbytes += sizeof(inh.iut);
  nobj += fread(&inh.iref_time,sizeof(inh.iref_time),1,fpinh);
  nbytes += sizeof(inh.iref_time);
  nobj += fread(&inh.dhrs,sizeof(inh.dhrs),1,fpinh);
  nbytes += sizeof(inh.dhrs);
  nobj += fread(&inh.vc,sizeof(inh.vc),1,fpinh);
  nbytes += sizeof(inh.vc);
  nobj += fread(&inh.ivctype,sizeof(inh.ivctype),1,fpinh);
  nbytes += sizeof(inh.ivctype);
  nobj += fread(&inh.sx,sizeof(inh.sx),1,fpinh);
  nbytes += sizeof(inh.sx);
  nobj += fread(&inh.sy,sizeof(inh.sy),1,fpinh);
  nbytes += sizeof(inh.sy);
  nobj += fread(&inh.sz,sizeof(inh.sz),1,fpinh);
  nbytes += sizeof(inh.sz);
  nobj += fread(&inh.rinteg,sizeof(inh.rinteg),1,fpinh);
  nbytes += sizeof(inh.rinteg);
  nobj += fread(&inh.proid,sizeof(inh.proid),1,fpinh);
  nbytes += sizeof(inh.proid);
  nobj += fread(&inh.souid,sizeof(inh.souid),1,fpinh);
  nbytes += sizeof(inh.souid);
  nobj += fread(&inh.isource,sizeof(inh.isource),1,fpinh);
  nbytes += sizeof(inh.isource);
  nobj += fread(&inh.ipos,sizeof(inh.ipos),1,fpinh);
  nbytes += sizeof(inh.ipos);
  nobj += fread(&inh.offx,sizeof(inh.offx),1,fpinh);
  nbytes += sizeof(inh.offx);
  nobj += fread(&inh.offy,sizeof(inh.offy),1,fpinh);
  nbytes += sizeof(inh.offy);
  nobj += fread(&inh.iofftype,sizeof(inh.iofftype),1,fpinh);
  nbytes += sizeof(inh.iofftype);
  nobj += fread(&inh.ira,sizeof(inh.ira),1,fpinh);
  nbytes += sizeof(inh.ira);
  nobj += fread(&inh.idec,sizeof(inh.idec),1,fpinh);
  nbytes += sizeof(inh.idec);
  nobj += fread(&inh.rar,sizeof(inh.rar),1,fpinh);
  nbytes += sizeof(inh.rar);
  nobj += fread(&inh.decr,sizeof(inh.decr),1,fpinh);
  nbytes += sizeof(inh.decr);
  nobj += fread(&inh.epoch,sizeof(inh.epoch),1,fpinh);
  nbytes += sizeof(inh.epoch);
  nobj += fread(&inh.sflux,sizeof(inh.sflux),1,fpinh);
  nbytes += sizeof(inh.sflux);
  nobj += fread(&inh.size,sizeof(inh.size),1,fpinh);
  nbytes += sizeof(inh.size);
//  inhptr = &inh;
//  return inhptr;
   return  inh;
  
} /* end of function inh_read */


/* This function reads one baseline header */
struct blh_def blh_read(FILE * fpblh)
{
  int nbytes;   /* counts number of bytes written */
  int nobj;     /* the number of objects written by each write */
  struct blh_def blh;
// struct blh_def *blhptr;
 
  nbytes = 0;
  nobj = 0;
 
 
  nobj += fread(&blh.blhid,sizeof(blh.blhid),1,fpblh);
  if (nobj == 0) {
    printf("Unexpected end of file bl_read\n");
    exit(-1);
  }
  nbytes += sizeof(blh.blhid);
  nobj += fread(&blh.inhid,sizeof(blh.inhid),1,fpblh);
  nbytes += sizeof(blh.inhid);
  nobj += fread(&blh.isb,sizeof(blh.isb),1,fpblh);
  nbytes += sizeof(blh.isb);
  nobj += fread(&blh.ipol,sizeof(blh.ipol),1,fpblh);
  nbytes += sizeof(blh.ipol);
  nobj += fread(&blh.pa,sizeof(blh.pa),1,fpblh);
  nbytes += sizeof(blh.pa);
  nobj += fread(&blh.iaq,sizeof(blh.iaq),1,fpblh);
  nbytes += sizeof(blh.iaq);
  nobj += fread(&blh.ibq,sizeof(blh.ibq),1,fpblh);
  nbytes += sizeof(blh.ibq);
  nobj += fread(&blh.icq,sizeof(blh.icq),1,fpblh);
  nbytes += sizeof(blh.icq);
  nobj += fread(&blh.ioq,sizeof(blh.ioq),1,fpblh);
  nbytes += sizeof(blh.ioq);
  nobj += fread(&blh.irec,sizeof(blh.irec),1,fpblh);
  nbytes += sizeof(blh.irec);
  nobj += fread(&blh.iifc,sizeof(blh.iifc),1,fpblh);
  nbytes += sizeof(blh.iifc);
  nobj += fread(&blh.u,sizeof(blh.u),1,fpblh);
  nbytes += sizeof(blh.u);
  nobj += fread(&blh.v,sizeof(blh.v),1,fpblh);
  nbytes += sizeof(blh.v);
  nobj += fread(&blh.w,sizeof(blh.w),1,fpblh);
  nbytes += sizeof(blh.w);
  nobj += fread(&blh.prbl,sizeof(blh.prbl),1,fpblh);
  nbytes += sizeof(blh.prbl);
  nobj += fread(&blh.angres,sizeof(blh.angres),1,fpblh);
  nbytes += sizeof(blh.angres);
  nobj += fread(&blh.vis,sizeof(blh.vis),1,fpblh);
  nbytes += sizeof(blh.vis);
  nobj += fread(&blh.coh,sizeof(blh.coh),1,fpblh);
  nbytes += sizeof(blh.coh);
  nobj += fread(&blh.sigcoh,sizeof(blh.sigcoh),1,fpblh);
  nbytes += sizeof(blh.sigcoh);
  nobj += fread(&blh.csnr,sizeof(blh.csnr),1,fpblh);
  nbytes += sizeof(blh.csnr);
  nobj += fread(&blh.vflux,sizeof(blh.vflux),1,fpblh);
  nbytes += sizeof(blh.vflux);
  nobj += fread(&blh.cnoise,sizeof(blh.cnoise),1,fpblh);
  nbytes += sizeof(blh.cnoise);
  nobj += fread(&blh.avedhrs,sizeof(blh.avedhrs),1,fpblh);
  nbytes += sizeof(blh.avedhrs);
  nobj += fread(&blh.ampave,sizeof(blh.ampave),1,fpblh);
  nbytes += sizeof(blh.ampave);
  nobj += fread(&blh.phaave,sizeof(blh.phaave),1,fpblh);
  nbytes += sizeof(blh.phaave);
  nobj += fread(&blh.tpvar,sizeof(blh.tpvar),1,fpblh);
  nbytes += sizeof(blh.tpvar);
  nobj += fread(&blh.blsid,sizeof(blh.blsid),1,fpblh);
  nbytes += sizeof(blh.blsid);
  nobj += fread(&blh.itel1,sizeof(blh.itel1),1,fpblh);
  nbytes += sizeof(blh.itel1);
  nobj += fread(&blh.itel2,sizeof(blh.itel2),1,fpblh);
  nbytes += sizeof(blh.itel2);
  nobj += fread(&blh.iblcd,sizeof(blh.iblcd),1,fpblh);
  nbytes += sizeof(blh.iblcd);
  nobj += fread(&blh.ble,sizeof(blh.ble),1,fpblh);
  nbytes += sizeof(blh.ble);
  nobj += fread(&blh.bln,sizeof(blh.bln),1,fpblh);
  nbytes += sizeof(blh.bln);
  nobj += fread(&blh.blu,sizeof(blh.blu),1,fpblh);
  nbytes += sizeof(blh.blu);
  nobj += fread(&blh.soid,sizeof(blh.soid),1,fpblh);
  nbytes += sizeof(blh.soid);
//  blhptr = &blh;
//  return blhptr;
    return  blh;
  
} /* end of blh_read  */


unsigned long mfsize(FILE *fp)
{
/* Optimization stuff */
 char temp[BUFSIZ];
 static const long DATALENGTH_MAX=SMA_LONG_MAX%2!=0?SMA_LONG_MAX-1:SMA_LONG_MAX;
 long datalength=DATALENGTH_MAX;
 unsigned long counter, fsize;
  fsize = 0;
  
  if (fp==NULL) {
    printf("null pointer\n");
    return (unsigned)NULL;
  }

  /* fseek() doesn't signal EOF so i use fread() to detect the end of file */
  for (fseek(fp, datalength-1, SEEK_SET); 
       datalength>0 && fread(temp, 1, 1, fp)==0; 
       fseek(fp, datalength-1, SEEK_SET)) datalength/=128;
  fseek(fp, 0, SEEK_SET);
  if (datalength==0 && fread(temp, 1, 1, fp)==0) {
  return fsize;
  } else if (datalength==0)
    datalength=BUFSIZ;

  fseek(fp, datalength-1, SEEK_SET);
  /* fseek() doesn't signal EOF so i use fread() to detect the end of file */
  for(counter=0; fread(temp, 1, 1, fp)!=0; ++counter)
  fseek(fp, datalength-1, SEEK_CUR);
  fseek(fp, 0, SEEK_SET);
  for( ; counter>0; --counter) {
    fseek(fp, datalength, SEEK_CUR);
    fsize += datalength;
  }

  do {
  fsize += datalength=fread(temp, 1, BUFSIZ, fp);
  } while(datalength!=0);
  fseek(fp, 0, SEEK_SET);
  return fsize;
}


struct sph_def sph_read(FILE * fpsph)
{
  int nbytes;   /* counts number of bytes written */
  int nobj;     /* the number of objects written by each write */
 
  struct sph_def sph;
//  struct sph_def *sphptr; 
  nbytes = 0;
  nobj = 0;
 
  nobj += fread(&sph.sphid,sizeof(sph.sphid),1,fpsph);
  if (nobj == 0) {
    printf("Unexpected end of file sp_read\n");
    exit(-1);
  }
  nbytes += sizeof(sph.sphid);
  nobj += fread(&sph.blhid,sizeof(sph.blhid),1,fpsph);
  nbytes += sizeof(sph.blhid);
  nobj += fread(&sph.inhid,sizeof(sph.inhid),1,fpsph);
  nbytes += sizeof(sph.inhid);
  nobj += fread(&sph.igq,sizeof(sph.igq),1,fpsph);
  nbytes += sizeof(sph.igq);
  nobj += fread(&sph.ipq,sizeof(sph.ipq),1,fpsph);
  nbytes += sizeof(sph.ipq);
  nobj += fread(&sph.iband,sizeof(sph.iband),1,fpsph);
  nbytes += sizeof(sph.iband);
  nobj += fread(&sph.ipstate,sizeof(sph.ipstate),1,fpsph);
  nbytes += sizeof(sph.ipstate);
  nobj += fread(&sph.tau0,sizeof(sph.tau0),1,fpsph);
  nbytes += sizeof(sph.tau0);
  nobj += fread(&sph.vel,sizeof(sph.vel),1,fpsph);
  nbytes += sizeof(sph.vel);
  nobj += fread(&sph.vres,sizeof(sph.vres),1,fpsph);
  nbytes += sizeof(sph.vres);
  nobj += fread(&sph.ivtype,sizeof(sph.ivtype),1,fpsph);
  nbytes += sizeof(sph.ivtype);
  nobj += fread(&sph.fsky,sizeof(sph.fsky),1,fpsph);
  nbytes += sizeof(sph.fsky);
  nobj += fread(&sph.fres,sizeof(sph.fres),1,fpsph);
  nbytes += sizeof(sph.fres);
  nobj += fread(&sph.tssb,sizeof(sph.tssb),1,fpsph);
  nbytes += sizeof(sph.tssb);
  nobj += fread(&sph.integ,sizeof(sph.integ),1,fpsph);
  nbytes += sizeof(sph.integ);
  nobj += fread(&sph.wt,sizeof(sph.wt),1,fpsph);
  nbytes += sizeof(sph.wt); 
  nobj += fread(&sph.itaper,sizeof(sph.itaper),1,fpsph);
  nbytes += sizeof(sph.itaper);
  nobj += fread(&sph.snoise,sizeof(sph.snoise),1,fpsph);
  nbytes += sizeof(sph.snoise);
  nobj += fread(&sph.nch,sizeof(sph.nch),1,fpsph);
  nbytes += sizeof(sph.nch);
  nobj += fread(&sph.nrec,sizeof(sph.nrec),1,fpsph);
  nbytes += sizeof(sph.nrec);
  nobj += fread(&sph.dataoff,sizeof(sph.dataoff),1,fpsph);
  nbytes += sizeof(sph.dataoff);
  nobj += fread(&sph.linid,sizeof(sph.linid),1,fpsph);
  nbytes += sizeof(sph.linid);
  nobj += fread(&sph.itrans,sizeof(sph.itrans),1,fpsph);
  nbytes += sizeof(sph.itrans);
  nobj += fread(&sph.rfreq,sizeof(sph.rfreq),1,fpsph);
  nbytes += sizeof(sph.rfreq);
  nobj += fread(&sph.pasid,sizeof(sph.pasid),1,fpsph);
  nbytes += sizeof(sph.pasid);
  nobj += fread(&sph.gaiidamp,sizeof(sph.gaiidamp),1,fpsph);
  nbytes += sizeof(sph.gaiidamp);
  nobj += fread(&sph.gaiidpha,sizeof(sph.gaiidpha),1,fpsph);
  nbytes += sizeof(sph.gaiidpha);
  nobj += fread(&sph.flcid,sizeof(sph.flcid),1,fpsph);
  nbytes += sizeof(sph.flcid);
  nobj += fread(&sph.atmid,sizeof(sph.atmid),1,fpsph);
  nbytes += sizeof(sph.atmid);
//  sphptr = &sph;
//  return sphptr;
    return sph;
  
} /* end of sph_write */

/* This function reads  the code or strings header */
struct codeh_def * cdh_read (FILE * fpcodeh)
{
  int nbytes;   /* counts number of bytes written */
  int nobj;     /* the number of objects written by each write */
 
  struct codeh_def codeh;
  struct codeh_def *codehptr;
  nbytes = 0;
  nobj = 0;

  nobj += fread(codeh.v_name,sizeof(codeh.v_name),1,fpcodeh);
  if (nobj == 0) {
    printf("Unexpected end of file cdh_read\n");
    exit(-1);
  }
  nbytes += sizeof(codeh.v_name);
  nobj += fread(&codeh.icode,sizeof(codeh.icode),1,fpcodeh);
  nbytes += sizeof(codeh.icode);
  nobj += fread(codeh.code,sizeof(codeh.code),1,fpcodeh);
  nbytes += sizeof(codeh.code);
  nobj += fread(&codeh.ncode,sizeof(codeh.ncode),1,fpcodeh);
  nbytes += sizeof(codeh.ncode);
  codehptr = &codeh;
  return codehptr;
  
} /* end of codeh_write */ 

/* This function reads the engineering data header */
struct ant_def * enh_read(FILE * fpeng)
{
  int nbytes;   /* counts number of bytes written */
  int nobj;     /* the number of objects written by each write */

  struct ant_def ant;
  struct ant_def *antptr; 
  nbytes = 0;
  nobj = 0;
 
  nobj += fread(&ant.antennaNumber,sizeof(ant.antennaNumber),1,fpeng);
  if (nobj == 0) {
    printf("Unexpected end of file enh_read\n");
    exit(-1);
  }
  nbytes += sizeof(ant.antennaNumber);
  nobj += fread(&ant.padNumber,sizeof(ant.padNumber),1,fpeng);
  nbytes += sizeof(ant.padNumber);
  nobj += fread(&ant.antennaStatus,sizeof(ant.antennaStatus),1,fpeng);
  nbytes += sizeof(ant.antennaStatus);
  nobj += fread(&ant.trackStatus,sizeof(ant.trackStatus),1,fpeng);
  nbytes += sizeof(ant.trackStatus);
  nobj += fread(&ant.commStatus,sizeof(ant.commStatus),1,fpeng);
  nbytes += sizeof(ant.commStatus);
  nobj += fread(&ant.inhid,sizeof(ant.inhid),1,fpeng);
  nbytes += sizeof(ant.inhid);
  nobj += fread(&ant.ints,sizeof(ant.ints),1,fpeng);
  nbytes += sizeof(ant.ints);
  nobj += fread(&ant.dhrs,sizeof(ant.dhrs),1,fpeng);
  nbytes += sizeof(ant.dhrs);
  nobj += fread(&ant.ha,sizeof(ant.ha),1,fpeng);
  nbytes += sizeof(ant.ha);
  nobj += fread(&ant.lst,sizeof(ant.lst),1,fpeng);
  nbytes += sizeof(ant.lst);
  nobj += fread(&ant.pmdaz,sizeof(ant.pmdaz),1,fpeng);
  nbytes += sizeof(ant.pmdaz);
  nobj += fread(&ant.pmdel,sizeof(ant.pmdel),1,fpeng);
  nbytes += sizeof(ant.pmdel);
  nobj += fread(&ant.tiltx,sizeof(ant.tiltx),1,fpeng);
  nbytes += sizeof(ant.tiltx);
  nobj += fread(&ant.tilty,sizeof(ant.tilty),1,fpeng);
  nbytes += sizeof(ant.tilty);
  nobj += fread(&ant.actual_az,sizeof(ant.actual_az),1,fpeng);
  nbytes += sizeof(ant.actual_az);
  nobj += fread(&ant.actual_el,sizeof(ant.actual_el),1,fpeng);
  nbytes += sizeof(ant.actual_el);
  nobj += fread(&ant.azoff,sizeof(ant.azoff),1,fpeng);
  nbytes += sizeof(ant.azoff);
  nobj += fread(&ant.eloff,sizeof(ant.eloff),1,fpeng);
  nbytes += sizeof(ant.eloff);
  nobj += fread(&ant.az_tracking_error,sizeof(ant.az_tracking_error),1,fpeng);
  nbytes += sizeof(ant.az_tracking_error);
  nobj += fread(&ant.el_tracking_error,sizeof(ant.el_tracking_error),1,fpeng);
  nbytes += sizeof(ant.el_tracking_error);
  nobj += fread(&ant.refraction,sizeof(ant.refraction),1,fpeng);
  nbytes += sizeof(ant.refraction);
  nobj += fread(&ant.chopper_x,sizeof(ant.chopper_x),1,fpeng);
  nbytes += sizeof(ant.chopper_x);
  nobj += fread(&ant.chopper_y,sizeof(ant.chopper_y),1,fpeng);
  nbytes += sizeof(ant.chopper_y);
  nobj += fread(&ant.chopper_z,sizeof(ant.chopper_z),1,fpeng);
  nbytes += sizeof(ant.chopper_z);
  nobj += fread(&ant.chopper_angle,sizeof(ant.chopper_angle),1,fpeng);
  nbytes += sizeof(ant.chopper_angle);
  nobj += fread(&ant.tsys,sizeof(ant.tsys),1,fpeng);
  nbytes += sizeof(ant.tsys);
  nobj += fread(&ant.ambient_load_temperature,sizeof(ant.ambient_load_temperature),1,fpeng);        
  nbytes += sizeof(ant.ambient_load_temperature);
  antptr = &ant;
  return antptr;
} 

struct sch_def * sch_head_read(FILE * fpsch)
{
  int nbytes;   /* counts number of bytes written */
  int nobj;     /* the number of objects written by each write */

  struct sch_def sch;
  struct sch_def *schptr; 
  nbytes = 0;
  nobj = 0;
 
  nobj += fread(&sch.inhid,sizeof(sch.inhid),1,fpsch);
  if (nobj == 0) {
    fprintf(stderr,"Unexpected end of file sch_head_read\n");
    fprintf(stderr,"nscans[2]=%d, try a smaller number.\n", 
             smabuffer.scanproc);
    exit(-1);
  }
  nbytes += sizeof(sch.inhid);
  nobj += fread(sch.form,sizeof(sch.form),1,fpsch);
  nbytes += sizeof(sch.form);
  nobj += fread(&sch.nbyt,sizeof(sch.nbyt),1,fpsch);
  nbytes += sizeof(sch.nbyt);
  nobj += fread(&sch.nbyt_pack,sizeof(sch.nbyt_pack),1,fpsch);
  nbytes += sizeof(sch.nbyt_pack);
  schptr = &sch;
  return schptr;
  
} /* end of sch_write */ 

int sch_data_read(FILE * fpsch, long int datalength, short int * data)
{
  int nbytes;   /* counts number of bytes written */
  int nobj;     /* the number of objects written by each write */

  /*  short buff;*/
  nbytes = 0;
  nobj = 0;
  nobj += fread(data,datalength*sizeof(short int),1,fpsch);
  if (nobj == 0) {
    printf("The current scan (set=% 4d) is being read.\n",
	   smabuffer.currentscan); 
    bug_c('f',"Unexpected end of file shc_data_read. Using nscans\n to select a scan range and run smalod again.\n"); 
    exit(-1);
  }
  return nbytes;
  
} /* end of sch_data_read */

char *rar2c(double ra)
{ 
  static char rac[14];
  int hh, mm;
  float ss;
  hh = (int) (12.0/DPI*ra);
  mm = (int) ((12.0/DPI*ra-hh)*60.0);
  ss = (float) (((12.0/DPI*ra-hh)*60.0-mm)*60.0);
  sprintf(rac,"%02d:%02d:%07.4f", hh,mm,ss);
  rac[13]='\0';
  //printf("inside ra=%s\n", rac);
  
  return &rac[0];      
}

char *decr2c(double dec)
{
  static char decc[16];
  int dd, am;
  float as;
  dd = (int)(180./DPI*dec);
  am = (int)((180./DPI*dec-dd)*60.0);
  as = (float)(((180./DPI*dec-dd)*60.0-am))*60.0;
  am = (int)fabs(am);
  as = (float)fabs(as);
  sprintf(decc,"% 3d:%02d:%07.4f", dd,am,as);
  decc[15]='\0';
  return &decc[0];
}
 
int spdecode (struct codeh_def *specCode[])
{ 
  int spid;
  char  cspid[13];
  char  prefix[1];
  cspid[13]='\0';
  memcpy(cspid, specCode[0]->code, 12);
  sscanf(cspid, "%1s%d", prefix, &spid);
  return spid;
}

float juliandate (struct codeh_def *refdate[], int doprt)
{ 
  int i;
  int stat=0;   
  double jdate;
  char  ccaldate[13];
  static char *months[] = {"ill", "Jan","Feb","Mar","Apr","May","Jun","Jul", 
          "Aug","Sep","Oct","Nov","Dec"};
//  char yc[4];
//  char yc[2];
  char mc[3];
  int yi,mi,di;

  memcpy(ccaldate,refdate[0]->code, 12);
  ccaldate[13]='\0';
//  printf("ccaldate %s\n",ccaldate);
    sscanf(&ccaldate[0], "%s", mc);
    sscanf(&ccaldate[4], "%2d", &di);
    sscanf(&ccaldate[8], "%4d", &yi);
  fprintf(stderr,"*******************************\n");
  fprintf(stderr,"* Observing Date: %d %s %d *\n", yi, mc, di);
  fprintf(stderr,"*******************************\n");
  mi=0;
  for (i=1; i<13; i++){
    if (memcmp(mc,months[i], 3)==0) mi=i;
  }
  jdate = slaCldj (yi, mi, di, stat)+2400000.5;
  if(stat==1) {
     fprintf(stderr,"bad year   (MJD not computed).");
     exit(-1);
              }
  if(stat==2) {
     printf("bad month   (MJD not computed).");
     exit(-1);
              }
  if(stat==3) {
     printf("bad day   (MJD not computed).");
     exit(-1);
              }
     if(doprt==1)
 printf("Observing Date: %d %s %d    Julian Date: %f\n", yi, mc, di, jdate);
  return jdate;
}


double slaCldj ( int iy, int im, int id,  int sj)
     /*
     **  - - - - - - - -
     **   s l a C l d j
     **  - - - - - - - -
     **
     **  Gregorian calendar to Modified Julian Date.
     **
     **  Given:
     **     iy,im,id     int    year, month, day in Gregorian calendar
     **
     **  Returned:
     **     mjd_rtn      double Modified Julian Date (JD-2400000.5) for 0 hrs
     **     sj           int    status:
     **                           0 = OK
     **                           1 = bad year   (MJD not computed)
     **                           2 = bad month  (MJD not computed)
     **                           3 = bad day    (MJD computed)
     **
     **  The year must be -4699 (i.e. 4700BC) or later.
     **
     **  The algorithm is derived from that of Hatcher 1984 (QJRAS 25, 53-55).
     **
     **  Last revision:   29 August 1994
     **
     **  Copyright P.T.Wallace.  All rights reserved.
     */
{
  long iyL, imL, mjd;
  double mjd_rtn;
  /* Month lengths in days */
  static int mtab[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
  
  /* Validate year */
  if ( iy < -4699 ) { sj = 1; return 0.0; }
  
  /* Validate month */
  if ( ( im < 1 ) || ( im > 12 ) ) { sj = 2; return 0.0; }
  
  /* Allow for leap year */
  mtab[1] = ( ( ( iy % 4 ) == 0 ) &&
	      ( ( ( iy % 100 ) != 0 ) || ( ( iy % 400 ) == 0 ) ) ) ?
    29 : 28;
  
  /* Validate day */
  sj =  (( id < 1 || id > mtab[im-1] ) ? 3 : 0);
  
  /* Lengthen year and month numbers to avoid overflow */
  iyL = (long) iy;
  imL = (long) im;
  /* Perform the conversion */
  /*djm = (double)*/
  
  mjd =  ( ( 1461L * ( iyL - ( 12L - imL ) / 10L + 4712L ) ) / 4L
	   + ( 306L * ( ( imL + 9L ) % 12L ) + 5L ) / 10L
	   - ( 3L * ( ( iyL - ( 12L - imL ) / 10L + 4900L ) / 100L ) ) / 4L
	   + (long) id - 2399904L );
  mjd_rtn = (double) mjd;
  return mjd_rtn;
}

void precess(double jday1,double ra1,double dec1,double jday2,double *ra2pt,double *dec2pt)
{
  /* jhz 2004-7-23: based on a miriad fortran code, translate into c.
     c  A simple precession routine, to precess from one set of mean
     c  equatorial coordinates (RA,DEC), to another at a different epoch.
     c  This is accurate to order 0.3 arcsec over 50 years.
     c
     c  Reference:
     c    Explanatory Supplement to the Astronomical Almanac, 1993. p 105-106.
     c
     c  NOTE: This does not take account of atmospheric refraction,
     c  nutation, aberration nor gravitational deflection.
     c
     c  Input:
     c    jday1      Julian day of the known epoch.
     c    ra1,dec1   RA,DEC at the jday1 epoch (radians).
     c    jday2      Julian day of the new epoch.
     c  Output:
     c    ra2,dec2   Precessed coordinates (radians) */
  double r0,d0,rm,dm,T,M,N,ra2,dec2;
  T  = (jday1 - 2451545.0)/36525;
  M  = DPI/180 * (1.2812323 + (0.0003879 + 0.0000101*T)*T)*T;
  N  = DPI/180 * (0.5567530 - (0.0001185 + 0.0000116*T)*T)*T;
  rm = ra1 - 0.5*(M + N*sin(ra1)*tan(dec1));
  dm = dec1 - 0.5*N*cos(rm);
  
  /*   J2000 coordinates */
  r0 = ra1 - M - N*sin(rm)*tan(dm);
  d0 = dec1 - N*cos(rm);
  /* Coordinates of the other epoch. */
  T = (jday2 - 2451545.0)/36525.0;
  M = DPI/180.0 * (1.2812323 + (0.0003879 + 0.0000101*T)*T)*T;
  N = DPI/180.0 * (0.5567530 - (0.0001185 + 0.0000116*T)*T)*T;
  rm = r0 + 0.5*(M + N*sin(r0)*tan(d0));
  dm = d0 - 0.5*N*cos(rm);
  ra2 = r0 + M + N*sin(rm)*tan(dm);
  dec2 = d0 + N*cos(rm);
  *ra2pt=ra2;
  *dec2pt=dec2;
}

void nutate(double jday,double rmean,double dmean,double *rtrueptr,double *dtrueptr)
{
  /* jhz 2004-7-23: based on miriad code in f, translate into c
     c  Convert between mean and true equatorial coordinates, by
     c  accounting for nutation.
     c
     c  Input:
     c    jday       Julian day.
     c    rmean,dmean Mean (RA,DEC) at jday.
     c  Output:
     c    rtrue,dtrue True (RA,DEC) at jday.
  */
  double deps,dpsi,eps, rtrue, dtrue;
  double coseps,sineps,sinra,cosra,tandec;
  
  /*  Nutation parameters. */
  nuts(jday,&dpsi,&deps);
  /*  True obliquity. */
  eps = mobliq(jday) + deps;
  /*  Various parameters. */
  sineps = sin(eps);
  coseps = cos(eps);
  sinra  = sin(rmean);
  cosra  = cos(rmean);
  tandec = tan(dmean);   
  
  rtrue = rmean + (coseps + sineps*sinra*tandec)*dpsi
    - cosra*tandec*deps;
  dtrue = dmean + sineps*cosra*dpsi + sinra*deps;
  *rtrueptr = rtrue;
  *dtrueptr = dtrue;
  /*   printf("nutate: r1 d1 %f %f\n", rtrue, dtrue);
   */
}

void nuts(double ljday, double *dpsiptr,double *depsptr)
{
  /* jhz 2004-7-23: based on miriad code in f and translate into c.
     c
     c  Return nutation parameters. The claimed accuracy is 1 arcsec.
     c
     c  Input:
     c    jday       Julian date.
     c  Output:
     c    dpsi,deps  Difference between mean and true ecliptic latitude and
     c               longitude due to nutation, in radians.
     c
     c  Reference:
     c    Explanatory Supplmenet, page 120.
     c--
  */
  double d,t1,t2, dpsi,  deps;
  d = jday - 2451545.0;
  t1 = DPI/180*(125.0 - 0.05295 * d);
  t2 = DPI/180*(200.9 + 1.97129 * d);
  dpsi = DPI/180 * (-0.0048*sin(t1) - 0.0004*sin(t2));
  deps = DPI/180 * ( 0.0026*cos(t1) + 0.0002*cos(t2));
  *dpsiptr=dpsi;
  *depsptr=deps;
}

double mobliq(double jday)
{
  /* jhz 2004-7-23: based on miriad code in f and translate into c.
     c
     c  Return the mean obliquity of the ecliptic.
     c
     c  Input:
     c    jday       Julian day.
     c  Output:
     c    mobliq     Mean obliquity of the ecliptic, in radians.
     c
     c  Reference:
     c    Explanatory Supplement ... page 114.
     c-- */
  double T;
  double vmobliq;
  /* Centuries from J2000*/
  T = (jday - 2451545.0) / 36525.0;
  /* Mean obliquity.*/    
  vmobliq = 84381.448 - (46.8150+(0.00059-0.001813*T)*T)*T;
  vmobliq = DPI/(180.*3600.) * vmobliq;    
  return vmobliq;
}

void aberrate(double jday,double ra,double dec,double *rappptr,double *dappptr)
{
  // jhz 2004-7-23: based on miriad code in f and translate into c.
  //  Account for the effect of annual aberration, to convert
  //  from a true (RA,DEC) to a geocentric apparent (RA,DEC).
  //
  //  Input:
  //    jday       Julian date.
  //    ra,dec     True (RA,DEC).
  //  Output:
  //    rapp,dapp  Geocentric apparent (RA,DEC).
  //
  double  pos[3],vel[3],sinra,sindec,cosra,cosdec, rapp, dapp;
  void vearth();

  vearth(jday,pos,vel);
  sinra = sin(ra);
  cosra = cos(ra);
  sindec = sin(dec);
  cosdec = cos(dec);
  rapp = ra +  (-vel[0]*sinra + vel[1]*cosra)/
    (0.001*DCMKS*cosdec);
  dapp = dec + (-vel[0]*cosra*sindec - vel[1]*sinra*sindec
		+ vel[2]*cosdec)/(0.001*DCMKS);
  *rappptr= rapp;
  *dappptr= dapp;
  
}

void vearth (double jday, double pos[3], double vel[3])
{
  /* jhz 2004-7-23: based on miriad code in f and translate into c.
   *
   *  Approximate heliocentric position and velocity of the Earth
   *  The date and time should really be in the TDB in the Gregorian
   *  calendar, and is interpreted in a manner which is valid between
   *  1900 March 1 and 2100 February 28.
   *
   *  Input:
   *    jday       Time of interest (as Julian day).
   *  Output:
   *    pos        Position, in km.
   *    vel        Velocity, in km/sec.
   *
   *  The Earth heliocentric position/velocity is for mean equator and equinox
   *  of date.
   *
   *  Max/RMS errors 1950-2050:
   *     13/5 E-5 AU = 19200/7600 km in position
   *     47/26 E-10 AU/s = 0.0070/0.0039 km/s in speed
   */
  float twopi, speed, remb, semb;
  double aukm, j1901;
  float YF,T,ELM,GAMMA,EM,ELT,EPS0,DAY;
  float E,ESQ,V,R,ELMM,COSELT,SINEPS,COSEPS,W1,W2,SELMM,CELMM;
  int IY, QUAD;
  twopi = (float) 2*DPI;
  /* Mean orbital speed of Earth, AU/s */
  speed = 1.9913E-7;
  /* Mean Earth:EMB distance and speed, AU and AU/s */
  remb = 3.12E-5;
  semb = 8.31E-11;
  /* AU to km */
  aukm=149.597870e6;
  /* Julian date for 1 January, 1901. */
  j1901=2415385.5;
  /* Whole years & fraction of year, and years since 1900.*/
  QUAD = (int)((jday - j1901) / 1461.);
  IY   = (int)((jday - j1901 - 1461*QUAD) / 365.0);
  DAY  = (float)(jday - j1901 - 1461*QUAD - 365*IY + 1);
  IY   = 4*QUAD + IY + 1;
  YF   = (4*DAY - 4*(1/(fmod(IY,4)+1)) - fmod(IY,4) - 2) / 1461.0;
  T    = IY + YF;
  /* Geometric mean longitude of Sun
   *  (cf 4.881627938+6.283319509911*T MOD 2PI)*/
  ELM  = fmod(4.881628+twopi*YF+0.00013420*T, twopi);
  /*  Mean longitude of perihelion */
  GAMMA=4.908230+3.0005e-4*T;
  /*  Mean anomaly */
  EM=ELM-GAMMA;
  /*  Mean obliquity */
  EPS0=0.40931975-2.27e-6*T;
  /*  Eccentricity  */
  E=0.016751-4.2e-7*T;
  ESQ=E*E;
  /*  True anomaly */
  V=EM+2.0*E*sin(EM)+1.25*ESQ*sin(2.0*EM);
  /*  True ecliptic longitude*/
  ELT=V+GAMMA;
  /*  True distance */
  R=(1.0-ESQ)/(1.0+E*cos(V));
  /*  Moon's mean longitude */
  ELMM=fmod(4.72+83.9971*T, twopi);
  /*  Useful functions */
  COSELT=cos(ELT);
  SINEPS=sin(EPS0);
  COSEPS=cos(EPS0);
  W1=-R*sin(ELT);
  W2=-speed*(COSELT+E*cos(GAMMA));
  SELMM=sin(ELMM);
  CELMM=cos(ELMM);
  /*  Earth position and velocity*/
  pos[0] = aukm * (-R*COSELT-remb*CELMM);
  pos[1] = aukm * (W1-remb*SELMM)*COSEPS;
  pos[2] = aukm * W1*SINEPS;
  vel[0] = aukm * (speed*(sin(ELT)+E*sin(GAMMA))+semb*SELMM);
  vel[1] = aukm * (W2-semb*CELMM)*COSEPS;
  vel[2] = aukm * W2*SINEPS;
}

void elazchi(int tno) {
  /* calculate and store mean az and el into uv data */
  int i;
  double mel, maz;
  double sinq,cosq,ha;
  double sinha,cosha,sind,cosd,sinl,cosl,elev;
  float chi, chi2, evec;
  mel=0;
  maz=0;

  if(smabuffer.nants!=0) {
    for (i=0; i<smabuffer.nants; i++) {
      mel=mel+smabuffer.el[i];
      maz=maz+smabuffer.az[i];
    }
    mel=mel/smabuffer.nants;
    maz=maz/smabuffer.nants;
    /* both az and el in degree */
    //         uvputvrd_c(tno,"antaz",&maz,1);
    //         uvputvrd_c(tno,"antel",&mel,1);
    // bee.for require store antaz and antel for each antenna
    uvputvrd_c(tno,"antaz",&smabuffer.az,smabuffer.nants);
    uvputvrd_c(tno,"antel",&smabuffer.el,smabuffer.nants);
    // required by Bob Sault to store chi and chi2 for pol calibration
    // input:
    // smabuffer.obsra: Apparent RA and DEC of the source of interest (radians)
    // smabuffer.obsdec: 
    // smabuffer.lat:   Observatory geodetic latitude (radians)
    // smabuffer.lst:   Local sidereal time (radians)
    // output:
    // chi:             Parallatic angle (radians)
    // chi2:            chi2=-el
    // smabuffer.chi = evec + chi + chi2
    // evec = 0? for sma; smabuffer.chi = chi + chi2 = chi - el
//        printf("lst=%f obsra=%f lat=%f obsdec=%f el=%f\n", 
//        smabuffer.lst,
//        smabuffer.obsra,
//        smabuffer.lat,
//        smabuffer.obsdec,
//        smabuffer.el[1]);
        evec = (float) smabuffer.evec;
          ha = smabuffer.lst - smabuffer.obsra;
        sinq = cos(smabuffer.lat)*sin(ha);
        cosq = sin(smabuffer.lat)*cos(smabuffer.obsdec) - 
               cos(smabuffer.lat)*sin(smabuffer.obsdec)*cos(ha);
        chi  = (float) atan2(sinq,cosq);
// uvredo: for Nasmyth SMA Needs to be modified by elev
// uncertainty in elev is 0.0001 radians.
       sinha = sin(ha);
       cosha = cos(ha);
        sind = sin(smabuffer.obsdec);
        cosd = cos(smabuffer.obsdec);
        sinl = sin(smabuffer.lat);
        cosl = cos(smabuffer.lat);
        elev = asin(sinl*sind+cosl*cosd*cosha);
          chi  = evec + chi - (float) elev;
          chi2 =      (float) (-elev);
      uvputvrr_c(tno,"chi", &chi,1);
      uvputvrr_c(tno,"chi2",&chi2,1);
    } else {
     fprintf(stderr,"WARNING: nants=0; skip this scan. \n"); 
    }
}

void tsysStore(int tno) {
  // store Tsys to uvdata 
  int cnt, j;
  float tsysbuf[SMANT*SMIF];

  cnt =0;
  // only one per antenna 
  for (j=0; j< smabuffer.nants; j++) {
    tsysbuf[cnt]= smabuffer.tsys[j];
    cnt++;
  }
  uvputvrr_c(tno,"systemp",&tsysbuf,cnt);
}

double velrad( short dolsr,
               double time,
               double raapp,
               double decapp,
               double raepo,
               double decepo,
               double lst,
               double lat) {
  //  Based on Miriad subroutine velrad in atlod.for
  //  Compute the radial velocity of the observatory, 
  //  in the direction of a source, with respect to either 
  //  LSR or the barycentre. The subroutine is based on
  //  the fortran routine in miriad.
  //
  //  Input:
  //    dolsr      If >0, compute LSR velocity. Otherwise barycentric.
  //    time       Time of interest (Julian date).
  //    raapp,decapp Apparent RA and DEC (radians).
  //    raepo,decepo RA and DEC at the J2000 epoch (radians).
  //    lat        Observatory geodetic latitude (radians).
  //    lst        Local sideral time (radians).
  //  Output:
  //    vel        Radial velocity.
  struct lmn *inlmn;
  double lmn2000[3], lmnapp[3];
  struct vel *velosite;
  double  posearth[3], velsite[3], velearth[3], velsun[3];
  int i;
  double  vel;
  
  // computer barycentric velocity
  
  inlmn = sph2lmn(raapp,decapp);
  lmnapp[0] = inlmn->lmn1;
  lmnapp[1] = inlmn->lmn2;
  lmnapp[2] = inlmn->lmn3;
  
  velosite = vsite(lat,lst);
  
  velsite[0] = velosite->vx;
  velsite[1] = velosite->vy;
  velsite[2] = velosite->vz;
  vearth(time, posearth, velearth);
  vel =0.;
  for (i=0; i<3; i++) {
    vel = vel - (velsite[i] + velearth[i])*lmnapp[i];
  }
  
  // To compute LSR velocity, we need the source position in J2000 coordinates.
  // Vsun returns the Suns LSR velocity in the J2000 frame. Add this
  // contribution to the velocity we already have.
  
  if(dolsr==1) {
    inlmn= sph2lmn(raepo,decepo);
    lmn2000[0]=inlmn->lmn1;
    lmn2000[1]=inlmn->lmn2;
    lmn2000[2]=inlmn->lmn3;
    vsun(velsun);              
    for (i=0; i<3; i++ ) {
      vel = vel + lmn2000[i]*velsun[i];
    }
  }
  return vel;
}

struct lmn *sph2lmn(double ra, double dec) {
  //Convert from spherical coordinates to direction cosines.
  //Convert spherical coordinates (e.g. ra,dec or long,lat) into
  //direction cosines.
  //Input:
  //    ra,dec     Angles in radians.
  //Output:
  //    lmn        Direction cosines.
  struct lmn *outlmn;
  outlmn = (struct lmn *)malloc(sizeof(struct lmn ));
  outlmn->lmn1 = cos(ra)*cos(dec);
  outlmn->lmn2 = sin(ra)*cos(dec);
  outlmn->lmn3 = sin(dec);
  return outlmn;
}

struct vel *vsite(double phi, double st) {
  // based on miriad fortran subroutine vsite in velocity.for
  //*  Velocity due to Earth rotation 
  //*
  //*  Input:
  //*     PHI       latitude of observing station (geodetic)
  //*     ST        local apparent sidereal time
  //*  Output:
  //*     VEL       velocity in km/s.
  //*
  //*  PHI and ST are all in radians.
  //*  Accuracy:
  //*     The simple algorithm used assumes a spherical Earth and
  //*     an observing station at sea level.  For actual observing
  //*     sites, the error is unlikely to be greater than 0.0005 km/s.
  //*  Sidereal speed of Earth equator, adjusted to compensate for
  //*  the simple algorithm used.  (The true value is 0.4651.)
  //*  in units of km/s
  float espeed=0.4655;
  struct vel *sitevel;
  sitevel = (struct vel *)malloc(sizeof(struct vel ));
  sitevel->vx = -espeed*cos(phi)*sin(st);
  sitevel->vy =  espeed*cos(phi)*cos(st);
  sitevel->vz =  0.0;
  return sitevel;
}


void vsun(double *VEL) {
  // based on Miriad subroutine vsub in velocity.for
  //  Velocity of the Sun with respect to the Local Standard of Rest
  //
  //  Output:
  //     VEL       Velocity of the Sun.
  //------------------------------------------------------------------------
  //  Speed = 20 km/s
  //
  //  Apex = RA 270 deg, Dec +30deg, 1900.0
  //  = 18 07 50.3, +30 00 52, J2000.0
  //
  //  This is expressed in the form of a J2000.0 x,y,z vector:
  //
  //      VA(1) = X = -SPEED*COS(RA)*COS(DEC)
  //     VA(2) = Y = -SPEED*SIN(RA)*COS(DEC)
  //      VA(3) = Z = -SPEED*SIN(DEC)
  //      DATA VA / -0.29000, +17.31726, -10.00141 /
  float VA[3];
  VA[0] = -0.29000;
  VA[1] = +17.31726;
  VA[2] = -10.00141;
  VEL[0] = VA[0];
  VEL[1] = VA[1];
  VEL[2] = VA[2];
}

short ipolmap(short input_ipol) {
// mapping ipol to miriad polarization states id
short iPolmiriad;
int   ipol;
      ipol=input_ipol;
      iPolmiriad = 1;
if(smabuffer.oldpol==1) {
            switch(ipol) {
            case 0: iPolmiriad = 1; break;
            case 1: iPolmiriad =-5; break;
            case 2: iPolmiriad =-7; break;
            case 3: iPolmiriad =-8; break;
            case 4: iPolmiriad =-6; break;
              // convert MIR polarization label used befor sep1,2004 to Miriad
              // used   MIR  actual          Miriad
              //non      0   I                 1
              //RR       1   HH               -5
              //RL       2   HV               -7
              //LR       3   VH               -8
              //LL       4   VV               -6
                      }
                        } else {
if(smabuffer.circular==1)
              switch(ipol) {
              case 1: iPolmiriad =-1; break;
              case 2: iPolmiriad =-3; break;
              case 3: iPolmiriad =-4; break;
              case 4: iPolmiriad =-2; break;
                //MIR     MIRIAD     STATE
                //1       -1         RR
                //2       -3         RL
                //3       -4         LR
                //4       -2         LL
                           }
if(smabuffer.linear==1)
              switch(ipol) {
              case 1: iPolmiriad =-6; break;
              case 2: iPolmiriad =-7; break;
              case 3: iPolmiriad =-8; break;
              case 4: iPolmiriad =-5; break;
// from ram mar7,2005
                // In the case where options=linear then
                // MIR MIRIAD  POL
                // 1   -6      VV (YY)
                // 2   -7      HV (XY)
                // 3   -8      VH (YX)
                // 4   -5      HH (XX)
                          }
                 }
        if(smabuffer.nopol==1) iPolmiriad=-5;

     return iPolmiriad;
}

//
//Subject: A patch for the pipeline of sma DOUBLE-BAND data to Miriad (since 
//         2008-10-17).
//
//jhz pre2009notes: ..........
//
//jhz (2009-01-28): The smalod code read data 090128_02:42:25 successfully,
//                  which is an example of non-bandwidth doubled data file
//                  produced from Taco's new code. Here is Taco's email to 
//                  describe this file.
//
//Date: Wed, 28 Jan 2009 10:54:39 -0500 (EST)
//From: Ken Young <rtm@cfa.harvard.edu>
//To: jzhao@cfa.harvard.edu
//
//   Hi Jun-Hui,
//
//   One of last night's tracks used the new version of dataCatcher,
//   which can write 48 chunk files, but the track did not use the 
//   bandwidth doublers. So its file "data/science/mir_data/090128_02:42:25/"
//   is an example of a 24 chunk file written with the new software.
//
//   Taco
//
//jhz (2009-07-10): with help (gdb) from NP, found bugs in the old mir 
//                  reading codes -- for example not adequate memory 
//                  allocation for several data buffer arrays.
//
//jhz (2009-07-14): adopted an sample code from Taco K. Young
//                  to read the double-band SMA data created from
//                  his new code.
//
//jhz (2009-07-14): duplicated the code from KY's email
//jhz (2009-07-14): turned it into general reading program.
//jhz (2009-07-16): created byteswap routine (EK).
//jhz (2009-07-17): implemented inRead.c to read in_read.
//jhz (2009-07-20): implemented blRead.c to read bl_read.
//jhz (2009-07-21): implemented spRead.c to read sp_read.
//
//jhz (2009-07-21): made a note to list the inconsistences between 
//                  single-band and the double-band data in order 
//                  to identify possible bugs that cause the failure 
//                  in reading double-band data.
//
//jhz (2009-07-21): discovered a skip in sphid and built structure to reset
//                  the sp cursor. The patch breaks the assumption of continuity
//                  in the table handle ids and messes up a few pointing arrays.
//
//jhz (2009-07-22): A separate routine is needed to patch the holes in order to
//                  avoid causing any potential problems to the well tested 
//                  code in reading the old sma (or single-band) data. 
//
//jhz (2009-07-22): created data_buffer.h. 
//
//jhz (2009-07-23): created routines to determine the size of
//                  header and data files and allocated memory
//                  for the header buffers.
//
//jhz (2009-07-27): implemented scRead.c to read sch_read.
//
//jhz (2009-07-28): added RA_cnvrt and DEC_cnvrt (convert double
//                  digital coordinates to the format of characterized
//                  coordinates).
//
//jhz (2009-07-29): adopted routines from (old) smalod to             
//                  calculate jday and convert J2000 catalog          
//                  source coordinates to apparent source coordinates
//                  of observations.
//
//jhz (2009-07-30): created a better algorithm to determine nskip which 
//                  can apply to both single-band and double-band data 
//                  files.
//
//jhz (2009-07-31): created debug printing levels for reporting messages.
//
//jhz (2009-08-03): found a hidden bug of an array cursor being negative;
//                  and fixed it. Note that inhid starts from 0 while both
//                  blhid and sphid start from 1.
//jhz (2009-08-06): reported miriad software development pre 2009-08-06 
//                  on August 6 software meeting.
//
//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
//
//jhz (2009-08-06): Implemented codeRead.c to read codes_read;
//                  implemented reading projectInfo to get observer's 
//                  information.
//
//jhz (2009-08-07): Following the new data retrieval algorithm,
//                  implemented routines to determine
//                  number of sidebands,
//                  number of integrations,
//                  number of baselines,
//                  number of antennas,
//                  number of spectra per baseline.
//
//jhz (2009-08-10): Created bltsys structure (baseline-based tsys);
//                  created antsys structure (antenna-based tsys);
//                  populated the elements of bltsys.
//
//jhz (2009-08-11): Start to work on antenna-based Tsys.
//                  Have the online data provided a table for 
//                  antenna-based tsys for each chunk, which we agreed on 
//                  (july 15 software meeting)? 
//                  If so table name? format? 
//                  Or does miriad have to solve the bltsys matrix
//                  for antenna-based tsys (for each chunk)?....
//
//jhz (2009-08-12): Have we archieved online-software versions in the 
//                  the sma science data file, which we agreed on 
//                  (august 6 software meeting)?
//                  in which file (projectInfo?) do we store the information?
//                  any example files?
//                  Do we also (plan to) store the information on operation
//                  modes ("1 receiver, 2 GHz", "2 receiver, 2 GHz" and
//                  "1 receiver 4 GHz") in projectInfo? The operation modes have
//                  been described in smalog 18582. The information on
//                  the operation modes will be useful for smalod to start
//                  this DBA patch prior to parsing the spectral table.
//
//jhz (2009-08-12): reported miriad software development pre 2009-08-12
//                  on August 12 software meeting.
//
//jhz (2009-08-13): Taco assured that the online software will make an antenna-based
//                  Tsys table for Miriad, archive operation modes in projectInfo
//                  and provide CVS version ids of the online software (dDs, 
//                  dataCatcher, coordinates ....) to store them in each of the
//                  science project files that are generated by the online software.
//
//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
//
//jhz (2009-08-13): reading the 'antennas' file, parsing the data strings
//                  and making certain that the antenna coordinates
//                  are not corrupted. The ASCII file is easy to be
//                  corrupted. The solver the antenna positions from
//                  baseline table are no longer used in this patch.
//
//jhz (2009-08-13): worked with Taco to created antenna-based Tsys table 
//                  format for online software. 
//
//jhz (2009-08-14): converting geocentral coordinates in meters (SMA) to the 
//                  miriad equatorial system (in nanosecs).
//
//jhz (2009-08-24): added data pathname for the input data file.
//jhz (2009-08-25): fixed a bug in open antennas' file :
//                  adding the 'antennas' to the file list of
//                  the SMA raw data.
//
//jhz (2009-08-28): implemented routines to determine 
//                  number of channels.
//jhz (2009-08-31): find a minor bug in reading projectInfo
//                  in the case the string ends improperly or exceeds the
//                  buffer size assigned.
//                  fixed it.
//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
//jhz (2009-09-03): added ivctype in the inh buffer, parsing the velocity
//                  type.
//jhz (2009-09-04): added decoding spectral windows' name including 'c1' of
//                  the pseudo continuum channel.
//jhz (2009-09-08): worked out multiple source structure,filling it with
//                  id, name, coordinates, equanox, velocity type, 
//                  velocity definition.
//jhz (2009-09-14): read antenna-based Tsys.
//jhz (2009-10-07): make the first release.
//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
//jhz (2009-10-08): define miriad output routines
//jhz (2009-10-08): write out the basic parameters of the observing track
//                  write out the antenna positions
//jhz (2009-10-09): write out the spectral header parameters
//jhz (2009-10-10): flush out the visibilities, 
//                  flags and other random headers,
//                  work out history file.
//jhz (2009-10-11): check up the variables which has been written out.
//jhz (2009-10-12): using varlist, uvlist and uvindex to find bugs.
//                  write out velocity information.
//jhz (2009-10-13): make the next release for Glenn quick look.
//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
//jhz (2009-10-13): write out source structure.
//jhz (2009-10-14): fix a bug in the frequency structure.
//jhz (2009-10-14): work out side band separation.
//jhz (2009-10-15): make the next release for the software crew.
//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
//jhz (2009-10-26): work out tsys (single band) storage routine.
//jhz (2009-10-27): work out converting mir weight to miriad flag. 
//jhz (2009-10-28): add a pointing cursor to track a specific visibility record.
//                  line up the side band data with the headers.
//jhz (2009-10-29): line up the baseline header with the visibility data.
//jhz (2009-10-30): finally get all the data of the first 24-chunk band 
//                  (1-24 chunks).
//                  in miriad format. 
//jhz (2009-11-01): line up the flag state with the visibility data.
//jhz (2009-11-02): line up sky frequency with Miriad frequency convension.
//                  add a subroutine for corrections of sky freq in early epoch.
//                  determine base frequency.
//                  convert uvw coordinates to miriad convension in nsec.
//jhz (2009-11-03): add rsnchan, a number of channels per chunk to achieve after
//                  average.
//jhz (2009-11-04): work out the frequency precision.
//                  tested for usb.
//jhz (2009-11-05): tested for lsb.
//jhz (2009-11-06): work out the first 24-chunk band (chunk 1-24) data.
//jhz (2009-11-07): get all 48 chunk data in.
//jhz (2009-11-08): line up sky frequency of the new 24-chunk band 
//                  (chunk 25-48) data. 
//jhz (2009-11-09): Integrate to smalod. 
//jhz (2009-11-10): Change the name sma_dbmirRead to dbpatch.
//jhz (2009-11-12): Fixed a bug in counting number of visibilities in a spectrum.
//jhz (2009-11-13): Added options for 1st channel flagging.
//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
//jhz (2009-11-16): for the new test release before the beta release.
//jhz (2009-11-23): add a ruotine to check online software versiond.
//jhz (2009-11-27): make release for beta 1.0.0
//jhz (2009-11-30): make next release 1.0.1 for dataCatcher update.
//jhz (2010-04-50): add double rx patch for 2010 spring data 
//                  and make beta release 1.0.5.
//jhz (2010-07-25): clean a few obsoleted routines and add few messages.
//                  add hostlookup script to make sure all the test users
//                  have no problems to install this package and load
//                  sma db data. make beta release 1.0.9
//jhz (2010-08-09): implement sb=2 feature and make beta release 1.1.1
//jhz             : update messages are given in the beginning after 2010-08
//------------------------------------------------------------------------------
//sma_dbmirRead.c
//------------------------------------------------------------------------------
//
//define identifiers:
//
//#define H_BYTE         1
//#define H_INT          2
//#define H_REAL         4
//#define H_DBLE         5 
//#define TSTDY  2454880.5
//#define TSTDY  2455155.5
//#define TSTDY  2455354.5
//#define TSTDY  2455378.5
//#define TSTDY  2455403.5
//#define TSTDY  2455503.5
//#define TSTDY  2455835.5
//#define TSTDY  2455926.5
//#define TSTDY  2456113.5
//#define TSTDY  2456171.5
#define TSTDY  2456292.5
#define VSTDY  2455061.5 //setLO 090819
#define POLDY  2455317.5
#define SNDCNBYTE        1
#define C1F              1.0E0
#define S1F              1.0E0
#define C2F              1.0E0
#define S2F              1.0E0
// Define const and void if needed.
//#if (__STDC__ == 1)
//#define Const const
//#endif /* __STDC__ */
//
//define miriad output routines
//
/* void uvputvr_c (int tno, int type, Const char *var, Const char *data, int n);
#define uvputvra_c(tno,name,value)   \
        uvputvr_c(tno,H_BYTE,name,value,strlen(value))
#define uvputvrr_c(tno,name,value,n) \
        uvputvr_c(tno,H_REAL,name,(char *)(value),n)
#define uvputvri_c(tno,name,value,n) \
        uvputvr_c(tno,H_INT,name,(char *)(value),n)
#define uvputvrd_c(tno,name,value,n) \
        uvputvr_c(tno,H_DBLE,name,(char *)(value),n)
*/
//
// external parameters, functions and routines:
//
//void uvopen_c(int *tno, Const char *name, Const char *status);
//void uvclose_c(int tno);
//void hisopen_c  (int tno, Const char *status);
//void hiswrite_c (int tno, Const char *text);
void hisinput_c (int tno, char *name);
//void hisclose_c (int tno);
double jday;
// int input_isb=0;    // default is 0 for lsb; or 1 for usb.
int input_rxif=-1;  // default is any rx in the case of single rx;
                    // for daul rx case, user must pick one of the following id
                    // 0 -> 230 GHz;
                    // 1 -> 345 GHz;
                    // 2 -> 400 GHz;
                    // 3 -> 690 GHz.
//========================
short iPolmapCirdb(short input_ipol);
int spdecodedb (struct dbcdh_def *specCode[]);
struct RA_cnvrt *ra(double rar);
struct DEC_cnvrt *dec(double decr);
char *rar2cdb(double ra);
char *decr2cdb(double dec);
void tsysStoredb(int tno, int nants, int set);
void fixed_c(int tno, short dobary);
struct dbanttsys  **atsys;
void sfcorr(double sfoff[MAXCHUNK+1], double fres[MAXCHUNK+1]);
void byteswap(char * b, int n);
void dbpatch_c(char pathname[64], char outf[64], int input_isb, int *doflagch0,
     int datswap, int *iPointflag, double lat1, double long1, double evec1);
void dbcheck_c(int nchunk[1], char *datapath, int datswap);
int dbchkCodeVers(char *datapath);
//================================
void byteswap(char *, int);
int *hstusrs();
short int *swap_sch_dbdata(short int *sch_data_pnr, int datalength);
void reverse2db(char *bytes);
void precessdb(double jday1, double ra1, double dec1,
     double jday2, double *ra2pt, double *dec2pt);
void nutatedb(double jday, double rmean, double dmean,
     double *rtrueptr, double *dtrueptr);
void aberratedb(double jday, double ra, double dec,
     double *rappptr, double *dappptr);
float juliandatedb(char refdate[26],int doprt, int *testlev);
void nutsdb(double jday, double *dpsiptr, double *depsptr);
double mobliqdb(double jday);
void vearthdb(double jday, double pos[3], double vel[3]);
double slaCldjdb(int iy, int im, int id, int sj);
void uvinit(int *tno);
//
// main routine
//
//main(int argc, char *argv[])
void dbpatch_c(char pathname[64], char outf[64], int input_isb, int *doflagch0,
     int datswap, int *iPointflag,double lat1, double long1, double evec1)
{
  int  file, nfiles=8;
  char location[nfiles][81];
//  char pathname[64];
  char filename[nfiles][36];
  int  set, nsets[3];
  int  infd, nRead_in=1;
  int  blfd, nRead_bl=1;
  int  spfd, nRead_sp=1;
  int  cdfd, nRead_cd=1;
  FILE *pjfd;
  FILE *anfd;
  inhDef in_record;         // integeration header string
  blhDef bl_record;         // baseline header string
  sphDef sp_record;         // spectral header string
  codehDef cd_record;       // code header string
  int  in_count = 0;
  int  bl_count = 0;
  int  sp_count = 0;
  int  cd_count = 0;
  struct dbinh_def  **inh;    // integration header array
  struct dbblh_def  **blh;    // baseline header array
  struct dbsph_def  **sph;    // spectral header array
  struct dbcdh_def  **cdh;    // code header array
  struct dbbltsys  **tsys;    // baseline-based tsys array
//  struct anttsys  **atsys;  // antenna-based tsys array
  struct RA_cnvrt *racnvrt;
  struct DEC_cnvrt *deccnvrt;
  int i;
//j,k;
  int i1;
  short oka,okb,okc,okd;
  int kk,ivis;
  int ipnt=0;
//ifs
  int tset,sset;
  int inhid,blhid;
  int inhid_rd;
  int inhid_edrp=0;
//sphid;
  int inhset,blhset,sphset;
  int firstbsl,lastbsl,firstsp,lastsp;
  int numberIntegrations;
  int numberBaselines=0;
  int numberAnts;
  int numberSpectra=0;
  int numberSpectra1=0;
  int numberSpectra2=0;
  int if1spc = 0;
  int if2spc = 0;
  int numberChannel;
  int numberSidebands;
  int numberPols;
  int p1[5];
  int rx1,rx2,numberReceivers;
//  int fd,
  FILE *fd; 
  int nRead=1;
  int tno;
  int refant=6; //reference antenna
  int nants;  //number of antennas in antennas 
  int nnants; //number of antenna coordinates = 3*MAXANT
  int nspect; //number of spectral chunks
  int sspect=1; 
              //single spectrum
  int count = 0;
  int nskip = 0;
  int doprt = 0;
  int nflush = 1;
  float veldop;
  float vsource;
  long int *data_start_pos;
  unsigned long datalength, bytepos;
// nbytes;
  schDef record;
  short int *shortdata;
  short int realvisS,imagvisS,scale;
  short int dodebug=-1; 
              // -1=no debug; 0-> brief debug; 1-> normal debug; 2-> deep debug 
  float realvisF[MAXSCHAN],imagvisF[MAXSCHAN];
  dbsource   multisour[MAXSOURCE];
  static char target[7];
  static char unknown[8];
  int sourceID;
  int skipsrc; // number of source skipped; -1 -> default or no source skipped.
  char sours[9], smasours[33]; 
               //sours: miriad source name (8-characters)
               //smasours: sma source name (32-characters)
//  char  outf[64];
  time_t  startTime, endTime;
  float   trueTime;
  char    telescope[4];
  char    instrument[4];
  char    version[64];
  char    strngbuf[120];
  char    observer[25];
  float   eta,jyperk, eta_c;
  float   eta_a=0.0;
  float   r_ant=3.0;
  int     ischan[MAXCHUNK+1];
  int     nschan[MAXCHUNK+1];
  int     spcode[MAXCHUNK+1];
  int     iband[MAXCHUNK+1];
  double  sfreq[MAXCHUNK+1];
  double  sdf[MAXCHUNK+1]; 
  double  restfreq[MAXCHUNK+1];
  double  pfreq;
  float   smavis[2*MAXCHAN];
  int     flags[MAXCHAN];
  int nchan;
  double  preamble[5];
// tdash;
  float  inttime;
  double antpos[3*MAXANT+1]; 
// antenna position array
  short  dobary;
  int    dbsourceID;
  double dbut;
  double dbobsra;
  double dbobsdec;
  double dbra;
  double dbdec;
  double dblst;
  double dbel[MAXANT];
  double dbaz[MAXANT];
  double dbrar;
  double dbdecr;
  double jjddaayy;
  float  dbtau0;
  char   dbsour[17];
//MIR sp id mapping 
  int    spcband[SMIF+1];
  int    spcnchn[SMIF+1];
  int    chunkid[SMIF+1];
  double spcfreq[SMIF+1];
//
//  int    dbsb;
//
  int    dbnants=8;
//
//  dbsmlodd dbsmabuffer;
//  short ifpnt;  // 1 - 48
//  short polpnt; // 0 - 5
//  short blpnt;  // 1 - maxant*(maxant-1)/2
//  short sbpnt;  // 0 - 1
//  short rxpnt;  // 0 - 3
//
  int   iflag=0;
  double sfoff[MAXCHUNK+1];
  double sfres[MAXCHUNK+1];
  int    rsnchan=0;
  int    doave = 0; 
//
// doave=1 - make averaging; doave !=1 - keep the original
//
  int    avenchan;
  float  avereal, aveimag;
  short  do4GHz=1; 
  int    doflag1st;
  int    doiPntflg;
  int    onlineUpdate=0;
  int    testlev=-1;
  float  chi,chi2,evec;
  double sinha,cosha,sind,cosd,sinl,cosl,elev;
  double sinq,cosq,ha;
  char strngLine[128];
  short st_save=1;
  int    blhid_off=-1;
  int    doswap;
  doflag1st = *doflagch0;
  doiPntflg = *iPointflag;
//fprintf(stderr, "\n doflagCh0=%d doflag1st=%d\n", doflagch0, doflag1st);
//fprintf(stderr, "\n iPointflag=%d doiPntflg=%d\n", iPointflag, doiPntflg);
//
// doswap = 1 do endian swap
// doswap = -1 no endian swap
//
//   doswap=-1;
   doswap=datswap;
   if(doswap < 0) fprintf(stderr, "No endian swap.\n");
          for (i=0; i< SMIF+1; i++) {
          spcband[i] = 0;
          spcnchn[i] = 0;
          spcfreq[i] = 0.0;
          } 
//
//       fprintf(stderr, "lat=%f long=%f evec=%f\n", lat1,long1,evec1);
//
      onlineUpdate=dbchkCodeVers(pathname);
// jhz 2011-9-11
// disable the checking online software updating
//      if(onlineUpdate==1) 
//                       exit(-1);
      if(dodebug==DEBUG)
         fprintf(stderr, "onlineUpdate = %d\n", onlineUpdate);
//
// initialize the ch0 flagging option
//
//        doflag1st = *doflagch0;
  if(dodebug==DEBUG)
                { 
           fprintf(stderr, "doflagch0=%d\n", *doflagch0);
                  exit(-1);
                      }
// do4GHz=1 - means do 4GHz mode; 
  if(rsnchan==0) doave = 0;
  sprintf(telescope,"SMA");
  sprintf(instrument,"SMA");
  sprintf(target,"target%s","\0");
  sprintf(unknown,"unknown%s","\0");
//sprintf(version, "DbP version 1.0.1.-beta: 2009-11-30%s","\0");
  sprintf(version, "DbP version 2.0.5-beta: 2012-06-28%s","\0");
//
// print out version id for this double band patch
//
//**    if (argc == 3){
//**    if(dodebug==DEBUG) fprintf(stderr, "input data: path handle =\n ");
//    if(dodebug==DEBUG) fprintf(stderr, "%s %s\n", argv[1],argv[2]);
//**    strcpy(pathname,argv[1]);
//**    dbsb=atoi(argv[2]);
//    if(dodebug==DEBUG) fprintf(stderr, "dbsb=%d\n", dbsb);
//**      } else {
//**    fprintf(stderr, "usage: scRead path sb\n");
//**    fprintf(stderr, "       sb=0 for lsb \n");
//**    fprintf(stderr, "       sb=1 for usb \n");
//**        exit(-1);
//**             }
//
     
    fprintf(stderr,
              "double-band patch................%s\n", version);
//
// select sideband data to load 
//
//**        input_isb = dbsb;
//
// start ticking the time
//
  startTime = time(NULL);
   if(dodebug==DEBUG)
                     {
           fprintf(stderr,
              "pathname=%s\n", pathname);
                                    exit(-1);
                      }
//
// assign filename
//
  strncpy(filename[0],"in_read", 7);
  strncpy(filename[1],"bl_read", 7);
  strncpy(filename[2],"sp_read", 7);
  strncpy(filename[3],"codes_read", 10);
  strncpy(filename[4],"eng_read", 8);
  strncpy(filename[5],"sch_read", 8);
  strncpy(filename[6],"projectInfo", 11);
  strncpy(filename[7],"antennas", 8);
//
// precede pathname to each file location
//
if(dodebug==DEBUG)
             {
   fprintf(stderr, 
          "nfiles=%d\n", nfiles);
                               exit(-1);
                      }
if(pathname[strlen(pathname)-1]!='/') 
                  strncat(pathname,"/",1);
for (file=0; file<nfiles; file++){
if(dodebug==DEBUG) 
                {
      fprintf(stderr, "strlen(pathname)=%d\n", (int)(strlen(pathname)));
                                    exit(-1);
                      }
if(dodebug==DEBUG) 
      {
          fprintf(stderr,"pathname=%c\n", pathname[strlen(pathname)-1]);
                                  exit(-1);
                      }
      strncpy(location[file],pathname, 64);
      strncat(location[file],filename[file], 36);
if(dodebug==DEBUG)
                {
   fprintf(stderr, 
           "location[%d] =%s\n", file, location[file]);
                                      exit(-1);
                      }
                                 }

//
// open output file
//
   fprintf(stderr, "open output file.\n");
//   sprintf(outf,"%s\0","miriad.uv");
//   uvopen_c (&tno, outf, "new");
   uvopen_c (&tno, outf, "new");
   uvset_c(tno,"corr", "r", (int)0,(double)0.0,(double)0.0,(double)0.0);
//
// initialize the miriad file
//
   uvset_c(tno,"preamble","uvw/time/baseline",
                            (int)0,(double)0.0,(double)0.0,(double)0.0);
//
// call fixed
   dobary = -1;
   fixed_c(tno,dobary);
//
// open history file
   hisopen_c(tno,"write");
//
// write out version
   sprintf(strngLine, "SMALOD: %s", version);
   hiswrite_c(tno,strngLine);
   sprintf(strngLine, "SMALOD: Telescope -> SMA");
   hiswrite_c(tno,strngLine);
   sprintf(strngLine, "SMALOD: Filename  -> %s", outf);
   hiswrite_c(tno,strngLine); 
//   hiswrite_c(tno,"SMALOD: Miriad_dbpatch.0.0");
//   hisinput_c(tno,"SMALOD");
//   hisinput_c(tno,observer);

if(dodebug==DEBUG)
          {
   fprintf(stderr, 
           "open miriad uvdata file........%s\n", outf);
                                exit(-1);
                      }
//
// read projectInfo
//
//        pjfd = fopen("./projectInfo","r");
if(dodebug==DEBUG)
                  {
          fprintf(stderr,
                  "projectInfo=%s\n", location[6]);
                                       exit(-1);
                      }
          pjfd = fopen(location[6],"r");
          if (pjfd == NULL) {
          fprintf(stderr,
                   "Fatal: do not find %s\n",location[6]);
                    sprintf(observer,"SmaUser%s","\0");
                    exit(-1);
if(dodebug==DEBUG) 
                 {
          fprintf(stderr, 
                   "observer: %s\n",observer);
                                            exit(-1);
                      }
                                     } else {
if(dodebug==DEBUG) 
          {
          fprintf(stderr,
                   "found file %s/%s\n",pathname,"projectInfo");
                                   exit(-1);
                      }
                        fread(&strngbuf,sizeof(strngbuf),1,pjfd);
if(dodebug==DEBUG)
              {
                 fprintf(stderr,"sizeof(strngbuf)=%d strlen(strngbuf)=%d\n", 
                                 (int) (sizeof(strngbuf)), 
                                 (int) (strlen(strngbuf)));
//
                                exit(-1);
                      }
         strncpy(observer,strngbuf,sizeof(observer)-1);
if(dodebug==DEBUG)
              {
                 fprintf(stderr,
                "strlen(observer)=%d PI=%s\n",  (int)strlen(observer), observer);
                                 exit(-1);
                      }
if(dodebug==DEBUG) 
                 {
          fprintf(stderr,
                          "observer: %s",observer);
//
                                     exit(-1);
                      }
                                            }
              fclose(pjfd);
// 
// write out the basic informations for each observing track
//
// telescope
    uvputvra_c(tno, "telescop", telescope);
//
// instrument
    uvputvra_c(tno, "instrume", instrument);
//
// PI observer
    uvputvra_c(tno, "observer", observer);
//
// software version
    uvputvra_c(tno, "version", version);
//
// determine the size of cdh
//
//  cdfd = open("./codes_read", O_RDONLY);
  cdfd = open(location[3], O_RDONLY);
  if(dodebug==DEBUG) 
   {
             fprintf(stderr,
                          "cdfd: %d\n",cdfd);
                         exit(-1);
                      }
  if (cdfd < 0) {
          perror("open");
              exit(-1);
                }
                    nsets[3]=0;
                    do {
                    nRead_cd = read(cdfd, &cd_record, sizeof(cd_record));
                    if (nRead_cd > 0) nsets[3]++; 
                    if(dodebug==DEBUG)
                         fprintf(stderr,
                           "number of sets in cd_read=%d\n", nsets[3]);

                        } while (nRead_cd > 0);
                    if(dodebug==DEBUG) 
                     fprintf(stderr,
                           "number of sets in cd_read=%d\n", nsets[3]);
                        close(cdfd);
                        nRead_cd = 1;
//
// decode the content of codes_read
//
//  cdfd = open("./codes_read", O_RDONLY);
//
  if(dodebug==DEBUG)
           {
    fprintf(stderr,
                  "codes_read=%s\n", location[3]);
//
                                exit(-1);
                      }
    cdfd = open(location[3], O_RDONLY);

  if (cdfd < 0) {
    perror("open");
    exit(-1);
                }
//
// allocate memory to cdh
//
  cdh = (struct dbcdh_def **) malloc(nsets[3]*sizeof( struct dbcdh_def *));
  for (set=0;set<nsets[3];set++) {
      cdh[set] = (struct dbcdh_def *)malloc(sizeof(struct dbcdh_def ));
          if (cdh[set] == NULL ){
            fprintf(stderr,
    "Fatal: Memory allocation for cdh failed trying to allocate %d bytes\n",
                          (int) (nsets[3]*sizeof(struct dbcdh_def)));
                                exit(-1);
                                    }
                                      }

    do {
//
// Swap the bytes in place
//
    nRead_cd = read(cdfd, &cd_record, sizeof(cd_record));
if(dodebug==DEBUG) fprintf(stderr,"nRead_cd=%d doswap=%d\n", nRead_cd,doswap);
     if (nRead_cd > 0) {
    if (doswap > 0) {
//  byteswap(&record.v_name, sizeof(record.v_name));
    byteswap(&cd_record.icode, sizeof(cd_record.icode));
//  byteswap(&cd_record.code, sizeof(cd_record.code));
    byteswap(&cd_record.ncode, sizeof(cd_record.ncode));
                    }
if(dodebug==DEBUG)    fprintf(stderr,
              "cd_count=%d v_name=%s icode=%d code=%s ncode=%d\n",
              cd_count,cd_record.v_name,cd_record.icode,
              cd_record.code,cd_record.ncode);


//
//    sprintf(cdh[cd_count]->v_name,"%s", cd_record.v_name);
      strncpy(cdh[cd_count]->v_name,cd_record.v_name,sizeof(cd_record.v_name));
            cdh[cd_count]->icode   =    cd_record.icode;
//    sprintf(cdh[cd_count]->code,  "%s", cd_record.code);
      strncpy(cdh[cd_count]->code, cd_record.code, sizeof(cd_record.code));
            cdh[cd_count]->ncode   =    cd_record.ncode;
if(dodebug==DEBUG) 
          { 
      fprintf(stderr, 
              "cd_count=%d v_name=%s icode=%d code=%s ncode=%d\n",
              cd_count,cd_record.v_name,cd_record.icode,
              cd_record.code,cd_record.ncode);

//                                exit(-1);
                      }
if(dodebug==DEBUG)
              {
      fprintf(stderr,
              "cd_count=%d v_name=%s icode=%d code=%s ncode=%d\n",
              cd_count,cdh[cd_count]->v_name,cdh[cd_count]->icode,
              cdh[cd_count]->code,cdh[cd_count]->ncode);
                                 exit(-1);
                      }
//
//  decode the julian date for from the observing date
//
      if((cd_record.v_name[0]=='r'&&cd_record.v_name[1]=='e')&&
      cd_record.v_name[2]=='f')           {
      doprt=-1;
//    fprintf(stderr,"before: testlev=%d\n", testlev);
      jday = juliandatedb(cd_record.code,doprt, &testlev);
      jjddaayy = jday;
//    fprintf(stderr,"main: testlev=%d\n", testlev);
//    fprintf(stderr,"jjddaayy = %f\n", jjddaayy);
              if((float)jday<DBDY) 
                       exit(-1);
              if(onlineUpdate==1)
                       exit(-1);
              if(dodebug==DEBUG) 
      fprintf(stderr,"onlineUpdate=%d jday=%f\n",
                       onlineUpdate, jday);
      if(onlineUpdate==-1&&jday<VSTDY&&jday!=2454880.5)
                       exit(-1);
                    }
if(dodebug==DEBUG) 
            fprintf(stderr,"nread_cd=%d cd_count=%d\n",
                         nRead_cd, cd_count);
         cd_count++;
                                       }
    } while (nRead_cd > 0);
//    fprintf(stderr,"JJJ\n");
    close(cdfd);
//    fprintf(stderr,"LLL\n");
    if(dodebug==DEBUG)
     { 
             fprintf(stderr, 
                     "observing date jday=%f \n", jday);
//
                              exit(-1);
                      }
    if(dodebug==DEBUG)
          { 
             fprintf(stderr,
                     "number of sets in codes_read=%d\n", cd_count-1);
//
                               exit(-1);
                      }
//          fprintf(stderr,"KKK\n");
//
// print out observer
// 
            fprintf(stderr, 
                    "principal investigator...........%s\n",observer);
   sprintf(strngLine, "SMALOD: P.I.      -> %s", observer);
   hiswrite_c(tno,strngLine);
//
// reading antenna position from ASCII file
//
//            if(( anfd = fopen("./antennas","r"))==NULL) {
              if(( anfd = fopen(location[7],"r"))==NULL) {
               fprintf(stderr, 
                       "Fatal: canot open antennas.\n");
//
                        exit(-1);                       
                         }
           {
struct dbxyz geocxyz[MAXANT+3];
unsigned short   antid;
double xyzpos;
float xx,yy,zz;
char   line[1000];
double r,cost,sint,z0,tmp;
              nants=0;
              xyzpos = (double) 1.0;
              while (fgets(line,sizeof(line),anfd) != NULL)
                   {
//
// old file => 41 e.g. 2005-09-11
// new file => 53 e.g. 2009-02-18
//
       if(strlen(line)>40) { 
                   nants++;
                           } else {
                   fprintf(stderr,
                           "Fatal: a corrupted entry %d in antennas.\n",
                      nants+1);
                      exit(-1);
                      }
       if(dodebug==DEBUG) 
                {
              fprintf(stderr,
                                  "STRING: line=%s",
                                   line );
                                 exit(-1);
                      }
       if(dodebug==DEBUG) 
                    {
          fprintf(stderr,
                      "strlen(line): %d\n",
                           (int) (strlen(line)));
//
                                       exit(-1);
                      }
                   line[strlen(line)-1]='\0';
{ int  antidd;
                   sscanf(line, "%d%f%f%f\n",&antidd, &xx, &yy, &zz);
              antid = (unsigned short) antidd;
             }
       if(dodebug==DEBUG) 
             {
           fprintf(stderr,
             "NUMBER: strlen(line)=%d\t%16.9e\t%16.9e\t%16.9e\n\n",
                                   antid, xx, yy, zz);
//
                               exit(-1);
                      }
             geocxyz[antid].x = (double) xx;
             geocxyz[antid].y = (double) yy;
             geocxyz[antid].z = (double) zz;
             xyzpos = (double) (xx+yy+zz);
             if(xyzpos==0) refant = antid;
                                      }
             if(nants>0) 
                {
             fprintf(stderr,
                     "Number of antenna in antennas....%d\n", nants);
                    }else{
             fprintf(stderr,
                     "Fatal: failure in reading antennas\n");
//
                        exit(-1);
                              }
             if(nants>8)
             fprintf(stderr,
"Warning: Number of %d antennas in antennas, exceeding that of standard SMA.\n", 
             nants);
             fclose(anfd);
     fprintf(stderr,
"Geocentrical coordinates (meter) with refant=%2d:\n",
              refant);
     for (i=1; i < MAXANT+1; i++) {
     fprintf(stderr,
"ANT x y z =%2d %11.4f %11.4f %11.4f\n",
              i,
              geocxyz[i].x,
              geocxyz[i].y,
              geocxyz[i].z);
                             }

//
// convert geocentrical coordinates to equatorial coordinates
// of miriad system y is local East, z is parallel to pole
// Units are nanosecs.
// write antenna dat to uv file
//
       fprintf(stderr,
"converting geocentrical coordinates to equatorial system (nanosecs).\n");
        r = sqrt(pow(geocxyz[refant].x,2) +
               pow(geocxyz[refant].y,2));
      if(r>0.) {
        cost = geocxyz[refant].x / r;
        sint = geocxyz[refant].y / r;
        z0   = geocxyz[refant].z;
              } else {
        cost = (double) 1.;
        sint = (double) 0.;
        z0   = (double) 0.;
                     }

        for (i=1; i < MAXANT+1; i++) {
         tmp  = ( geocxyz[i].x) * cost + (geocxyz[i].y)*sint - r;
         antpos[i-1]
         = (double) (1.e9/DCMKS) * tmp;
 fprintf(stderr,
"ANT x y x =%2d %11.4f ", i, antpos[i-1]);
         tmp  = (-geocxyz[i].x) * sint + (geocxyz[i].y) * cost;
         antpos[i-1+MAXANT]
         = (double) (1.e9/DCMKS) * tmp;
 fprintf(stderr,
"%11.4f ", antpos[i-1 + MAXANT]);
         antpos[i-1+2*MAXANT]
         = (double) (1.e9/DCMKS) * (geocxyz[i].z-z0);
 fprintf(stderr,
         "%11.4f\n", antpos[i-1+2*MAXANT]);
                                             }

                          }
//
//now store antenna cooridiantes
//
      nnants= 3* MAXANT;
      uvputvri_c(tno,"nants",&dbnants,1);
//
//    write out the antenna positions
      uvputvrd_c(tno,"antpos", antpos, nnants);

//
//Now  handling header variables
//
   fprintf(stderr,
              "handling header variables........\n");
//
// determine the size of inh
//
//  infd = open("./in_read", O_RDONLY);
    infd = open(location[0], O_RDONLY);
  if (infd < 0) {
    perror("open");
    exit(-1);
  }
    nsets[0]=0;
      do { 
      nRead_in = read(infd, &in_record, sizeof(in_record));
      if (nRead_in > 0) nsets[0]++; 
      } while (nRead_in > 0);
      if(dodebug==DEBUG)
          {
         fprintf(stderr,
"number of sets in in_read=%d\n", nsets[0]);
//
                             exit(-1);
                      }
      close(infd);
      nRead_in = 1;
//
// determine the size of blh
//
//  blfd = open("./bl_read", O_RDONLY);
    blfd = open(location[1], O_RDONLY);
  if (blfd < 0) {
    perror("open");
    exit(-1);
  }
    nsets[1]=0;
      do {
      nRead_bl = read(blfd, &bl_record, sizeof(bl_record));
      if (nRead_bl > 0) nsets[1]++; 
      } while (nRead_bl > 0);
      if(dodebug==DEBUG) 
           fprintf(stderr,
"number of sets in bl_read=%d\n", nsets[1]);
      close(blfd);

      nRead_bl = 1;
//
// determine the size of sph
//
//  spfd = open("./sp_read", O_RDONLY);
   spfd = open(location[2], O_RDONLY);
  if (spfd < 0) {
    perror("open");
//
    exit(-1);
  }
    nsets[2]=0;
      do {
      nRead_sp = read(spfd, &sp_record, sizeof(sp_record));
      if (nRead_sp > 0) nsets[2]++;
      } while (nRead_sp > 0);
    if(dodebug==DEBUG) 
    fprintf(stderr, "number of sets in sp_read=%d\n", nsets[2]);
      close(spfd);
      nRead_sp = 1;

//
// allocate memory for inh
//
//      infd = open("./in_read", O_RDONLY);
    infd = open(location[0], O_RDONLY);
    if (infd < 0) {
    perror("open");
//
          exit(-1);
                  }
  inh = (struct dbinh_def **) malloc(nsets[0]*sizeof( struct dbinh_def *));
  for (set=0;set<nsets[0];set++) {
    inh[set] = (struct dbinh_def *)malloc(sizeof(struct dbinh_def ));
    if (inh[set] == NULL ){
  fprintf(stderr, 
"Fatal: Memory allocation for inh failed trying to allocate %d bytes\n",
           (int) (nsets[0]*sizeof(struct dbinh_def)));
//
      exit(-1);
    }
  }
//
// allocate memory for  blh
//
//      blfd = open("./bl_read", O_RDONLY);
     blfd = open(location[1], O_RDONLY);
    if (blfd < 0) {
    perror("open");
//
          exit(-1);
                  }
  blh = (struct dbblh_def **) malloc(nsets[1]*sizeof( struct dbblh_def *));
  for (set=0;set<nsets[1];set++) {
    blh[set] = (struct dbblh_def *)malloc(sizeof(struct dbblh_def ));
    if (blh[set] == NULL ){
  fprintf(stderr, 
"Fatal: Memory allocation for blh failed trying to allocate %d bytes\n",
          (int) (nsets[1]*sizeof(struct dbblh_def)));
//
      exit(-1);
    }
  }
       
//
// allocate memory for  sph
//
//    spfd = open("./sp_read", O_RDONLY);
    spfd = open(location[2], O_RDONLY);
    if (spfd < 0) {
    perror("open");
//
          exit(-1);
                  }
    sph = (struct dbsph_def **) malloc(nsets[2]*sizeof( struct dbsph_def *));
    for (set=0;set<nsets[2];set++) {
    sph[set] = (struct dbsph_def *)malloc(sizeof(struct dbsph_def ));
    if (sph[set] == NULL ){
    fprintf(stderr, 
"Fatal: Memory allocation for sph failed trying to allocate %d bytes\n",
            (int) (nsets[2]*sizeof(struct dbsph_def)));
//
            exit(-1);
    }
  }

//
//allocate memory for baseline-based tsys 
//
    tsys = (struct dbbltsys **) malloc(nsets[1]*sizeof( struct dbbltsys *));
    for (set=0;set<nsets[1];set++) {
      tsys[set] = (struct dbbltsys *)malloc(sizeof(struct dbbltsys ));
      if (tsys[set] == NULL )      {
      fprintf(stderr,
"Fatal: Memory allocation for tsys failed trying to allocate %d bytes\n",
               (int) (nsets[1]*sizeof(struct dbbltsys)));
//
        exit(-1);
                                   }
                                   }
//
//allocate memory for antenna-based tsys
//
    atsys = (struct dbanttsys **) malloc(nsets[0]*sizeof( struct dbanttsys *));
    for (set=0;set<nsets[0];set++)  {
      atsys[set] = (struct dbanttsys *)malloc(sizeof(struct dbanttsys ));
      if (atsys[set] == NULL )      {
      fprintf(stderr,
"Fatal: Memory allocation for atsys failed trying to allocate %d bytes\n",
         (int) (nsets[0]*sizeof(struct dbanttsys)));
//
        exit(-1);
                                    }
                                    }

//
// load inh
//
//     printf("Loading ihn.....\n");
  do {
      nRead_in = read(infd, &in_record, sizeof(in_record));
      if(nRead_in > 0) {
      if(doswap > 0) {
      byteswap(&in_record.inhid, sizeof(in_record.inhid));
      byteswap(&in_record.ints,  sizeof(in_record.ints));
      byteswap(&in_record.az,    sizeof(in_record.az));
      byteswap(&in_record.el,    sizeof(in_record.el));
      byteswap(&in_record.ha,    sizeof(in_record.ha));
      byteswap(&in_record.dhrs,  sizeof(in_record.dhrs));
      byteswap(&in_record.rinteg, sizeof(in_record.rinteg));
      byteswap(&in_record.souid, sizeof(in_record.souid));
      byteswap(&in_record.ivctype, sizeof(in_record.ivctype));
      byteswap(&in_record.rar,   sizeof(in_record.rar));
      byteswap(&in_record.decr,  sizeof(in_record.decr));
      byteswap(&in_record.vc,    sizeof(in_record.vc));
                        }
      if(dodebug==DEBUG) 
      fprintf(stderr,
                       "in_record.inhid =%d\n", in_record.inhid);
//
// inh or in_record.inhid starts from 0 
//
      inh[in_record.inhid]->inhid  = in_record.inhid;
      inh[in_record.inhid]->ints   = in_record.ints;
      inh[in_record.inhid]->az     = in_record.az;
      inh[in_record.inhid]->el     = in_record.el;
      inh[in_record.inhid]->ha     = in_record.ha;
      inh[in_record.inhid]->dhrs   = in_record.dhrs;
      inh[in_record.inhid]->rinteg = in_record.rinteg;
      inh[in_record.inhid]->souid  = in_record.souid;
      inh[in_record.inhid]->ivctype= in_record.ivctype;
      inh[in_record.inhid]->rar    = in_record.rar;
      inh[in_record.inhid]->decr   = in_record.decr;
//
// calculate UTC time
//
      inh[in_record.inhid]->UTCtime=jday+in_record.dhrs/24.000;
//
//work out veldop
//
      inh[in_record.inhid]->veldop = in_record.vc;
      switch(in_record.ivctype) {
      case 0: sprintf(inh[in_record.inhid]->vtype, "%s", "VELO-LSR\0"); break;
//
// double check what cz stands for.
//
      case 1: sprintf(inh[in_record.inhid]->vtype, "%s", "FELO-HEL\0"); break;
      case 2: sprintf(inh[in_record.inhid]->vtype, "%s", "VELO-HEL\0"); break;
      case 3: fprintf(stderr,
"Fatal: vtype=pla has not been implemented.%s","\n"); break;
                           }
 if(dodebug==BRIEFDEBUG)
 {
//   fprintf(stderr, 
printf(
"in_record.inhid=%d inhid=%04d veldop=%f vtype=%s ivctype=%d\n",
            in_record.inhid,
            inh[in_record.inhid]->inhid,
            inh[in_record.inhid]->veldop,
            inh[in_record.inhid]->vtype,
            inh[in_record.inhid]->ivctype);
//                            exit(-1);
                      }
 if(dodebug==BRIEFDEBUG)
           { 
   fprintf(stderr, 
"inhid=%04d in_record.inhid=%04d in_count=%d\n", 
            inh[in_record.inhid]->inhid, 
            in_record.inhid,
            in_count);
                                 exit(-1);
                      }
 if(dodebug==DEBUG) 
            { 
   fprintf(stderr, 
"inhid=%04d,dhrs=%6.4f,souid=%d,rar=%16.14f,decr=%16.14f\n",
            in_record.inhid,
            in_record.dhrs,
            in_record.souid,
            in_record.rar,
            in_record.decr);
                                  exit(-1);
                      }
 if(dodebug==DEEPDEBUG) {    
   racnvrt= ra(in_record.rar);
   deccnvrt= dec(in_record.decr);
   fprintf(stderr, "RA=%02d:%02d:%08.5f Dec=%03d:%02d:%08.5f souid=%d\n",
   racnvrt->rahh,
   racnvrt->ramm,
   racnvrt->rass,
   deccnvrt->decdg,
   deccnvrt->decam,
   deccnvrt->decas,
   in_record.souid);
                      exit(-1);
                          }
//
// calculate the apparent position coordinates from j2000 coordinates
//
   {double obsra,obsdec,r1,d1;
    double julian2000=2451544.5;
    precessdb(julian2000,in_record.rar,in_record.decr,jday, &obsra, &obsdec);
    nutatedb(jday,obsra,obsdec,&r1,&d1);
    aberratedb(jday,r1,d1,&obsra,&obsdec);
    inh[in_record.inhid]->ra_app  = obsra;
    inh[in_record.inhid]->dec_app = obsdec;
    }
      in_count++;      }
   } while (nRead_in > 0);
       if(in_count-1!=in_record.inhid) {
       fprintf(stderr, 
              "fatal: a skip in inhid.\n");
       exit(-1);
           }
      numberIntegrations = nsets[0];
fprintf(stderr, 
     "number of integrations...........%04d\n", 
                               numberIntegrations);
//       fprintf(stderr,"jday = %f\n", jday);
       if(jday==2455734.5) inhid_edrp=70;
       if(jday==2456010.5) inhid_edrp=1;
       if(jday==2456005.5) inhid_edrp=43;
       if(jday==2456008.5) inhid_edrp=1;
       inhid_rd = (numberIntegrations-1) - inhid_edrp ;     
//
// load blh
//
      numberPols=0;
      for (i=0;i<5;i++) p1[i]=-100; 
  do {
      nRead_bl = read(blfd, &bl_record, sizeof(bl_record));
      if(nRead_bl > 0) {
      if(doswap>0) {
      byteswap(&bl_record.blhid, sizeof(bl_record.blhid));
      byteswap(&bl_record.inhid, sizeof(bl_record.inhid));
      byteswap(&bl_record.isb, sizeof(bl_record.isb));
      byteswap(&bl_record.ipol, sizeof(bl_record.ipol));
      byteswap(&bl_record.ioq, sizeof(bl_record.ioq));
      byteswap(&bl_record.irec, sizeof(bl_record.irec));
      byteswap(&bl_record.u, sizeof(bl_record.u));
      byteswap(&bl_record.v, sizeof(bl_record.v));
      byteswap(&bl_record.w, sizeof(bl_record.w)); 
      byteswap(&bl_record.blsid, sizeof(bl_record.blsid)); 
      byteswap(&bl_record.itel1, sizeof(bl_record.itel1));
      byteswap(&bl_record.itel2, sizeof(bl_record.itel2));
                   } 
      blh[bl_record.blhid-1]->blhid = bl_record.blhid;
      blh[bl_record.blhid-1]->inhid = bl_record.inhid;
      blh[bl_record.blhid-1]->isb   = bl_record.isb;
//
// pol-id mapping
//
      blh[bl_record.blhid-1]->polcode  = iPolmapCirdb(bl_record.ipol);
//
// counting number of pol states
//
      if(blh[bl_record.blhid-1]->polcode==-5&&p1[0]!=-5)  
   {p1[0]=-5;numberPols++;}
      if(blh[bl_record.blhid-1]->polcode==-4&&p1[1]!=-1)  
   {p1[1]=-1;numberPols++;}
      if(blh[bl_record.blhid-1]->polcode==-3&&p1[2]!=-3)  
   {p1[2]=-3;numberPols++;}
      if(blh[bl_record.blhid-1]->polcode==-2&&p1[3]!=-4)  
   {p1[3]=-4;numberPols++;}
      if(blh[bl_record.blhid-1]->polcode==-1&&p1[4]!=-2)  
   {p1[4]=-2;numberPols++;}
//
// ipointing flag
//
      blh[bl_record.blhid-1]->ioq   = bl_record.ioq;
//
// receiver id
//
      blh[bl_record.blhid-1]->irec  = bl_record.irec;
      blh[bl_record.blhid-1]->u     = bl_record.u;
      blh[bl_record.blhid-1]->v     = bl_record.v;
      blh[bl_record.blhid-1]->w     = bl_record.w;
      blh[bl_record.blhid-1]->blsid = bl_record.blsid;
      blh[bl_record.blhid-1]->itel1 = bl_record.itel1;
      blh[bl_record.blhid-1]->itel2 = bl_record.itel2;
//
// calculate blcode
//
      blh[bl_record.blhid-1]->blcode =bl_record.itel1*256+bl_record.itel2;
// 
// blhid starts from 1 not 0
//
if(dodebug==DEBUG) 
 {
      fprintf(stderr,
 "blhid=%04d bl_record.blhid=%04d bl_count=%d inhid=%d blsid=%d isb=%d polcode=%d\n", 
    blh[bl_record.blhid-1]->blhid,
    bl_record.blhid,bl_count,
    bl_record.inhid,
    bl_record.blsid,
    bl_record.isb, 
    blh[bl_record.blhid-1]->polcode);
                             exit(-1);
                      }
//
// populate tsys
//
    tsys[bl_record.blhid-1]->blhid = bl_record.blhid;
    tsys[bl_record.blhid-1]->inhid = bl_record.inhid;
    tsys[bl_record.blhid-1]->blsid = bl_record.blsid;
    tsys[bl_record.blhid-1]->isb   = bl_record.isb;
    tsys[bl_record.blhid-1]->irec  = bl_record.irec;
    tsys[bl_record.blhid-1]->ipol  = bl_record.ipol;
    tsys[bl_record.blhid-1]->itel1 = bl_record.itel1;
    tsys[bl_record.blhid-1]->itel2 = bl_record.itel2;
   
   if(bl_record.itel1>8||bl_record.itel2>8) {
      if(dodebug==DEBUG) 
      fprintf(stderr, "%d %d\n",bl_record.itel1,bl_record.itel2);
      fprintf(stderr,".......""......."".........."".........");
      fprintf(stderr,".......""......."".........."".........");
      fprintf(stderr,"\n");
                    exit(-1);
                      }

    bl_count++;      
         }
     if(dodebug==DEBUG)
     fprintf(stderr,
               "inhid_rd=%d bl_record.inhid=%d\n",
                            inhid_rd, bl_record.inhid);
     if(bl_record.inhid==inhid_rd) nRead_bl=-1;
   } while (nRead_bl > 0);
      if(bl_count!=bl_record.blhid) {
       fprintf(stderr, 
           "Fatal: a skip in blhid.");
       exit(-1);}


//
// load sph
//
  do {
  if (nRead_sp > 0) {
      nRead_sp = read(spfd, &sp_record, sizeof(sp_record));
      if(nRead_sp > 0) {     
      if(doswap>0) {                              
      byteswap(&sp_record.sphid,   sizeof(sp_record.sphid));
      byteswap(&sp_record.blhid,   sizeof(sp_record.blhid));
      byteswap(&sp_record.inhid,   sizeof(sp_record.inhid));
      byteswap(&sp_record.ipstate, sizeof(sp_record.ipstate));
      byteswap(&sp_record.tau0,    sizeof(sp_record.tau0));
      byteswap(&sp_record.fsky,    sizeof(sp_record.fsky));   
      byteswap(&sp_record.fres,    sizeof(sp_record.fres));   
      byteswap(&sp_record.rfreq,   sizeof(sp_record.rfreq));  
      byteswap(&sp_record.tssb,    sizeof(sp_record.tssb));  
      byteswap(&sp_record.wt,      sizeof(sp_record.wt)); 
      byteswap(&sp_record.integ,   sizeof(sp_record.integ));  
      byteswap(&sp_record.nch,     sizeof(sp_record.nch));
      byteswap(&sp_record.dataoff, sizeof(sp_record.dataoff));
      byteswap(&sp_record.iband,   sizeof(sp_record.iband));
//
//atmid    = crate number
//gaiidamp = block number
//gaiidpha = chunk number
//
      byteswap(&sp_record.gaiidpha, sizeof(sp_record.gaiidpha));
                 }
      if(dodebug==DEBUG) {
      fprintf(stderr, "inhid=%d blhid=%d sphid=%d\n", 
       sp_record.inhid,sp_record.blhid,sp_record.sphid);
      if(sp_record.blhid > 5)  exit(-1); }
//
// old sphid skipping algorithm
//      if(sp_record.sphid==(nskip+1)*50+1) nskip++;
      if(sp_record.sphid!=sp_count+1+nskip) nskip++;
//
// for 2GHz (24chunk) 
if(do4GHz!=1) nskip=0;
      sph[sp_record.sphid-1-nskip]->sphid   = sp_record.sphid;
      sph[sp_record.sphid-1-nskip]->blhid   = sp_record.blhid;
      sph[sp_record.sphid-1-nskip]->inhid   = sp_record.inhid;
      sph[sp_record.sphid-1-nskip]->ipstate = sp_record.ipstate;
      sph[sp_record.sphid-1-nskip]->tau0    = sp_record.tau0;
      sph[sp_record.sphid-1-nskip]->fsky    = sp_record.fsky;
      sph[sp_record.sphid-1-nskip]->fres    = sp_record.fres;
      sph[sp_record.sphid-1-nskip]->rfreq   = sp_record.rfreq;
      sph[sp_record.sphid-1-nskip]->tssb    = sp_record.tssb;
      sph[sp_record.sphid-1-nskip]->wt      = sp_record.wt;
      sph[sp_record.sphid-1-nskip]->integ   = sp_record.integ;
      sph[sp_record.sphid-1-nskip]->nch     = sp_record.nch;
      sph[sp_record.sphid-1-nskip]->dataoff = sp_record.dataoff;
      sph[sp_record.sphid-1-nskip]->iband   = sp_record.iband;
      if (numberSpectra1==0&&sp_record.iband<=24) {
             if1spc++;
           spcband[sp_record.iband]    = sp_record.iband;
           spcnchn[sp_record.iband]    = sp_record.nch;
           spcfreq[sp_record.iband]    = sp_record.fsky;
           chunkid[sp_record.iband]    = sp_record.gaiidpha;
               }
      if (numberSpectra1==0&&sp_record.iband>24) {
       numberSpectra1 = if1spc;
       fprintf(stderr, "number of c1 + IF1 Spectra.......%d\n", 
                           numberSpectra1);
       if1spc=0;
       }
      if (numberSpectra2==0&&sp_record.iband<=48) {
              if2spc++;
             spcband[sp_record.iband] = sp_record.iband;
             spcnchn[sp_record.iband] = sp_record.nch;
             spcfreq[sp_record.iband] = sp_record.fsky;
             chunkid[sp_record.iband] = sp_record.gaiidpha;
                }
      if ((numberSpectra2==0&&sp_record.iband<=24)&&if1spc==0) {
      numberSpectra2 = if2spc-numberSpectra1-1;
      fprintf(stderr, "number of IF2 Spectra............%d\n", 
      numberSpectra2);
      if2spc=0;
       }

//

//
// initialize the flag array
//
      sph[sp_record.sphid-1-nskip]->flag = -1;
//
// get the sign of wt
//
 if(fabs(sp_record.wt)>0) {
               sph[sp_record.sphid-1-nskip]->wt
                      = (short) (sp_record.wt / fabs(sp_record.wt));
                        } else {
               sph[sp_record.sphid-1-nskip]->wt = -1;
                               }
 if(dodebug==DEBUG)
            { 
      fprintf(stderr, 
      "sphid=%04d sp_record.sphid=%04d sp_count=%d nskip=%d\n",
      sph[sp_record.sphid-1-nskip]->sphid,
      sp_record.sphid,sp_count+1, nskip);
                                         exit(-1);
                      }
//
// loading chunk-based tsys
//
      sset = sp_record.sphid-1-nskip;
//
// blhid start from 1
// tsys array start from 0
//
      if(jday==2455925.5) blhid_off = 1;
      if(jday==2455926.5) blhid_off = 1;
      if(blhid_off==1) {
         tset = sph[sset]->blhid;
 if(sph[sset]->blhid==tsys[tset]->blhid-1)
      tsys[tset]->tssb[sp_record.iband] = sph[sset]->tssb;
         }else{  
         tset = sph[sset]->blhid-1;
 if(sph[sset]->blhid==tsys[tset]->blhid)
      tsys[tset]->tssb[sp_record.iband] = sph[sset]->tssb;
              }
      sp_count++;
 if(dodebug==DEBUG)      
      fprintf(stderr,
      "sset=%d tset=%d tsys[tset]->blhid=%d sph[sset]->blhid=%d\n", 
           sset, tset, tsys[tset]->blhid-1, sph[sset]->blhid);
     if(sph[sset]->blhid == 145655&&jday==2455926.5) goto spout;
     if(sph[sset]->blhid == 146789&&jday==2455925.5) goto spout;
           }
         }
     if(sph[sset]->inhid==inhid_rd) nRead_sp = -1;
   } while (nRead_sp > 0);
spout:
//
//MIR-IDL sp ID to miriad
//
        if(dodebug==DEBUG)        
        for (i=0; i<SMIF+1; i++) {
        fprintf(stderr, 
        "sp=%d spcband=%d spcnchn=%d fsky=%f gaiidpha=%d\n",
        i, spcband[i], spcnchn[i], spcfreq[i], chunkid[i]);
                    }

      
//
// determin number of polarizations
//
      fprintf(stderr, "number of polarizations..........%d\n:  ",numberPols);
       if(numberPols>2&&jjddaayy<POLDY) exit(-1);
       if(p1[0]==-5)  fprintf(stderr, "XX--non polarization\n");
       if(p1[1]==-1) {fprintf(stderr, ":  ");
                      fprintf(stderr, "RR,");}
       if(p1[2]==-3)  fprintf(stderr, "RL,");
       if(p1[3]==-4)  fprintf(stderr, "LR,");
       if(p1[4]==-2) {fprintf(stderr, "LL,");
                      fprintf(stderr, "--cir polarization\n");     
                     }
       if(numberPols>2&&jjddaayy<POLDY)
//        fprintf(stderr,
//        "Warning: mixed non-polarization with polarization.\n");
         
       if(numberPols>2&&jjddaayy<POLDY)
       {
//        fprintf(stderr,
//        perror(
//        "Fatal: this code has not been tested for polarization.\n");
//         exit(-1);
        }
//
// determine number of receiver
//
      numberReceivers=1;
      rx1=rx2=-1;
      for (i=0; i<nsets[1]-1; i++) {
      rx1=blh[i]->irec;
      if( blh[i]->inhid == inh[1]->inhid
          &&  blh[i]->irec != blh[i+1]->irec) {
      rx2=blh[i+1]->irec;
        numberReceivers = 2;
        break;
                                                  }
                                      }
   fprintf(stderr,
       "number of receivers..............%d:  ",
                numberReceivers);
   if(rx1!=-1) 
              switch(rx1) {
   case 0: fprintf(stderr, "rx1->230"); break;
   case 1: fprintf(stderr, "rx1->340"); break;
   case 2: fprintf(stderr, "rx1->400"); break;
   case 3: fprintf(stderr, "rx1->690"); break;
                          }
 
   if(rx2!=-1) 
           switch(rx2) {
   case 0: fprintf(stderr, ", rx2->230 "); break;
   case 1: fprintf(stderr, ", rx2->340 "); break;
   case 2: fprintf(stderr, ", rx2->400 "); break;
   case 3: fprintf(stderr, ", rx2->690 "); break;
                          }
           fprintf(stderr, 
                  "\n");
   if(rx1>3)
       { fprintf(stderr,
           "Fatal: ID of receiver_1 =%2d is not understood by this code.\n",
           rx1);
//
           exit(-1);
        }
   if(rx2>3)
       { fprintf(stderr,
           "Fatal: ID of receiver_2 =%2d is not understood by this code.\n",
           rx2);
//
           exit(-1);
        }


//
// determine jyperk for a specific receiver (now is for rx1)
//
  switch(rx1) {
  case 0: eta_a=0.75;    // jyperk=139. assuming eta_a=0.7 d=6m
                         // 230
          break;
  case 1: eta_a=0.6;     // jyperk=194. assuming eta_a=0.6 d=6m
                         // 340
          break;
  case 2: eta_a=0.5;     // jyperk=???. assuming eta_a=??? d=6m
                         // 400
          break;
  case 3: eta_a=0.4;     // jyperk=242. assuming eta_a=0.4 d=6m
                         // 690
          break;
                         }

   eta_c = 0.88;
   eta   = eta_a*eta_c;
//
// calculate jyperk
   jyperk=2.* 1.38e3/(float) DPI/(eta*r_ant*r_ant);
//
// write out jyperk
   uvputvrr_c(tno,"jyperk", &jyperk,1);


//
// determine number of sideband
//
{
  int lsb, usb;
  lsb = 0;
  usb = 0;
  numberSidebands = 0;
  for(i=0;i<nsets[1];i++) { if(blh[i]->isb == 0) lsb=1;
                            if(blh[i]->isb == 1) usb=1;
                          }
  numberSidebands = lsb + usb;
  if(numberSidebands == 1&&lsb==1)
        fprintf(stderr,
        "number of sidebands..............%d:  lsb\n",
               numberSidebands);
  if(numberSidebands == 1&&usb==1)
        fprintf(stderr,
        "number of sidebands..............%d:  usb\n",
               numberSidebands);
  if(numberSidebands == 2)
        fprintf(stderr,
        "number of sidebands..............%d:  lsb & usb\n",
               numberSidebands);
 }
//
// determine number of baseline
//
  for (inhid=0; inhid<nsets[0]; inhid++) {
     firstbsl= -1;
     lastbsl = -1; 
  for (set=0;set<nsets[1];set++) {
    if (firstbsl == -1 && 
      (blh[set]->inhid == inhid&& blh[set]->isb==input_isb)) {
     firstbsl = set;
    }
    if (firstbsl != -1 && 
      (blh[set]->inhid != inhid&& blh[set]->isb==input_isb)) {
     lastbsl = set - 1;
    }
    if (lastbsl != -1) break;
  }
  if(inhid==0){numberBaselines = lastbsl-firstbsl+1;
  fprintf(stderr, "number of baselines..............%d\n",
  numberBaselines/numberSidebands/numberReceivers);}
  else {
  if(inhid<nsets[0]-1-inhid_edrp&&numberBaselines!=lastbsl-firstbsl+1)
  fprintf(stderr,
  "Warning: inhid=%d has baseline of %d that differs from %d (for inhid=0) \n",
  inhid, lastbsl-firstbsl+1, numberBaselines/numberSidebands);
     }
    }
//
// determine number of antennas
//
  numberBaselines=numberBaselines/numberSidebands/numberReceivers;
   if(numberBaselines>28)
{ fprintf(stderr,
"Fatal: number of baselines =%3d exceeds the limit of the standard SMA array.\n",
         numberBaselines);
//
         exit(-1);
}

  numberAnts = (int)((1+sqrt(1.+8.*numberBaselines))/2.);
  fprintf(stderr, 
          "number of antennas...............%d\n",numberAnts);
  if(numberAnts>8) {
  perror ("......."".......""..........""........."); 
                    exit(-1);
                    }
//
// determine number of spectra per baseline per sideband
//
  blhid=blh[0]->blhid;
    firstsp = -1;
    lastsp  = -1;
  for (set=0;set<nsets[2];set++) {
    if (firstsp == -1 && sph[set]->blhid == blhid) {
       firstsp = set;
    }
    if (firstsp  != -1 && sph[set]->blhid != blhid) {
       lastsp  = set - 1;
    }
    if (lastsp  != -1) break;
  }
   numberSpectra = lastsp-firstsp+1;
   fprintf(stderr, 
       "number of spectra................%d\n",
         numberSpectra);
   if(numberSpectra>49) 
   { 
   fprintf(stderr, 
"Fatal: number of spectra =%3d exceeds the limit of SMA doubleband spectrometer.\n",
      numberSpectra);
//
      exit(-1);
   } 
   numberChannel = 0;
   firstsp = -1;
   for (set=0;set<nsets[2];set++) {
   if (firstsp == -1 && sph[set]->blhid == blhid) {
       firstsp = set;
    }
    if(set!=-1&&set < firstsp + numberSpectra) {
     numberChannel +=sph[set]->nch;
       if(dodebug==DEBUG)
       fprintf (stderr, 
         "sp=%d nch=%d ntot=%d\n",
             set-firstsp,sph[set]->nch, numberChannel);
    }else{ break; }
                                 }
fprintf(stderr,
       "number of channels...............%d\n",
             numberChannel);
//
//handling Tsys
//
fprintf(stderr,
        "solving for antenna-based Tsys...\n");
//
//goto tsysskip;
//
//
// solving the tsys matrix for antenna-based tsys
//
{
      int refant;
      int done;
      int pair1;
      int pair2;
      int blset;
      int iband;
      int iant;
//
// solve for tsys of a reference ante
//
      set=0;
      refant=0;
      pair1=0;
      pair2=0;
      blset=1;
//      printf("solving for tsys: prior to bl_loop nsets[1]=%d\n", nsets[1]);
//      exit(-1);
      for(blset=0; blset<nsets[1]; blset++) {
//      printf("solving for tsys: bl_loop blset=%d\n", blset);
//        if(set==nsets[0]-1) goto next;
          if(set==nsets[0]-1) goto next;
//           printf("solving for tsys: bl_loop set=%d nsets[0]=%d\n", set, nsets[0]);
          if(tsys[blset]->inhid!=inh[set]->inhid) {set++; refant=0;}
//
// choose rx
// 
        if(tsys[blset]->irec==input_rxif||input_rxif==-1) {
          if(tsys[blset]->inhid==inh[set]->inhid&&tsys[blset]->isb==input_isb) {
            if(refant==0) {
               refant=100;
//
// pick up a reference antenna
//
           atsys[set]->refant = tsys[blset]->itel1;
//
// solve for chunk-based tsys -----------------------------------
//

        for(iband=0; iband<MAXCHUNK+1; iband++)
        atsys[set]->tssb[atsys[set]->refant][iband]=tsys[blset]->tssb[iband];
//
//---------------------------------------------------------------
//
            atsys[set]->refpair1  = tsys[blset]->itel2;
             }
            }
           }
          }
    next:
if(dodebug==DEBUG) 
    fprintf(stderr,"solving for tsys: first step done\n");
      done=0;
      set=0;
//
// pick up reference pair
//
      for(blset=0; blset<nsets[1]; blset++) {
//        if(set==nsets[0]-1) goto nextnext;
         if(set==nsets[0]-5) goto nextnext;
        if(tsys[blset]->inhid!=inh[set]->inhid) {set++;done=0;}
        if(tsys[blset]->irec==input_rxif||input_rxif==-1) {
        if(tsys[blset]->inhid==inh[set]->inhid&&tsys[blset]->isb==0) {
        if(done==0) {
        if(tsys[blset]->itel1==atsys[set]->refant&&atsys[set]->refpair1!=tsys[blset]->itel2) {
                atsys[set]->refpair2 = tsys[blset]->itel2;
//
// solve for chunk-based
//
            for(iband=0; iband<MAXCHUNK+1; iband++)
                atsys[set]->tssb[atsys[set]->refant][iband] *=
                tsys[blset]->tssb[iband];
                done=100;
              }
            }
          }
        }
      }
      nextnext:
if(dodebug==DEBUG)
fprintf(stderr,"solving for tsys: 2nd step done\n");
//
// solve for tsys for the reference antenna
//
      set=0;
      for(blset=0; blset<nsets[1]; blset++) 
              {
        if(set==nsets[0]-1) goto nextnextnext;
        if(tsys[blset]->inhid!=inh[set]->inhid) 
              {set++; refant=0;}
        if(tsys[blset]->irec==input_rxif||input_rxif==-1) 
              {
        if(tsys[blset]->inhid==inh[set]->inhid&&tsys[blset]->isb==0) 
              {
        if((tsys[blset]->itel1==atsys[set]->refpair2&&
               tsys[blset]->itel2==atsys[set]->refpair1)||
              (tsys[blset]->itel2==atsys[set]->refpair2&&
               tsys[blset]->itel1==atsys[set]->refpair1)) 
              {
//
// solve for chunk-based
//
               for(iband=0; iband<MAXCHUNK+1; iband++)
            atsys[set]->tssb[atsys[set]->refant][iband] =
            atsys[set]->tssb[atsys[set]->refant][iband]/
                        tsys[blset]->tssb[iband];
            }
          }
        }
      }
    nextnextnext:
if(dodebug==DEBUG)
fprintf(stderr,"solving for tsys: 3rd step done\n");
//
// solve for Tsys for each antenna in the array
//

     set=0;
      for(blset=0; blset<nsets[1]; blset++) 
                     {
        if(set==nsets[0]-1) goto nnextnextnext;
        if(tsys[blset]->inhid!=inh[set]->inhid) 
                     {set++;}
        if(tsys[blset]->irec==input_rxif||input_rxif==-1) 
                     {
        if(tsys[blset]->inhid==inh[set]->inhid&&tsys[blset]->isb==0) 
                     {
        if(tsys[blset]->itel1==atsys[set]->refant) 
                     {
             for(iband=0; iband<MAXCHUNK+1; iband++)
             atsys[set]->tssb[tsys[blset]->itel2][iband] =
             tsys[blset]->tssb[iband]*tsys[blset]->tssb[iband]
             / atsys[set]->tssb[atsys[set]->refant][iband];
                     }
        if(tsys[blset]->itel2==atsys[set]->refant) 
                     {
             for(iband=0; iband<MAXCHUNK+1; iband++)
             atsys[set]->tssb[tsys[blset]->itel1][iband] =
             tsys[blset]->tssb[0]*tsys[blset]->tssb[0]
             /atsys[set]->tssb[atsys[set]->refant][iband];
            }
          }
        }
      }
    nnextnextnext:
if(dodebug==DEBUG)
fprintf(stderr,"solving for tsys: 4th step done\n");
//
// check up the solutions for antenna based tsys
//
     if(dodebug==DEBUG) 
                     {
            fprintf(stderr,
                        "solved for antenna-based Tsys\n");
                                exit(-1);
                      }
     if(dodebug==DEBUG) 
       for (set=0; set< nsets[0]-1; set++) {
       for (iant=1; iant<8; iant++) {
       fprintf(stderr,
              "set=%4d ant=%2d\n", set, iant);
       for (iband=1; iband<25; iband++)
       fprintf(stderr,
              "%3.0f ", atsys[set]->tssb[iant][iband]);
       fprintf(stderr,
              "\n");
       for (iband=25; iband<49; iband++)
       fprintf(stderr,
              "%3.0f ", atsys[set]->tssb[iant][iband]);
       fprintf(stderr,
              "\n");
                                    }
                                         }
                                              }
//
//tsysskip:
//
if(dodebug==DEBUG)
fprintf(stderr,"solving for tsys: all done!\n");
//
// handling source information
//
    sourceID = 0;
    for (set=0;set<nsets[3];set++)   {
//
// decode the spectral window (chunk) ids
//
    if((cdh[set]->v_name[0]=='b'&&cdh[set]->v_name[1]=='a')&&
     cdh[set]->v_name[2]=='n') 
              spcode[cdh[set]->icode]=spdecodedb(&cdh[set]);
           }
fprintf(stderr,"decode the spectral window (chunk) ids: done\n");
//
// decode velocity type
// 2 CODE NAME vctype  STRING vlsr  icode 0 ncode 1
// 3 CODE NAME vctype  STRING cz    icode 1 ncode 1
// 4 CODE NAME vctype  STRING vhel  icode 2 ncode 1
// 5 CODE NAME vctype  STRING pla   icode 3 ncode 1
//
    if(inh[1]->ivctype==0) {
//      printf("ivctype=%d\n", inh[1]->ivctype); 
//      strcpy(multisour[sourceID].veltyp, "VELO-LSR");
     strncpy(multisour[sourceID].veltyp, "VELO-LSR", 8);
//      printf("veltype=%s\n", multisour[sourceID].veltyp);
               }
    if(inh[1]->ivctype==2) {
//      strcpy(multisour[sourceID].veltyp, "VELO-HEL");
    strncpy(multisour[sourceID].veltyp, "VELO-HEL", 8);
                }
    if(inh[1]->ivctype!=0 && inh[1]->ivctype!=2) {
    fprintf(stderr,
             "ERROR: veltype ivctype=%d is not supported.\n",
             inh[1]->ivctype);
//
    exit(-1);
                                                 }
 if(dodebug==DEBUG)
               {
    fprintf(stderr, 
             "sourceID=%d veltyp=%s\n",
                   sourceID,multisour[sourceID].veltyp);
                                    exit(-1);
                      }
//
// write out velocity type
//    uvputvra_c(tno,"veltype", multisour[sourceID].veltyp);
//
//
fprintf(stderr, "decode velocity type: done\n");
//
// decode the source information
//
if(dodebug==DEBUG)
                 {
         fprintf(stderr, "nsets[3]=%d\n", nsets[3]);
                                      exit(-1);
                      }
     for (set=0;set<nsets[3];set++) {
if(dodebug==DEBUG)
                  {
         fprintf(stderr,"set=%d v_name=%s\n", set, cdh[set]->v_name);
                                exit(-1);
                      }
     if(cdh[set]->v_name[0]=='s'&&cdh[set]->v_name[1]=='o') { 
                sourceID = cdh[set]->icode;
//
// parsing the source name and trim the junk tail
     for(i=0; i<17; i++) {
        sours[i]=cdh[set]->code[i];
      if(cdh[set]->code[i]==32||cdh[set]->code[i]==0||i==16)
     sours[i]='\0';
                  }
//
// copy source name to the multiple source array with source ID
// as the array argument
//
           sprintf(multisour[sourceID].name, "%s", sours);
//
// now check up if the new sours name has been used in the
//  multiple source array
//
          for(i=2; i< sourceID; i++) {
          if(strcmp(multisour[i].name, sours)==0) {
//
// if the name has been used then the last character need to be changed
// copy the original source name to smasours
//
          for(i1=0; i1<33; i1++) {
          smasours[i1]=cdh[set]->code[i1];
          if(cdh[set]->code[i1]==32||cdh[set]->code[i1]==0||i1==32)
            smasours[i]='\0';
                              }
         oka=okb=okc=okd=0;
          if(multisour[sourceID].name[15]=='a') oka=-1;
          if(multisour[sourceID].name[15]=='b') okb=-1;
          if(multisour[sourceID].name[15]=='c') okc=-1;
          if(multisour[sourceID].name[15]=='d') okd=-1;
          if(oka==0) {  sours[15]='a';
          sprintf(multisour[sourceID].name, "%s", sours);
                     } else {
          if(okb==0) {sours[15]='b';
          sprintf(multisour[sourceID].name, "%s", sours);
                     } else {
          if(okc==0) {sours[15]='c';
          sprintf(multisour[sourceID].name, "%s", sours);
                     } else {
          if(okd==0) {sours[15]='d';
          sprintf(multisour[sourceID].name, "%s", sours);
                     }
                             }
                               }
                             }
          fprintf(stderr,
                "Warning: The original name: '%s' is renamed to '%s'\n",
    smasours, multisour[sourceID].name);
                                          }
                                                 }
    multisour[sourceID].sour_id = cdh[set]->icode;
    inhset=0;
//
// looking for the 1st inhset corresponding to  sour_id
//
        while (inh[inhset]->souid!=multisour[sourceID].sour_id)
        inhset++;
        multisour[sourceID].ra  = inh[inhset]->rar;
        multisour[sourceID].dec = inh[inhset]->decr;
//
// check source id and coordinates
//
        if((strncmp(multisour[sourceID].name,target,6)!=0)||
        (strncmp(multisour[sourceID].name,unknown,7)!=0)) {
//        fprintf(stderr,"multisour[%d].name %s\n", sourceID,multisour[sourceID].name);
        skipsrc=-1;
        for (i=1; i<sourceID+1; i++) {
        if(inh[inhset]->souid!=multisour[i].sour_id&&
        (multisour[i].ra==inh[inhset]->rar&&
         multisour[i].dec==inh[inhset]->decr)){
fprintf(stderr,
        "Warning: %s has the source id (%d) different from that (%d) of %s \n",
         multisour[sourceID].name,multisour[sourceID].sour_id,
         multisour[i].sour_id,multisour[i].name);
fprintf(stderr,
         "but their coordinates are the same:\n RA=%13s",
         (char *)rar2cdb(multisour[sourceID].ra));
fprintf(stderr,"  Dec=%14s\n",
         (char *)decr2cdb(multisour[sourceID].dec));
        if((inhset< (nsets[0]-1))&&(strncmp(multisour[sourceID].name,unknown,7)!=0))
        { inhset++; skipsrc=1;} }
                                   }
        if(skipsrc==1)  {
        while (inh[inhset]->souid!=multisour[sourceID].sour_id)
        inhset++;
fprintf(stderr, 
        "Warning: found the next integration for %s of id=%d at inhset=%d ",
        multisour[sourceID].name, inh[inhset]->souid, inhset);
        multisour[sourceID].ra  = inh[inhset]->rar;
        multisour[sourceID].dec = inh[inhset]->decr;
fprintf(stderr,
                "with coordinates:\n RA=%13s",
                 (char *)rar2cdb(multisour[sourceID].ra));
fprintf(stderr,
                "  Dec=%14s\n",
                 (char *)decr2cdb(multisour[sourceID].dec));
fprintf(stderr, 
                "Update the coordinates for %s of id=%d\n",
                 multisour[sourceID].name, inh[inhset]->souid);
                                   }
               }
//
//calculate the apparent position coordinates from j2000 coordinates
//
           {
          double obsra,obsdec,r1,d1;
          double julian2000=2451544.5;
          precessdb(julian2000,
                  multisour[sourceID].ra,
                  multisour[sourceID].dec, jday, &obsra, &obsdec);
          nutatedb(jday,obsra,obsdec,&r1,&d1);
          aberratedb(jday,r1,d1,&obsra,&obsdec);
          multisour[sourceID].ra_app   = obsra;
          multisour[sourceID].dec_app  = obsdec;
          multisour[sourceID].qual     = 0;
          multisour[sourceID].pmra     = 0.;
          multisour[sourceID].pmdec    = 0.;
          multisour[sourceID].parallax = 0.;
          strncpy(multisour[sourceID].veldef, "radio", 5);
          strncpy(multisour[sourceID].calcode, "c", 1);
           }
      }
    }
        if(sourceID> MAXSOURCE) {
             fprintf(stderr,
             "ERROR: Number of sources exceeded the limit %d\n", 
             MAXSOURCE);
//
             exit(-1);
                                     }
    if(dodebug==DEBUG)
             {
             fprintf(stderr,"sourceID=%d\n", sourceID);
//
             exit(-1);
                      }

//
// print out sources observed
//
fprintf(stderr,
        "sources found in the file........\n");       
         for (i=1; i< sourceID+1; i++) {
         if(multisour[i].sour_id==0)
           strncpy(multisour[i].name, "skipped!", 8);
           fprintf(stderr,"%-21s id=%3d RA=%13s ",
           multisour[i].name,
           multisour[i].sour_id,
           (char *)rar2cdb(multisour[i].ra));
           fprintf(stderr,"DEC=%12s\n", 
                         (char *)decr2cdb(multisour[i].dec));
                                                             }
//
// read vis data
//
fprintf(stderr,
        "reading visibilities.............");
fprintf(stderr,
               "inhid  time(UTC) int(s) percent Gbyt W-status\n");

//
//  fd = fopen("./sch_read", "r");
//
  fd = fopen(location[5], "r");
  if (fd < 0) {
    perror("open");
//
    exit(-1);
  }
//
// read the headers of data
//
     nRead=1;
     data_start_pos = (long int*)malloc(nsets[0]*sizeof(long int));
     rewind(fd);
  for (inhset=0; inhset<nsets[0]; inhset++) { 
//
// Swap the bytes in place 
//
    if (nRead > 0) {
      data_start_pos[inhset] = ftell(fd);
      nRead = fread(&record.inhid, sizeof(record.inhid), 1, fd);
      nRead = fread(&record.form, sizeof(record.form),1, fd);
      nRead = fread(&record.nbyt,sizeof(record.nbyt),1, fd);
      nRead = fread(&record.nbyt_pack,sizeof(record.nbyt_pack),1, fd);
      if(doswap>0) {
      byteswap(&record.inhid, sizeof(record.inhid));
      byteswap(&record.form, sizeof(record.form));
      byteswap(&record.nbyt, sizeof(record.nbyt));
      byteswap(&record.nbyt_pack, sizeof(record.nbyt_pack));
          }
      fseek(fd,record.nbyt,SEEK_CUR);
if(dodebug==DEBUG)
          { 
    fprintf(stderr, 
      "count=%d inhid=%d nbyt=%d nbyt_pack=%d data_start_pos=%d form=%s\n", 
       count,
       record.inhid,
       record.nbyt,
       record.nbyt_pack,
       (int)data_start_pos[inhset],
       record.form);
                                exit(-1);
                      }
if(dodebug==BRIEFDEBUG)
               { 
    fprintf(stderr, 
            "record.inhid =%d count=%d\n",
             record.inhid, 
             count);
                                    exit(-1);
                      }
    count++;
    }
  } 
//
// read the body of the data
//
        rewind(fd);
if(testlev!=TSTLEV) 
                         exit(-1);
//
//skip the first integration
        inhset=0;
        blhset=0;
        sphset=0;
        dbut = (inh[inhset]->UTCtime-jday)*DPI*2.0;
        uvputvrd_c(tno,"ut",&(dbut),1);
if(dodebug==DEBUG) 
            {
           fprintf(stderr,"dbut %f\n", dbut);
//
                                 exit(-1);
                      }
//
// write out velocity type
{
        uvputvra_c(tno,"veltype",inh[0]->vtype);
        veldop = inh[0]->veldop; 
        uvputvrr_c(tno,"veldop",&(veldop),1);
        vsource = 0.0;
        uvputvrr_c(tno,"vsource",&(vsource),1);
//
//initialize
        dbsourceID = inh[inhset]->souid;
        dbobsra  = multisour[dbsourceID].ra_app;
        dbobsdec = multisour[dbsourceID].dec_app;
        dbra     = multisour[dbsourceID].ra;
        dbdec    = multisour[dbsourceID].dec;
        dblst    = (double) inh[inhset]->ha*DPI/12.0 + dbobsra;
//loading el az and tsys to smabuffer
      for (i=0; i<numberAnts; i++) {
//mir inh file gives the mean el and mean az
        dbel[i] = inh[inhset]->el;
        dbaz[i] = inh[inhset]->az;
                                   }
        uvputvrd_c(tno,"antaz",&(dbaz), MAXANT);
        uvputvrd_c(tno,"antel",&(dbel), MAXANT);
        uvputvrd_c(tno,"lst",&(dblst),1);
//        if(inhset==0) dbtau0 = sph[0]->tau0;
//        uvputvrr_c(tno,"tau0", &(dbtau0),1);
//        printf("inh=%d tau=%f", inhset,dbtau0);
//calculate parallatic angle
         evec = evec1;
         ha   = dblst - dbobsra;
         sinq = cos(lat1)*sin(ha);
         cosq = sin(lat1)*cos(dbobsdec) -
                cos(lat1)*sin(dbobsdec)*cos(ha);
         chi  = (float) atan2(sinq,cosq);
// uvredo: for Nasmyth SMA Needs to be modified by elev
// uncertainty in elev is 0.0001 radians.
       sinha = sin(ha);
       cosha = cos(ha);
        sind = sin(dbobsdec);
        cosd = cos(dbobsdec);
        sinl = sin(lat1);
        cosl = cos(lat1);
        elev = asin(sinl*sind+cosl*cosd*cosha);
        chi  = evec + chi - (float) elev;
        chi2 = (float)(-elev);
      uvputvrr_c(tno,"chi", &chi,1);
      uvputvrr_c(tno,"chi2", &chi2,1);
// 
// write out source
        strncpy(dbsour, multisour[dbsourceID].name, 17);
        uvputvra_c(tno,"source", dbsour);
if(dodebug==DEBUG) 
          {
             fprintf(stderr, "dbsour=%s\n",  dbsour);
                               exit(-1);
                      }
        uvputvrd_c(tno,"ra",&(dbra),1);
        uvputvrd_c(tno,"dec",&(dbdec),1);
 
// store the true pointing position 
        dbrar = inh[inhset]->rar;
        uvputvrd_c(tno,"pntra",  &dbrar,1);
        dbdecr = inh[inhset]->decr;
        uvputvrd_c(tno,"pntdec", &dbdecr,1);
        uvputvrd_c(tno,"obsra",  &(dbobsra),1);
        uvputvrd_c(tno,"obsdec", &(dbobsdec),1);
        uvputvra_c(tno,"calcode",multisour[dbsourceID].calcode);
        uvputvri_c(tno,"sourid", &dbsourceID, 1);
       if(dodebug==DEBUG) 
             fprintf(stderr,
                     "dbsourceID %d\n", 
                      dbsourceID);
} 

//        while (sphset<nsets[2]-1) {
//        while (inh[inhset]->inhid<sph[sphset]->inhid)
//        for (inhset=1; inhset<nsets[0]; inhset++)
//        while (inhset<nsets[0])
//
        dbtau0 = sph[0]->tau0;
        uvputvrr_c(tno,"tau230", &dbtau0,1);
        do
        {
if(dodebug==DEBUG)
            {
      fprintf(stderr, "inhset=%d \n", inhset);
                                    exit(-1);
                      }
        dbut = (inh[inhset]->UTCtime-jday)*DPI*2.0; 
        uvputvrd_c(tno,"ut",&(dbut),1);
        if(inhset>0&&inh[inhset]->vtype!=inh[inhset-1]->vtype)
        {
//
// write out velocity type and doppler velocity
        uvputvra_c(tno,"veltype",inh[inhset]->vtype);
//     
        veldop  = inh[inhset]->veldop;
//      fprintf(stderr, "veldop=%f\n", veldop);
        uvputvrr_c(tno,"veldop",&veldop,1);
        vsource = 0.0;
        uvputvrr_c(tno,"vsource",&(vsource),1);
         if(dodebug==DEBUG)
                   {
             fprintf(stderr,"vsource %f\n", vsource);
//
                                      exit(-1);
                      }
        }
// 
// work out source information to write out
{ 
//  int    dbsourceID;
//  double dbobsra;
//  double dbobsdec;
//  double dbra;
//  double dbdec;
//  double dblst;
//  double dbel[MAXANT];
//  double dbaz[MAXANT];
//  double dbrar;
//  double dbdecr;
//  char   dbsour[17];
        dbsourceID = inh[inhset]->souid;
        dbobsra  = multisour[dbsourceID].ra_app;
        dbobsdec = multisour[dbsourceID].dec_app;
        dbra     = multisour[dbsourceID].ra;
        dbdec    = multisour[dbsourceID].dec;
        dblst    = (double) inh[inhset]->ha*DPI/12.0 + dbobsra;
//         fprintf(stderr,"lst=%f ha=%f obsra=%f\n", dblst, inh[inhset]->ha, dbobsra);
//loading el az and tsys to smabuffer
      for (i=0; i<numberAnts; i++) {
//mir inh file gives the mean el and mean az
        dbel[i] = inh[inhset]->el;
        dbaz[i] = inh[inhset]->az;
                                      }
        uvputvrd_c(tno,"antaz",&(dbaz), MAXANT);
        uvputvrd_c(tno,"antel",&(dbel), MAXANT);
        uvputvrd_c(tno,"lst",&(dblst),1);
//calculate parallatic angle
         evec = evec1;
         ha   = dblst - dbobsra;
         sinq = cos(lat1)*sin(ha);
         cosq = sin(lat1)*cos(dbobsdec) -
                cos(lat1)*sin(dbobsdec)*cos(ha);
         chi  = (float) atan2(sinq,cosq);
// uvredo: for Nasmyth SMA Needs to be modified by elev
// uncertainty in elev is 0.0001 radians.
         sinha = sin(ha);
         cosha = cos(ha); 
         sind = sin(dbobsdec);
         cosd = cos(dbobsdec);
         sinl = sin(lat1);
         cosl = cos(lat1);
         elev = asin(sinl*sind+cosl*cosd*cosha);
         chi  = evec + chi - (float) elev;
         chi2 = (float)(-elev);
      uvputvrr_c(tno,"chi", &chi,1);
      uvputvrr_c(tno,"chi2", &chi2,1);
//
// write out source
        strncpy(dbsour, multisour[dbsourceID].name, 17);
        uvputvra_c(tno,"source", dbsour);
if(dodebug==DEBUG)
                { 
          fprintf(stderr, 
                  "dbsour=%s\n",  
                      dbsour);
                                    exit(-1);
                      }
        uvputvrd_c(tno,"ra",&(dbra),1);
        uvputvrd_c(tno,"dec",&(dbdec),1);

// store the true pointing position 
        dbrar = inh[inhset]->rar;
        uvputvrd_c(tno,"pntra",  &dbrar,1);
        dbdecr = inh[inhset]->decr;
        uvputvrd_c(tno,"pntdec", &dbdecr,1);
        uvputvrd_c(tno,"obsra",  &(dbobsra),1);
        uvputvrd_c(tno,"obsdec", &(dbobsdec),1);
        uvputvra_c(tno,"calcode",multisour[dbsourceID].calcode);
        uvputvri_c(tno,"sourid", &dbsourceID, 1);  
}

if(dodebug==DEBUG)
                 {
    fprintf(stderr,"calcode=%s id=%d\n", 
             multisour[dbsourceID].calcode,
             dbsourceID);
//
                                  exit(-1);
                      }
if(dodebug==DEBUG)
                 { 
    fprintf(stderr,
            "inhset=%d  dbsourceID=%d\n",
             inhset, 
             dbsourceID);
//
                                   exit(-1);
                      }
if(inhset==0) {
    fprintf(stderr,
            "inhset=.........................");
             ipnt=0;}
if(fmod(inhset, 4.)<0.5) {
    fprintf(stderr,
            ".");
            ipnt++;}
if(fmod(inhset, 100.)==0.)
// 
// work out printing msg for scans
//
                                 {
int utcd;
int utch;
int utcm;
int utcs;
int prcnt;
double dhrs;
         if(dodebug==DEBUG) 
                  {
           fprintf(stderr,
             "inh[inhset]->UTCtime=%f  jday=%f\n", 
               inh[inhset]->UTCtime,jday);
                                        exit(-1);
                      }
          dhrs = (double)((inh[inhset]->UTCtime-jday)*24.0);
         if(dodebug==DEBUG) 
           fprintf(stderr,"dhrs=%f\n", 
               dhrs);
      utch  = (int)dhrs;
      if(utch>24 || utch==24) {
          utcd =1;
            } else {
          utcd =0;
            }
      utcm  = (dhrs-utch)*60;
      utcs  = ((dhrs-utch)*60.0 - utcm)*60;
      prcnt = (int) (100.*(inhset+1)/(numberIntegrations-inhid_edrp));
      if(st_save>0) {
      fprintf(stderr,
        "%05d %1dd%02d:%02d:%02d  %04.1f  %03d %s %04.2f  OK\n", 
        inhset,
        utcd,
        utch,
        utcm,
        utcs,
        inh[inhset]->rinteg,
        prcnt,"(%)", (float)(bytepos)/1000./1000./1000.);
           } else {
       fprintf(stderr,
        "%05d %1dd%02d:%02d:%02d  %04.1f  %03d %s %04.2f  NO\n",
        inhset,
        utcd,
        utch,
        utcm,
        utcs,
        inh[inhset]->rinteg,
        prcnt,"(%)", (float)(bytepos)/1000./1000./1000.);
               }
//                                  }

//        if(fmod(inhset, 100.)==0.||inhset==1) 
           if(fmod(inhset, 100.)==0) 
                                    {
                 fprintf(stderr,
                         "inhset=.");
                             ipnt=0;
                                    }
                              }
//
// end of printing msg for scans
//
        if(dodebug==DEBUG)
           {
        fprintf(stderr,
                "sphset=%d sph[sphset]->inhid=%d\n", 
                sphset, 
                sph[sphset]->inhid);
                                  exit(-1);
                      }
//
// initially search for relevant inhid by skipping blhset
if(dodebug==DEBUG)
               {
        fprintf(stderr, "inhset=%d blhset=%d my_isb=%d\n", 
                inhset, 
                blhset, 
                blh[blhset]->isb);
                              exit(-1);
                      }
if(dodebug==DEBUG)
        if(blhset==0)
        while (blh[blhset]->inhid < inh[inhset]->inhid)
              { 
        blhset++;
        if(dodebug==DEBUG)
        fprintf(stderr,"i: blhset = %d  inhset = %d\n", 
                           blhset,
                           inhset);
                }
if(dodebug==DEBUG)
            {
   fprintf(stderr,
 "o: blhset=%d inhset=%d isb=%d blh[blhset]->inhid=%d inh[inhset]->inhid=%d\n", 
       blhset, 
       inhset, 
       blh[blhset]->isb, 
       blh[blhset]->inhid, 
       inh[inhset]->inhid);
                              exit(-1);
                      }
//
// search for input side band by skipping blhset
if(dodebug==DEBUG)    
                {         
   fprintf(stderr, 
  "blh[blhset]->isb=%d input_isb=%d\n", 
                    blh[blhset]->isb, 
                    input_isb);
                                  exit(-1);
                      }  
/*        while(blh[blhset]->isb != input_isb)
               {
                blhset++;
        if(dodebug==DEBUG)
            fprintf(stderr,"i: blhset = %d  inhset = %d blh[blhset]->isb = %d\n", 
                   blhset, inhset, blh[blhset]->isb);
                              }
*/
if(dodebug==DEBUG)      
                  {     
   fprintf(stderr, 
       "o: blhset = %d  inhset = %d blh[blhset]->isb = %d\n",
                   blhset, 
                   inhset, 
                   blh[blhset]->isb);
                                       exit(-1);
                      }
//
// initially search for relevant blhid by skipping sphset
 if(dodebug==DEBUG)
         if(sphset==0)
         while (sph[sphset]->blhid<blh[blhset]->blhid)
              {
                sphset++;
if(dodebug==DEBUG)
                     {
       fprintf(stderr, 
                    "i: sphset = %d  blhset = %d\n", 
               sphset,
               blhset);
                                     exit(-1);
                      }
                }
if(dodebug==DEBUG)
                   {
   fprintf(stderr, 
                    "o: sphset=%d blhset=%d inhset=%d\n", 
               sphset,
               blhset,
               inhset);
                                      exit(-1);
                      }
if(dodebug==DEBUG)
                   {
   fprintf(stderr,
   "o: sph[sphset-1]->blhid=%d sph[sphset]->blhid=%d blh[blhset]->blhid=%d\n",
              sph[sphset-1]->blhid, 
              sph[sphset]->blhid, 
              blh[blhset]->blhid);
                                                exit(-1);
                      }
//   while (blh[blhset]->blhid < sph[sphset]->blhid)
if(dodebug==DEBUG)
                   {
   fprintf(stderr,
   "oo:blhset=%d blh[blhset]->inhid=%d inhset=%d inh[inhset]->inhid=%d\n",
            blhset, 
            blh[blhset]->inhid , 
            inhset, 
            inh[inhset]->inhid);
                                      exit(-1);
                      }
if(dodebug==DEBUG)
               {
   fprintf(stderr, 
               "\n inhset=%d inh[inhset]->inhid=%d\n", 
               inhset, 
               inh[inhset]->inhid);
                                    exit(-1);
                      }
//    while (blh[blhset]->inhid < inh[inhset]->inhid)   
     do    
     {
if(dodebug==DEBUG)
                 {
    fprintf(stderr, 
              "\n inhset=%d inh[inhset]->inhid=%d\n",
               inhset, 
               inh[inhset]->inhid);
                                         exit(-1);
                      }
if(dodebug==DEBUG)
             {
    fprintf(stderr, 
              "z: sphset=%d blhset=%d inhset=%d isb=%d\n",
                             sphset,
                             blhset,
                             inhset, 
                             blh[blhset]->isb);
                                        exit(-1);
                      }
if(dodebug==DEBUG)
                  {
        fprintf(stderr,
                "blhid=%d  inhid=%d blhset=%d \n",
                  blh[blhset]->blhid, 
                  blh[blhset]->inhid, 
                  blhset);
                                     exit(-1);
                      }
if(dodebug==DEBUG)
                    {
        fprintf(stderr,
                "blhset=%d blh[blhset]->blhid=%d sph[sphset]->blhid=%d\n", 
                 blhset, 
                 blh[blhset]->blhid, 
                 sph[sphset]->blhid);
                                     exit(-1);
                      }
//
// work out miriad header
//
//      write out the nnumber of nspect - number of the spectral chunks.
//49        nspect = numberSpectra-1;
        nspect = numberSpectra;
        uvputvri_c(tno,"nspect",&(nspect),1);
        if(dodebug==DEBUG)
                   { 
        fprintf(stderr, "write nspect=%d\n", nspect);
                                    exit(-1);
                      }
//
//do frequency correction
//
//49        for(i=1; i<numberSpectra; i++)  {
       for(i=0; i<numberSpectra; i++)  {
        sfres[i] = sph[sphset+i]->fres;
        sfoff[i] = 0.0;
             }
        if (jday < 2454430.500000 ) sfcorr (sfoff, sfres);
        ischan[0] =1;
        if( input_isb ==0) 
//49        for(i=1; i<numberSpectra; i++)  {
        for(i=0; i<numberSpectra; i++)  {
     if(dodebug==DEBUG)
              {  
        fprintf(stderr, 
                "\n sph[sphset+i]->nch=%d i=%d sphset+i=%d",
                sph[sphset+1]->nch,
                i,
                sphset+1);
                                exit(-1);
                      }
//
// make sure sph is lined up with blh
//
     if(dodebug==DEBUG)
        {
         fprintf(stderr,
              "\n i=%d sph[sphset+i]->blhid=%d blh[blhset]->blhid=%d", 
                           i, 
                           sph[sphset+i]->blhid,
                           blh[blhset]->blhid);
                              exit(-1);
                      }
//
//spectral header
//
//49       iband[i-1] = sph[sphset+i]->iband;
       iband[i] = sph[sphset+i]->iband;
       if (doave==1) {
       avenchan = sph[sphset+i]->nch/rsnchan;
//49
    if(i>0) {
       ischan[i]=ischan[i-1]+sph[sphset+i]->nch/avenchan;
            nschan[i]=sph[sphset+i]->nch/avenchan;
       sfreq[i]=sph[sphset+i]->fsky -
           (double)sph[sphset+i]->fres/1000.*
                     (sph[sphset+i]->nch/2 -0.5) + sfoff[i];
       sdf[i]=(double)sph[sphset+i]->fres/1000.*avenchan;
               }
         if(i==0) {
       nschan[i]=sph[sphset+i]->nch;
       sfreq[i]=sph[sphset+i]->fsky -
           (double)sph[sphset+i]->fres/1000.*
                     (sph[sphset+i]->nch/2 -0.5) + sfoff[i];
       sdf[i]=(double)sph[sphset+i]->fres/1000.;
               }
//       ischan[i]=ischan[i-1]+sph[sphset+i]->nch/avenchan;
//       nschan[i-1]=sph[sphset+i]->nch/avenchan;
//       sfreq[i-1]=sph[sphset+i]->fsky -
//           (double)sph[sphset+i]->fres/1000.*
//                     (sph[sphset+i]->nch/2 -0.5) + sfoff[i];
//       sdf[i-1]=(double)sph[sphset+i]->fres/1000.*avenchan;
                     } else {
      if(i>0)     
          ischan[i]=ischan[i-1]+sph[sphset+i]->nch;
       nschan[i]=sph[sphset+i]->nch;
       sfreq[i]=sph[sphset+i]->fsky -
           (double)sph[sphset+i]->fres/1000.*
                     (sph[sphset+i]->nch/2 -0.5) + sfoff[i];
       sdf[i]=(double)sph[sphset+i]->fres/1000.;

//       nschan[i-1]=sph[sphset+i]->nch;
//       sfreq[i-1]=sph[sphset+i]->fsky -
//           (double)sph[sphset+i]->fres/1000.*
//                     (sph[sphset+i]->nch/2 -0.5) + sfoff[i];
//       sdf[i-1]=(double)sph[sphset+i]->fres/1000.;
                  }
//       restfreq[i-1]=sph[sphset+i]->rfreq;
         restfreq[i]=sph[sphset+i]->rfreq;
       if(dodebug==DEBUG)
              {
          fprintf(stderr,
          "\n i-1=%d iband[i-1]=%d ischan[i-1]=%d sdf[i-1]=%f freq[i-1]=%f",
              i-1, 
              iband[i-1], 
              ischan[i-1], 
              sdf[i-1], 
              sfreq[i-1]); 
                              exit(-1);
                      }
          } 

       if(input_isb ==1)
//49        for(i=1; i<numberSpectra; i++)  {
      for(i=0; i<numberSpectra; i++)  {
if(dodebug==DEBUG)
               {
        fprintf(stderr,
                "\n sph[sphset+i]->nch=%d i=%d sphset+i=%d",
                sph[sphset+1]->nch,i,sphset+1);
                                  exit(-1);
                      }
//
// make sure sph is lined up with blh
//
if(dodebug==DEBUG)
               {
        fprintf(stderr,
               "\n i=%d sph[sphset+i]->blhid=%d blh[blhset]->blhid=%d",
                                       i,
                                       sph[sphset+i]->blhid,
                                       blh[blhset]->blhid); 
                                exit(-1);
                      }
//
//
//49             iband[i-1] = sph[sphset+i]->iband;
//
        iband[i] = sph[sphset+i]->iband;
               if (doave==1) {
       avenchan = sph[sphset+i]->nch/rsnchan;
       if(i>0) {
       ischan[i]=ischan[i-1]+sph[sphset+i]->nch/avenchan;
       nschan[i]=sph[sphset+i]->nch/avenchan;
       sfreq[i]=sph[sphset+i]->fsky -
           (double)sph[sphset+i]->fres/1000.*
                     (sph[sphset+i]->nch/2 -0.5) + sfoff[i];
       sdf[i]=(double)(sph[sphset+i]->fres/1000.*avenchan);
                }
        if(i==0) {
       nschan[i]=sph[sphset+i]->nch;
       sfreq[i]=sph[sphset+i]->fsky -
           (double)sph[sphset+i]->fres/1000.*
                     (sph[sphset+i]->nch/2 -0.5) + sfoff[i];
       sdf[i]=(double)(sph[sphset+i]->fres/1000.);
                }

//
//       nschan[i-1]=sph[sphset+i]->nch/avenchan;
//       sfreq[i-1]=sph[sphset+i]->fsky -
//           (double)sph[sphset+i]->fres/1000.*
//                     (sph[sphset+i]->nch/2 -0.5) + sfoff[i];
//       sdf[i-1]=(double)(sph[sphset+i]->fres/1000.*avenchan);
                     } else {
          if(i>0)
             ischan[i]=ischan[i-1]+sph[sphset+i]->nch;
             nschan[i]=sph[sphset+i]->nch;
             sfreq[i]=sph[sphset+i]->fsky -
                  (double)sph[sphset+i]->fres/1000.*
                     (sph[sphset+i]->nch/2. -0.5) + sfoff[i];
             sdf[i]=(double)(sph[sphset+i]->fres/1000.);
//             nschan[i-1]=sph[sphset+i]->nch;
//             sfreq[i-1]=sph[sphset+i]->fsky - 
//                  (double)sph[sphset+i]->fres/1000.*
//                     (sph[sphset+i]->nch/2. -0.5) + sfoff[i];
//             sdf[i-1]=(double)(sph[sphset+i]->fres/1000.);
                              }
//             restfreq[i-1]=sph[sphset+i]->rfreq;
               restfreq[i]=sph[sphset+i]->rfreq;
if(dodebug==DEBUG)
             {
       fprintf(stderr,
        "\n i-1=%d iband[i-1]=%d ischan[i-1]=%d sdf[i-1]=%f fres=%f freq[i-1]=%f",
             i-1, 
             iband[i-1], 
             ischan[i-1], 
             sdf[i-1],
             (double)(sph[sphset+i]->fres)*2./1000.,
             sfreq[i-1]);
                                     exit(-1);
                      }
             }
//
//while(sphset-i>0&&sph[sphset-i-1]->blhid<blh[blhset]->blhid);
//    fprintf(stderr,"\n");
//              exit(-1);
/*         ischan[0] = 1; 
        for (ifs = 1; ifs < numberSpectra; ifs++) {
        ischan[ifs]=ischan[ifs-1]+ischan[ifs];
      if(dodebug==DEBUG)        
        fprintf(stderr, 
                "ischan[%d]=%d nschan=%d sfreq=%f sdf=%f rfreq=%f \n", 
                 ifs,ischan[ifs],nschan[ifs],sfreq[ifs],sdf[ifs],restfreq[ifs]);
        }
      if(dodebug==DEBUG)
                 fprintf(stderr,
                 "\n");
*/
//
// write the header parameters for each baseline record
//
if(dodebug==DEBUG)
 {
    fprintf(stderr, "\n inhset=%d\n",
            inhset);
                               exit(-1);
                      }
if(blh[blhset]->isb==input_isb) {
      if(dodebug==DEBUG)
             {
           fprintf(stderr, "\n select sideband=%d\n", 
                            blh[blhset]->isb);
                                   exit(-1);
                      } 
//
// spectral information
//
// write out parameters for the spectral headers
//
//        printf("write out spectral header.\n");
// number of spectral windows
        uvputvri_c(tno,"nspect",&(nspect),sspect);
// start channel
//      uvputvri_c(tno,"ischan",&(ischan),numberSpectra-1);
        uvputvri_c(tno,"ischan",ischan,nspect);
// number of spectral channels
//      uvputvri_c(tno,"nschan",&(nschan),numberSpectra-1);
        uvputvri_c(tno,"nschan",nschan,nspect);
if(dodebug==DEBUG)
            {
        for(i=1; i<nspect+1;i++)
           fprintf(stderr, "\n nschan=%d",  
                     nschan[i]);
                   exit(-1);
                     }
// sky-frequency
if(dodebug==DEBUG) 
        for (i=0; i<numberSpectra; i++) 
        {
        fprintf(stderr, 
                "%i %f\n",
                     i, 
                            sfreq[i]);
        }   
if(dodebug==DEBUG) 
              {
        fprintf(stderr,
            "numberSpectra-1=%d\n", 
             numberSpectra-1);
                                      exit(-1);
                      }
//
// uvputvrd_c(tno,"sfreq",&(sfreq),numberSpectra-1);
      uvputvrd_c(tno,"sfreq", sfreq,nspect);
// spectral resolution
 if(dodebug==DEBUG)
       for (i=0; i<numberSpectra; i++)
        {
        fprintf(stderr, "%i sdf=%f\n", i,sdf[i]*10.);
        }
      uvputvrd_c(tno,"sdf",&sdf,nspect);
// rest frequency
      uvputvrd_c(tno,"restfreq",restfreq,nspect);
// rest frequency for the primary line
      pfreq = restfreq[0];
      uvputvrd_c(tno,"freq",&(pfreq),1);
//
// store system temperature
      tsysStoredb(tno,dbnants,inhset);
//
// polarization information
//
{
int npol;
int ipol;
      npol=1;  
// 
      ipol=blh[blhset]->polcode;
//
// number of polarization
      uvputvri_c(tno,"npol",&npol,1);
// polarization component
      uvputvri_c(tno,"pol",&ipol,1);
} 
}
//
// baseline information
//
if(dodebug==DEBUG)
             {
    fprintf(stderr,"\n inhset=%d\n", inhset);
                                   exit(-1);
                      }
if(dodebug==DEBUG)
             {
    fprintf(stderr,
  "sph[sphset]->iband=%d sph[sphset]->fsky=%f sphset=%d blhset=%d inhset=%d\n",
                sph[sphset]->iband,
                sph[sphset]->fsky,
                sphset,
                blhset,
                inhset);
                            exit(-1);
                      }
//
// get the basefrequency
if(sph[sphset]->iband==0) 
      blh[blhset]->basefreq = sph[sphset]->fsky;
      preamble[0] = -blh[blhset]->u/blh[blhset]->basefreq*1000.;
      preamble[1] = -blh[blhset]->v/blh[blhset]->basefreq*1000.;
      preamble[2] = -blh[blhset]->w/blh[blhset]->basefreq*1000.;
      preamble[3] = inh[inhset]->UTCtime;
      preamble[4] = (double)blh[blhset]->blcode;
if(dodebug==DEBUG) if(blhset>2) exit(0);
//--- if(blh[blhset]->isb==input_isb)  {
if(dodebug==DEBUG)
             { 
    fprintf(stderr,
          "inhset=%d data_start_pos[inhset]=%d blhset=%d sphset=%d\n",
               inhset, 
                (int) data_start_pos[inhset], 
                  blhset, 
                    sphset);
                                    exit(-1);
                      }

if(dodebug==DEEPDEBUG)
                 {
    fprintf(stderr,
          "\n blhset=%d blhid=%d sphset=%d blsid=%d isb=%d\n",
                 blhset,
                  blh[blhset]->blhid,
                   sphset,
                    blh[blhset]->blsid,
                     blh[blhset]->isb
                      );
                                     exit(-1);
                      }
//c1
        ivis=0;
        datalength = 5 + 2*sph[sphset]->nch;
if(dodebug==DEBUG)
               {
    fprintf(stderr,"c1: sph[sphset]->nch=%d sphset=%d \n", sph[sphset]->nch, sphset);
                                  exit(-1);
                      }
if(dodebug==DEBUG)
              {
    fprintf(stderr,"c1:sphset=%d sph[sphset]->iband=%d sph[sphset]->dataoff=%d\n",
              sphset,
              sph[sphset]->iband,
              sph[sphset]->dataoff);
                               exit(-1);
                      } 
        shortdata = (short int* )malloc(datalength*sizeof(short int));
        bytepos = 16 + data_start_pos[inhset] + sph[sphset]->dataoff;
        fseek(fd,bytepos,SEEK_SET);
        nRead = fread(shortdata,datalength*sizeof(short int),1,fd);
        if(doswap>0) 
             shortdata=swap_sch_dbdata(shortdata, datalength);
        inttime = (int)(shortdata[0]/10.);
//
// write out integration time
//
        uvputvrr_c(tno,"inttime",&inttime,1);
if(dodebug==DEBUG) 
        {
  fprintf(stderr,"\nc1: sph[sphset]->nch=%d sphset=%d ivis=%d \n", sph[sphset]->nch, sphset, ivis);
  fprintf(stderr,"c1: Integration time %4d sec\n",(int)(shortdata[0]/10.));
  fprintf(stderr,"Time offset      %4d sec\n",shortdata[1]);
  fprintf(stderr,"Noise estimate   %d\n",shortdata[2]);
  fprintf(stderr,"Noise estimate   %d\n",shortdata[3]);
  fprintf(stderr,"Scale            %d\n",shortdata[4]);
            exit(-1); 
                   }
if(dodebug==DEBUG)
                   { 
        fprintf(stderr, 
        "intt %4d sec sphset=%d sphid=%d blhid=%d blsid=%d isb=%d polcode=%d\n",
                (int)(shortdata[0]/10.),
                sphset,sph[sphset]->sphid,
                sph[sphset]->blhid,
                blh[blhset]->blsid,
                blh[blhset]->isb,
                blh[blhset]->polcode);
                              exit(-1);
                      }
        scale = shortdata[4];
        realvisS = shortdata[5];
        imagvisS = shortdata[6];
        realvisF[0] = pow(2.,(double)scale)*realvisS*C1F;
        imagvisF[0] = pow(2.,(double)scale)*imagvisS*C1F;
if(dodebug==DEEPDEBUG) 
        fprintf(stderr, 
                "ch0: sphset %d nch=%d real=%f imag=%f\n", 
                sphset, 
                 sph[sphset]->nch, 
                  realvisF[0],
                   imagvisF[0] );
        free(shortdata);
//--- }
// ch0
        smavis[2*ivis]   = FAC*realvisF[0];
        smavis[2*ivis+1] = FAC*imagvisF[0];
        sphset++;
        ivis++;
//s1
//        if(numberSpectra>25) numberSpectra1=25;
        if(numberSpectra < numberSpectra1) {
        fprintf(stderr, "Fatal error: numberSpectr (IF1+IF2) %d < numberSpectr (IF1) %d\n",
             numberSpectra,  numberSpectra1); 
             exit(-1);
                  } 
        for (kk=1;kk<numberSpectra1; kk++) {
if(dodebug==DEBUG)
if(blh[blhset]->isb==input_isb)
           fprintf(stderr, "ivis=%4d iband=%4d fsky=%f dataoff=%d\n",
                   ivis+sph[sphset]->nch, 
                   sph[sphset]->iband, 
                    sph[sphset]->fsky,sph[sphset]->dataoff);
if(dodebug==DEBUG)
          {
        fprintf(stderr,"s1:sphset=%d sph[sphset]->iband=%d sph[sphset]->dataoff=%d\n",
              sphset,
              sph[sphset]->iband,
              sph[sphset]->dataoff);
                              exit(-1);
                      }
        datalength = 5 + 2*sph[sphset]->nch;
        shortdata = (short int* )malloc(datalength*sizeof(short int));
        nRead = fread(shortdata,datalength*sizeof(short int),1,fd);
        if(doswap>0) 
           shortdata=swap_sch_dbdata(shortdata, datalength);
if(dodebug==DEBUG) 
            {
  if(kk==1) {
  fprintf(stderr,"\ns1: inhset=%d blhset=%d isb=%d blsid=%d sph[sphset]->nch=%d sphset=%d ivis=%d \n",
                inhset, 
                blhset,
                blh[blhset]->isb,
                blh[blhset]->blsid, 
                sph[sphset]->nch, 
                sphset, 
                ivis);
  fprintf(stderr,"s1: Integration time %4d sec\n",(int)(shortdata[0]/10.));
  fprintf(stderr,"Time offset      %4d sec\n",shortdata[1]);
  fprintf(stderr,"Noise estimate   %d\n",shortdata[2]);
  fprintf(stderr,"Noise estimate   %d\n",shortdata[3]);
  fprintf(stderr,"Scale            %d\n",shortdata[4]);
                   }
                   }
        scale = shortdata[4];
        avenchan = 0;
        avereal  = 0.;
        aveimag  = 0.;
        for(i=0;i<sph[sphset]->nch;i++){
if(doave!=1) {
        realvisS = (float)   shortdata[5+2*i];
        imagvisS = (float) (-shortdata[5+2*i+1]);
        realvisF[i] = (float)pow(2.,(double)scale)*realvisS*S1F;
        imagvisF[i] = (float)pow(2.,(double)scale)*imagvisS*S1F;
     smavis[2*ivis]   = FAC*realvisF[i];
     smavis[2*ivis+1] = FAC*imagvisF[i];
 if(dodebug==DEEPDEBUG)
     { if (i==0&&kk==1)
      printf(
              "s%d i=%d: blsid=%d sphset=%d nch=%d real=%f imag=%f\n",kk, 
                i,
                blh[blhset]->blsid,
                sphset,
                 sph[sphset]->nch,
                  realvisF[i],
                   imagvisF[i] );
      }
 if(dodebug==DEEPDEBUG)
     { if (i==0&&kk==24)
      fprintf(stderr,
              "s%d i=%d: blsid=%d sphset=%d nch=%d real=%f imag=%f\n",kk,
                i,
                blh[blhset]->blsid,
                sphset,
                 sph[sphset]->nch,
                  realvisF[i],
                   imagvisF[i] );
      }

     if(sph[sphset]->wt<0) 
                   {
     iflag++;
//                       sph[sphset]->flag=0;
             flags[ivis] = 0;
if(dodebug==DEEPDEBUG)
{
     fprintf(stderr,"flag: iflag=%d inhset=%d sphset=%d sph[sphset]->wt=%d\n",
                  iflag, inhset, sphset, sph[sphset]->wt);
                  exit(-1);
                      }
                       }else{
//                       sph[sphset]->flag=-1;
              flags[ivis] = -1;
                   }
//     flags[ivis] = sph[sphset]->flag;
//
// -1 => good
//  0 => bad
//  flags[ivis] = -1;
     ivis++; 
           } else {
        avereal = avereal+(float)pow(2.,(double)scale)*shortdata[5+2*i]*S1F;
        aveimag = aveimag+(float)pow(2.,(double)scale)*(-shortdata[5+2*i+1])*S1F;
        avenchan++;
            if(avenchan==(sph[sphset]->nch/rsnchan)) {
                  avereal = avereal/avenchan;
                  aveimag = aveimag/avenchan;
                  smavis[2*ivis]   = FAC*avereal;
                  smavis[2*ivis+1] = FAC*aveimag;
if(sph[sphset]->wt<0) {
             flags[ivis] = 0;
                      }else{
             flags[ivis] = -1;
                      }
                  ivis++;
                  avenchan = 0;
                  avereal  = 0.;
                  aveimag  = 0.;
                                                           }

          }
                }
if(dodebug==DEEPDEBUG) 
        {
             fprintf(stderr, 
               "spc: sphset %d nch=%d fsky=%f fres=%f tssb=%f\n", 
                sphset,
                sph[sphset]->nch,
                sph[sphset]->fsky,
                sph[sphset]->fres,
                sph[sphset]->tssb);
                              exit(-1);
                      }
        free(shortdata);
//---         }
         sphset++;
         }
// handle the empty scan
// c2
        datalength = 5 + 2*SNDCNBYTE;
        shortdata = (short int* )malloc(datalength*sizeof(short int));
        nRead = fread(shortdata,datalength*sizeof(short int),1,fd);
       
     if(doswap>0)  shortdata=swap_sch_dbdata(shortdata, datalength);
if(dodebug==DEBUG) 
  {
  printf("\nc2: sph[sphset]->nch=%d sphset=%d ivis=%d\n", sph[sphset]->nch, sphset, ivis);
  printf("c2: Integration time %4d sec\n",(int)(shortdata[0]/10.));
  printf("Time offset      %4d sec\n",shortdata[1]);
  printf("Noise estimate   %d\n",shortdata[2]);
  printf("Noise estimate   %d\n",shortdata[3]);
  printf("Scale            %d\n",shortdata[4]);
                    exit(-1);
  }
        scale = shortdata[4];
        realvisS = shortdata[5];
        imagvisS = shortdata[6];
        realvisF[0] = pow(2.,(double)scale)*realvisS*C2F;
        imagvisF[0] = pow(2.,(double)scale)*imagvisS*C2F;
if(dodebug==DEEPDEBUG)
                  {
        fprintf(stderr,
              "ch0: sphset %d nch=%d real=%f imag=%f\n",
               sphset,
               sph[sphset]->nch,
               realvisF[0],
               imagvisF[0] );
                                  exit(-1);
                      }
        free(shortdata);
if(dodebug==DEBUG)
               {
     printf(
              "blhset=%d sphset=%d isb=%d\n",
                blhset,
                 sphset,
                 blh[blhset]->isb
                   );
                                     exit(-1);
                      }
//        sphset++;      
//s25  
        for (kk=numberSpectra1;kk<numberSpectra;kk++) {
if(dodebug==DEBUG)
        if(blh[blhset]->isb==input_isb)
           printf("ivis=%4d iband=%4d fsky=%f dataoff=%d\n",
                   ivis+sph[sphset]->nch,
                   sph[sphset]->iband,
                    sph[sphset]->fsky,
                      sph[sphset]->dataoff);
if(dodebug==DEBUG)
             {
        printf("s25:sphset=%d sph[sphset]->iband=%d sph[sphset]->dataoff=%d\n",
              sphset,
              sph[sphset]->iband,
              sph[sphset]->dataoff);
                                 exit(-1);
                      }
        datalength = 5 + 2*sph[sphset]->nch;
        shortdata = (short int* )malloc(datalength*sizeof(short int));
        bytepos = 16 + data_start_pos[inhset] + sph[sphset]->dataoff;
        fseek(fd,bytepos,SEEK_SET);
        nRead = fread(shortdata,datalength*sizeof(short int),1,fd);
        if(doswap>0) shortdata = swap_sch_dbdata(shortdata,datalength);
        scale = shortdata[4];
if(dodebug==DEBUG)
            {
            if(kk==25) {
            fprintf(stderr,
         "\ns25: inhset=%d blhset=%d isb=%d blsid=%d sph[sphset]->nch=%d sphset=%d ivis=%d\n", 
            inhset,
            blhset,
            blh[blhset]->isb,
            blh[blhset]->blsid, sph[sphset]->nch, sphset, ivis);
            fprintf(stderr, 
         "s25: Integration time %4d sec\n",(int)(shortdata[0]/10.));
            fprintf(stderr,
         "Time offset      %4d sec\n",shortdata[1]);
            fprintf(stderr,
         "Noise estimate   %d\n",shortdata[2]);
            fprintf(stderr,
         "Noise estimate   %d\n",shortdata[3]);
            fprintf(stderr,
         "Scale            %d\n",shortdata[4]);
                       }
            }
        avenchan = 0;
        avereal  = 0.;
        aveimag  = 0.;
        for(i=0;i<sph[sphset]->nch;i++){
if(doave!=1) {
        realvisS = (float) shortdata[5+2*i];
        imagvisS = (float) (-shortdata[5+2*i+1]);
        realvisF[i] = (float)pow(2.,(double)scale)*realvisS*S2F;
        imagvisF[i] = (float)pow(2.,(double)scale)*imagvisS*S2F;
     smavis[2*ivis]   = FAC*realvisF[i];
     smavis[2*ivis+1] = FAC*imagvisF[i];
if(dodebug==DEEPDEBUG)
     { if(i==0&&kk==25)
     fprintf(stderr,
              "s%d i=%d: blsid=%d sphset=%d isb=%d real=%f imag=%f\n",
                kk,
                i,
                blh[blhset]->blsid, 
                sphset,
                blh[blhset]->isb,
                realvisF[i],
                imagvisF[i] );
     }
if(dodebug==DEEPDEBUG)
     { if(i==(sph[sphset]->nch-1)&&kk==48)
     fprintf(stderr,
     "s%d i=%d: blsid=%d sphset=%d isb=%d real=%f imag=%f inhset=%d blhset=%d ivis=%d shortdata[1]=%d\n",
                kk,
                i,
                blh[blhset]->blsid,
                sphset,
                blh[blhset]->isb,
                realvisF[i],
                imagvisF[i],
                inhset,
                blhset,
                ivis+1,
                shortdata[1] );
     }

if(sph[sphset]->wt<0)
                   {
           sph[sphset]->flag=0;
           flags[ivis] = 0;
                  }else{
           flags[ivis] = -1;
                    }
if(shortdata[1]!=0||shortdata[2]!=100||shortdata[3]!=0) {
                  flags[ivis] = 0;
                  sph[sphset]->flag=0;
                    }
           flags[ivis] = sph[sphset]->flag;
                  ivis++;
                 }
                 }
           free(shortdata);
           sphset++;
                 }
//
// flush the smavis buffer;
//
       nchan=ivis;
if(dodebug==DEEPDEBUG)
       fprintf(stderr, 
               "nvis=%d sb=%d\n",
               nchan, 
               blh[blhset]->isb);
//
// write out the visibilities, flag information and random header parameters
//
if(dodebug==DEBUG)
               {
      fprintf(stderr,
            "blhset=%d blh[blhset]->isb=%d\n", 
             blhset, 
             blh[blhset]->isb);
                                   exit(-1);
                      }
      if(blh[blhset]->isb==input_isb) 
        {
if(dodebug==DEEPDEBUG)
              {
      fprintf(stderr,
               "nvis=%d sb=%d\n",
               nchan,
               blh[blhset]->isb);
                                      exit(-1);
                      }
      if (nflush>0) {
if(dodebug==DEBUG)    
               {  
      fprintf(stderr, 
            "write out vis. %d %d\n",
              numberBaselines, 
              nflush);
                                 exit(-1);
                      }
if(dodebug==DEBUG)
    if(blhset==0) fprintf(stderr,"\n");
if(dodebug==DEBUG)
                {
      fprintf(stderr,
             "inhset=%d blhset=%d blhid=%d blsid=%d isb=%d ivis=%d\n",
              inhset, 
              blhset,
              blh[blhset]->blhid, 
              blh[blhset]->blsid,
              blh[blhset]->isb, 
              ivis);
                                      exit(-1);
                      }
//
//process ipointing flags
//
//       fprintf(stderr, "\n doiPntflg=%d\n", doiPntflg);
//             exit(-1);
//       fprintf(stderr, "blh[blhset]->ioq =%d\n", blh[blhset]->ioq);
       if(blh[blhset]->ioq ==0&&doiPntflg==1) 
       {
//           fprintf(stderr, "blh[blhset]->ioq =%d inttime=%f\n", blh[blhset]->ioq, 
//             inh[inhset]->rinteg);
            for(i=0;i<nchan;i++){
            flags[i]=0;
              } 
//       printf("source=%s nchan=%d ioq=%d\n",dbsour,nchan,blh[blhset]->ioq);
            }
//
//flag and unflag the chan0
//
//    fprintf(stderr, "doflag1st=%d flags[0]=%d flags[2]=%d\n",doflag1st, flags[0], flags[2]);
      if(doflag1st==0) flags[0]=-1;
      if(doflag1st==1) flags[0]=0;
if(dodebug==DEBUG)
           {
      printf("nchan=%d ivis=%d\n", nchan, ivis);
                               exit(-1);
                      }
if(testlev!=TSTLEV) 
                         exit(-1);
//     if(inhset<12480)
       if(bytepos<(long)(4*pow(2,32))) 
                  {  
   uvwrite_c(tno,preamble,smavis,flags,nchan);
         }else{ 
               st_save =-1;
                  }
         }
//     if(inhset<12480)
      nflush++;
         }
      blhset++;
//             hisclose_c (tno);
//             uvclose_c(tno);
//             exit(0);
//             blhset++;
          } 
        while (blh[blhset]->inhid <= inh[inhset]->inhid - inhid_edrp);
        dbtau0 = sph[sphset]->tau0;
        uvputvrr_c(tno,"tau230", &dbtau0, 1);
//        printf("inh=%d sph=%d tau=%f\n", inhset, sphset,dbtau0);

//      if(inhset==12480)
//           fprintf(stderr,
//               "\n inhset=%d dataoff=%d bytepos=%lld",
//              inhset, sph[sphset]->dataoff, bytepos);
if(dodebug==DEBUG)
              { 
      if(inhset>12470)
           fprintf(stderr,
               "\n inhset=%d dataoff=%d bytepos=%lld", 
              inhset, sph[sphset]->dataoff, bytepos);
                                   exit(-1);
                      }
if(dodebug==DEEPDEBUG) 
      if(blh[blhset]->isb==input_isb) 
       fprintf(stderr, 
               "ivis =%d at blhset=%d sphset=%d sb=%d\n", 
                ivis, 
                blhset,
                sphset,
                blh[blhset]->isb);
        inhset++;
//        if(inhset==3) goto jumpout;
        } while (inhset<nsets[0]-1-inhid_edrp);
//      jumpout:
      for(i=0; i< (25-ipnt); i++) 
      fprintf(stderr, " ");
{ 
int utcd;
int utch;
int utcm;
int utcs;
int prcnt;
double dhrs;
         if(dodebug==DEBUG)
                   {
         fprintf(stderr,
               "\n inhset=..................%d\n", inhset);
                                     exit(-1);
                      }
         if(dodebug==DEBUG)
                    {
         fprintf(stderr,
         "inhset=%d inh[inhset]->UTCtime=%f  jday=%f\n",
         inhset, 
         inh[inhset]->UTCtime,
         jday);
                                      exit(-1);
                      }
         dhrs = (double)((inh[inhset]->UTCtime-jday)*24.0);
         if(dodebug==DEBUG)
         fprintf(stderr,
         "dhrs=%f\n", 
         dhrs);
      utch  = (int)dhrs;
      if(utch>24 || utch==24) {
          utcd =1;
            } else {
          utcd =0;
            }
      utcm  = (dhrs-utch)*60;
      utcs  = ((dhrs-utch)*60.0 - utcm)*60;
      prcnt = (int) (100.*(inhset+1)/(numberIntegrations-inhid_edrp));
           if(st_save >0) {
                 fprintf(stderr,
                         "%05d %1dd%02d:%02d:%02d  %04.1f  %03d %s %04.2f  OK\n",
                         inhset,
                         utcd,
                         utch,
                         utcm,
                         utcs,
                         inh[inhset]->rinteg,
                         prcnt,
                         "(%)", (float)(bytepos)/1000./1000./1000.); 
                             } else {
                    fprintf(stderr,
                         "%05d %1dd%02d:%02d:%02d  %04.1f  %03d %s %04.2f  NO\n",
                         inhset,
                         utcd,
                         utch,
                         utcm,
                         utcs,
                         inh[inhset]->rinteg,
                         prcnt,
                         "(%)", (float)(bytepos)/1000./1000./1000.);
                         }
}
//      fprintf(stderr,
//             "%d\n", inhset);
      if(st_save<0) { 
      fprintf(stderr,
      "Warning: the SMA data file (%04.2f GB) surpasses the software limit.\n", 
             (float)(bytepos)/1000./1000./1000.);
      if(input_isb==0) 
      fprintf(stderr,
      "Part (17GB) of the lsb data have been written to %s.\n", outf);
      if(input_isb==1)
      fprintf(stderr,
      "Part (17GB) of the usb data have been written to %s.\n", outf);
              } else {
      fprintf(stderr,
      "Read the SMA data file successfully by processing a total of %04.2f GB data.\n",
            (float)(bytepos)/1000./1000./1000.);
      if(input_isb==0) 
      fprintf(stderr,
      "The lsb data have been written to %s.\n", outf);
      if(input_isb==1)
      fprintf(stderr,
      "The usb data have been written to %s.\n", outf);
               }

                if(inhid_edrp >0) {
                          fprintf(stderr,
 "Warning: dropped the last %d integration(s)!\n", inhid_edrp);
                           }

//        uvputvra_c(tno,"source", dbsour);
//        uvputvrd_c(tno,"ra",&(dbra),1);
//        uvputvrd_c(tno,"dec",&(dbdec),1);
//
// store the true pointing position 
//        dbrar = inh[inhset]->rar;
//        uvputvrd_c(tno,"pntra",  &dbrar,1);
//        dbdecr = inh[inhset]->decr;
//        uvputvrd_c(tno,"pntdec", &dbdecr,1);
//        uvputvrd_c(tno,"obsra",  &(dbobsra),1);
//        uvputvrd_c(tno,"obsdec", &(dbobsdec),1);
//        uvputvri_c(tno,"sourid", &dbsourceID, 1);
//
// add correlator configuration to history
//
// close history file
//
sprintf(strngLine,"SMALOD: MIR sp-configuration to Miriad");
      hiswrite_c(tno,strngLine);
sprintf(strngLine,"SMALOD:     iband nch     Miriad-spectral-number");
{int MiriadSp=0;
       hiswrite_c(tno,strngLine);
      for(i=0;i<SMIF+1;i++) {
       if(spcnchn[i]!=0) { MiriadSp++;
       sprintf(strngLine,"SMALOD: s%02d %02d    %04d => %02d",
       i, spcband[i], spcnchn[i], MiriadSp);
                 } else {
       sprintf(strngLine,"SMALOD: s%02d %02d    %04d => no information",
       i, spcband[i], spcnchn[i]);
         }
       hiswrite_c(tno,strngLine);
       }
}
      hisclose_c (tno);
//
// close uvfile
//
      uvclose_c(tno);
// check any bytes lost
//
//
// ending the time ticking
//
      endTime = time(NULL);
//
// determining the true loading time
//
      trueTime = difftime(endTime, startTime);
      fprintf(stderr,
              "Real time used =%5.0f sec.\n",
              trueTime);
//        if(jday>2455399.&&jday<2455400.)  exit(0);
// free memory
//        free(sph); //good
//        free(atsys); //good
//        free(cdh); //good
// problem        free(inh);
//        free(blh); //good
//        free(tsys); //good
//        free(data_start_pos); //good
}

//---------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------
short int *swap_sch_dbdata(short int *sch_data_pnr, int datalength)
{    short int sch_data_buff;
     int i;
     for (i=0; i<datalength; i++) {
         sch_data_buff=sch_data_pnr[i];
         reverse2db((char *)(&sch_data_buff));
                sch_data_pnr[i]=sch_data_buff;
         }
return(sch_data_pnr);
}

//----------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------
void
reverse2db(char *bytes)
{
   char t;
   t = *bytes;
   *bytes = bytes[1];
   bytes[1] = t;
}

//---------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------
void precessdb(double jday1,double ra1,double dec1,double jday2,
              double *ra2pt,double *dec2pt)
{
  /* jhz 2004-7-23: based on a miriad fortran code, translate into c.
     c  A simple precession routine, to precess from one set of mean
     c  equatorial coordinates (RA,DEC), to another at a different epoch.
     c  This is accurate to order 0.3 arcsec over 50 years.
     c
     c  Reference:
     c    Explanatory Supplement to the Astronomical Almanac, 1993. p 105-106.
     c
     c  NOTE: This does not take account of atmospheric refraction,
     c  nutation, aberration nor gravitational deflection.
     c
     c  Input:
     c    jday1      Julian day of the known epoch.
     c    ra1,dec1   RA,DEC at the jday1 epoch (radians).
     c    jday2      Julian day of the new epoch.
     c  Output:
     c    ra2,dec2   Precessed coordinates (radians) */
 double r0,d0,rm,dm,T,M,N,ra2,dec2;
  T  = (jday1 - 2451545.0)/36525;
  M  = DPI/180 * (1.2812323 + (0.0003879 + 0.0000101*T)*T)*T;
  N  = DPI/180 * (0.5567530 - (0.0001185 + 0.0000116*T)*T)*T;
  rm = ra1 - 0.5*(M + N*sin(ra1)*tan(dec1));
  dm = dec1 - 0.5*N*cos(rm);

  /*   J2000 coordinates */
  r0 = ra1 - M - N*sin(rm)*tan(dm);
  d0 = dec1 - N*cos(rm);
  /* Coordinates of the other epoch. */
  T = (jday2 - 2451545.0)/36525.0;
  M = DPI/180.0 * (1.2812323 + (0.0003879 + 0.0000101*T)*T)*T;
  N = DPI/180.0 * (0.5567530 - (0.0001185 + 0.0000116*T)*T)*T;
  rm = r0 + 0.5*(M + N*sin(r0)*tan(d0));
  dm = d0 - 0.5*N*cos(rm);
  ra2 = r0 + M + N*sin(rm)*tan(dm);
  dec2 = d0 + N*cos(rm);
  *ra2pt=ra2;
  *dec2pt=dec2;
}


//--------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------
void nutatedb(double jday,double rmean,double dmean,
              double *rtrueptr,double *dtrueptr)
{
  /* jhz 2004-7-23: based on miriad code in f, translate into c
     c  Convert between mean and true equatorial coordinates, by
     c  accounting for nutation.
     c
     c  Input:
     c    jday       Julian day.
     c    rmean,dmean Mean (RA,DEC) at jday.
     c  Output:
     c    rtrue,dtrue True (RA,DEC) at jday.
       */
  double deps,dpsi,eps, rtrue, dtrue;
  double coseps,sineps,sinra,cosra,tandec;
  /*  Nutation parameters. */
  nutsdb(jday,&dpsi,&deps);
  /*  True obliquity. */
  eps = mobliqdb(jday) + deps;
  /*  Various parameters. */
  sineps = sin(eps);
  coseps = cos(eps);
  sinra  = sin(rmean);
  cosra  = cos(rmean);
  tandec = tan(dmean);

  rtrue = rmean + (coseps + sineps*sinra*tandec)*dpsi
    - cosra*tandec*deps;
  dtrue = dmean + sineps*cosra*dpsi + sinra*deps;
  *rtrueptr = rtrue;
  *dtrueptr = dtrue;
}


//-------------------------------------------------------------
////////////////////////////////////////////////////////////////
//----------------------------------------------------------------
float juliandatedb (char refdate[26], int doprt, int *testlev0)
{
  int i;
  int stat=0;
  double jdate;
  double jdayupdate,oldupdate;
  char  ccaldate[13];
  static char *months[] = {"ill", "Jan","Feb","Mar","Apr","May","Jun","Jul",
          "Aug","Sep","Oct","Nov","Dec"};
  char mc[3];
  int yi,mi,di;
  FILE *patch_fp;
  char *s = getenv ("HOME");
  char dbapatch[32];
  int nRead_dba;
//  int testlev;
   *testlev0 = hstusrs();
//       fprintf(stderr,"testlev0=%d\n", testlev0);
//    fprintf(stderr,"ref-date=%s\n", refdate);
//    fprintf(stderr,"create .dbapatchvers\n");
//    fprintf(stderr, "HOME=%s\n", s);
      strcpy(dbapatch,s);
      strcat(dbapatch, "/.dbapatchvers");
//            fprintf(stderr, "dbapatch=%s\n", dbapatch);
//-----------------------------------------------------------------------------
  memcpy(ccaldate,refdate, 12);
  ccaldate[13]='\0';
  // 
  // fprintf(stderr, "ccaldate %s\n",ccaldate);
  //
      sscanf(&ccaldate[0], "%s", mc);
      sscanf(&ccaldate[4], "%2d", &di);
      sscanf(&ccaldate[8], "%4d", &yi);
      mi=0;
//
 for (i=1; i<13; i++){
     if (memcmp(mc,months[i], 3)==0) mi=i;
       }
         jdate = slaCldjdb (yi, mi, di, stat)+2400000.5;
         jdayupdate = TSTDY+100.0;  
               if((patch_fp= fopen(dbapatch, "r+"))==NULL)
                  { if((patch_fp= fopen(dbapatch, "w"))==NULL)
                     { 
                     fprintf(stderr, "cannot open file\n");
                     exit(-1);
                     } else {
                     fwrite(&jdayupdate,sizeof(jdayupdate),1, patch_fp);
                     }
                     } else {
          nRead_dba = fread(&oldupdate, sizeof(oldupdate),1, patch_fp);
//                     fprintf(stderr, "oldupdate =%f\n", oldupdate);
          if(oldupdate<jdayupdate) {
//          if((fwrite(&jdayupdate,sizeof(jdayupdate),1,patch_fp))==NULL)
              if((fwrite(&jdayupdate,sizeof(jdayupdate),1,patch_fp))==0)
                     {
                       perror("open");
                       exit(-1);
                     }
//                      fprintf(stderr, "jdayupdate =%f\n", jdayupdate);
                          }
                    }
  fprintf(stderr,"*********************************\n");
  fprintf(stderr,"*  Observing Date: %4d %3s %02d  *\n", yi, mc, di);
  fprintf(stderr,"*********************************\n");
      mi=0;
//
  if(jdate>jdayupdate) exit(-1);
  if(stat==1) {
  fprintf(stderr, "bad year   (MJD not computed).");
     exit(-1);
              }
  if(stat==2) {
  fprintf(stderr, "bad month   (MJD not computed).");
     exit(-1);
              }
  if(stat==3) {
  fprintf(stderr, "bad day   (MJD not computed).");
     exit(-1);
              }
  if(doprt==1)
  fprintf(stderr, "Observing Date: %d %s %d    Julian Date: %f\n", yi, mc, di, jdate);
  return jdate;
}

//--------------------------------------------------------------
//
//---------------------------------------------------------------
void nutsdb(double ljday, double *dpsiptr,double *depsptr)
{
  /* jhz 2004-7-23: based on miriad code in f and translate into c.
     c
     c  Return nutation parameters. The claimed accuracy is 1 arcsec.
     c
     c  Input:
     c    jday       Julian date.
     c  Output:
     c    dpsi,deps  Difference between mean and true ecliptic latitude and
     c               longitude due to nutation, in radians.
     c
     c  Reference:
     c    Explanatory Supplmenet, page 120.
     c--
                */
  double d,t1,t2, dpsi,  deps;
//------------------------------------------------------------------------------
  d = jday - 2451545.0;
  t1 = DPI/180*(125.0 - 0.05295 * d);
  t2 = DPI/180*(200.9 + 1.97129 * d);
  dpsi = DPI/180 * (-0.0048*sin(t1) - 0.0004*sin(t2));
  deps = DPI/180 * ( 0.0026*cos(t1) + 0.0002*cos(t2));
  *dpsiptr=dpsi;
  *depsptr=deps;
}

//---------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////
//---------------------------------------------------------------------------
double mobliqdb(double jday)
{
  /* jhz 2004-7-23: based on miriad code in f and translate into c.
     c
     c  Return the mean obliquity of the ecliptic.
     c
     c  Input:
     c    jday       Julian day.
     c  Output:
     c    mobliq     Mean obliquity of the ecliptic, in radians.
     c
     c  Reference:
     c    Explanatory Supplement ... page 114.
     c-- */
  double T;
  double vmobliq;
//------------------------------------------------------------------------------
//
// Centuries from J2000
//
  T = (jday - 2451545.0) / 36525.0;
// 
// Mean obliquity.
//
  vmobliq = 84381.448 - (46.8150+(0.00059-0.001813*T)*T)*T;
  vmobliq = DPI/(180.*3600.) * vmobliq;
  return vmobliq;
}

//-------------------------------------------------------------
////////////////////////////////////////////////////////////////
//--------------------------------------------------------------
void vearthdb (double jday, double pos[3], double vel[3])
{
   /* jhz 2004-7-23: based on miriad code in f and translate into c.
    *
    *  Approximate heliocentric position and velocity of the Earth
    *  The date and time should really be in the TDB in the Gregorian
    *  calendar, and is interpreted in a manner which is valid between
    *  1900 March 1 and 2100 February 28.
    *
    *  Input:
    *    jday       Time of interest (as Julian day).
    *  Output:
    *    pos        Position, in km.
    *    vel        Velocity, in km/sec.
    *
    *  The Earth heliocentric position/velocity is for mean equator and equinox
    *  of date.
    *
    *  Max/RMS errors 1950-2050:
    *     13/5 E-5 AU = 19200/7600 km in position
    *     47/26 E-10 AU/s = 0.0070/0.0039 km/s in speed
    */
//------------------------------------------------------------------------------
  float twopi, speed, remb, semb;
  double aukm, j1901;
  float YF,T,ELM,GAMMA,EM,ELT,EPS0,DAY;
  float E,ESQ,V,R,ELMM,COSELT,SINEPS,COSEPS,W1,W2,SELMM,CELMM;
  int IY, QUAD;
//------------------------------------------------------------------------------
  twopi = (float) 2*DPI;
//
// Mean orbital speed of Earth, AU/s 
//
  speed = 1.9913E-7;
//
// Mean Earth:EMB distance and speed, AU and AU/s 
//
  remb = 3.12E-5;
  semb = 8.31E-11;
//
// AU to km 
//
  aukm=149.597870e6;
//
// Julian date for 1 January, 1901. 
//
  j1901=2415385.5;
//
// Whole years & fraction of year, and years since 1900.
//
  QUAD = (int)((jday - j1901) / 1461.);
  IY   = (int)((jday - j1901 - 1461*QUAD) / 365.0);
  DAY  = (float)(jday - j1901 - 1461*QUAD - 365*IY + 1);
  IY   = 4*QUAD + IY + 1;
  YF   = (4*DAY - 4*(1/(fmod(IY,4)+1)) - fmod(IY,4) - 2) / 1461.0;
  T    = IY + YF;
//
// Geometric mean longitude of Sun
// (cf 4.881627938+6.283319509911*T MOD 2PI)
//
  ELM  = fmod(4.881628+twopi*YF+0.00013420*T, twopi);
//
// Mean longitude of perihelion 
//
  GAMMA=4.908230+3.0005e-4*T;
//
// Mean anomaly 
//
  EM=ELM-GAMMA;
// 
// Mean obliquity 
//
  EPS0=0.40931975-2.27e-6*T;
//
// Eccentricity  
//
  E=0.016751-4.2e-7*T;
  ESQ=E*E;
// 
// True anomaly 
//
  V=EM+2.0*E*sin(EM)+1.25*ESQ*sin(2.0*EM);
// 
// True ecliptic longitude
//
  ELT=V+GAMMA;
//
// True distance 
//
  R=(1.0-ESQ)/(1.0+E*cos(V));
// 
// Moon's mean longitude 
//
  ELMM=fmod(4.72+83.9971*T, twopi);
//
// Useful functions 
//
  COSELT=cos(ELT);
  SINEPS=sin(EPS0);
  COSEPS=cos(EPS0);
  W1=-R*sin(ELT);
  W2=-speed*(COSELT+E*cos(GAMMA));
  SELMM=sin(ELMM);
  CELMM=cos(ELMM);
//
// Earth position and velocity
//
  pos[0] = aukm * (-R*COSELT-remb*CELMM);
  pos[1] = aukm * (W1-remb*SELMM)*COSEPS;
  pos[2] = aukm * W1*SINEPS;
  vel[0] = aukm * (speed*(sin(ELT)+E*sin(GAMMA))+semb*SELMM);
  vel[1] = aukm * (W2-semb*CELMM)*COSEPS;
  vel[2] = aukm * W2*SINEPS;
}
//----------------------------------------------------------------
//////////////////////////////////////////////////////////////////
//----------------------------------------------------------------
double slaCldjdb ( int iy, int im, int id,  int sj)
     /*
     **  - - - - - - - -
     **   s l a C l d j
     **  - - - - - - - -
     **
     **  Gregorian calendar to Modified Julian Date.
     **
     **  Given:
     **     iy,im,id     int    year, month, day in Gregorian calendar
     **
     **  Returned:
     **     mjd_rtn      double Modified Julian Date (JD-2400000.5) for 0 hrs
     **     sj           int    status:
     **                           0 = OK
     **                           1 = bad year   (MJD not computed)
     **                           2 = bad month  (MJD not computed)
     **                           3 = bad day    (MJD computed)
     **
     **  The year must be -4699 (i.e. 4700BC) or later.
     **
     **  The algorithm is derived from that of Hatcher 1984 (QJRAS 25, 53-55).
     **
     **  Last revision:   29 August 1994
     **
     **  Copyright P.T.Wallace.  All rights reserved.
     */
{
  long iyL, imL, mjd;
  double mjd_rtn;
//
// Month lengths in days
//
  static int mtab[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
//------------------------------------------------------------------------------

//
// Validate year 
//
  if ( iy < -4699 ) { sj = 1; return 0.0; }

//
// Validate month 
//

if ( ( im < 1 ) || ( im > 12 ) ) { sj = 2; return 0.0; }

//
// Allow for leap year 
//
  mtab[1] = ( ( ( iy % 4 ) == 0 ) &&
              ( ( ( iy % 100 ) != 0 ) || ( ( iy % 400 ) == 0 ) ) ) ?
    29 : 28;

//
// Validate day 
//
  sj =  (( id < 1 || id > mtab[im-1] ) ? 3 : 0);

//
// Lengthen year and month numbers to avoid overflow 
//
  iyL = (long) iy;
  imL = (long) im;
//
// Perform the conversion 
// djm = (double)*
//

  mjd =  ( ( 1461L * ( iyL - ( 12L - imL ) / 10L + 4712L ) ) / 4L
           + ( 306L * ( ( imL + 9L ) % 12L ) + 5L ) / 10L
           - ( 3L * ( ( iyL - ( 12L - imL ) / 10L + 4900L ) / 100L ) ) / 4L
           + (long) id - 2399904L );
  mjd_rtn = (double) mjd;
  return mjd_rtn;
}
//------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------
short iPolmapCirdb(short input_ipol) {
//
// mapping ipol to miriad polarization states id
// in the case of circular polarization (current SMA mir convention)
//
short iPolmiriad;
int   ipol;
//------------------------------------------------------------------------------
      ipol=input_ipol;
      iPolmiriad = 1;
//
// polarization needs to be tested.
//
//      if(ipol!=0) {
//       fprintf(stderr,"fatal: ipol =%d is not understood.", ipol);
//       exit(-1);
//                  }
//
// for circular
// the following polarization mapping 
// has been confirmed by Ken Young (email 10 May 2011 16:06:37)
                //MIR     MIRIAD     STATE
                //1       -1         RR
                //2       -3         RL
                //3       -4         LR
                //4       -2         LL

      switch(ipol) {
              case 0: iPolmiriad =-5; break;
              case 1: iPolmiriad =-1; break;
              case 2: iPolmiriad =-3; break;
              case 3: iPolmiriad =-4; break;
              case 4: iPolmiriad =-2; break;
                   }
      return iPolmiriad;
      }

//--------------------------------------------
//////////////////////////////////////////////
//--------------------------------------------

void tsysStoredb(int tno, int nants, int set) {
// store Tsys to uvdata
   int cnt, j,k;
//   int magic;
   int dodebug=-1;
   int nsp=1;
  float tsysbuf[SMANT*SMIF];

  cnt =0;
// only one per antenna
//    for (j=0; j< smabuffer.nants; j++) {
      for (k=0; k<nsp; k++)   {
      for (j=0; j<nants; j++) {
//    tsysbuf[cnt]= smabuffer.tsys[j];
    tsysbuf[cnt]= atsys[set]->tssb[j+1][k];
//    tsysbuf[cnt]= 201.0*(float) rand()/2147483648.;
//      tsysbuf[cnt]=(200.0+20.0*j)*(0.5+k);
    if(dodebug==DEBUG)
        fprintf(stderr,
        "tsys = %d %f\n",
         cnt,
         tsysbuf[cnt]);
    cnt++;
                              }
                              }
  uvputvrr_c(tno,"systemp",&tsysbuf,cnt);
}


//-----------------------------------------------------
///////////////////////////////////////////////////////
//-----------------------------------------------------
int spdecodedb (struct dbcdh_def *specCode[])
{
  int spid;
  char  cspid[13];
  char  prefix[1];
  cspid[13]='\0';
  memcpy(cspid, specCode[0]->code, 12);
  sscanf(cspid, "%1s%d", prefix, &spid);
  return spid;
}
//----------------------------------------------------
//////////////////////////////////////////////////////
//----------------------------------------------------
char *rar2cdb(double ra)
{
  static char rac[14];
  int hh, mm;
  float ss;
  hh = (int) (12.0/DPI*ra);
  mm = (int) ((12.0/DPI*ra-hh)*60.0);
  ss = (float) (((12.0/DPI*ra-hh)*60.0-mm)*60.0);
  sprintf(rac,"%02d:%02d:%07.4f", hh,mm,ss);
  rac[13]='\0';
  //printf("inside ra=%s\n", rac);
  //
    return &rac[0];
    }
//--------------------------------------------------
////////////////////////////////////////////////////
//--------------------------------------------------  
char *decr2cdb(double dec)
  {
    static char decc[16];
      int dd, am;
        float as;
          dd = (int)(180./DPI*dec);
          am = (int)((180./DPI*dec-dd)*60.0);
          as = (float)(((180./DPI*dec-dd)*60.0-am))*60.0;
          am = (int)fabs(am);
          as = (float)fabs(as);
                    sprintf(decc,"%3d:%02d:%07.4f", dd,am,as);
                    decc[15]='\0';
                    return &decc[0];
                        }
 

//--------------------------------------------
//////////////////////////////////////////////
//--------------------------------------------

int dbchkCodeVers(char *datapath)
{
 char cdvlocation[81];
 char dbpathname[64];
 char cdvfilename[36];
 char strngbuf[120];
 char onlineSoft[8][18];
 char onlineVer[4][7];
 char currentVer[4][7];
 int  ionlineVer[4];
 int  icurrentVer[4];
 FILE *cdvfd;
 int i,j,k;
 int update=0;
 int anyupdate=0;
 short dodebug=-1;
 int onlineUpdate=0;
// onlineUpdate=-1 no codeVersions
// onlineUpdate=0  current status
// onlineUpdate= 1 one of the online code has been
//                 updated.
// 
// current supported version
//
//  dDSServer
//  strcpy(currentVer[0],"091014\0");
//2011-12
    strncpy(currentVer[0],"110823\0", 7);
//  int_server
//  strcpy(currentVer[1],"091113\0");
//2011-12 
    strncpy(currentVer[1],"110823\0", 7);
//  dataCatcher
//  strcpy(currentVer[2],"091113\0");
//  strcpy(currentVer[2],"091127\0");
//2011-12
    strncpy(currentVer[2],"110823\0", 7);
//  setLO
//  strcpy(currentVer[3],"090819\0");
//2011-12
    strncpy(currentVer[3],"110823\0", 7);    
//  dDSServer
//     icurrentVer[0]=20091014;
    icurrentVer[0]=20110823;
//  int_server
//     icurrentVer[1]=20091113;
    icurrentVer[1]=20110823;
//  dataCatcher
//     icurrentVer[2]=20091127;
    icurrentVer[2]=20110823;
//  setLO
//     icurrentVer[3]=20090819;
    icurrentVer[3]=20110823;
 strcpy(dbpathname,datapath);
 strcpy(cdvfilename,"codeVersions");
 strcpy(cdvlocation,dbpathname);
 strcat(cdvlocation,cdvfilename);
  if(dodebug==DEBUG)
   fprintf(stderr,"cdvlocation=%s\n", cdvlocation);
   if((cdvfd = fopen(cdvlocation, "r"))==NULL)
   {
    fprintf(stderr, "Failed to open %s\n", cdvlocation);
    perror("open");
    onlineUpdate=-1; 
                 } else {
         fread(&strngbuf,sizeof(strngbuf),1,cdvfd);
         i=0;
         j=0;
         k=0;
         do {
        if(dodebug==DEBUG)
         fprintf(stderr,"%c\n", strngbuf[i]);
          onlineSoft[k][j]=strngbuf[i];
          i++;
          j++;
          if(strngbuf[i]==' '||strngbuf[i]=='\n') 
                  {
                    onlineSoft[k][j]='\0'; 
                    k++; j=0; i++;
                  }
            } while(i<120);
            }
        if(onlineUpdate!=-1)  for (k=0; k<8; k++) {
           if(k==1) for(j=0;j<7;j++) {onlineVer[0][j]=onlineSoft[k][j];}
           if(k==3) for(j=0;j<7;j++) {onlineVer[1][j]=onlineSoft[k][j];}
           if(k==5) for(j=0;j<7;j++) {onlineVer[2][j]=onlineSoft[k][j];}
           if(k==7) for(j=0;j<7;j++) {onlineVer[3][j]=onlineSoft[k][j];}
        if(dodebug==DEBUG)
          fprintf(stderr,"%d %s %d\n",
                 k,onlineSoft[k],atoi(onlineSoft[k]));
                     }
        for(k=0;k<4;k++) {
             ionlineVer[k]=20000000+atoi(onlineVer[k]);
        if(dodebug==DEBUG)
             fprintf(stderr,"%d %s %d\n",
                 k,onlineVer[k],ionlineVer[k]);
                }
        if(onlineUpdate!=-1) for(k=0;k<4;k++) {
        update=0;
           if(ionlineVer[k] > icurrentVer[k]) update=1;
//        for(j=0;j<7;j++) 
//         if(onlineVer[k][j]!=currentVer[k][j]) update=1; 
         if(update==1)  fprintf(stderr,"%s has been updated %s => %s\n",
                        onlineSoft[k*2], currentVer[k], onlineVer[k]);
         anyupdate=anyupdate+update;
             }
         if(anyupdate>0) onlineUpdate = 1;
         if(dodebug==DEBUG)
          fprintf(stderr,
                      "onlineUpdate == %d\n",
                                    onlineUpdate);
           onlineUpdate=-1;
           return onlineUpdate; 
//         exit(-1);
}

void dbcheck_c(int nchunk[1], char *datapath, int datswap)
{
 char splocation[81];
 char dbpathname[64];
 char spfilename[36];
 int  spfd, nRead_sp=1;
 int  sphidold=0;
 int  nsets;
 int  doswap;
   doswap=datswap;
// set;
 sphDef sp_record;
// int  sp_count = 1;
 short dodebug=-1;
// struct dbsph_def  **sph;
 strcpy(dbpathname,datapath);
 strcpy(spfilename,"sp_read");
 strcpy(splocation,dbpathname);
 strcat(splocation,spfilename);
       if(dodebug==DEBUG)
              fprintf(stderr,"splocation=%s\n", splocation);
 spfd = open(splocation, O_RDONLY);
  if (spfd < 0) {
    perror("open");
    exit(-1);
     }
    nsets=0;
    do {
      nRead_sp = read(spfd, &sp_record, sizeof(sp_record));
      byteswap((char *)&sp_record.sphid, sizeof(sp_record.sphid));
      
      if(dodebug==DEBUG)
                {
              printf("sp_record.sphid=%d nsets=%d sphidold=%d\n",
              sp_record.sphid, nsets, sphidold);
//                 exit(-1);
                   }
      if((sp_record.sphid-sphidold)>1)
           nchunk[0]=sphidold;
      sphidold=sp_record.sphid;
      if (nRead_sp > 0) nsets++;
      } while (nRead_sp > 0&&sp_record.sphid<99);
      if(dodebug==DEBUG)
                {
          printf("nchunk=%d\n", nchunk[0]);
//                     exit(-1);
                       }
      if(dodebug==DEBUG) 
                   { 
                  fprintf(stderr,
        "number of sets in sp_read=%d\n", nsets);
//                     exit(-1);
                       }
      close(spfd);
}

//--------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------------
void aberratedb(double jday,double ra,double dec,
         double *rappptr,double *dappptr)
{
  // jhz 2004-7-23: based on miriad code in f and translate into c.
  //  Account for the effect of annual aberration, to convert
  //  from a true (RA,DEC) to a geocentric apparent (RA,DEC).
  // 
  // Input:
  //    jday       Julian date.
  //    ra,dec     True (RA,DEC).
  //
  // Output:
  //    rapp,dapp  Geocentric apparent (RA,DEC).
  //
  double  pos[3],vel[3],sinra,sindec,cosra,cosdec, rapp, dapp;
  void vearthdb();

  vearthdb(jday,pos,vel);
  sinra = sin(ra);
  cosra = cos(ra);
  sindec = sin(dec);
  cosdec = cos(dec);
  rapp = ra +  (-vel[0]*sinra + vel[1]*cosra)/
    (0.001*DCMKS*cosdec);
  dapp = dec + (-vel[0]*cosra*sindec - vel[1]*sinra*sindec
                + vel[2]*cosdec)/(0.001*DCMKS);
  *rappptr= rapp;
  *dappptr= dapp;
}

                          
