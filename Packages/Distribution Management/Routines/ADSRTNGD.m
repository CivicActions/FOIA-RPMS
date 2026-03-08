ADSRTNGD ;GDIT/HS/AEF - SEND ROUTINE DATA FROM GOLD DB TO DTS ; May 16, 2022
 ;;1.0;DISTRIBUTION MANAGEMENT;**4,5**;Apr 23, 2020;Build 14
 ;
 ;Feature 82446 Mechanism to compare routines on a local instance
 ;to a standard image.
 ;Feature 80489 Provide mechanism to compare data dictionaries on a
 ;local instance to a standard image
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;This routine gathers routine and DD checksum data from the HQ SQA
 ;;Gold Database and sends it to the DTS central server.  It
 ;;should run on a daily basis via an autoqueued option.  This
 ;;routine should only run on the HQ SQA Gold database and nowhere
 ;;else.
 ;;
 ;;$$END
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
AUTO ;EP -- AUTOQUEUED ENTRY POINT
 ;Gather the data and send it
 ;
 N GBL
 D ^XBKVAR
 ;
 S GBL="^ADSRTNGD"
 ;
 ;Get routine data:
 D RTN(GBL)
 I $D(@GBL) D SEND($P(GBL,U,2),"RTNGD")
 ;
 ;Get DD data:
 D DD(GBL)
 I $D(@GBL) D SEND($P(GBL,U,2),"DDGD")
 ;
 K @GBL
 ;
 Q
RTN(GBL) ;
 ;----- GET ROUTINE DATA
 ;Build ^ADSRTNGD scratch global containing routine name, checksum
 ;
 N CNT,ROU,RSUM
 ;
 K @GBL
 ;
 I '$G(ZTQUEUED) D BMES^XPDUTL("Building ADSRTNGD file...")
 ;
 ;Loop thru ^ADSROU global:
 S CNT=0
 S ROU=""
 F  S ROU=$O(^ROUTINE(ROU)) Q:ROU']""  D
 . S CNT=CNT+1
 . I '$G(ZTQUEUED),'(CNT#100) W "."
 . Q:ROU["."
 . Q:ROU'?1U.7UN&(ROU'?1"%"1U.6UN)
 . S RSUM=$P($$NEWSUM^XTRUTL(ROU),"/",2)
 . Q:'RSUM
 . S @GBL@(ROU)=ROU_","_RSUM_","_+$$ISINIT(ROU)
 Q
DD(GBL) ;
 ;----- GET DATA DICTIONARY DATA
 ;Build ^ADSRTNGD scratch global containing DD file and field data
 ;
 N CNT,DD,FILE
 ;
 K @GBL
 ;
 I '$G(ZTQUEUED) D BMES^XPDUTL("Building ADSDDGD file...")
 ;
 ;Loop thru ^DD global:
 S CNT=0
 S FILE=.1
 F  S FILE=$O(^DD(FILE)) Q:'FILE  D
 . S CNT=CNT+1
 . I '$G(ZTQUEUED),'(CNT#100) W "."
 . D GET1DD(FILE,GBL)
 ;
 Q
GET1DD(FILE,GBL) ;
 ;----- GET DD DATA
 ;
 N DATA,FLD,FLNAME,SIZE
 ;
 S FLNAME=$O(^DD(FILE,0,"NM",""))
 Q:FLNAME']""
 S DATA=$G(^DIC(FILE,0))
 I DATA']"" S DATA=$P($G(^DD(FILE,0)),U,1,2)
 S SIZE=$$SIZE(DATA)
 S @GBL@(FILE_":"_0)=FILE_":"_0_U_SIZE_U_FILE_U_FLNAME_U_U
 ;
 S FLD=0
 F  S FLD=$O(^DD(FILE,FLD)) Q:'FLD  D
 . D GETFLD(FILE,FLNAME,FLD,GBL)
 ;
 Q
GETFLD(FILE,FLNAME,FLD,GBL) ;
 ;----- GET FIELD DATA
 ;
 N DATA,FLDNAME,SIZE
 ;
 S DATA=$G(^DD(FILE,FLD,0))
 S FLDNAME=$P(DATA,U)
 S FLDNAME=$TR(FLDNAME,"|","-")  ;Replace | with - in field name for DTS
 S SIZE=$$SIZE(DATA)
 S @GBL@(FILE_":"_FLD)=FILE_":"_FLD_U_SIZE_U_FILE_U_FLNAME_U_FLD_U_FLDNAME
 ;
 Q
ISINIT(ROU) ;
 ;----- CHECKS IF ROUTINE IS AN INIT ROUTINE
 ;
 ;      INPUT:
 ;      ROU  =  ROUTINE NAME
 ;
 ;       OUTPUT:
 ;       Y  =  0 IF NOT INIT ROUTINE
 ;             1 IF IT IS AN INIT ROUTINE
 ;
 N DIF,ERR,FDA,IEN,J,L,MATCH,T,X,XCNP,Y
 S Y=0,MATCH=""
 ;
 I $L(ROU)>8!(ROU[".") Q 0
 ;
 ;Check if name matches DIFROM pattern:
 I ROU?1U1.3UN1"I"1(1N,1"N")1.UN S MATCH=1
 ;
 ;If name matches DIFROM pattern, check first line of routine:
 I $G(MATCH) D
 . S X=$T(^@ROU)
 . I $L(X) D
 . . S X=$TR(X," ","")
 . . Q:$P(X,";",2)]""
 . . S X=$P(X,";",3)
 . . I X?2N1"-"3U1"-"4N.E S Y=1         ;EXAMPLE: 24-MAY-1991
 . . I X?3U1.2N1","2.4N S Y=1           ;EXAMPLE: MAY24,1991
 . . I X?1.2N1"/"1.2N1"/"2.4N.E S Y=1   ;EXAMPLE: 5/24/91
 . . I X']"" S Y=1                      ;EMPTY
 . ;
 . ;If still suspect it is an init, take a closer look,
 . ;ZLOAD the routine, check lines 1-6:
 . S T(1)="Q:'DIFQ"
 . S T(2)="K DIF,DIFQ"
 . S T(3)="F I=1:2 S X=$T(Q+I)"
 . S T(4)="K ^UTILITY(""DIFROM"",$J)"
 . S T(5)="K DIF,DIK,D,DDF,DDT,DTO,D0,DLAYGO,DIC,DIDUZ,DIR,DA,DFR,DTN,DIX,DZ D DT^DICRW S %=1,U=""^"",DSEC=1"
 . S XCNP=0,DIF="RTN("
 . K RTN
 . S X=ROU X ^%ZOSF("LOAD")
 . F I=1:1:6 D
 . . Q:'$G(RTN(I,0))
 . . S L=RTN(I,0)
 . . S J=0 F  S J=$O(T(J)) Q:'J  D
 . . . I L[T(J) S Y=1
 ;
 Q Y
SIZE(X) ;
 ;----- RETURN SIZE OF DATA STRING
 ;Code borrowed from ^%ZOSF("RSUM")
 ;
 ;The original code from ^%ZOSF("RSUM") gathered the size of each line of
 ;a routine and added them together to get the cumulative size of the
 ;entire routine.
 ;This code is modified to return only the size of one datastring.  It
 ;gets the $A value of each character in the string and multiplies it by
 ;the character's position in the string and adds the value to Y.
 ;Y contains the cumulative values of each character*position in the
 ;string.
 ;
 N %1,%2,%3,Y
 ;
 S Y=0
 S %1=X
 F %3=$L(%1)
 F %2=1:1:%3 S Y=$A(%1,%2)*%2+Y
 Q Y
 ;
SEND(GBL,FN) ;
 ;Use XBGSAVE to send it to the server
 ;\\d1.na.ihs.gov\hqabq-fs1\Limited\DIT\ADS\RoutineChecksums
 ;
 N XBF,XBFLG,XBFLT,XBFN,XBGL,XBMED,XBNAR,XBPAFN,XBQ,XBS1,XBTLE,XBUF
 D ^XBKVAR
 ;
 ;File name:
 S XBFN="ADS"_FN
 ;Destination folder:
 S XBUF="\\d1.na.ihs.gov\hqabq-fs1\Limited\DIT\ADS\"
 I FN="RTNGD" S XBUF=XBUF_"RoutineChecksums"
 I FN="DDGD" S XBUF=XBUF_"DDChecksums"
 ;S XBUF="H:\Temp\F1Q2D"  ;*** FOR TESTING ***
 ;Global to be copied to file:
 S XBGL=GBL
 ;Other necessary variables:
 S XBMED="F"
 S XBTLE=FN
 S XBF=0
 S XBFLT=1
 S XBQ="N"
 S XBNAR=FN
 S XBS1=""
 S XBFLG(9)=""
 ;
 ;Put file into folder:
 D ^XBGSAVE
 ;
 Q
