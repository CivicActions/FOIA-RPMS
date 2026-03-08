BARUTL0 ; IHS/SD/LSL - Utility programs for user/fac ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35,39**;OCT 26, 2005;Build 231
 ;;
 ;IHS/SD/LSL 1.7 09/24/02 NOIS HQW-0902-100094 Set BARUSR(29 [service section] to be BUSINESS OFFICE if it is something other than BUSINESS OFFICE or FISCAL SERVICE"
 ;
 ;IHS/SD/SDR 1.8*35 ADO60910 Updated to display PPN preferred name
 ;IHS/SD/SDR 1.8*39 NO ADO Line tag PSLIST was added as a tool when setting up a new site; it simply
 ;   writes to the screen the A/R Setup info in a clean easy format, to be used before setting up a new site
 ;   or verifying the setup when complete
 ;*************************************
 ;
BARUSR ;EP setup BARUSR( user array from DUZ:200
 N XB,DIQ,DIC,DA
 K BARUSR
 S DIQ="BARUSR("
 S DIQ(0)="I"
 S DIC=200
 S DR=".01;29"
 S DA=DUZ
 D EN^XBDIQ1
 Q:BARUSR(29)="BUSINESS OFFICE"
 Q:BARUSR(29)="FISCAL SERVICE"
 S DIC="^DIC(49,"          ; Service/Section file
 S DIC(0)="ZEX"
 S X="BUSINESS OFFICE"
 K DD,DO
 D ^DIC
 Q:Y'>0
 S BARUSR(29)=$P(Y,U,2)
 S BARUSR(29,"I")=+Y
 Q
 ;*************************************
 ;
BARSPAR ;EP setup BARSPAR( A/R Site Parameter array
 N XB,DIC,DIQ,DA,DR
 K BARSPAR
 S DIC=90052.06
 S DR=".01:99"
 S DA=DUZ(2)
 S DIQ="BARSPAR("
 S DIQ(0)="I"
 D EN^XBDIQ1
 Q
 ;*************************************
 ;
BARSITE ;EP setup BARSITE( site array
 N XB,DIC,DA,DR
 S DIC="^AUTTSITE("
 S DIQ="BARSITE("
 S DIQ(0)="I"
 S DA=1
 S DR=".01"
 D EN^XBDIQ1
 Q
 ;*************************************
 ;
BARPSAT ;EP built BARPS arrary with Parent Satellite
 N DA,DIC,DR,BARGL,Y
 K BARPSAT
 S DIC=90052.05
 S DIQ="BARPSAT("
 S DIQ(0)="I"
 S DR=".01;2"
 S DIQ(0)="1E"
 S DA=0
 D ENM^XBDIQ1
 Q
 ;*************************************
 ;
ADDREGON ;EP add a regional site (needs DUZ(2))
 K DIQ
 S DIC=4
 S DIQ="BARTMP("
 S DR=".01"
 S DA=DUZ(2)
 D EN^XBDIQ1
 I $D(^BARBL(DUZ(2))) D
 .W !,?5,BARTMP(.01),"  EXISTS"
 .D EOP^BARUTL(0)
 K DIR
 S DIR(0)="Y"
 S DIR("B")="NO"
 S DIR("A")=BARTMP(.01)_" to be added/updated as an A/R Regional Site?"
 D ^DIR
 I 'Y D  Q
 .W !,"You can change your Default A/R Facility and return here if necessary!",!
 .K DIR,BARTMP
 .D EOP^BARUTL(1)
 ; -------------------------------
 ;
 ; set files 0 nodes
 F BARI=1:1 S BARFLNUM=$P($T(FNUM+BARI),";;",2) Q:'BARFLNUM  D
 .S BARGL=^DIC(BARFLNUM,0,"GL")_"0)"
 .I '$D(@BARGL) D
 ..S $P(@BARGL,"^",1,2)=$P(^DIC(BARFLNUM,0),"^",1,2)
 ..W !,"ADDED: ",?10,$P(@BARGL,U)
 W !!,BARTMP(.01)," Has been added",!
 ;--------------------------------
 ;
ARSPAC ;set up two special A/R accounts
 K DIC
 S DIC=$$DIC^XBDIQ1(90052.07)
 S DIC(0)="L"
 I '$D(@(DIC_"""B"",""UN-ALLOCATED"")")) D
 .S X="UN-ALLOCATED"
 .K DD,DO
 .D ^DIC
 .I Y'>0 D
 ..S BARQUIT=1
 ..W !,"ERROR IN SETUP OF UN-ALLOCATED"
 ;--------------------------------
 ;
HOSPSRVC ;
 S DIC=49 ;hospital service
 S DIC(0)="L"
 S DLAYGO=49
 I '$D(^DIC(49,"B","BUSINESS OFFICE")) D
 .S X="BUSINESS OFFICE"
 .K DD,DO
 .D ^DIC
 .I Y'>0 D
 ..S BARQUIT=1
 ..W !,"ERROR IN SETUP OF BUSINESS OFFICE",!
 I '$D(^DIC(49,"B","FISCAL SERVICE")) D
 .S X="FISCAL SERVICE"
 .K DD,DO
 .D ^DIC
 .I Y'>0 D
 ..S BARQUIT=1
 ..W !,"ERROR IN SETUP OF FISCAL SERVICE",!
 I $G(BARQUIT) D EOP^BARUTL(0)
 ;
EADD ;
 Q
FNUM ;;$T filenumber to be regionally added/deleted
 ;;90051.01
 ;;90051.02
 ;;90050.02
 ;;90050.01
 ;;90052.05
 ;;90052.06
 ;;90052.07
 ;;90050.03
 ;;end of list
EFNUM ;----------
 ;
SRVSEC ;EP switch Service Section
 K DIC,DR,DIE,DA
 S DIC="^BARTBL("
 S DIC(0)="AEQM"
 S DIC("S")="I $P(^(0),U,3)=""SRVSEC"""
 K DD,DO
 D ^DIC
 Q:Y'>0
 S Y=+Y
 S DIE="^VA(200,"
 S DA=DUZ
 S DR="29///"_$$VAL^XBDIQ1("^BARTBL(",+Y,.01)
 S DIDEL=90050
 D ^DIE
 K DIDEL
 Q
 ;start new bar*1.8*35 IHS/SD/SDR ADO60910
DICWACCT(BARY) ;
 ;BARY is the IEN into the A/R Account file; It was done this way because sometimes it's Y and sometimes it is $P(Y,U,2) (if a multiple)
 I $P(^BARAC(DUZ(2),BARY,0),U)'["AUPNPAT" Q  ;only patient entries
 I $$GETPREF^AUPNSOGI(+$P(^BARAC(DUZ(2),BARY,0),U),"I",1)'="" W ?40," - "_$$GETPREF^AUPNSOGI(+$P(^BARAC(DUZ(2),BARY,0),U),"I",1)_"*"
 Q
DICWPP ;EP
 ;pre-payments
 N BARN
 S BARN=$P($G(^BARPPAY(DUZ(2),+Y,0)),U,8)
 W !?3,$P(^DPT(BARN,0),U)
 W $S($$GETPREF^AUPNSOGI(BARN,"I",1)'="":" - "_$$GETPREF^AUPNSOGI(BARN,"I",1)_"*",1:"")
 W ?46,$P(^DPT(BARN,0),U,2)," ",$$HDT^BARDUTL($P(^(0),U,3))," ","***-**-"_$E($P(^(0),U,9),6,9)
 I  I $G(DUZ(2)),$D(^AUPNPAT(BARN,41,DUZ(2),0)) D
 .W ?70,$P($G(^AUTTLOC(DUZ(2),0)),U,7)," ",$P(^AUPNPAT(BARN,41,DUZ(2),0),U,2)
 Q
DICWPAT(BAR) ;EP - for displaying identifiers
 ;BAR is a 0 (display everything) or a 1 (only display the PPN); this is because it would display the patient data twice sometimes
 I (+$G(BAR)=0) W !?3,$P(^DPT(+Y,0),U)
 W $S($$GETPREF^AUPNSOGI(+Y,"I",1)'="":" - "_$$GETPREF^AUPNSOGI(+Y,"I",1)_"*",1:"")
 Q:(+$G(BAR)=1)  ;only display the preferred name
 W ?46,$P(^DPT(+Y,0),U,2)," ",$$HDT^BARDUTL($P(^(0),U,3))," ","***-**-"_$E($P(^(0),U,9),6,9)
 I  I $G(DUZ(2)),$D(^AUPNPAT(+Y,41,DUZ(2),0)) D
 .W ?70,$P($G(^AUTTLOC(DUZ(2),0)),U,7)," ",$P(^AUPNPAT(+Y,41,DUZ(2),0),U,2)
 Q
 ;end new bar*1.8*35 IHS/SD/SDR ADO60910
 ;
 ;start new bar*1.8*39 IHS/SD/SDR NO ADO
PSLIST ;
 I +$G(DUZ(2))'=0 S BARH=DUZ(2)
 S DUZ(2)=0
 W !,?38,"Use A/R"
 W !?14,"Location",?29,"Usable?",?38,"P/S setup?",?52,"Start Dt",?68,"End Dt"
 W ! F I=1:1:80 W "-"
 F  S DUZ(2)=$O(^BAR(90052.05,DUZ(2))) Q:'DUZ(2)  D
 .W !,"Parent: ("_DUZ(2)_") "_$P($G(^AUTTLOC(DUZ(2),0)),U,2)
 .I $D(^BAR(90052.05,DUZ(2),DUZ(2),0))<1 W " The rest of parent entry is missing"
 .I $D(^BAR(90052.05,DUZ(2),DUZ(2),0)) D
 ..W ?29,$S($P($G(^BAR(90052.05,DUZ(2),DUZ(2),0)),U,5)=0:"Usable",$P($G(^BAR(90052.05,DUZ(2),DUZ(2),0)),U,5)="":"",1:"Not Usable")
 ..W ?41,$S($P($G(^ABMDPARM(DUZ(2),1,4)),U,9)=0:"NO",$P($G(^ABMDPARM(DUZ(2),1,4)),U,9)="":"",1:"YES")
 ..W ?52,$$SDT^BARDUTL(+$P($G(^BAR(90052.05,DUZ(2),DUZ(2),0)),U,6))
 ..W ?68,$$SDT^BARDUTL(+$P($G(^BAR(90052.05,DUZ(2),DUZ(2),0)),U,7))
 .S BARSAT=0
 .F  S BARSAT=$O(^BAR(90052.05,DUZ(2),BARSAT)) Q:'BARSAT  D
 ..Q:DUZ(2)=BARSAT  ;parent - done already
 ..W !?3,"Sat: ("_BARSAT_") "_$P($G(^AUTTLOC(BARSAT,0)),U,2)
 ..W ?29,$S($P($G(^BAR(90052.05,DUZ(2),BARSAT,0)),U,5)=0:"Usable",$P($G(^BAR(90052.05,DUZ(2),DUZ(2),0)),U,5)="":"",1:"Not Usable")
 ..W ?41,$S($P($G(^ABMDPARM(BARSAT,1,4)),U,9)=0:"NO",$P($G(^ABMDPARM(BARSAT,1,4)),U,9)="":"",1:"YES")
 ..W ?52,$$SDT^BARDUTL(+$P($G(^BAR(90052.05,DUZ(2),BARSAT,0)),U,6))
 ..W ?68,$$SDT^BARDUTL(+$P($G(^BAR(90052.05,DUZ(2),BARSAT,0)),U,7))
 .W ! F I=1:1:80 W "-"
 I +$G(BARH)'=0 S DUZ(2)=BARH
 Q
 ;end new bar*1.8*39 IHS/SD/SDR NO ADO
