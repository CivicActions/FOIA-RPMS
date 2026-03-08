ADSDDCS ;GDIT/IHS/AEF - Compare data dictionary checksums
 ;;1.0;DISTRIBUTION MANAGEMENT;**5,6**;Apr 23, 2020;Build 8
 ;
 ;New routine  
 ;Feature 80489 Mechanism to compare data dictionaries
 ;on a local instance to a standard image.
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;; 
 ;;This routine gathers data dictionary checksum values from the local
 ;;database and places them into file ADS DATA DICTIONARIES #9002293.2.
 ;;It will then compare the checksums with the "gold" checksums and
 ;;send the mismatch checksum values back to DTS.
 ;; 
 ;;$$END
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
EN ;EP ENTRY POINT
 ;
 N ERROR,OUT
 S OUT=0
 I $D(ZTQUEUED) S ZTREQ="@"
 ;
 ;Get starting date for DTS download:
 S STARTDT=$$DATE
 ;
 ;Get Local checksum data and put into FM file:
 D GETLOC
 ;
 ;Pull down data from DTS and put into FM file:
 D GETDTS(STARTDT,.OUT)
 I OUT,'$D(ZTQUEUED) D EN^DDIOL("DD CHECKSUM PROCESS ABORTED!")
 Q:OUT
 ;
 ;Compare Local checksums with DTS checksums and put into
 ;^TMP("ADSDD",$J,global:
 D GET^ADSDDRP
 ;
 ;Send differences back to DTS:
 D SENDDTS
 ;
 ;Update DD CHKSM LAST UPDATED in ADS PARAMETERS file:
 D UPDATE
 ;
 I '$D(ZTQUEUED) D EN^DDIOL("DONE!")
 I '$D(ZTQUEUED) D EN^DDIOL("Use option 'Print Data Dictionary Checksum Report' to see the data")
 ;
 ;Kill scratch globals set by various calls:
 K ^TMP("ADSDD",$J)
 K ^TMP("ADSDDFF",$J)
 K ^TMP("ADSDDCS",$J)
 K ^TMP("ADS_DTS_DD",$J)
 K ^TMP("ADS_DTS_TOTAL",$J,0)
 ;
 Q
GETLOC ;
 ;----- GET LOCAL CHECKSUM DATA AND PUT INTO FM FILE
 ;
 ;Get the local file/fields checksums:
 D LOOPDD
 ;
 ;Populate the ADS DATA DICTIONARIES file:
 D SETDATA(1)
 ;
 Q
LOOPDD ;
 ;----- LOOP THROUGH FILE/FIELD ZERO NODES AND GET SIZE
 ;This process loops through the ^DD global and gets each file/field
 ;and their checksum size and stores this data into the ^TMP global to
 ;be further processed.
 ;
 N CNT,FILE
 ;
 D ^XBKVAR
 ;
 K ^TMP("ADSDDCS",$J)
 S CNT=0
 ;
 I '$D(ZTQUEUED) D EN^DDIOL("Finding data...")
 ;
 S FILE=.1
 F  S FILE=$O(^DD(FILE)) Q:'FILE  D
 . Q:$$NTF(FILE)   ;EXCLUDE LAB FILES; IHS/GDIT/AEF ADS*1.0*6 FID110410
 . S CNT=CNT+1
 . I '$G(ZTQUEUED),'(CNT#100) W "."
 . D GET1(FILE)
 ;
 Q
GET1(FILE) ;
 ;----- GET FILE DATA
 ;
 N DATA,FLD,FLNAME,SIZE
 ;
 S FLNAME=$O(^DD(FILE,0,"NM",""))
 Q:FLNAME']""
 S DATA=$G(^DIC(FILE,0))
 I DATA']"" S DATA=$P($G(^DD(FILE,0)),U,1,2)
 S SIZE=$$SIZE(DATA)
 S ^TMP("ADSDDCS",$J,FILE_":0")=FILE_":0"_U_SIZE_U_FILE_U_FLNAME
 ;
 S FLD=0
 F  S FLD=$O(^DD(FILE,FLD)) Q:'FLD  D
 . D GETFLD(FILE,FLNAME,FLD)
 ;
 Q
GETFLD(FILE,FLNAME,FLD) ;
 ;----- GET FIELD DATA
 ;
 N DATA,FLDNAME,SIZE
 ;
 S DATA=$G(^DD(FILE,FLD,0))
 S FLDNAME=$P(DATA,U)
 S FLDNAME=$TR(FLDNAME,"|","-")  ;Change | to - in field name for DTS
 S SIZE=$$SIZE(DATA)
 S ^TMP("ADSDDCS",$J,FILE_":"_FLD)=FILE_":"_FLD_U_SIZE_U_FILE_U_FLNAME_U_FLD_U_FLDNAME
 ;
 Q
SETDATA(MODE) ;
 ;----- LOOP THROUGH ^TMP GLOBAL
 ;Loop through the ^TMP global created by LOOP and put the data into the
 ;ADS DATA DICTIONARIES file
 ;
 S MODE=1  ;1=LOCAL; 2=DTS
 ;
 I '$D(ZTQUEUED) D EN^DDIOL("Updating ADS DATA DICTIONARIES file")
 ;
 S CNT=0
 S NAME=""
 F  S NAME=$O(^TMP("ADSDDCS",$J,NAME)) Q:NAME']""  D
 . S CNT=CNT+1
 . I '$G(ZTQUEUED),'(CNT#1000) W "."
 . S DATA=$G(^TMP("ADSDDCS",$J,NAME))
 . D SET(DATA,MODE)
 ;
 Q
GETDTS(STARTDT,OUT) ;
 ;----- PULL THE DD CHECKSUMS DOWN FROM DTS AND PUT INTO FM FILE
 ;
 N ADS,X
 S OUT=0
 S STARTDT=$G(STARTDT)
 ;
 I '$D(ZTQUEUED) D EN^DDIOL("GETTING DTS DATA...")
 ;
 K ^TMP("ADS_DTS_DD",$J)
 ;
 ;Get the total number of records to be downloaded:
 S X=$$TREC(STARTDT)
 Q:'X
 S ADS("TOTREC")=+$P(X,U)
 S ADS("FIRSTREC")=+$P(X,U,2)
 S ADS("LASTREC")=+$P(X,U,3)
 S ADS("NEXTREC")=0
 S ADS("STARTDT")=$G(STARTDT)
 ;
 ;Loop to get all DTS data:
 F  D  Q:ADS("NEXTREC")>ADS("TOTREC")  Q:OUT
 . D GETDTS1(.ADS,.OUT)
 . S ADS("NEXTREC")=$G(^TMP("ADS_DTS_DD",$J,0))+1
 . I '$D(ZTQUEUED) W "."
 Q:OUT
 ;
 ;Process the downloaded DTS data into FM file:
 D PROCDTS
 ;
 I '$D(ZTQUEUED) D EN^DDIOL("Total records processed: "_ADS("TOTREC"))
 ;
 Q
GETDTS1(ADS,OUT) ;
 ;----- WEB SERVICE CALL TO GET DTS DD CHECKSUM DATA
 ;Returns number of records downloaded from DTS in ^TMP("ADS_DTS_DD",$J,0)
 ;DTS server will only download 10000 records each time, so multiple calls
 ;are needed for an initial download.
 ;
 N ERR,ERROR,EXEC,RESULT,STS,TRY
 ;
 ;Calls the (ADS.DTS.WebServiceCalls).GetDDChecksums class to get
 ;the data from DTS and place it into the ^TMP("ADS_DTS",$J) global:
 F TRY=1:1:3 S STS="",EXEC="S STS=##class(ADS.DTS.WebServiceCalls).GetDDChecksums(.ADS,.RESULT)" X EXEC Q:+STS
 I '+STS D
 . S ERROR="Web service call failure"
 . I '$D(ZTQUEUED) D EN^DDIOL(ERROR)
 . S ERR="S "_"$"_"ZE=ERROR D ^%ZTER" X ERR
 I 'STS S OUT=1
 Q
 ;
PROCDTS ;
 ;----- PROCESS DATA FROM DTS
 ;
 ;DATA WILL BE IN FORMAT:
 ;     NAME^RSUM^FILENUM^FILENAME^FIELDNUM^FIELDNAME
 ;     EX:  5:.01^62827^5^STATE^.01^NAME   
 ;     WHERE 5:.01 = 5(STATE FILE);.01(NAME FIELD) 
 ;     I 2ND : PIECE OF NAME IS 0 & FIELDNUM & FIELDNAME FIELDS = NULL, 
 ;      THEN IT IS A FILE, NOT A FIELD
 ;     EX:  5:0^7285^5^STATE^^
 ;
 ;Loop thru ^TMP("ADS_DTS_DD",$J) global and set into ADS DATA DICTIONARIES file:
 S X=0
 F  S X=$O(^TMP("ADS_DTS_DD",$J,X))  Q:'X  D
 . S DATA=^TMP("ADS_DTS_DD",$J,X)
 . Q:$$NTF($P(DATA,U,3))   ;EXCLUDE LAB FILES; IHS/GDIT/AEF ADS*1.0*6 FID110410
 . D SET(DATA,2)
 ;
 Q
TREC(STARTDT) ;
 ;----- GET TOTAL NUMBER OF RECORDS TO DOWNLOAD
 ;Returns NumberofRecords^StartingID^LastID
 ;
 N ADS,ERR,ERROR,EXEC,STS,TRY
 S ADS("STARTDT")=$G(STARTDT)
 ;
 K ^TMP("ADS_DTS_TOTAL",$J,0)
 ;
 ;Calls the (ADS.DTS.WebServiceCalls).GetDDChecksumsTotal class to get
 ;the number of records to download:
 F TRY=1:1:3 S STS="",EXEC="S STS=##class(ADS.DTS.WebServiceCalls).GetDDChecksumsTotal(.ADS,.RESULT)" X EXEC Q:+STS
 I '+STS D
 . S ERROR="Web service call failure"
 . I '$D(ZTQUEUED) D EN^DDIOL(ERROR)
 . S ERR="S "_"$"_"ZE=ERROR D ^%ZTER" X ERR
 ;
 Q $G(^TMP("ADS_DTS_TOTAL",$J,0))
 ;
COMPDD ;
 ;----- COMPARE ADS DD GLOBAL WITH DTS TO SEE IF ANY NO LONGER
 ;      EXIST
 ;
 ;ONLY DO THIS WITH A FULL DOWNLOAD!
 ;Loop thru the ^ADSDD global and if the DD does not exist in
 ;the ^DD file, delete the LOCAL CHECKSUM VALUE; if the DD
 ;does not exist in the DTS pulldown global, delete the DTS CHECKSUM
 ;VALUE.  If both the LOCAL and DTS CHECKSUM VALUEs are null, then
 ;the DD has been deleted and is nonexistent and will not show
 ;up on the reports
 ;
 N IEN,IENS,OUT
 S OUT=0
 ;
 ;Get full download from DTS:
 D GETDTS("",.OUT)
 I OUT,'$D(ZTQUEUED) D EN^DDIOL("FAILED TO RETRIEVE FULL DOWNLOAD")
 Q:OUT
 ;
 I '$D(ZTQUEUED) D EN^DDIOL("COMPARING LOCAL AND DTS DD CHECKSUMS...")
 ;
 ;Build B xref in ^TMP("ADS_DTS_DD",$J global:
 S IEN=0
 F  S IEN=$O(^TMP("ADS_DTS_DD",$J,IEN)) Q:'IEN  D
 . S X=$P(^TMP("ADS_DTS_DD",$J,IEN),U)
 . Q:X']""
 . S ^TMP("ADS_DTS_DD",$J,"B",X)=IEN
 ;
 ;Loop thru ADS Data Dictionaries file:
 S IEN=0
 F  S IEN=$O(^ADSDD(IEN)) Q:'IEN  D
 . D COMPDD1(IEN)
 ;
 ;Kill DTS download global:
 K ^TMP("ADS_DTS_DD",$J)
 Q
COMPDD1(IEN) ;
 ;
 N DATA,FIELD,FILE,IENS,MODE,NAME
 ;
 S IENS=IEN_","
 S NAME=$$GET1^DIQ(9002293.2,IENS,.01,"I")
 S FILE=$$GET1^DIQ(9002293.2,IENS,.02,"I")
 Q:$$NTF(FILE)   ;EXCLUDE LAB FILES; IHS/GDIT/AEF ADS*1.0*6 FID110410
 S FIELD=$$GET1^DIQ(9002293.2,IENS,.04,"I")
 ;
 S DATA=""
 ;
 ;If file:
 I 'FIELD,'$D(^DD(FILE,0)) D
 . ;Set LOC CHECKSUM = NULL
 . S MODE=1
 . D EDIT(IEN,DATA,MODE)
 ;
 ;If field:
 I FIELD,'$D(^DD(FILE,FIELD,0)) D
 . ;Set LOC CHECKSUM = NULL
 . S MODE=1
 . D EDIT(IEN,DATA,MODE)
 ;
 ;If not in DTS global:
 I '$D(^TMP("ADS_DTS_DD",$J,"B",NAME)) D
 . ;Set DTS CHECKSUM = NULL
 . S MODE=2
 . D EDIT(IEN,DATA,MODE)
 ;
 Q
SENDDTS ;
 ;----- SEND DIFFERENCES BACK TO DTS
 ;Adds the data to the ^XTMP("BSTSPROCQ","L") global to be transmitted
 ;to DTS via BSTS.
 ;
 ;DATASTRING=ASUFAC|DBID|SITENAME|ENTRYNAME|FILENUM|FILENAME|
 ;FLDNUM|FLDNAME|LOCRSUM|DTSRSUM|TYPE|TIMESTAMP|GUID|DOMAINNAME
 ;TYPE: 2=MISMATCH, 3=DTSONLY (missing), 4=LOCONLY
 ;
 N ASUFAC,DATA,DBID,FAC,FLDNAME,NOW,NAME,SITE,TYPE,Z
 N ADSDT,CNT S ADSDT=$$NOW^XLFDT,CNT=0  ;IHS/GDIT/AEF ADS*1.0*6 FID107834; NEW LINE
 ;
 I '$D(ZTQUEUED) D EN^DDIOL("UPLOADING DD DIFFERENCES TO DTS...")
 ;
 K ^TMP("ADSDD",$J)
 ;
 ;Timestamp:
 S NOW=$$FMTE^ADSUTL($$NOW^XLFDT)
 ;
 ;Get differences and put into ^TMP("ADSDD" scratch global:
 D GET^ADSDDRP
 ;
 ;Get Site data:
 S SITE=$$SITE^ADSUTL
 S ASUFAC=$P(SITE,U)
 S DBID=$P(SITE,U,2)
 S FAC=$P(SITE,U,3)
 I FAC D
 . S FAC=$$GET1^DIQ(4,FAC_",",.01,"E")
 ;
 ;Loop thru the ^TMP global and send the data to DTS:
 F TYPE="MISMATCH","DTSONLY","LOCONLY" D
 . S NAME=""
 . F  S NAME=$O(^TMP("ADSDD",$J,TYPE,1,NAME)) Q:NAME']""  D
 . . S DATA=^TMP("ADSDD",$J,TYPE,1,NAME)
 . . Q:$$NTF($P(DATA,U,2))   ;EXCLUDE LAB FILES; IHS/GDIT/AEF ADS*1.0*6 FID110410
 . . S FLDNAME=$P(DATA,U,5)
 . . S FLDNAME=$TR(FLDNAME,"|","-")  ;Change | to - in fieldname for DTS
 . . S Z=ASUFAC_U_DBID_U_FAC       ;FAC IDs     FLDS 1-3
 . . S Z=Z_U_NAME                  ;ENTRY NAME; FLD 4
 . . S Z=Z_U_$P(DATA,U,2)          ;FILENUM;    FLD 5
 . . S Z=Z_U_$P(DATA,U,3)          ;FILENAME;   FLD 6
 . . S Z=Z_U_$P(DATA,U,4)          ;FLDNUM;     FLD 7
 . . S Z=Z_U_FLDNAME               ;FLDNAME;    FLD 8
 . . S Z=Z_U_$P(DATA,U,6)          ;LOCRSUM;    FLD 9
 . . S Z=Z_U_$P(DATA,U,8)          ;DTSRSUM;    FLD 10
 . . S Z=Z_U_$S(TYPE="MISMATCH":2,TYPE="DTSONLY":3,TYPE="LOCONLY":4,1:"")  ;TYPE; FLD 11
 . . S Z=Z_U_NOW  ;TIMESTAMP;                   FLD 12
 . . S Z=Z_U_$P($$SITE^ADSUTL,U,4) ;GUID ;IHS/GDIT/AEF ADS*1.0*6 FID110314
 . . S Z=Z_U_$P($$SITE^ADSUTL,U,5) ;DOMAIN NAME ;IHS/GDIT/AEF ADS*1.0*6 FID110314
 . . S Z=$TR(Z,"^","|")
 . . D LOG^BSTSAPIL("ADS",42,"DDCHECKSUM",$$TFRMT^ADSRPT(Z))
 . . S CNT=CNT+1  ;IHS/GDIT/AEF ADS*1.0*6 FID107834; NEW LINE
 ;
 ;Send the data now:
 N XBDTH,XBFQ,XBIOP,XBRC
 S XBRC="PLOG^BSTSAPIL",XBFQ=1,XBDTH=$$NOW^XLFDT,XBIOP=0
 D ^XBDBQUE
 ;
 ;IHS/GDIT/AEF ADS*1.0*6 FID107834; NEW LINES:
 ;Update ADS EXPORT LOG file:
 D UPDTLOG^ADSUTL(ADSDT,"DDCS",CNT)
 ;
 Q
SET(DATA,MODE) ;
 ;----- SET FILE/FIELD VALUES INTO FM FILE
 ;
 N IEN,NAME,RSUM
 ;
 S NAME=$P(DATA,U,1)
 ;
 ;Get entry IEN in ADS DATA DICTIONARIES file:
 S IEN=$O(^ADSDD("B",NAME,0))
 ;
 ;If the entry is not in the ADS DATA DICTIONARIES file, add it:
 I 'IEN D ADD(.IEN,DATA)
 Q:'IEN
 ;
 ;Quit if checksum hasn't changed:
 S RSUM=$P(DATA,U,2)
 Q:RSUM=$P($G(^ADSDD(IEN,MODE)),U)
 ;
 ;Edit the entry and add new checksum and date:
 D EDIT(IEN,DATA,MODE)
 ;
 Q
ADD(IEN,DATA) ;
 ;----- ADD NEW FILE/FIELD TO ADS DATA DICTIONARIES FILE
 ;
 N FDA,ERR
 ;
 S FDA(9002293.2,"+1,",.01)=$P(DATA,U,1)   ;NAME
 S FDA(9002293.2,"+1,",.02)=$P(DATA,U,3)   ;FILE NUMBER
 S FDA(9002293.2,"+1,",.03)=$P(DATA,U,4)   ;FILE NAME
 S FDA(9002293.2,"+1,",.04)=$P(DATA,U,5)   ;FIELD NUMBER
 S FDA(9002293.2,"+1,",.05)=$P(DATA,U,6)   ;FIELD NAME
 D UPDATE^DIE("","FDA","IEN","ERR")
 S IEN=IEN(1)
 Q:'IEN
 ;
 Q
EDIT(IEN,DATA,MODE) ;
 ;----- EDIT RSUM DATA IN ADS DATA DICTIONARIES FILE
 ;
 N FDA,ERR
 ;
 S FDA(9002293.2,IEN_",",MODE_.1)=$P(DATA,U,2)  ;RSUM
 S FDA(9002293.2,IEN_",",MODE_.2)=DT
 S FDA(9002293.2,IEN_",",MODE_.3)=$$GET1^DIQ(9002293.2,IEN,MODE_.1,"I")
 S FDA(9002293.2,IEN_",",MODE_.4)=$$GET1^DIQ(9002293.2,IEN,MODE_.2,"I")
 D UPDATE^DIE("","FDA","IEN","ERR")
 ;
 Q
SIZE(X) ;
 ;----- RETURN SIZE OF DATA STRING
 ;Code borrowed from ^%ZOSF("RSUM"):
 ;N %,%1,%3 ZL @X S Y=0 F %=1,3:1 S %1=$T(+%),%3=$F(%1," ") Q:'%3  S %3=$S($E(%1,%3)'=";":$L(%1),$E(%1,%3+1)=";":$L(%1),1:%3-2) F %2=1:1:%3 S Y=$A(%1,%2)*%2+Y
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
 S %3=$L(%1)
 F %2=1:1:%3 S Y=$A(%1,%2)*%2+Y
 Q Y
DATE() ;
 ;----- RETURN STARTING DATE FOR DTS DD DOWNLOAD
 ;Gets the date from the DD CHKSM LAST UPDATED field in the ADS PARAMETERS file
 ;
 S Y=$$GET1^DIQ(9002292,"1,",12.3,"I")
 S Y=$$FMTE^ADSUTL(Y)
 Q Y
UPDATE ;
 ;----- UPDATE THE DATE IN THE ADS PARAMETERS FILE
 ;
 N FDA,IEN
 ;
 S FDA(9002292,"1,",12.3)=$$NOW^XLFDT
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
 S ZTDESC="ADS DATA DICTIONARY CHECKSUM EXPORT"
 S ZTRTN="EN^ADSDDCS"
 I '$D(ZTQUEUED) D  Q
 . S ZTIO=""
 . D ^%ZTLOAD
 D @ZTRTN
 ;
 Q
NTF(X) ;IHS/GDIT/AEF ADS*1.0*6 FID110410 NEW SUBROUTINE
 ;----- NOT THIS FILE
 ;Quits with a value of 1 if this file should be excluded
 ;The ADSD array should be present
 ;
 I '$D(ADSD("NOFILE")) D NOFILE(.ADSD)
 Q $D(ADSD("NOFILE",X))
 ;
NOFILE(ADSD) ;IHS/GDIT/AEF ADS*1.0*6 FID110410 NEW SUBROUTINE
 ;----- BUILD ADSD("NOFILE" ARRAY
 ;These are the files/subfiles that are excluded from DD Checksum processing:
 ;;63.04^63.07^63.041^63.05^63.06^63.061^63.292^63.29^63.291^63.3^63.31
 ;;63.332^63.33^63.341^63.34^63.35^63.351^63.361^63.1^63.36^63.371^63.37
 ;;63.372^63.111^63.11^63.38^63.39^63.4^63.181^63.18^63.41^63.42^63.43
 ;;63.432^63.431^63.44
 ;;$$END
 ;
 N I,J,X
 F I=1:1 S X=$P($T(NOFILE+I),";;",2) Q:X["$$END"  D
 . Q:X']""
 . F J=1:1:$L(X,U) D
 . . Q:$P(X,U,J)']""
 . . S ADSD("NOFILE",$P(X,U,J))=""
 Q
