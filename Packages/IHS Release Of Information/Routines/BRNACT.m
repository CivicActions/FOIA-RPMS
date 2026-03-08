BRNACT ; IHS/OIT/GAB - ROI PATIENT ACCOUNTING OF DISCLOSURE REPORT; 
 ;;2.0;IHS RELEASE OF INFORMATION;**4,5**;APR 10, 2003 ;Build 20
 ;;IHS/OIT/GAB 09/01/16 PATCH #4 ADDED THIS REPORT
 ;;IHS/OIT/GAB 06/01/23 PATCH #5 ADDED PRINT BY FACILITY & FIX WHEN DISCLOSURE DATE=CURRENT DATE
SERVICE ;PICK PATIENT NAME ENTRY
 NEW BRNPTN,BRNBD,BRNED,BRNDT,BRNDAT,BRNFIND,BRNQUIT,X
 W !!
 S DIC=2 S DIC("A")="Enter a Patient Name: " S DIC(0)="AEMIQO" D ^DIC
 G END:Y<1 S BRNPTN=+Y
 I BRNPTN="" Q
 I '$D(^BRNREC("AA",BRNPTN)) W !,?20,"**--NO EXISTING DISCLOSURES--**",! D PAUSE^XB Q  ;/IHS/OIT/GAB Patch 5 Added Pause
ASK ;Ask For Date Range
 ;
 ;
BD ;get beginning date
 W !! S DIR(0)="D^:"_DT_":EP",DIR("A")="Enter beginning ROI Initiated Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G END
 S BRNBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BRNBD_":"_DT_":EP",DIR("A")="Enter ending ROI Initiation Date"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BRNED=Y
 ;I $L(BRNED)=7 S BRNED=BRNED_.2359  ;/IHS/OIT/GAB Patch 5 Added Ck for time stamp
 S X1=BRNBD,X2=-1 D C^%DTC S BRNSD=X
 ; /IHS/OIT/GAB Patch 5 Added Two Lines Below for Facility search
 N BRNFAC,BRNFACN D ASKFAC^BRNU(.BRNFAC) I BRNFAC="" D ED Q
 I BRNFAC>0 S BRNFACN=$$GET1^DIQ(90264.2,BRNFAC,.01)
 ;
PRINT ;PRINT PATIENT RECORD OF ALL DISCLOSURES BY DATE
 N DIC,L,FLDS,BY,FR,TO
 ;S FLDS="[BRN ACCOUNTING OF DISCLOSURES]",BY="@INTERNAL(#.01),@INTERNAL(#.03)",DIC="^BRNREC(",L=0
 ;/IHS/OIT/GAB Patch 5 commented above line added next line for facility search (by Facility & Date
 S FLDS="[BRN ACCOUNTING OF DISCLOSURES]",BY="FACILITY,@INTERNAL(#.01),@INTERNAL(#.03),DATE REQUEST INITIATED'=""""",DIC="^BRNREC(",L=0
 ;S FR=BRNBD_","_BRNPTN,TO=BRNED_","_BRNPTN
 ;/IHS/OIT/GAB Patch 5 Comment above line and added next two lines for Facility search
 I BRNFAC=0 S FR="@,"_BRNBD_","_BRNPTN,TO="ZZZ,"_BRNED_","_BRNPTN ;if selecting all facilities
 E  S FR=BRNFACN_","_BRNBD_","_BRNPTN,TO=BRNFACN_","_BRNED_","_BRNPTN
 K DHIT,DIOEND,DIOBEG
 D CKROI
 D COVPAGE   ;/IHS/OIT/GAB Patch 5 added cover page
 I BRNFIND=0 W !!!,"       ***No disclosures to print in this date range***   ",! D PAUSE^XB W !! G END ;/IHS/OIT/GAB Patch 5 Added Pause and line feeds
 D EN1^DIP
 D PAUSE^XB
 D END
 Q
COVPAGE ; /IHS/OIT/GAB Patch 5
 W:$D(IOF) @IOF
 W !?25,"ROI PATIENT ACCOUNTING RECORD          "
 W !?20,"REPORT REQUESTED BY: ",$P(^VA(200,DUZ,0),U)
 W !?25,"FOR PATIENT:  ",$P(^DPT(BRNPTN,0),U)
 W !?25,"TODAY'S DATE: ",$$FMTE^XLFDT(DT),!
 Q
CKROI ; IHS/OIT/GAB CHECK FOR DISCLOSURES IN THE DATE RANGE TO PREVENT ERROR
 ;/IHS/OIT/GAB Patch 5 Updated function to print by facility if BRNFAC=0 / All facilities, if BRNFAC>0 , selected one facility
 ;S BRNDT=BRNBD    ;start looking in the date range   ;/IHS/OIT/GAB Patch 5 Fix for Disclosure Date Search
 S (BRNDAT,BRNDAT2,BRNDT,BRNFC,BRNDA)=""  ;/Patch 5 Added BRNDAT2,BRNDT,BRNFC,BRNDA
 S BRNFIND=0
 ;F  S BRNDT=$O(^BRNREC("AA",BRNPTN,BRNDT)) Q:BRNDT=""!BRNFIND=1  D   ;/IHS/OIT/GAB Patch 5 updated search, added the following line
 F  S BRNDT=$O(^BRNREC("AA",BRNPTN,BRNDT),-1) Q:BRNDT'=+BRNDT!BRNFIND=1  D
 . S BRNDAT2=BRNDT  ;/IHS/OIT/GAB Patch 5 Save the date
 . S BRNDAT=$P(BRNDAT2,".",1) ;/IHS/OIT/GAB Patch 5 updated BRNDT to BRNDAT2
 . I (BRNDAT>BRNED)!(BRNDAT<BRNBD) Q  ;/IHS/OIT/GAB Patch 5 updated date criteria, commented next two lines
 . ;Q:BRNDAT>BRNED
 . ;I (BRNDAT>(BRNBD-1)&&((BRNDAT-1)<BRNED)) S BRNFIND=1 Q
 . I BRNFAC=0 S BRNFIND=1 Q   ;Patch 5 - found one match for all facilities search, added next 4 lines for selected facility
 . I BRNFAC>0  D
 . . S BRNDA=$O(^BRNREC("AA",BRNPTN,BRNDAT2,BRNDA))
 . . Q:BRNDA=""
 . . I $D(^BRNREC("AJ",BRNFAC,BRNDA)) S BRNFIND=1
 Q
END ;
 K BRNDAT,BRNDAT2,BRNDT,BRNFC,BRNFAC,BRNFN,BRNFACN,BRNDA
 K BRNPTN,BRNED,BRNBD,BRNSD,X,DD0,B Q
