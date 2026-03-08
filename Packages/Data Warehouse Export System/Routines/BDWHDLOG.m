BDWHDLOG ; IHS/CMI/LAB - DISPLAY DW EXPORT LOG DATA AUGUST 14, 1992 ;
 ;;1.0;IHS DATA WAREHOUSE;**6,9,11**;JAN 24, 2006;Build 14
 ;
EN1 ;
 W:$D(IOF) @IOF
 K BDWQUIT
 W !!,"Display PHARMACY PRESCRIPTION DATA WAREHOUSE EXPORT Log Entry",!
 W !,"Type a ?? and press enter at the following prompt to view a list of ORIGINAL RUN DATES.",!,"Or, if you know the original run date you can enter it in the format MM/DD/YY:  e.g. 2/26/19",!
 S DIC="^BDWHLOG(",DIC(0)="AEMQ" D ^DIC K DIC I Y=-1 W !!,"Goodbye" G XIT
 S BDWLOG=+Y
 ;S DIR(0)="SO^B:BROWSE Output on Screen;P:PRINT Output to Printer",DIR("A")="Do you want to",DIR("B")="B" K DA D ^DIR K DIR
 ;G:$D(DIRUT) XIT
 ;I Y="B" D BROWSE,XIT Q
 ;S XBRP="PRINT^BDWHDLOG",XBRC="PROC^BDWHDLOG",XBRX="XIT^BDWHDLOG",XBNS="BDW"
 ;D ^XBDBQUE
 D BROWSE
 D XIT
 Q
BROWSE ;
 D VIEWR^XBLM("PRINT^BDWHDLOG","Prescription Drug Data Warehouse Export Log Display")
 Q
XIT ;EP
 D FULL^VALM1
 K BDWLOG,BDWREC
 Q
PROC ;
 Q
PRINT ;
 W:$D(IOF) @IOF W !?19,"PRESCRIPTION DRUG DATA WAREHOUSE EXPORT LOG REPORT"
 W !?7,"Information for Log Entry ",BDWLOG," Beginning Date:  ",$$VAL^XBDIQ1(90213.1,BDWLOG,.02)
 S BDWREC=^BDWHLOG(BDWLOG,0)
 W !!?35,"Number:",?45,BDWLOG
 W !?24,"Original Run Date:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,.01)
 W !?22,"Beginning Fill Date:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,.02)
 W !?25,"Ending Fill Date:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,.03)
 W !?22,"Run Start Date/Time:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,.1)
 W !?23,"Run Stop Date/Time:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,.04)
 W !?33,"Run Time:",?45,$P(BDWREC,U,13)
 W !?20,"Run Database/Location:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,.09)
 W !?30,"Export Type:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,.07)
 W !?22,"Transmission Status:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,.15)
 W !?19,"Production/Test System:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,1108)
 I $$VAL^XBDIQ1(90213.1,BDWLOG,.16)]"" D
 .W !?25,"Processing Error:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,.16)
 I $$VAL^XBDIQ1(90213.1,BDWLOG,.22) D
 .W !?26,"Was this a REDO?",?45,"YES"
 W !?3,"Number of Prescription Fills Processed:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,.05)
 W !?11,"Total Number of Fills Exported:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,.08)
 W !?4,"Total Number of HL7 Messages Exported:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,1105)
 W !?5,"Number of Prescription Fills Skipped:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,.06)
 W !?10,"Number of Outside Meds Exported:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,1106)
 W !?25,"Filename Created:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,1101)
 I $$VAL^XBDIQ1(90213.1,BDWLOG,1102)]"" D
 .W !?22,"Backload Begin Date:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,1102)
 .W !?24,"Backload End Date:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,1103)
 .W !?3,"Total # of Backload Prescription Fills:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,1104)
 .W !?2,"Total # of Backload Outside Medications:",?45,$$VAL^XBDIQ1(90213.1,BDWLOG,1107)
 W !!,"The following fills/refills were skipped and not exported:"
 W !,"RX #",?21,"FILL DATE",?32,"REF#",?38,"REASON NOT EXPORTED",! S X="",$P(X,"-",79)="-" W X,!
 S BDWX=0 F  S BDWX=$O(^BDWHLOG(BDWLOG,21,BDWX)) Q:BDWX'=+BDWX  I '$P(^BDWHLOG(BDWLOG,21,BDWX,0),U,7) D
 .W !,$P(^BDWHLOG(BDWLOG,21,BDWX,0),U,2),?21,$$DATE($P(^BDWHLOG(BDWLOG,21,BDWX,0),U,4))
 .W ?32,$P(^BDWHLOG(BDWLOG,21,BDWX,0),U,3)
 .W ?38,$P(^BDWHLOG(BDWLOG,21,BDWX,0),U,8)
 W !!,"AUDIT:"
 S BDWX=0 F  S BDWX=$O(^BDWHLOG(BDWLOG,31,BDWX)) Q:'BDWX  D
 . S BDWXDAT=$G(^BDWHLOG(BDWLOG,31,BDWX,0))
 . W !,"Date: "_$E($$UP^XLFSTR($$FMTE^XLFDT($P(BDWXDAT,U))),1,18),?26,"User: "_$E($$GET1^DIQ(200,$P(BDWXDAT,U,2),.01),1,18),?51,"Option: "_$E($$GET1^DIQ(19,$P(BDWXDAT,U,3),.01),1,21)
 W !!
 Q
DATE(D) ;
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
 ;
SETPARM ;EP - called from option to set site parameter for Prescription export
 ;If there is nothing in the multiple, stuff all outpatient site entries
 ;and default to NO
 NEW BDWS,BDWC,Y,DIR,DA,X,Z,BDWI
 Q:'$D(^BDWSITE(1,0))
 I '$O(^PS(59,0)) W !!,"There are no pharmacies defined in the outpatient site file.",!,"No need to update this parameter",! D EOP Q   ;NO PHARMACIES
 D EN^DDIOL(" ")
 D EN^DDIOL("For each Pharmacy in the Pharmacy Outpatient Site file you must provide")
 D EN^DDIOL("a response as to whether the pharmacy will enable prescription data")
 D EN^DDIOL("to be exported to the national reporting database at the National ")
 D EN^DDIOL("Data Warehouse to support the Heroin, Opioids and Pain Efforts (HOPE)")
 D EN^DDIOL("and other opioid initiatives.")
 D EN^DDIOL(" ")
 D EN^DDIOL("Enabling this data export will assist local sites with extracting")
 D EN^DDIOL("data to create opioid surveillance strategy to monitor local opioid")
 D EN^DDIOL("and leverage utilization of timely, actionable data to inform")
 D EN^DDIOL("strategies and interventions.")
 D EN^DDIOL(" ")
 D EN^DDIOL("Federal sites MUST set the parameter to YES - Enable the export.")
 D EN^DDIOL("Tribal and Urban sites must verify with site leadership/Health Director")
 D EN^DDIOL("prior to setting the parameter to Yes.")
 D EN^DDIOL(" ")
 D EN^DDIOL("If you are NOT sure, please set the parameter to NO - Do not enable export.")
 S DIR(0)="E",DIR("A")="Press ENTER to continue" KILL DA D ^DIR KILL DIR
 ;
W ;
 D EN^DDIOL("PHARMACY OUTPATIENT SITE",,"!?4")
 D EN^DDIOL("ENABLE PRESCRIPTION EXPORT?",,"?36")
 D EN^DDIOL("------------------------",,"!?5")
 D EN^DDIOL("---------------------------",,"?36")
 ;D EN^DDIOL("","","!")
 K BDWS
 S BDWC=0
 S X=0 F  S X=$O(^BDWSITE(1,21,X)) Q:X'=+X  D
 .S BDWC=BDWC+1
 .S BDWS(BDWC)=X
 .S Y=$P(^BDWSITE(1,21,X,0),U,2)
 .S $P(BDWS(BDWC),U,2)=Y
 .S Y=$S(Y:"YES, ENABLE EXPORT",1:"NO, DO NOT ENABLE EXPORT")
 .S Z=""
 .S $E(Z,2)=BDWC_") "_$P(^PS(59,X,0),U,1),$E(Z,37)=Y
 .D EN^DDIOL(Z,"","!")
 ;ASK WHICH ONE TO EDIT
W1 ;
 ;D EN^DDIOL("","","!")
 K DIR
 S DIR(0)="S^E:Edit a Pharmacy's Parameter Setting;A:Add a new Pharmacy to the List;D:Delete a Pharmacy from the list;Q:Quit"
 S DIR("A")="Which action",DIR("B")="E" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I Y="Q" Q
 I Y="E" D EDIT G W
 I Y="A" D ADD G W
 I Y="D" D DEL G W
 Q
ADD ;
 W !,"Please select the Pharmacy Outpatient Site entry to add",!
 K DIC
 S DIC="^PS(59,",DIC(0)="AEMQ" D ^DIC
 I Y=-1 Q
 S BDWX=+Y
 I $D(^BDWSITE(1,21,BDWX,0)) W !!,"That site is already in the site parameters, choose E to edit it.",! D EOP K DIC,Y,BDWX Q
 S DIC="^BDWSITE(1"_",21,"
 S DA(1)=BDWX
 S DIC("P")=$P(^DD(90212.1,2100,0),U,2)
 S (DINUM,X)=BDWX
 S DIC("DR")=".02//NO, DO NOT ENABLE EXPORT"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"adding failed" K DIC,DINUM,X Q
 ;S DA=+Y,DA(1)=1,DR=".02//NO, DO NOT ENABLE EXPORT"
 ;S DIE="^BDWSITE(1"_",21,",DIE("NO^")=1
 ;D ^DIE
 K DIE,DA,DR,DIC,DINUM
 Q
DEL ;
 W !!,"Only Pharmacies that no longer have Prescription data in RPMS should"
 W !,"be deleted."
 ;delete which one
 ;GET WHICH ONE
 S BDWI=""
 S DIR(0)="N^1:"_BDWC_":0",DIR("A")="Delete Which one" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S BDWI=Y
 S DA=$P(BDWS(BDWI),U,1)
 D EN^DDIOL($P(^PS(59,DA,0),U,1),,"!!")
 S DA(1)=1,DR=".01///@"
 S DIE="^BDWSITE("_DA(1)_",21,"
 D ^DIE
 W "...has been removed from the site parameters for prescription exporting."
 K DIE,DA
 Q
EDIT ;
 ;GET WHICH ONE
 S BDWI=""
 S DIR(0)="N^1:"_BDWC_":0",DIR("A")="Edit Which one" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S BDWI=Y
 S DA=$P(BDWS(BDWI),U,1)
 D EN^DDIOL($P(^PS(59,DA,0),U,1),,"!!")
 S DA(1)=1,DR=".02"
 S DIE="^BDWSITE("_DA(1)_",21,",DIE("NO^")=1
 D ^DIE
 K DIE,DA
 Q
EOP ;
 W !
 S DIR(0)="E",DIR("A")="Press ENTER to continue" KILL DA D ^DIR KILL DIR
 Q
