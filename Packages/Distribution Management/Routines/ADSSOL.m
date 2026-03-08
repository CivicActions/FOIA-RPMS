ADSSOL ;IHS/GDIT/AEF - Send Sign-on Log Data to DTS Central Server
 ;;1.0;DISTRIBUTION MANAGEMENT;**3,6**;Apr 23, 2020;Build 8
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;This routine gathers data from the Sign-On Log file and sends
 ;;it to the IHS Central Repository database. 
 ;; 
 ;;$$END
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
AUTO ;EP  -- AUTOQUEUED ENTRY POINT
 ;Gather data since last date/time transmitted
 ;This subroutine is called by TASK^ADSFAC
 ;
 ;
 N DAY,X,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSK  ;IHS/GDIT/AEF ADS*1.0*6 FID107605
 ;
 ;Don't run if switch is not on:
 Q:'$$GET1^DIQ(9002292,1,11.3,"I")
 ;
 ;Only run on day indicated in DOW TO RUN SO EXTRACT field in the
 ;ADS PARAMETERS FILE:
 S X=DT
 D DW^%DTC
 S DAY=X
 S X=$$GET1^DIQ(9002292,"1,",11.4,"E")
 Q:DAY'=X
 ;
 ;IHS/GDIT/AEF ADS*1.0*6 FID107605; ADD QUEUEING CODE
 ;Queue the background job:
 S ZTDTH=$$NOW^XLFDT
 S ZTDESC="ADS SIGN-ON LOG EXTRACT"
 S ZTRTN="DQ^ADSSOL"
 I '$D(ZTQUEUED) D  Q
 . S ZTIO=""
 . D ^%ZTLOAD
 D @ZTRTN
 ;
 Q
MAN ;EP  -- MANUAL ENTRY POINT
 ;Gather and send the Sign-in Log data to central server
 ;
 N ADS,X
 ;
 D ^XBKVAR
 ;
 S X=DT
 D DW^%DTC
 I X="FRIDAY"!(X="SATURDAY") D
 . D EN^DDIOL("WARNING: Running this extract on Friday or Saturday could have a negative impact on the DTS Central Server.")
 ;
 ;Get user input:
 D PROMPTS(.ADS)
 Q:'$G(ADS("DTS"))
 ;
 D DOIT(.ADS)
 ;
DQ ;EP ;QUEUED AUTO JOB STARTS HERE ;IHS/GDIT/AEF ADS*1.0*6 FID107605 ;NEW SUBROUTINE
 ;
 N ADS,BEGIN,END
 ;
 ;Begin where we left off last time:
 S BEGIN=$$GET1^DIQ(9002292,1,11.2,"I")
 ;Add 1 second to prevent sending last one again:
 I BEGIN S BEGIN=$$FMADD^XLFDT(BEGIN,,,,1)
 ;If there is no begin date, go back 7 days:
 I 'BEGIN D
 . S BEGIN=$$FMADD^XLFDT(DT,-7)
 ;
 ;Set end date:
 S END=$$FMADD^XLFDT(DT,1)_".99999999"
 ;
 S ADS("DTS")=BEGIN_U_END
 ;
 D DOIT(.ADS)
 ;
 Q
DOIT(ADS) ;
 ;----- DO THE REPORT
 ;Come here after all prompts are answered
 ;
 ;Get the data:
 D GET(.ADS)
 ;
 ;Set the data into the ^XTMP("BSTSPROCQ","L") global:
 D SEND
 ;
 ;Send the data now: *** REMOVE THIS WILL BE CALLED FROM ADSUTL
 ;D PLOG^BSTSAPIL
 ;
 ;Kill the ^TMP global when done:
 K ^TMP("ADSSOL",$J)
 ;
 Q
GET(ADS) ;
 ;----- GET THE DATA
 ;Put into ADSD data array
 ;
 N ADSD,ADSDT,ADSDTS,BEGIN,END
 K ^TMP("ADSSOL",$J)
 ;
 ;Set beginning and ending dates:
 S BEGIN=$P(ADS("DTS"),U)
 S END=$P($P(ADS("DTS"),U,2),".")
 I '$P(END,".",2) S END=END_".999999"
 ;
 ;Loop thru Sign-in Log file ^XUSEC(0 global and set data 
 ;arrays:
 S ADSDT=BEGIN
 F  S ADSDT=$O(^XUSEC(0,ADSDT)) Q:'ADSDT  Q:ADSDT>END  D
 . D SET(ADSDT,.ADSD)
 Q
SET(ADSDT,ADSD) ;
 ;----- SET DATA STRING
 ;
 N ADSDATA,ADSERR,ASUFAC,FILE,IENS,P,SECS,Z
 ;
 ;Get the data:
 S FILE=3.081
 S IENS=ADSDT_","
 D GETS^DIQ(FILE,IENS,"*","IE","ADSDATA","ADSERR")
 Q:$D(ADSERR)   ;IHS/GDIT/AEF ADS*1.0*6 FID102698
 ;
 ;Filter out EPCS logins:
 Q:ADSDATA(FILE,IENS,.01,"E")["EPCS,SERVICE CERT"
 ;
 ;Strip "*" from elapsed time:
 S SECS=$TR(ADSDATA(FILE,IENS,97,"I")," ")
 I SECS]"" S SECS=+SECS
 ;
 ;Get ASUFAC:
 S ASUFAC=ADSDATA(FILE,IENS,17,"I")
 I ASUFAC S ASUFAC=$$GET1^DIQ(9999999.06,ASUFAC_",",.12)
 ;
 ;Format DATA string, set array member into ^TMP global:
 S P="|"
 S Z=""
 S Z=Z_$$FMTDT(ADSDATA(FILE,IENS,.001,"I"))_P  ;.001 DATE/TIME FORMATTED
 S Z=Z_ADSDATA(FILE,IENS,.01,"I")_P   ;.01 USER DFN
 S Z=Z_ADSDATA(FILE,IENS,.01,"E")_P   ;.01 USER NAME
 S Z=Z_$$FMTDT(ADSDATA(FILE,IENS,3,"I"))_P  ;3 SIGNOFF TIME FORMATTED
 S Z=Z_ADSDATA(FILE,IENS,4,"E")_P     ;4 CPU
 S Z=Z_ADSDATA(FILE,IENS,10,"E")_P    ;10 NODE NAME
 S Z=Z_ADSDATA(FILE,IENS,16,"E")_P    ;16 FORCE CLOSE
 S Z=Z_ASUFAC_P                       ;17 DIVISION:ASUFAC
 S Z=Z_SECS_P                         ;97 ELAPSED TIME (SECONDS)
 S Z=Z_$P($$SITE^ADSUTL,U,4)_P        ;GUID ;IHS/GDIT/AEF ADS*1.0*6 FID110314
 S Z=Z_$P($$SITE^ADSUTL,U,5)_P        ;DOMAIN NAME ;IHS/GDIT/AEF ADS*1.0*6 FID110314
 S ^TMP("ADSSOL",$J,"DATASTRING",ADSDT)=Z
 ;
 Q
SEND ;
 ;----- SEND THE DATA
 ;Put the data strings in the BSTS global
 ;
 N ADSDTL,CNT S ADSDTL=$$NOW^XLFDT,CNT=0  ;IHS/GDIT/AEF ADS*1.0*6 FID107834; NEW LINE
 ;
 ;Quit if there is no data to send:
 Q:'$D(^TMP("ADSSOL",$J))
 ;
 ;Loop thru ^TMP global and send each entry:
 S ADSDT=0
 F  S ADSDT=$O(^TMP("ADSSOL",$J,"DATASTRING",ADSDT)) Q:'ADSDT  D
 . D SENDONE(ADSDT,.CNT)  ;IHS/GDIT/AEF ADS*1.0*6 FID107834 ;ADD CNT
 ;
 ;IHS/GDIT/AEF ADS*1.0*6 FID107834; NEW LINES:
 ;Update ADS EXPORT LOG file:
 D UPDTLOG^ADSUTL(ADSDTL,"SOL",CNT)
 ;
 Q
SENDONE(ADSDT,CNT) ;IHS/GDIT/AEF ADS*1.0*6 FID107834 ;ADD CNT
 ;----- SEND ONE ENTRY
 ;
 N DATA
 ;
 S DATA=^TMP("ADSSOL",$J,"DATASTRING",ADSDT)
 Q:DATA']""
 ;
 ;Put entry in BSTS log queue:
 D LOG^BSTSAPIL("ADS",42,"SIGNON",$$TFRMT^ADSRPT(DATA))
 ;Example:
 ;^XTMP("BSTSPROCQ","L",SEQ#)="ADS^3220317.123909^42^SIGNON^
 ;2022-03-07 15:05:23|6363|FUGATT,ANNE|2022-03-07 15:07:21|DEHR|R
 ;PMSDEVCON01||202101|118|"
 ;
 S CNT=CNT+1  ;IHS/GDIT/AEF ADS*1.0*6 FID107834; NEW LINE
 ;
 ;Enter login date into parameters file:
 D LOGDT(ADSDT)
 ;
 Q
LOGDT(ADSDT) ;
 ;----- LOG THE LOGIN-IN DATE INTO THE ADS PARAMETERS FILE
 ;Records earliest and latest date/time EVER sent to DTS
 ;
 N ERR,FDA,IEN
 Q:'ADSDT
 ;
 ;If log-in date/time < earliest date/time, log the date:
 I (ADSDT<$P($G(^ADSPARM(1,11)),U))!(($P($G(^ADSPARM(1,11)),U))="") D
 . S FDA(9002292,"1,",11.1)=ADSDT
 ;
 ;If log-in date/time > latest date/time, log the date:
 I ADSDT>$P($G(^ADSPARM(1,11)),U,2) D
 . S FDA(9002292,"1,",11.2)=ADSDT
 ;
 ;Update the params:
 I $D(FDA) D
 . D UPDATE^DIE("","FDA","IEN","ERR")
 ;
 Q
PROMPTS(ADS) ;
 ;----- PROMPTS FOR INPUT
 ;Returns ADS array
 ;
 N ADSDTS
 S ADSDTS=""
 ;
 ;Get date range:
 D DATES(.ADSDTS)
 Q:'ADSDTS
 S ADS("DTS")=ADSDTS
 ;
 Q
DATES(ADSDTS) ;
 ;----- PROMPT FOR DATE RANGE
 ;
 ;      OUTPUT:
 ;      ADSDTS  =  BEGIN^END
 ;
 N BEGIN,DIR,DIROUT,DIRUT,END,X,Y
 ;
 ;Prompt for beginning date:
 ;(Use last ending date for default)
 S DIR(0)="DO^::ETS"
 S DIR("A")="Enter BEGINNING DATE"
 I $$GET1^DIQ(9002292,"1,",11.2,"I") D
 . S DIR("B")=$$FMTE^XLFDT($E($$GET1^DIQ(9002292,"1,",11.2,"I"),1,14))
 D ^DIR
 Q:$D(DIRUT)!($D(DIROUT))!(+Y'>0)
 S BEGIN=+Y
 I BEGIN=$$GET1^DIQ(9002292,"1,",11.2,"I") D
 . S BEGIN=$$FMADD^XLFDT(BEGIN,,,,1)
 ;
 ;Prompt for ending date:
 ;(NOW is default)
 K DIR
 S DIR(0)="DOA^"_BEGIN_"::ETS"
 S DIR("A")="Enter ENDING DATE: "
 S DIR("B")="NOW"
 D ^DIR
 Q:$D(DIRUT)!($D(DIROUT))!(+Y'>0)
 S END=+Y
 I '$P(END,".",2) S END=END_".999999"
 ;
 S ADSDTS=BEGIN_U_END
 ;
 Q
FMTDT(X) ;
 ;----- FORMAT FM DATE/TIME TO SQL YYYY-MM-DD HH:MM:SS FORMAT
 ;
 ;Will return the date in MAY 26, 2022 17:22:23 format:
 ;(will append :00 if there are no minutes after the hour,
 ;this is what DTS needs)
 Q $$FMTE^BSTSUTIL(X)
 ;
DOW(DAY) ;
 ;----- INPUT XFORM FOR 'DOW TO RUN SO EXTRACT' FIELD
 ;      DAY = INTERNAL DAY OF WEEK
 ;      Example input xform:
 ;      I 67[X K:'$$DOW^ADSSOL(X) X
 ;
 N ANS,DAYS,DIR,DIRUT,DTOUT,X,Y
 ;
 S DAYS="SUNDAY^MONDAY^TUESDAY^WEDNESDAY^THURSDAY^FRIDAY^SATURDAY"
 S DAY=$P(DAYS,U,DAY)
 ;
 D EN^DDIOL("CAUTION: Running the extract on "_DAY_" could impact DTS Workload")
 S ANS=0
 S DIR(0)="Y"
 S DIR("A")="Do you really want to run it on that day"
 S DIR("B")="NO"
 D ^DIR
 K DIR
 Q:($D(DIROUT)!($D(DTOUT)))
 S ANS=Y
 Q ANS
