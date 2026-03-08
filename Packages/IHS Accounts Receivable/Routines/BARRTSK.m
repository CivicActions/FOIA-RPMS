BARRTSK ; IHS/OIT/FCJ - TASKED - Reports ; 03/28/2011
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**31,35**;OCT 26, 2005;Build 187
 ;
 ;IHS/OIT/FCJ 1.8*31 11/5/2020 CR#6369 New Routine to run monthly tasked reports
 ;IHS/SD/SDR 1.8*35 ADO76628 Fixed ASM to use VISIT, not BILLING for Location Type For Reports;Adjusted display for longer option names;
 ;   Added code for TBSL, TAR, ADJT, and ATS
 ;
 ;********************************************************************
 Q
TASK ;EP ;Called by site parameter option: BAR TASKED REPORTS
 S I=0,BARCNT=0
 F  S I=$O(^BAR(90052.06,DUZ(2),DUZ(2),12,I)) Q:I'?1N.N  S BARCNT=BARCNT+1,BAR("TSK",BARCNT)=I_U_^(I,0)
 F  D DSPTSK,DSP,TSKED Q:BARLIN=0
 S DIE="^BAR(90052.06,DUZ(2),",DA=DUZ(2),DR="1602"
 D ^DIE
 I X="",$P($G(^BAR(90052.06,DUZ(2),DUZ(2),16)),U,2)="" W !!,"A Directory has not been specified for the Tasked reports.",!,"The reports will not be created until a directory has been entered." H 5
 D XIT
 Q
TSKED ;EDIT REPORT FILE NAME
 D ASKLIN^BARFPST3
 Q:BARLIN=0
 S DIE="^BAR(90052.06,DUZ(2),DUZ(2),12,"
 S DA=$P(BAR("TSK",BARLIN),U),DA(1)=DUZ(2),DR=".02;.05"
 D ^DIE
 S BAR("TSK",BARLIN)=DA_U_^BAR(90052.06,DUZ(2),DUZ(2),12,DA,0)
 K DA,D,D0,DA,DIE,DR
 Q
DSP ;DISPLAY ENTRIES
 W !!,"Tasked Reports:"
 ;W !,"LINE",?5,"REPORT",?35,"Schedule",?45,"File Name"  ;bar*1.8*35 IHS/SD/SDR ADO76628
 W !,"LINE",?5,"REPORT",?43,"Schedule",?60,"File Name"  ;bar*1.8*35 IHS/SD/SDR ADO76628
 S I=0 F  S I=$O(BAR("TSK",I)) Q:I'?1N.N  D
 .;W !,$J(I,3),?5,$P(BAR("TSK",I),U,2),?38,$S($P(BAR("TSK",I),U,6)="Y":"Yes",1:"No"),?45,$P(BAR("TSK",I),U,3)  ;bar*1.8*35 IHS/SD/SDR ADO76628
 .W !,$J(I,3),?5,$P(BAR("TSK",I),U,2),?46,$S($P(BAR("TSK",I),U,6)="Y":"Yes",1:"No"),?55,$P(BAR("TSK",I),U,3)  ;bar*1.8*35 IHS/SD/SDR ADO76628
 Q
DSPTSK ;Display Scheduled task
 ;
 W $$EN^BARVDF("IOF")
 S BARTSK=""
 D OPTSTAT^XUTMOPT("BAR RPTS MONTHLY TASKED",.BARTSK)
 D:BARTSK DISP^XUTMOPT("BAR RPTS MONTHLY TASKED")
 W:'BARTSK !,"TASK OPTION: BAR RPTS MONTHLY TASKED has not been scheduled,",!,"Please contact Site Manager to Schedule."
 W !
 K BARTSK
 Q
 ;
ST ;RUN REPORTS from taskman option BAR RPTS MONTHLY TASKED
 ;TEST FOR DIRECTORY, IF NOT DEFINED TASKED REPORTS WILL NOT RUN
 S L1=0
 F  S L1=$O(^BAR(90052.06,L1)) Q:L1'?1N.N  D
 .S L2=0 F  S L2=$O(^BAR(90052.06,L1,L2)) Q:L2'?1N.N  D
 ..S R1=0 F  S R1=$O(^BAR(90052.06,L1,L2,12,R1)) Q:R1'?1N.N  D
 ...S BARPTH=$P($G(^BAR(90052.06,L1,L2,16)),U,2) Q:BARPTH=""
 ...I $P(^BAR(90052.06,L1,L2,12,R1,0),U,5)="Y" D
 ....S RTN=$P(^BAR(90052.06,L1,L2,12,R1,0),U,6),BARFIL=$P(^BAR(90052.06,L1,L2,12,R1,0),U,2)
 ....D @RTN^BARRTSK(L1)
 Q
PSR(LOC) ;PERIOD SUMMARY REPORT
 S DUZ(2)=LOC
 D VARS
 S BAR("PRIVACY")=1                  ;Privacy act applies (used BARRHD)
 S BAR("LOC")="VISIT"                ;should always be VISIT
 S BARP("RTN")="BARRPSRA"            ;Routine used to gather data
 ;Federal or Tribal
 I $P(^AUTTLOC(DUZ(2),0),U,25)=1 D
 .S BARY("STCR")=5                   ;SORTING CRITERIA A/R
 .S BARY("STCR","NM")="ALLOWANCE CATEGORY"  ;Allowance Cat=ALL
 E  D
 .S BARY("STCR")=1                   ;SORTING CRITERIA A/R
 .S BARY("STCR","NM")="A/R ACCOUNT"  ;A/R ACCOUNT=ALL
 S BARY("RTYP")=1                    ;SUMMARIZE BY
 S BARY("RTYP","NM")="Summarize by ALLOW CAT/BILL ENTITY/INS TYPE"
 S BAR("PRIVACY")=1                  ;Privacy act applies (used BARRHD)
 S BAR("LOC")="VISIT"                ;should always be VISIT
 D SETHDR^BARRPSRA                   ;Build header array
 D COMPUTE^BARRPSRA                  ;Build tmp global with data
 D PRINT^BARRPSRB                    ;Print reports from tmp global
 D XIT
 Q
 ;*********************************************************************
 ;
ASM(LOC) ;AGED SUMMARY REPORT
 S DUZ(2)=LOC
 D VARS
 S BAR("PRIVACY")=1                  ;Privacy act applies (used BARRHD)
 ;S BAR("LOC")="BILLING"             ;should always be VISIT  ;bar*1.8*35 IHS/SD/SDR ADO76628
 S BAR("LOC")="VISIT"                ;should always be VISIT  ;bar*1.8*35 IHS/SD/SDR ADO76628
 S XQY0="BAR AGE SUM RPT^Age Summary Report^^R^^BARZMENU,^1540^^^^^230^^1^1^^"
 S BARP("RTN")="BARRASM"            ;Routine used to gather data
 ;Federal or Tribal
 I $P(^AUTTLOC(DUZ(2),0),U,25)=1 D
 .S BARY("STCR")=5                    ;SORTING CRITERIA A/R
 .S BARY("STCR","NM")="ALLOWANCE CATEGORY"  ;Allowance Cat=ALL
 E  D
 .S BARY("STCR")=1                   ;SORTING CRITERIA A/R
 .S BARY("STCR","NM")="A/R ACCOUNT"  ;A/R ACCOUNT=ALL
 S BARY("RTYP")=1                    ;SUMMARIZE BY
 S BARY("RTYP","NM")="Summarize by ALLOW CAT/BILL ENTITY/INS TYPE"
 D SETHDR^BARRASM                    ;Build header array
 D COMPUTE^BARRASM                   ;Build tmp global with data
 D PRINT^BARRASMB                    ;Print reports from tmp global
 D XIT
 Q
USM(LOC) ;UFMS AGED SUMMARY REPORT
 S DUZ(2)=LOC
 D VARS
 S BAR("LOC")="VISIT"
 S BARA("SORT")=1
 S BARMSGPT=1
 S BARA=$$FISCAL^XBDT()              ;GET CURRENT FISCAL YEAR
 S BARFY=$P(BARA,U)
 S BARSFY="08",BAREFY=$E(BARFY,3,4)
 D FYSET^BARRASM2
 S BARY("STCR")=5                            ;SORTING CRITERIA A/R
 S BARY("STCR","NM")="ALLOWANCE CATEGORY"    ;Allowance Cat=ALL
 S BARY("RTYP")=1                            ;SUMMARIZE BY
 S BARY("RTYP","NM")="Summarize by ALLOW CAT/BILL ENTITY/INS TYPE"
 M BARTBARY=BARY
 M BARTBAR=BAR
 D START^BARRASM2                            ;process and create file
 D XIT
 Q
BSL(LOC) ;Batch Statistical Listing
 S DUZ(2)=LOC
 D VARS
 S BAR("XBDOS")=$$MDT^BARDUTL(BAR("BDOS"))
 S BAR("XEDOS")=$$MDT^BARDUTL(BAR("EDOS"))
 Q:BARPTH=""
 D DIPVAR^BARRBSL
 D PRINT^BARRBSL
 D XIT
 Q
 ;start new bar*1.8*35 IHS/SD/SDR ADO76628
TBSL(LOC) ;Treasury Deposit/Batch Statistical Report
 S DUZ(2)=LOC
 D VARS
 S DATETYPE=1  ;date type = BATCH
 S BARFROM=BAR("BDOS")
 S BARTO=BAR("EDOS")
 S BARSORT=2,SORTTYP="TDN"
 D SORT^BARRTBSL
 D PRINT^BARRTBSL
 Q
TAR(LOC) ;Transaction Report
 S DUZ(2)=LOC
 D VARS
 S BARFROM=BAR("BDOS")
 S BARTO=BAR("EDOS")
 S BAR("LOC")="VISIT"
 S BAR("OPT")="TAR"
 S BARY("SORT")="V"  ;sort by visit type
 S BARY("RTYP")=1  ;report type - default to detailed
 S BARY("DT")="T"  ;transaction date
 S BARY("DT",1)=BAR("BDOS")
 S BARY("DT",2)=BAR("EDOS")
 S BARP("RTN")="BARRTAR"
 S BARMENU="Transaction Report"
 S BAR("HD",0)="Detail Transaction Report"
 S BARY("RTYP","NM")="Detail"
 D ^BARRHD
 D COMPUTE^BARRTAR
 D PRINT^BARRTAR
 Q
ADJT(LOC) ;Adjustment and Refund Report by Transaction Date
 S DUZ(2)=LOC
 D VARS
 S BARDET=1
 S BAR("LOC")="VISIT"
 S BAR("OPT")="ADJ"
 ;
 S BARA("LOC")=0
 S BARA("SORT")=1
 ;
 S BARP("RTN")="BARTRANT"
 ;
 S BARY("DT")="T"
 S (BARSTART,BARY("DT",1))=BAR("BDOS")
 S (BAREND,BARY("DT",2))=BAR("EDOS")
 S BARY("RTYP")=2
 S BARY("RTYP","NM")="Detail by PAYER w/in ALLOW CAT/INS TYPE"
 S BARY("STCR")=2
 S BARY("STCR","NM")="ALLOWANCE CATEGORY"
 ;
 D SETHDR^BARTRANT
 D COMPUTE^BARTRNS2
 D PRINT^BARTRNS3
 Q
ATS(LOC) ;A/R Bill and Transaction Synchronization Report
 S DUZ(2)=LOC
 D VARS
 S BAR("LOC")="VISIT"
 S BARP("RTN")="BARRATS"
 S BARY("RTYP")=1
 S BARY("RTYP","NM")="Detail"
 K BARY("DT"),BARY("STCR")
 K BAR("HD")
 D SETHDR^BARRATS
 D COMPUTE^BARRATS
 D PRINT^BARRATS
 Q
 ;end new bar*1.8*35 IHS/SD/SDR ADO76628
VARS ;
 ;Set beginning and ending Transaction Dates.
 ;S BARSTART=$$DT^XLFDT,(BAR("BDOS"),BARSTART,BARY("DT",1))=$E(BARSTART,1,5)_"01"  ;bar*1.8*35 IHS/SD/SDR ADO76628
 ;start new bar*1.8*35 IHS/SD/SDR ADO76628
 S BARSTART=$$DT^XLFDT
 I $E(BARSTART,6,7)="01" D
 .S BARMTH=$E(BARSTART,4,5)
 .S BARMTH=BARMTH-1
 .I BARMTH=0 S BARMTH=12,BARSTART=($E(BARSTART,1,3)-1)_$E(BARSTART,4,7)
 .S BARMTH=$S($L(BARMTH)=1:"0"_BARMTH,1:BARMTH)
 .S BARSTART=$E(BARSTART,1,3)_BARMTH_$E(BARSTART,6,7)
 S (BAR("BDOS"),BARSTART,BARY("DT",1))=$E(BARSTART,1,5)_"01"
 ;end new bar*1.8*35 IHS/SD/SDR ADO76628
 S (Y,BAR("EDOS"),BAREND,BARY("DT",2))=$P($$SCH^XLFDT("1M",BARSTART),".")
 D DD^%DT S BARFILD=$E(Y,1,3)_$E(Y,9,12)
 D INIT^BARUTL                       ;Set up basic A/R Variables
 ;S BARFILN=RTN_"_"_BARSITE(.01)_"_"_BARFILD  ;bar*1.8*35 IHS/SD/SDR ADO76628
 S BARFILN=RTN_"_"_BARSPAR(.01)_"_"_BARFILD  ;bar*1.8*35 IHS/SD/SDR ADO76628
 S:$L(BARFIL)>0 BARFILN=BARFILN_"_"_BARFIL
 Q
 ;********************************************************************
XIT ;
 D CLOSE^%ZISH("FILE")
 D ^BARVKL0
 D POUT^BARRUTL
 K ^TMP($J,"BAR-PSR")
 K ^TMP($J,"BAR-PSRT")
 K ^TMP($J,"BAR-ASMFY")
 K ^TMP($J,"BAR-ASMC")
 K ^TMP($J,"BAR-ASMT")
 ;start new bar*1.8*35 IHS/SD/SDR ADO76628
 K ^XTMP("BARRTBSL",$J)
 K ^TMP($J,"BAR-TAR")
 K ^TMP($J,"BAR-TARS")
 K ^TMP($J,"BAR-TRANS")
 K ^TMP($J,"BAR-TRANST")
 K ^TMP($J,"BAR-ATS")
 ;end new bar*1.8*35 IHS/SD/SDR ADO76628
 K DA,D,D0,DA,DIE,DR,XQY0
 Q
