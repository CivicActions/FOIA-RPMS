ADSRTNCS ;GDIT/IHS/AEF - Compare routine checksums; May 18, 2022
 ;;1.0;DISTRIBUTION MANAGEMENT;**4,5,6**;Apr 23, 2020;Build 8
 ;New Routine:  Feature 82446 Mechanism to compare routines on a local
 ;instance to a standard image.
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;This routine gathers checksum values from the local database
 ;;and places them into file ADS ROUTINES #9002293.1.  It will then
 ;;send the mismatch checksum values back to DTS
 ;; 
 ;;$$END
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
EN ;EP -- MAIN ENTRY POINT
 ;Manual entry point called by option ADSRTNCS REC/SEND RSUMS MAN
 ;
 N ERROR,OUT
 S OUT=0
 I $D(ZTQUEUED) S ZTREQ="@"
 ;
 ;Get Local checksum data and put into FM file:
 D GETLOC
 ;
 ;Pull down data from DTS and put into FM file:
 D GETDTS(.OUT)
 I OUT,'$D(ZTQUEUED) D EN^DDIOL("PROCESS ABORTED!")
 Q:OUT
 ;
 ;Compare ADS ROUTINES global with DTS and ^ROUTINE globals to see
 ;if any no longer exist:
 D COMPRTN
 ;
 ;Compare Local checksums with DTS checksums and put into
 ;^TMP("ADSROU",$J, global:
 D GET^ADSRTNRP
 ;
 ;Send differences back to DTS:
 D SENDDTS
 ;
 ;Update CHKSM LAST UPDATED in ADS PARAMETERS file: 
 D UPDATE
 ;
 I '$D(ZTQUEUED) D EN^DDIOL("DONE!")
 I '$D(ZTQUEUED) D EN^DDIOL("Use option 'Print Routine Checksum Report' to see the data")
 ;
 ;Kill scratch globals set by various calls:
 K ^TMP("ADSROU",$J)
 K ^TMP("ADS_DTS",$J,"RSUM")
 ;
 Q
GETLOC ;
 ;----- MAIN LOOP THROUGH ^ROUTINE GLOBAL
 ;This process will make sure that the routines in the ^ROUTINE
 ;global are in the ADS ROUTINES file.
 ;It will also enter the latest checksum values into the ADS
 ;ROUTINES file.
 ;This will take a while to run.
 ;
 N CNT,MODE,ROU
 ;
 I '$D(ZTQUEUED) D EN^DDIOL("FINDING LOCAL ROUTINES...")
 ;
 S MODE=1  ;1=LOCAL; 2=DTS
 ;
 S CNT=0
 S ROU=""
 F  S ROU=$O(^ROUTINE(ROU)) Q:ROU']""  D
 . Q:ROU["."
 . Q:ROU'?1U.7UN&(ROU'?1"%"1U.6UN)
 . D ONE1(ROU,MODE)
 . S CNT=CNT+1
 . I '$D(ZTQUEUED),'(CNT#100) W "."
 ;
 Q
ONE1(ROU,MODE) ;
 ;----- PROCESS ONE ROUTINE
 ;
 N IEN,ISINIT,RSUM
 ;
 ;Quit if flagged as init routine in ADS ROUTINES file:
 S IEN=$O(^ADSROU("B",ROU,0))
 Q:$$GET1^DIQ(9002293.1,IEN_",",.02,",I")
 ;
 S ISINIT=$$ISINIT(ROU)
 ;
 ;Get routine checksum:
 S RSUM=$P($$NEWSUM^XTRUTL(ROU),"/",2)
 ;
 ;Enter/edit it in the ADS ROUTINEs file:
 D SET(ROU,RSUM,MODE,ISINIT)
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
 ;Check if flagged as init in ADS ROUTINES file:
 S IEN=$O(^ADSROU("B",ROU,0))
 I $$GET1^DIQ(9002293.1,IEN_",",.02,",I") Q 1
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
 . Q:Y
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
 . ;IHS/GDIT/AEF ADS*1.0*6 FID107834; ADDED NEXT 2 LINES TO CHECK IF ROUTINE EXISTS
 . I ROU[U Q:'$L($T(@ROU))
 . I ROU'[U Q:'$L($T(@(U_ROU)))
 . S X=ROU X ^%ZOSF("LOAD")
 . F I=1:1:6 D
 . . Q:'$G(RTN(I,0))
 . . S L=RTN(I,0)
 . . S J=0 F  S J=$O(T(J)) Q:'J  D
 . . . I L[T(J) S Y=1
 ;
 ;Flag the init routine as init in the ADS ROUTINES file
 I Y D
 . S FDA(9002293.1,IEN_",",.02)=Y
 . D UPDATE^DIE("","FDA","IEN","ERR")
 ;
 Q Y
SET(ROU,RSUM,MODE,ISINIT) ;
 ;----- SET RSUM VALUE INTO FM FILE
 ;
 N IEN
 S ISINIT=$G(ISINIT)
 ;
 ;Get routine IEN in ADS ROUTINES file:
 S IEN=$O(^ADSROU("B",ROU,0))
 ;
 ;If the routine isn't in the ADS ROUTINES file, add it:
 I 'IEN D ADD(ROU,.IEN)
 Q:'IEN
 ;
 ;Edit the entry and add new checksum and date:
 D EDIT(ROU,IEN,RSUM,MODE,ISINIT)
 ;
 Q
ADD(ROU,IEN) ;
 ;----- ADD NEW ROUTINE TO ADS ROUTINES FILE
 ;
 N FDA,ERR
 ;
 S FDA(9002293.1,"+1,",.01)=ROU
 D UPDATE^DIE("","FDA","IEN","ERR")
 S IEN=IEN(1)
 Q
EDIT(ROU,IEN,RSUM,MODE,ISINIT) ;
 ;----- EDIT ROUTINE ENTRY IN ADS ROUTINES FILE
 ;
 N FDA,ERR
 ;
 ;Edit ISINIT field:
 S FDA(9002293.1,IEN_",",.02)=ISINIT
 ;
 ;Add new checksum:
 I RSUM'=$P($G(^ADSROU(IEN,MODE)),U) D
 . S FDA(9002293.1,IEN_",",MODE_.1)=RSUM
 . S FDA(9002293.1,IEN_",",MODE_.2)=DT
 . S FDA(9002293.1,IEN_",",MODE_.3)=$$GET1^DIQ(9002293.1,IEN,MODE_.1,"I")
 . S FDA(9002293.1,IEN_",",MODE_.4)=$$GET1^DIQ(9002293.1,IEN,MODE_.2,"I")
 ;
 D UPDATE^DIE("","FDA","IEN","ERR")
 ;
 Q
COMPRTN ;
 ;----- COMPARE ROUTINES IN DTS & ^ROUTINE GLOBALS
 ;
 ;Loop thru the ^ADSROU global and if the routine does not exist in
 ;the ^ROUTINE file, delete the LOCAL CHECKSUM VALUE; if the routine
 ;does not exist in the DTS pulldown global, delete the DTS CHECKSUM
 ;VALUE.  If both the LOCAL and DTS CHECKSUM VALUEs are null, then
 ;the routine has been deleted and is nonexistent and will not show
 ;up on the reports
 ;
 N ROU
 ;
 I '$D(ZTQUEUED) D EN^DDIOL("COMPARING LOCAL AND DTS RTN CHECKSUMS...")
 ;
 S ROU=""
 F  S ROU=$O(^ADSROU("B",ROU)) Q:ROU']""  D
 . D COMPRTN1(ROU)
 Q
COMPRTN1(ROU) ;
 ;----- COMPARE ONE ROUTINE
 ;
 N IEN,ISINIT
 ;
 S IEN=$O(^ADSROU("B",ROU,0))
 S ISINIT=$$GET1^DIQ(9002293.1,IEN_",",.02,"I")
 ;
 ;If not in ^ROUTINE global set LOCAL CHECKSUM VALUE = null:
 I '$D(^ROUTINE(ROU)) D
 . D SET(ROU,"@",1,ISINIT)
 ;
 ;If not in DTS global set DTS CHECKSUM VALUE = null:
 I '$D(^TMP("ADS_DTS",$J,"RSUM",ROU)) D
 . D SET(ROU,"@",2,ISINIT)
 ;
 Q
REMOVE(IEN) ;
 ;----- REMOVE ENTRY FROM ADS ROUTINES FILE
 ;
 N FDA,ERR
 ;
 S FDA(9002293.1,IEN_",",.01)="@"
 D UPDATE^DIE("","FDA","IEN","ERR")
 Q
 ;
SENDDTS ;
 ;----- SEND DIFFERENCES TO DTS
 ;Adds the data to the ^XTMP("BSTSPROCQ","L") global to be transmtted
 ;to DTS via BSTS.
 ;
 ;DATASTRING=ASUFAC|DBID|SITENAME|ROU|LOCRSUM|DTSRSUM|TYPE|TIMESTAMP|
 ;GUID|DOMAINNAME
 ;TYPE: 2=MISMATCH, 3=DTSONLY (missing), 4=LOCONLY
 ;
 N ASUFAC,DATA,DBID,FAC,NOW,ROU,SITE,TYPE,Z
 N ADSDT,CNT S ADSDT=$$NOW^XLFDT,CNT=0  ;IHS/GDIT/AEF ADS*1.0*6 FID107834; NEW LINE
 ;
 I '$D(ZTQUEUED) D EN^DDIOL("UPLOADING RTN DIFFERENCES TO DTS...")
 ;
 K ^TMP("ADSROU",$J)
 ;
 ;Timestamp:
 S NOW=$$FMTE^BSTSUTIL($$NOW^XLFDT)
 ;
 ;Get the differences and put into ^ADSROU scratch global:
 D GET^ADSRTNRP
 ;
 ;Get Site data:
 S SITE=$$SITE^ADSUTL
 S ASUFAC=$P(SITE,U)
 S DBID=$P(SITE,U,2)
 S FAC=$P(SITE,U,3)
 I FAC D
 . S FAC=$$GET1^DIQ(4,FAC_",",.01,"E")
 ;
 ;Loop thru the global and send to DTS:
 F TYPE="MISMATCH","DTSONLY","LOCONLY" D
 . S ROU=""
 . F  S ROU=$O(^TMP("ADSROU",$J,TYPE,1,ROU)) Q:ROU']""  D
 . . S Z=ASUFAC_U_DBID_U_FAC
 . . S DATA=^TMP("ADSROU",$J,TYPE,1,ROU)
 . . S Z=Z_U_ROU_U_$P(DATA,U,2)
 . . S Z=Z_U_$P(DATA,U,4)
 . . S Z=Z_U_$S(TYPE="MISMATCH":2,TYPE="DTSONLY":3,TYPE="LOCONLY":4,1:"")
 . . S Z=Z_U_NOW
 . . S Z=Z_U_$P($$SITE^ADSUTL,U,4)  ;GUID ;IHS/GDIT/AEF ADS*1.0*6 FID110314
 . . S Z=Z_U_$P($$SITE^ADSUTL,U,5)  ;DOMAIN NAME ;IHS/GDIT/AEF ADS*1.0*6 FID110314
 . . S Z=$TR(Z,"^","|")
 . . D LOG^BSTSAPIL("ADS",42,"CHECKSUM",$$TFRMT^ADSRPT(Z))
 . . S CNT=CNT+1  ;IHS/GDIT/AEF ADS*1.0*6 FID107834; NEW LINE
 ;
 ;Send the data now:
 N XBDTH,XBFQ,XBIOP,XBRC
 S XBRC="PLOG^BSTSAPIL",XBFQ=1,XBDTH=$$NOW^XLFDT,XBIOP=0
 D ^XBDBQUE
 ;
 ;IHS/GDIT/AEF ADS*1.0*6 FID107834; NEW LINES:
 ;Update ADS EXPORT LOG file:
 D UPDTLOG^ADSUTL(ADSDT,"RCS",CNT)
 ;
 Q
GETDTS(OUT) ;
 ;----- PULL THE ROUTINE CHECKSUMS DOWN FROM DTS
 ;
 N DATA,ERR,ERROR,EXEC,ISINIT,RESULT,ROU,RSUM,STS,TRY,X
 ;
 I '$D(ZTQUEUED) D EN^DDIOL("GETTING DTS DATA...")
 ;
 K ^TMP("ADS_DTS",$J)
 ;
 ;Calls the (ADS.DTS.WebServiceCalls).GetRoutineChecksums class to get
 ;the data from DTS and place it into the ^TMP("ADS_DTS",$J) global:
 F TRY=1:1:3 S STS="",EXEC="S STS=##class(ADS.DTS.WebServiceCalls).GetRoutineChecksums(.RESULT)" X EXEC Q:+STS
 I '+STS D
 . S ERROR="Web service call failure"
 . I '$D(ZTQUEUED) D EN^DDIOL(ERROR)
 . S ERR="S "_"$"_"ZE=ERROR D ^%ZTER" X ERR
 I 'STS S OUT=1
 Q:OUT
 ;
 ;Loop thru ^TMP("ADS_DTS",$J) global and put into ADS ROUTINES file:
 S X=0
 F  S X=$O(^TMP("ADS_DTS",$J,X))  Q:'X  D
 . S DATA=^TMP("ADS_DTS",$J,X)
 . S ROU=$P(DATA,U)
 . S RSUM=$P(DATA,U,2)
 . S ISINIT=$P(DATA,U,3)
 . D SET(ROU,RSUM,2,ISINIT)
 . ;Create "RSUM" xref:
 . S ^TMP("ADS_DTS",$J,"RSUM",ROU)=RSUM
 ;
 Q
UPDATE ;
 ;----- UPDATE THE DATE IN THE ADS PARAMETERS FILE
 ;
 N FDA,IEN
 ;
 S FDA(9002292,"1,",12.2)=$$NOW^XLFDT
 D UPDATE^DIE("","FDA","IEN")
 ;
 Q
AUTO ;
 ;----- AUTOMATICALLY RUN CHECKSUM UPDATE
 ;Called by TASK^ADSFAC to automatically run the checksum update/export
 ;in the background.
 ;Only run on day indicated in DOW TO RUN SO EXTRACT field in the
 ;ADS PARAMETERS FILE if it is populated.
 ;
 N ADSDAY,ADSTODAY,OUT,X,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSK
 ;
 ;Check if export switch is on:
 S X=$$GET1^DIQ(9002292,"1,",12.1,"I")
 Q:'X
 ;
 ;Check if it should run this day:
 S ADSDAY=$$GET1^DIQ(9002292,"1,",11.4,"E")
 I ADSDAY]"" D   ;comment out this line to make it run every day.
 .S X=DT
 .D DW^%DTC
 .S ADSTODAY=X
 .S:ADSTODAY'=ADSDAY OUT=1
 Q:$G(OUT)
 ;
 ;Queue the background job:
 S ZTDTH=$$NOW^XLFDT
 S ZTDESC="ADS ROUTINE CHECKSUM COMPARISON"
 S ZTRTN="EN^ADSRTNCS"
 I '$D(ZTQUEUED) D  Q
 . S ZTIO=""
 . D ^%ZTLOAD
 D @ZTRTN
 ;
 Q
MAN ;
 ;----- MANUAL ENTRY POINT TO RUN CHECKSUM UPDATES
 ;Called by ADSRTNCS REC/SEND RSUMS MAN menu option to manually run
 ;both the routine checksum and data dictionary checksum updates.
 ;
 D EN^ADSRTNCS
 D EN^ADSDDCS
 ;
 Q
