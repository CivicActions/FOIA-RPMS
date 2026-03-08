ADSSTAT ;IHS/GDIT/AEF - Send Log Stats to DTS Central Server
 ;;1.0;DISTRIBUTION MANAGEMENT;**6**;Apr 23, 2020;Build 8
 ;
 ;IHS/GDIT/AEF ADS*1.0*6 FID107834
 ;New routine
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;This routine gathers statistical data from the ADS EXPPORT LOG file
 ;;and sends it to the IHS Central Repository database. 
 ;;It should run each Friday and gather the data from the previous
 ;;week, Friday (T-7) - Thursday (T-1).
 ;; 
 ;;$$END
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
AUTO ;EP  -- AUTOQUEUED ENTRY POINT
 ;This should run each Friday after the main exports are run
 ;Gather data from the previous week Friday - Thursday
 ;This subroutine is called by TASK^ADSFAC
 ;
 ;
 N ADS,BEG,DAY,DAYS,END,X,Y,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 ;
 ;Don't run if switch is not on:
 Q:'$$GET1^DIQ(9002292,1,11.3,"I")
 ;
 ;Get the DAY AFTER day indicated in DOW TO RUN SO EXTRACT field in the
 ;ADS PARAMETERS FILE:
 S DAYS="SUNDAY^MONDAY^TUESDAY^WEDNESDAY^THURSDAY^FRIDAY^SATURDAY^SUNDAY"
 S X=$$GET1^DIQ(9002292,"1,",11.4,"E")
 S DAY=$P($P(DAYS,X,2),U,2)
 S X=DT
 D DW^%DTC
 Q:DAY'=X
 ;
 S BEG=$$FMADD^XLFDT(DT,-7)
 S END=$$FMADD^XLFDT(DT,-1)
 S ADS("DTS")=BEG_U_END
 ;
 ;Queue the background job:
 S ZTDTH=$$NOW^XLFDT
 S ZTDESC="ADS STATS LOG EXTRACT"
 S ZTSAVE("ADS(")=""
 S ZTRTN="DQ^ADSSTAT"
 S ZTIO=""
 D ^%ZTLOAD
 W !,"TASK "_ZTSK_" QUEUED!"
 ;
 Q
MAN ;EP -- MANUAL ENTRY POINT
 ;Manually run the statistical export selecting any date range
 ;
 N ADS
 ;
 D PROMPTS(.ADS)
 Q:'$G(ADS("DTS"))
 ;
 D DQ
 ;
 Q
DQ ;EP -- QUEUED JOB STARTS HERE
 ;ADS variable array is passed by calling routine
 ;
 N TYPE
 ;
 ;Get the TYPE array containing stats:
 D GET(.ADS,.TYPE)
 Q:'$D(TYPE)
 ;
 D SEND(.ADS,.TYPE)
 ;
 Q
GET(ADS,TYPE) ;
 ;----- GET STATS AND BUILD TYPE ARRAY
 ;
 N I,C,DATE,END,IEN,T,TYPES,X
 ;
 ;Set begin and end array;
 S ADS("BEG")=$P(ADS("DTS"),U)
 S ADS("END")=$P(ADS("DTS"),U,2)
 ;
 ;Set data type array:
 S TYPES=$P(^DD(9002292.1,.02,0),U,3)
 F I=1:1:$L(TYPES,";") D
 . S X=$P($P(TYPES,";",I),":")
 . I X]"" S TYPE(X)=0
 ;
 ;Loop thru log file "B" xref and count records:
 S END=ADS("END")
 I '$P(END,".",2) S $P(END,".",2)=999999
 S DATE=$$FMADD^XLFDT(ADS("BEG"),-1)_".999999"
 F  S DATE=$O(^ADSXPLOG("B",DATE)) Q:'DATE  Q:DATE>END  D
 . S IEN=$O(^ADSXPLOG("B",DATE,0))
 . Q:'$D(^ADSXPLOG(IEN,0))
 . S X=^ADSXPLOG(IEN,0)
 . S T=$P(X,U,2)
 . S C=$P(X,U,3)
 . S TYPE(T)=TYPE(T)+C
 ;
 Q
SEND(ADS,TYPE) ;
 ;----- SEND THE STATS TO DTS
 ;
 N ASUFAC,DBID,FAC,SITE,X,Z
 ;
 Q:'$D(TYPE)
 ;
 ;Get Site ID data:
 S SITE=$$SITE^ADSUTL
 S ASUFAC=$P(SITE,U)
 S DBID=$P(SITE,U,2)
 S FAC=$P(SITE,U,3)
 I FAC D
 . S FAC=$$GET1^DIQ(4,FAC_",",.01,"E")
 ;
 ;Set the data string:
 S Z=ASUFAC_U_DBID_U_FAC
 S Z=Z_U_$$FMTE^ADSUTL(ADS("BEG"))
 S Z=Z_U_$$FMTE^ADSUTL(ADS("END"))
 S Z=Z_U_TYPE("ASU")
 S Z=Z_U_TYPE("IZ")
 S Z=Z_U_TYPE("PKG")
 S Z=Z_U_TYPE("LIC")
 S Z=Z_U_TYPE("SOL")
 S Z=Z_U_TYPE("RCS")
 S Z=Z_U_TYPE("DDCS")
 S Z=Z_U_$P($$SITE^ADSUTL,U,4) ;GUID ;IHS/GDIT/AEF ADS*1.0*6 FID110314
 S Z=Z_U_$P($$SITE^ADSUTL,U,5) ;DOMAIN NAME; IHS/GDIT/AEF ADS*1.0*6 FID110314
 S Z=$TR(Z,"^","|")
 ;
 ;Set data into transmission log;
 D LOG^BSTSAPIL("ADS",42,"STAT",$$TFRMT^ADSRPT(Z))
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
 N BEG,DIR,DIROUT,DIRUT,END,OUT,X,Y
 S ADSDTS=""
 S OUT=0
 ;
 ;Prompt for beginning date:
 K DIR
 S DIR(0)="D0^::ETS"
 S DIR("A")="Enter BEGINNING DATE"
 D ^DIR
 S:$D(DIRUT)!($D(DIROUT))!(+Y'>0) OUT=1
 Q:OUT
 S BEG=+Y
 ;
 ;Prompt for ending date:
 K DIR
 S DIR(0)="DOA^"_BEG_"::ETS"
 S DIR("A")="Enter ENDING DATE: "
 S DIR("B")="NOW"
 D ^DIR
 S:$D(DIRUT)!($D(DIROUT))!(+Y'>0) OUT=1
 Q:OUT
 S END=+Y
 ;
 S ADSDTS=BEG_U_END
 ;
 Q
