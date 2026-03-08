%ZOSVKSD ;SF/KAK - Calculate Disk Capacity ; 25 Jan 1999 4:23 pm [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1007**;APR 1, 2003
 ;;8.0;KERNEL;**121,197**;May 4, 2001
 ;
 ; This routine will help to calculate disk capacity for
 ; either DSM or OpenM-NT system platforms by looking up
 ; volume set table information
 ;
EN(SITENUM,SESSNUM,VOLS) ;-- called by routine SYS+2^KMPSLK
 ;--------------------------------------------------------------------
 ; SITENUM = Station number of site
 ; SESSNUM = SAGG session number
 ; VOLS    = Array containing names of monitored volumes
 ;
 ; Returns ^XTMP("KMPS",SITENUM,SESSNUM,"@VOL",vol_name) = vol_size
 ;--------------------------------------------------------------------
 ;
 N OS,OSTAG
 S OS=$P($G(^%ZOSF("OS")),U),OSTAG=$S(OS["VAX DSM":"DSM",OS["OpenM-NT":"OMNT",1:"UNK")
 Q:OSTAG="UNK"
 D @OSTAG
 Q
 ;
DSM ;--------------------------------------------------------------------
 ; VAX-DSM code
 ;--------------------------------------------------------------------
 ;
 ;-- code from routine %VOLDEF
 ;
VOLSET ;
 D VSSEL(,,"FULL")
 Q
 ;
VSSEL(PAR,VAL,FLAG) ;
 ; PAR  = "VSNUM","VSNAM", or "DBNAM" (optional)
 ; VAL  = value of PAR (optional)
 ; FLAG = shows what to be included for all VOL nodes (optional)
 ;        "FULL" - includes all volumes 
 ;
 S PAR=$G(PAR),VAL=$G(VAL),FLAG=$G(FLAG)
 N N,QUIT,V,VT,VOL,VOLNAM,VOLTOT
 ;
 I '$$SM Q
 S VOL=$$NVOLSETS-1
 F V=0:1:VOL S VOL(V)="" I $V($$SMX("VOLSNAM",V)) D
 .;
 .; define variable QUIT
 .I FLAG["FULL" S QUIT=0
 .;
 .; point to volume table
 .S VT=$$VOLTAB(V)
 .;
 .; get volume set mount name
 .S VOL(V)=$V(VT+$ZK(VOLTAB_NAM),-3,3)
 .;
 .S VOLNAM=VOL(V),VOLTOT=0
 .;
 .; build volume set table
 .F N=1:1:$V(VT+$ZK(VOLTAB_VOLS)) S VOLTOT=VOLTOT+$$GETVID(VT,N)
 .D SETNODE(SITENUM,SESSNUM,VOLNAM,VOLTOT)
 Q
 ;
SM(X,S) ;
 ; start of shared memory
 I $G(X)="" Q $V($ZK(GLS$SMSTART))
 I $G(S)="" S S="L"
 X "S X=$V($ZK(GLS$SMSTART))+$ZK(GLS$"_S_"_"_X_")"
 Q X
 ;
SMX(X,INDEX) ;
 Q $$SM(X,"AL")+(4*INDEX)
 ;
NVOLSETS() ;
 Q $V($$SM("NVOLSETS"))
 ;
VOLTAB(VSNUM) ; pointer to volume table entry
 Q $$SM+$V($$SMX("VOLTAB",VSNUM))
 ;
GETVID(VT,N) ; Get info from volume descriptor for each volume
 ;
 ; get number of blocks
 Q ($V(N-1*8+$ZK(VOLTAB_VDES)+VT))
 ;
 ;-- end of code from routine %VOLDEF
 ;
OMNT ;--------------------------------------------------------------------
 ; OpenM-NT Version for Cache 3.2
 ;--------------------------------------------------------------------
 ;
 ;-- code from routine %FREECNT
 ;
 N DIR,DIRUP,VOLTOT,X,Y,ZU
 ;
 S DIR=""
 F  S DIR=$O(^|"%SYS"|SYS("UCI",DIR)) Q:DIR=""  D
 .Q:$G(^|"%SYS"|SYS("UCI",DIR))]""
 .S X=DIR
 .X ^%ZOSF("UPPERCASE")
 .;
 .; strip off trailing '\' if needed
 .I $E(Y,$L(Y))="\" S Y=$E(Y,1,$L(Y)-1)
 .S DIRUP=Y
 .;
 .; use $ZU(49) to see if directory is mounted
 .S ZU=$ZU(49,DIR)
 .;
 .; quit if directory does not exist or is dismounted
 .Q:ZU<0
 .;
 .; quit is directory is not mounted
 .Q:+ZU=256
 .;
 .; volume size = blocks per map * number of maps
 .S VOLTOT=+$P(ZU,",",2)*$P(ZU,",",4)
 .;
 .;-- end of code from routine %FREECNT
 .;
 .D SETNODE(SITENUM,SESSNUM,DIRUP,VOLTOT)
 Q
 ;
SETNODE(SITENUM,SESSNUM,VOLNAM,VOLTOT) ;
 ; Set the @VOL node in the ^XTMP("KMPS" global array
 ;
 ; quit if SAGG is not monitoring this volume set (directory)
 Q:'$D(VOLS(VOLNAM))
 ;
 S ^XTMP("KMPS",SITENUM,SESSNUM,"@VOL",VOLNAM)=VOLTOT
 Q
