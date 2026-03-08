%ZOSVKSE ;SF/KAK - Automatic %GE Routine (VAX-DSM) ;06 Jan 94 1:23 pm [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003 
 ;;8.0;KERNEL;**90,94,197**;May 4, 2001
 ;
 ; VAX-DSM Version
 ;
 Q
START ;-- called by routine VAX+1^KMPSGE in VAH
 ;
 ; % = parameter passing variable
 S KMPSTEMP=%
 ;
 N KMPSDT,KMPSLOC,KMPSPROD,KMPSSITE,KMPSVOL,KMPSZU,NUM,X
 ;
 I $$NEWERR^%ZTER N $ETRAP,$ESTACK S $ETRAP="D ERR1^%ZOSVKSE"
 E  S X="ERR1^%ZOSVKSE",@^%ZOSF("TRAP")
 ;
 S U="^",KMPSSITE=$P(KMPSTEMP,U),NUM=$P(KMPSTEMP,U,2),KMPSLOC=$P(KMPSTEMP,U,3)
 S KMPSDT=$P(KMPSTEMP,U,4),KMPSPROD=$P(KMPSTEMP,U,5)
 K %,KMPSTEMP
 S KMPSZU=$ZU(0),KMPSVOL=$P(KMPSZU,",",2)
 S ^[KMPSPROD,KMPSLOC]XTMP("KMPS","START",KMPSVOL,NUM)=""
 ;
 ;-- code from routine %GE
 ;
 ; init system variables
 S X=$ZC(%UCI)
 ; quit if in baseline
 I X="" G NOUCI
 ;
 ; UCINAM = UCI name
 ; VSNAM  = volume set name
 ; GDIR   = global directory block
 ;
 S UCINAM=$P(X,","),VSNAM=$P(X,",",4),VSNUM=$P(X,",",5)  ; Get login defaults
 S UCINUM=+$ZUCI(UCINAM,VSNAM)  ; Get UCI number
 S STRNO="S"_VSNUM
 ;
GLOGET ; get globals to list
 D ^%ZOSVKSS
 I $O(%UTILITY(""))="" G END
 ;
 S (GN,UCINAM,VSNAM,STRNO)=""
 ;
NEXTGLO ; loop to next global
 S GN=$O(%UTILITY(GN))
 I GN="" G END
 I +$G(^[KMPSPROD,KMPSLOC]XTMP("KMPS","STOP")) G END
 ;
 ; check UCI and VOL for this global, if it's not the same then we
 ; need to setup a new viewbuffer and find global directory block
 ;
 ; validate global name and GV
 I '$D(@("^"_GN)) G UNDEF
 S GV=$V($ZK(GLS$GL_GLOBVEC))
 ;
 ; get noderange, local/remote, ptr, UCI and VOL for this global
 S NR=$V(GV+$ZK(G.NRANGE)),LOCAL=$V(GV+$ZK(G.REMOTE))
 S U1=$V(GV+$ZK(G.UCI),-3,3),V=$V(GV+$ZK(G.VSNAM),-3,3)
 S DPTR=$V(GV+$ZK(G.PNT)),STRNO="S"_$V(GV+$ZK(G.VSNUM))
 ;
 ; cannot do a remote (DDP) global
 I LOCAL'=0 G DDPERR
 ;
 ; UCINAM = UCI name
 ; VSNAM  = volume set name
 ;
 ; check for new directory
 I U1'=UCINAM!(V'=VSNAM) D
 .S UCINAM=U1,VSNAM=V,UCINUM=+$ZUCI(UCINAM,VSNAM)
 .S A=$ZC(%VIEWBUFFER,1,1,1)
 .; get UCI table pointer
 .V 0:STRNO
 .S UCITAB=$V(910,0,3)
 .; read the UCI block
 .V UCITAB:STRNO
 .; get global directory block number (GDIR)
 .S UCIOFF=20*(UCINUM-1),GDIR=$V(UCIOFF+2,0,3)
 ;
 ;
 ;  GN           = global name
 ;  DPTR         = first block
 ;  %UTILITY(GN) = see %ZOSVKSS routine for specifics
 ;
 S ^[KMPSPROD,KMPSLOC]XTMP("KMPS",KMPSSITE,NUM,KMPSDT,GN,KMPSZU)=DPTR_"^"_%UTILITY(GN)
 ;
 ; check first pointer level
 S TY=2,LVL=0 G LEFT
 ;
 ;  Report last level scanned
 ;
NXTLEV ; LEVNAME = pointer or bottom pointer
 I TY=2 S LEVNAME="P"
 E  I TY=6 S LEVNAME="Bottom p"
 ; E W !!,"Data level"
 ; CNT(LVL) = Number of blocks read
 ;
 ; packing efficiency
 S EFF=BYTES/(CNT(LVL)*1014)*100,EFF=$FN(EFF,"",4)
 ;
 ; if at data level, done with global
 I TY=8 D  G TOTAL
 .S ^[KMPSPROD,KMPSLOC]XTMP("KMPS",KMPSSITE,NUM,GN,KMPSZU,KMPSDT,"D")=CNT(LVL)_"^"_EFF_"%^Data"
 E  S ^[KMPSPROD,KMPSLOC]XTMP("KMPS",KMPSSITE,NUM,GN,KMPSZU,KMPSDT,LVL)=CNT(LVL)_"^"_EFF_"%^"_LEVNAME_"ointer"
 ;
 ;  Read in 1st block in next lower level and verify type
 ;
LEFT ; save type and read in 1st block in next level
 S STY=TY,BN=DPTR D BLOCK
 ;
 ; check types
 I STY=2,TY'=2,TY'=6 G BADTYP
 I STY=6,TY'=8 G BADTYP
 ;
 ; save type to check against rest of blocks at this level
 S STY=TY
 ;
 ; init counters for this level
 S LVL=LVL+1,(CNT(LVL),BYTES)=0
 ;
 ; if sizing BLP, then init next (data) level too
 I TY=6 S DLVL=LVL+1,CNT(DLVL)=0
 ;
 ; get down ptr to next level
 I TY=2!(TY=6) D GETPTR S DPTR=BN
 ;
 ;  Accumulate blocks read and offsets
 ;
COUNT S CNT(LVL)=CNT(LVL)+1,BYTES=BYTES+OFF
 I TY=6 D
 .;
 .; in the bottom pointer level
 .; count the number of down pointers and accumulate that
 .; for the number of blocks "read" at the data level
 .;
 .F P=0:0 Q:P'<OFF  D
 ..; count a node
 ..S CNT(DLVL)=CNT(DLVL)+1
 ..; advance pointer
 ..S P=P+1,P=P+$V(P,0,1)+4
 ;
 ;  Read in next block at same level
 ;
 ; done with this level if no RLP from last block
 I 'RLP G NXTLEV
 ;
 ; get right block and verify its type
 S BN=RLP
 D BLOCK
 I TY'=STY G BADTYP
 ;
 ; do counters for this block
 G COUNT
 ;
 ;  Total blocks for this global
 ;
TOTAL ; S BLKS=0 F I=1:1:LVL S BLKS=BLKS+CNT(I)
 ; W !?24,"---------",!,"Total blocks",?24,$J(BLKS,9)
 G NEXTGLO
 ;
 ;  Errors
 ;
ERR1 ; ERROR - Tell all SAGG jobs to STOP collection
 ;
 S KMPSERR="Error encountered while running SAGG collection routine for volume set"_$G(KMPSVOL)
 S KMPSERR2="Last global reference = "_$ZR
 S KMPSERR3=$$EC^%ZOSV
 ;
 I $D(KMPSLOC),$D(KMPSPROD),$D(KMPSVOL) D
 .S ^[KMPSPROD,KMPSLOC]XTMP("KMPS","ERROR",KMPSVOL)=""
 .S ^[KMPSPROD,KMPSLOC]XTMP("KMPS","STOP")=1
 .K ^[KMPSPROD,KMPSLOC]XTMP("KMPS","START",KMPSVOL)
 ;
 S X="",@^%ZOSF("TRAP")
 D ^%ZTER,UNWIND^%ZTER
 ;
 Q
 ;
UNDEF ; global ^GN is no longer defined
 G SKIP
 ;
DDPERR ; global ^GN is accessed via DDP
 G SKIP
 ;
BADTYP ; block BN contains the WRONG TYPE (type = TY)
SKIP ; scan aborted for ^GN
 G NEXTGLO
 ;
BLOCK ;  Read a block into the viewbuffer and return
 ;  its system values.
 ;
 ;  Input:
 ;        BN     - block to read
 ;        STRNO  - volset to read from
 ;  Output:
 ;        block in viewbuffer
 ;        RLP    - right-link pointer
 ;        OFF    - offset
 ;        TY     - type byte
 ;
 V BN:STRNO
 S RLP=$V(1018,0,3),TY=$V(1021,0,1),OFF=$V(1022,0,2)
 I TY>128 S TY=TY-128
 Q
 ;
GETPTR ;  Extract the 1st down pointer from block in the
 ;  viewbuffer.
 ;
 ;  Output:
 ;        BN     - downpointer
 ;
 N P
 S P=$V(1,0,1)+2
 S BN=$V(P,0,3)
 Q
 ;
NOUCI ; global efficiency is available only for volume set globals
 ; no volume sets are currently accessible
 ;
END ;
 K %UTILITY,BLKS,BN,BYTES,CNT,DLVL,DPTR,GDIR,GN,I,LVL,OFF,P,RLP,STRNO,STY,TY,UCINAM,UCIOFF,UCITAB,VSNAM,VSNUM,X
 K ^[KMPSPROD,KMPSLOC]XTMP("KMPS","START",KMPSVOL)
 Q
