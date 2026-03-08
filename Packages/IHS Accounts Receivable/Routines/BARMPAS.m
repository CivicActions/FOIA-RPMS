BARMPAS ; IHS/SD/LSL - Patient Account Statement ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**2,4,5,19,20,23,24,35,36**;OCT 26, 2005;Build 199
 ;
 ;IHS/SD/LSL 1.7*2 04/22/03
 ;IHS/SD/LSL 1.7*4 12/04/04 IM11692 Modify code to allow tasked option to catch all facilities.
 ;IHS/SD/LSL 1.7*5 02/11/04 IM12222 Modify MARKACC to allow marking of patient's registered at the parents satellite. 
 ;
 ;IHS/SD/AR 1.8*19 06/01/2010
 ;IHS/SD/PKD 1.8*19 9/10/10
 ;IHS/SD/PKD 1.8*20 2/24/11
 ;IHS/SD/POT 1.8*23 HEAT80718 ADDED SORTING OPTION BY PATNAME
 ;IHS/SD/POT 1.8*23 HEAT95153
 ;IHS/SD/POT 1.8*23 HEAT63286 added call to populate array BARPSAT
 ;IHS/SD/POT 1.8*23 HEAT91646 added OPTION 'PUR' & 'REB'
 ;IHS/SD/POT 1.8*23 HEAT106730
 ;IHS/SD/POT 1.8*24 HEAT152220 2/11/2014 FIX PRO PRINT AND CLEANUP
 ;IHS/SD/POT 1.8*24 HEAT100207 2/18/2014 FIXED AGE
 ;IHS/SD/SDR 1.8*35 Removed Mail message
 ;IHS/SD/SDR 1.8*35 ADO60910 Updated to displan PPN preferred name
 ;IHS/SD/SDR 1.8*36 ADO74825 Skip cancelled bills
 ;IHS/SD/SDR 1.8*36 ADO74824 Fixed:
 ;  -Changed the date range for tasked job so it is always the previous month's activity
 ;  -fixed when REB option is used - it was changing the DUZ(2) so you started at one location but ended up at another when it was done
 ;  -Also included change in PURGE so only stmt runs for the logged-into site will be purged, not all sites
 ;  -Made sure it does all of last day of month; if transactions were done on last day it wasn't counting them
 ;  -if balance is zero and final transaction was posted during the stmt run date range, the bill shows up on stmt that last time with zero balance
 ;*********
 Q
TASK ; EP
 ;Called from SCHEDULED OPTION BAR MAN ACCOUNT STATEMENT
 ;Start w/last run date thru Today
 ;Find BAR ACCOUNT STATEMENT in Option Scheduling File
 N BARXXX
 ;D INIT^BARUTL ;make sure site is setup; set user,site,parent/satellite vars ;bar*1.8*36 IHS/SD/SDR ADO74824
 S BARXXX=$$GETX()
 I BARXXX<0 QUIT
 S BARSRTBY=$$GETSRTBY() ;GET SORT-BY (0=account#; 1=patname)
 D INITXTMP(BARXXX,BARDTB,BARDTE,BARSRTBY,BARRUNDT) ;IHS/SD/POT BAR*1.8*23
 ;D BARPSAT^BARUTL0 ;IHS/SD/POT BAR*1.8*23 HEAT#63286 added call to populate array BARPSAT ;bar*1.8*36 IHS/SD/SDR ADO74824
 S BAR("DHOLD")=DUZ(2) ;bar*1.8*36 IHS/SD/SDR ADO74824
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARAC(DUZ(2))) Q:'+DUZ(2)  D  ;loop thru A/R Account DUZ(2)s
 .;start new bar*1.8*36 IHS/SD/SDR ADO74824
 .D INIT^BARUTL ;make sure site is setup; set user,site,parent/satellite vars
 .D BARPSAT^BARUTL0 ;added call to populate array BARPSAT
 .;end new bar*1.8*36 IHS/SD/SDR ADO74824
 .S BARACDA=0
 .F  S BARACDA=$O(^BARAC(DUZ(2),"PAS","Y",BARACDA)) Q:'BARACDA  D ACCOUNT(BARACDA) ;loop thru YES, do pt stmt
 S DUZ(2)=BAR("DHOLD")
 ;D MAIL^XBMAIL("BARZ MANAGER","MAIL^BARMPAS") ;IHS/SD/SDR bar*1.8*35 removed mail message
 Q
 ;***********************
 ;
GETX() ;
 K DIC,DR,DIE,DA
 ;start old bar*1.8*36 IHS/SD/SDR ADO74824
 ;S DIC=19.2  ;Option Scheduling File
 ;S X="BAR ACCOUNT STATEMENT"
 ;S DIC(0)="ZM"
 ;D ^DIC
 ;I Y<1 Q -1  ;NO SETUP
 ;S BARSCHED=+Y  ;Option IEN
 ;S BARFREQ=$$GET1^DIQ(19.2,BARSCHED,6)  ;Option schedule freq
 ;S X1=DT
 ;S X2=-90
 ;D C^%DTC
 ;F  S X=$$SCH^XLFDT(BARFREQ,X) Q:X>DT  S BARDTB=X  ;Last run date
 ;S BARDTE=DT  ;Today
 ;end old start new bar*1.8*36 IHS/SD/SDR ADO74824
 S BARDTB=$$DT^XLFDT   ;current dt in FM
 S BARMTH=$S($E(BARDTB,4,5)="01":"12",1:($E(BARDTB,4,5)-1))  ;previous month
 S BARYR=$E(BARDTB,1,3)  ;this is the original year; keep intact for begin and end date calculating
 S BARDTB=$S(BARMTH=12:($E(BARDTB,1,3)-1),1:BARYR)_$S($L(BARMTH)=1:"0"_BARMTH,1:BARMTH)_"01"  ;make begin date first day of last month
 ;
 S BARMTH=$S($E(BARDTB,4,5)="12":"01",1:($E(BARDTB,4,5)+1))
 S X=BARYR_$S($L(BARMTH)=1:"0"_BARMTH,1:BARMTH)_"01"
 D H^%DTC  ;converts FM dt/tm to $H
 S %H=%H-1
 D YMD^%DTC  ;converts $H to FM dt/tm
 S BARDTE=X_".999999"  ;make sure it is thru the end of the last day
 ;
 ;end new bar*1.8*36 IHS/SD/SDR ADO74824
 D NOW^%DTC
 S BARRUNDT=%
 ;start old bar*1.8*36 IHS/SD/SDR ADO74824
 ;S X1=DT
 ;S X2=+15
 ;D C^%DTC
 ;end old bar*1.8*36 IHS/SD/SDR ADO74824
 S X=BARRUNDT  ;bar*1.8*36 IHS/SD/SDR ADO74824
 Q X
ACCOUNT(BARACDA) ;
 D ACCOUNT^BARMPAS1  ;split routine bar*1.8*36 IHS/SD/SDR ADO74824
 Q
 ;************************
 ;start old bar*1.8*35 IHS/SD/SDR
 ;MAIL ; EP - MAIL MESSAGE TEXT
 ;;;A/R ACCOUNTS (PATIENTS) MONTHLY STATEMENTS
 ;;;This is to notify you that an automatic generation
 ;;;of statements for A/R Patient Accounts has completed.
 ;;;..
 ;;;Please use the Print Patient Account Statement option
 ;;;to print the statements to a printer.
 ;Q
 ;;*****************************
 ;end old bar*1.8*35 IHS/SD/SDR
 ;
MANUAL ; EP
 ;Called from Print Adhoc Patient Account Statement AR Menu Option
 ;Ask user to select AR Account marked for Patient Account Stmt
 S BARPRO=1  ;bar*1.8*36 IHS/SD/SDR ADO74824
 D ASKACCT  ;Ask AR Account
 Q:Y'>0
 Q:'$D(BARACDA)  ;No acct selected
 D DATE(1)  ;Ask date range AND init ^XTMP
 I +BARDTB<1 Q  ;Dates answered wrong
 D GETHDR^BARMPAS3  ;MOVED INTO LOOP
 Q:'$D(BARHDRDA)
 S BARQ("RC")="LOOP^BARMPAS"  ;Build tmp global with data
 S BARQ("RP")="PRINT^BARMPAS3,CLEANUP^BARMPAS" ;bar*1.8*24 HEAT#152220
 S BARQ("NS")="BAR"  ;Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"  ;bar*1.8*24 HEAT#152220
 D GETMSG
 D ^BARDBQUE  ;Double queuing
 ;D CLEANUP^BARMPAS  ;IHS/SD/POT bar*1.8*24 HEAT#152220 Clean-up routine 11/05/2013 LINE COMMENTED OUT
 K BARPRO  ;bar*1.8*36 IHS/SD/SDR ADO74824
 D PAZ^BARRUTL  ;Press return to continue
 Q
CLEANUP K ^XTMP("BARPAS"_BARRUNDT)  ;cleanup scratch global for option PRO 10/10/2013
 Q
 ;**************************
 ;^XTMP("BARPAS3130904.070754",0)=PurgeDt^CreationDt
 ;^XTMP("BARPAS3130904.070754",0,"DT")=StmtBeginDt^StmtEndDt
 ;                           "SCOPE")="PRO"
 ;                           "SORTBY")=1
 ;IHS/SD/AR bar*1.8*19 06/01/2010
GETMSG ;
 ;ASK USER TO INCLUDE A MESSAGE WITH REPORTS
 K BARPTMSG
 S BARPTMSG=""
 W !!
 K DIR
 S DIR("A")="Add a patient statement message"
 S DIR("?")="Enter up to 80 characters as a message appended to statement."
 S DIR(0)="FO^0:80^"
 D ^DIR
 Q:Y=""
 S BARPTMSG=X
 Q
ASKACCT ;
 ;Ask user to select AR Account marked for Patient Account Statement
 W !!
 K DIC
 S DIC("A")="Select Patient-Account: "
 S DIC=90050.02
 S DIC(0)="AEQM"
 S DIC("S")="I $D(^BARAC(DUZ(2),""PAS"",""Y"",+Y))"
 S DIC("W")="D DICWACCT^BARUTL0(Y)"  ;bar*1.8*35 IHS/SD/SDR ADO60910
 D ^DIC
 Q:Y'>0
 S BARACDA=+Y
 Q
 ;**************************
DATE(BARMODE) ;
 ;Select date range
DT1 ;
 S BARDTB=$$DATE^BARDUTL(1)
 I BARDTB<1 Q
 S BARDTE=$$DATE^BARDUTL(2)
 S BARDTE=BARDTE_".999999"  ;be sure to include all info for last day selected  ;bar*1.8*36 IHS/SD/SDR ADO74824
 I BARDTE<1 W ! G DT1
 I BARDTE<BARDTB D  G DT1
 .W *7
 .W !!,"The END date must not be before the START date.",!
 I BARMODE>1 QUIT  ;CALL W/O INIT
 ;---------MANUAL (PRO) STATEMENT ----------
 D NOW^%DTC
 S BARRUNDT=%
 ;start old bar*1.8*36 IHS/SD/SDR ADO74824
 ;S X1=DT
 ;S X2=+15
 ;D C^%DTC
 ;end old bar*1.8*36 IHS/SD/SDR ADO74824
 K ^XTMP("BARPAS"_BARRUNDT)
 ;S ^XTMP("BARPAS"_BARRUNDT,0)=X_"^"_DT_"^"_"BAR ACCOUNT STATEMENT"  ;bar*1.8*36 IHS/SD/SDR ADO74824
 S ^XTMP("BARPAS"_BARRUNDT,0)=BARRUNDT_"^"_DT_"^"_"BAR ACCOUNT STATEMENT"  ;bar*1.8*36 IHS/SD/SDR ADO74824
 S ^XTMP("BARPAS"_BARRUNDT,0,"DT")=BARDTB_"^"_BARDTE
 S BARSRTBY=$$GETSRTBY() ;GET SORT-BY  (0=account#; 1=patname)
 S ^XTMP("BARPAS"_BARRUNDT,0,"SORTBY")=BARSRTBY  ;P.OTT
 S ^XTMP("BARPAS"_BARRUNDT,0,"SCOPE")="PRO"
 Q
 ;*****************************
LOOP ; EP
 ;Part of manual process
 ;IHS/SD/PKD 1.8*20 2/24/11 Set XTMP date headers
 ;If Device definition calls for Start Time, this will capture
 ;Run Dates rather than having them blank
 I $G(BARDTB)=""!($G(BARDTE)="") Q  ;Need dates
 D ACCOUNT(BARACDA)
 Q
 ;*****************************
MARKACC ; EP
 ;Called from Patient Accounts for Statements AR Menu option
 W !
 F  D  Q:BARAC'>0
 .W !
 .K DIC,DIE,DA,DR,X,Y
 .S DIC=90050.02
 .S DIC(0)="AEQZM"
 .S DIC("S")="I $$GET1^DIQ(90050.02,+Y,1)=9000001"  ;screen so just patients are selectable
 .;S DIC("W")="W ?50,$$GET1^DIQ(90050.02,+Y,101)"  ;display Y/N for if a stmt is wanted  ;bar*1.8*35 IHS/SD/SDR ADO60910
 .S DIC("W")="D DICWACCT^BARUTL0(Y) W ?65,$$GET1^DIQ(90050.02,+Y,101)"  ;display Y/N for if a stmt is wanted  ;bar*1.8*35 IHS/SD/SDR ADO60910
 .D ^DIC
 .S BARAC=+Y
 .Q:Y'>0
 .S DIE=DIC
 .S DA=+Y
 .S DR="101"
 .D ^DIE
 Q
REBUILD ;EP P.OTT
 S BARSRTBY=$$GETSRTBY() ;GET SORT-BY  (0=account#; 1=patname)
 W !!!,"NOTE: This procedure will *collect* statements for printing."
 W !,"Statements will be sorted by ",$P("Billing location, Account Number;Billing location, Patient name",";",BARSRTBY+1)
 W !,"When done use the PAS>PRA menu option to print the collected statements."
 W !
RBLD D NOW^%DTC
 S BARRUNDT=%
 D DATE(2)  ;Ask date range AND *do not* init ^XTMP
 I +BARDTB<1 Q  ;Dates answered wrong
 I BARDTE>(BARRUNDT\1) D  G RBLD
 .W !!,"END date cannot be a future day",!
 W !
 S DIR("A")="OK to start the re-build process"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 I Y'=1 Q
 ;---------------------
 S BARTMPD1=BARDTB
 S BARTMPD2=BARDTE
 S BARXXX=$$GETX() I BARXXX<0 D  QUIT
 .W !,"**WARNING: The Option Scheduling File for BAR ACCOUNT STATEMENT has not been set up."
 .W !,"Cannot proceed."
 .W !! H 2
 S BARSRTBY=$$GETSRTBY() ;GET SORT-BY (0=account#; 1=patname)
 S BARDTB=BARTMPD1
 S BARDTE=BARTMPD2
 D INITXTMP(BARXXX,BARDTB,BARDTE,BARSRTBY,BARRUNDT) ;P.OTT
 D GETHDR^BARMPAS3
 Q:'$D(BARHDRDA)
 ;S BARHOLD=DUZ(2)  ;bar*1.8*36 IHS/SD/SDR ADO74825
 S BARRHOLD=DUZ(2)  ;bar*1.8*36 IHS/SD/SDR ADO74825
 S DUZ(2)=0 F  S DUZ(2)=$O(^BARAC(DUZ(2))) Q:'+DUZ(2)  D
 .S BARACDA=0 F  S BARACDA=$O(^BARAC(DUZ(2),"PAS","Y",BARACDA)) Q:'BARACDA  D ACCOUNT(BARACDA)
 ;S DUZ(2)=BARHOLD  ;bar*1.8*36 IHS/SD/SDR ADO74825
 S DUZ(2)=BARRHOLD  ;bar*1.8*36 IHS/SD/SDR ADO74825
 W !,"--- Statements collected."
 S DIR("A")="Do you want to send e-mail notification"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 ;I Y=1 D MAIL^XBMAIL("BARZ MANAGER","MAIL^BARMPAS")  ;bar*1.8*35 IHS/SD/SDR
 D PAZ^BARRUTL  ;Press return to continue
 Q
ASKMODE() ;         
 K DIRUT,DIR,Y
 S Y=$$DIR^XBDIR("S^1:Print Statement for Individual Patient;2:Collect Statements for ALL Flagged Patients","Select Statement Type ","","","","",1)
 K DA
 Q Y
PURGE ;
 D PURGE^BARMPAS1
 Q
PATNAME(BARACDA) ;P.OTT
 NEW BARDFN,BARRET,BARNAM
 S BARDFN=$$GET1^DIQ(90050.02,BARACDA,1.001)  ;IEN to Patient file
 S BARNAM=$$GET1^DIQ(9000001,BARDFN,.01)
 I BARNAM="" S BARNAM="UNKN"
 Q BARNAM_"^"_BARDFN  ;TO SEPARATE BILLS FOR 2 PATIENTS WITH THE SAME NAME
 ;
 ;LIST EXISTING STATEMENTS IN XTMP
LIST S X="BARPAS" F  S X=$O(^XTMP(X)) Q:X=""  Q:X'["BARPAS"  W !,X
 Q
GETSRTBY() ;P.OTT
 NEW BARSRT,X
 ;BARSRTBY=0 - NO ALPHA SORTING
 ;BARSRTBY=1 - ALPHA SORTING (PATNAME^PATIEN)
 ;INTERNAL VALUES
 ;A/R SITE PARM, #1401 PAS SORTING ORDER:
 ;  1  BILLING LOC, ACCOUNT NUMBER
 ;  2  BILLING LOC, PATIENT NAME
 S BARSRT=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),20)),U,4)
 I +BARSRT=0 Q 0  ;IF NOT SET: 0
 I BARSRT S BARSRT=BARSRT-1 ;1,2->0,1 - so default is by account number if sort not set
 Q BARSRT
 ;
INITXTMP(X,BARDTB,BARDTE,BARSRTBY,BARRUNDT) ;P.OTT
 K ^XTMP("BARPAS"_BARRUNDT)
 S ^XTMP("BARPAS"_BARRUNDT,0,"DT")=BARDTB_U_BARDTE
 ;S ^XTMP("BARPAS"_BARRUNDT,0)=X_"^"_BARDTE_"^"_"BAR ACCOUNT STATEMENT"  ;bar*1.8*36 IHS/SD/SDR ADO74824
 ;XTMP requires a 0 node, the first piece being a purge date, the second being the create date
 S ^XTMP("BARPAS"_BARRUNDT,0)="99999999"_"^"_DT_"^"_"BAR ACCOUNT STATEMENT"  ;bar*1.8*36 IHS/SD/SDR ADO74824
 S ^XTMP("BARPAS"_BARRUNDT,0,"SORTBY")=BARSRTBY ;P.OTT
 S ^XTMP("BARPAS"_BARRUNDT,0,"SCOPE")="PRA"
 Q
LISTRUNS ;
 S BARCNT=0
 S BAR1="BARPAS"
 F  S BAR1=$O(^XTMP(BAR1)) Q:BAR1'["BARPAS"  D
 .;start new bar*1.8*36 IHS/SD/SDR ADO74824
 .S BARDT=$P(BAR1,"BARPAS",2,99)  ;Date of Run
 .S BARRUN(BARCNT)=BARDT  ;Array of runs
 .S Y=BARDT
 .I '$D(^XTMP("BARPAS"_BARDT,DUZ(2))) Q
 .;end new bar*1.8*36 IHS/SD/SDR ADO74824
 .S BARCNT=BARCNT+1  ;Line counter
 .S BARDT=$P(BAR1,"BARPAS",2,99)  ;Date of Run
 .S BARRUN(BARCNT)=BARDT  ;Array of runs
 .S Y=BARDT
 .D DD^%DT
 .W !,$J(BARCNT,2),?5,Y  ;Line count,date run
 .I $G(^XTMP(BAR1,0,"SCOPE"))]"" W " (",$G(^XTMP(BAR1,0,"SCOPE")),") "
 .S BARSRTBY=$G(^XTMP("BARPAS"_BARDT,0,"SORTBY"))+1
 .I BARSRTBY W "  sorted by ",$P("Billing location, Account Number;Billing location, Patient name",";",BARSRTBY)
 Q
HELP ;
 W !,"This parameter will allow you to choose how patient statements"
 W !,"are sorted for printing.  Statements will first be sorted by"
 W !,"(1) billing location and then by account number, or by"
 W !,"(2) billing location and then alphabetically by the patient's last name"
 W !,"based on which option is selected."
 W !,"If nothing is selected, the print order will default to option 1."
 Q
LISTALL ;
 S BARCNT=0,(BARTMP,BARTMP0)="BARPAS" F  S BARTMP=$O(^XTMP(BARTMP)) Q:BARTMP=""  Q:BARTMP'[BARTMP0  D
 .S BARCNT=BARCNT+1
 .W !,BARCNT,".",?10,BARTMP," ",$G(^XTMP(BARTMP,0))
 .F X="DT","SCOPE","SORTBY","REINDEXED" W !?10,X,": ",$G(^XTMP(BARTMP,0,X))
 .Q
 Q
CLNUP ;
 Q  ;--EOR-
