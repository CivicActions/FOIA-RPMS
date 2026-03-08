BARTPRPT ; IHS/SD/SDR - Group Payment Report ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**39**;OCT 26, 2005;Build 231
 ;IHS/SD/SDR 1.8*39 ADO106244 INC0393324 New Group Payment Report, originally for Oklahoma Area
 ;
 K BAR,BARY
 ;I +$O(^AUTNEGRP("C",0))=0 W !!,"Re-index the Employer Group Insurance file" H 1 Q
 ;
SEL ;
 ;loc
 D GETFACS^ABMMUMUP  ;facility list
 M BARFLIST=ABMFLIST
 S BARCNT=0,BARDIR="",BARFQHC=0
 F  S BARCNT=$O(BARFLIST(BARCNT)) Q:'BARCNT  D
 .S:BARDIR'="" BARDIR=BARDIR_";"_BARCNT_":"_$$GET1^DIQ(9999999.06,$G(BARFLIST(BARCNT)),.01,"E")
 .S:BARDIR="" BARDIR=BARCNT_":"_$$GET1^DIQ(9999999.06,$G(BARFLIST(BARCNT)),.01,"E")
 .I $D(^ABMMUPRM(1,1,"B",BARFLIST(BARCNT))) S BARFQHC=1
 S BARCNT=$O(BARFLIST(99999),-1)  ;get last entry#
 S (BARCNT,BARTOT)=BARCNT+1
 I BARFQHC=0!(BARCNT>2) S BARDIR=BARDIR_";"_BARCNT_":All facilities"
 W !!
 K BARFANS,BARF
 F  D  Q:+$G(Y)<0!(Y=BARTOT)!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)  ;didn't answer or ALL selected
 .D ^XBFMK
 .S DIR(0)="SO^"_$G(BARDIR)
 .S:'$D(BARF) DIR(0)="S^"_$G(BARDIR)
 .S DIR("A")="Select one or more facilities"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S BARFANS=Y
 .I BARFANS'=(BARTOT) S BARF($G(BARFLIST(BARFANS)))=""
 .I BARFANS=(BARTOT) D
 ..S BARCNT=0
 ..F  S BARCNT=$O(BARFLIST(BARCNT)) Q:'BARCNT  S BARF($G(BARFLIST(BARCNT)))=""
 K BARFQHC
 ;
 ;ins or ins type?
 K DIR,BARY("ITYP"),BARY("INS")
 K BARANS
 S DIR(0)="SO^1:INSURER;2:INSURER TYPE;3:GROUP NAME/GROUP NUMBER;4:TRIBE OF MEMBERSHIP;5:EMPLOYER"
 S DIR("A")="Sort by INSURER, INSURER TYPE, GROUP, TRIBE OF MEMBERSHIP or EMPLOYER"
 D ^DIR
 K DIR
 Q:$D(DIRUT)!$D(DIROUT)
 S BARANS=Y
 I BARANS=1 S BARY("INS")="" D INSURER
 I BARANS=2 S BARY("ITYP")="" D INSTYPE
 I BARANS=3 S BARY("GRP")="" D GROUP
 I BARANS=4 S BARY("TRIBE")="" D TRIBE
 I BARANS=5 S BARY("EMP")="" D EMPLOYER
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 ;
DTYP ;
 K DIR,BARY("DT")
 S DIR(0)="SO^1:VISIT DATE;2:APPROVAL DATE;3:TRANSACTION DATE"
 ;
DDIR ;
 S DIR("A")="Select TYPE of DATE Desired"
 D ^DIR
 Q:$D(DIROUT)!$D(DIRUT)
 S BARY("DT")=$S(Y=1:"V",Y=2:"A",1:"T")
 S BARY("DTT")=$S(Y=1:"VISIT",Y=2:"APPROVAL",1:"TRANSACTION")_" DATE"
DT1 ;
 W !!," ============ Entry of ",BARY("DTT")," Range =============",!
 S DIR("A")="Enter STARTING "_BARY("DTT")_" for the Report"
 S DIR(0)="DO^::EP"
 D ^DIR
 G DTYP:$D(DIRUT)
 S BARY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING DATE for the Report"
 D ^DIR
 K DIR
 G DT1:$D(DIRUT)
 S BARY("DT",2)=Y
 I BARY("DT",1)>BARY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DT1
 ;
 K DIR
 S DIR(0)="S^A:ALL bills;P:POSTED bills w/payments"
 S DIR("A")="All bills, or just bills with payments posted?"
 S DIR("B")="ALL"
 D ^DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 I Y="A" S BARY("ALL")=""
 I Y="P" S BARY("POST")=""
 W !
 ;
 K DIR
 S DIR(0)="SA^C:CLINIC;V:VISIT TYPE"
 S DIR("A")="Sort Report by [V]isit Type or [C]linic: "
 S DIR("B")="V"
 S DIR("?")="Enter 'V' to sort the report by Visit Type (inpatient, outpatient, etc.) or a 'C' to sort it by the Clinic associated with each visit."
 D ^DIR
 I '$D(DIROUT)&('$D(DIRUT)) D
 .S BARY("SORT")=Y
 .I BARY("SORT")="C" D CLIN Q
 .D VTYP
 ;
RTYP ; EP
 ;Report Type
 K DIR,BARY("RTYP")
 S DIR(0)="SO^1:Detail (Printer);2:Delimited Detail"
 S DIR("A")="Select TYPE of REPORT desired"
 S DIR("B")=1
 D ^DIR
 K DIR
 I $D(DUOUT)!$D(DTOUT) S BARY("RTYP")=1,BARY("RTYP","NM")="Detail (Printer)" Q
 S BARY("RTYP")=Y
 S BARY("RTYP","NM")=Y(0)
 ;
ASKDEV ;
 S %ZIS="AQ"
 W !
 D ^%ZIS
 Q:POP
 I $D(IO("Q")) D QUE Q
 D COMPUTE
 U IO
 I '$D(^TMP("BAR-TP",$J)) D  Q
 .S BAR("PG")=1
 .D HDR^BARTPRP2
 .W !!,"THERE IS NO DATA TO PRINT",!
 .D ^%ZISC
 .U 0
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 ;
 S BARRTN="PRINT^BARTPRP2"
 D @BARRTN
 D ^%ZISC
 D HOME^%ZIS
 K DIR
 S DIR(0)="E"
 D ^DIR
 Q
QUE ;QUE TO TASKMAN
 S ZTRTN="COMPUTE3^BARTPRPT"
 S ZTDESC="Group Payment Report"
 S ZTSAVE("BAR*")=""
 K ZTSK
 D ^%ZTLOAD
 W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 Q
 ;
INSURER ;
 ;insurer
 W !
 ;F  D  Q:+$G(Y)<0!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)  ;this is what OK had but if you typed garbage it continued to next prompt
 F  D  Q:($G(X)="")!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)  ;X="" means they want ALL so don't prompt again
 .D ^XBFMK
 .S DIC="^AUTNINS("
 .S DIC(0)="QEAM"
 .S DIC("A")="Select Insurer: "_$S(($D(BARY("INS"))<10):"ALL// ",1:"")
 .D ^DIC
 .Q:+Y<0
 .S BARY("INS")=""
 .S BARY("INS",+Y)=""
 Q
 ;
INSTYPE ;
 ;insurer type
 F  D  Q:+$G(Y)<0!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .D ^XBFMK
 .S DIR(0)="SO^R:MEDICARE FI;D:MEDICAID FI;P:PRIVATE;N:NON-BENEFICIARY PATIENTS;I:BENEFICIARY PATIENTS;W:WORKMAN'S COMP;K:CHIP;H:HMO;M:MEDICARE SUPPL"
 .S DIR(0)=DIR(0)_";C:CHAMPUS;F:FRATERNAL ORG;T:3P LIABILITY;G:GUARANTOR;MD:MCR PART D;MH:MEDICARE HMO;V:VETERANS ADMINISTRATION;A:ALL"
 .S DIR("A")="Select INSURER TYPE to Display"
 .S:$D(BARY("ITYP"))<10 DIR("B")="ALL"
 .D ^DIR
 .K DIR
 .Q:$D(DIRUT)!$D(DIROUT)
 .S BARY("ITYP")=""
 .I Y="A" S Y=-1 Q
 .S BARY("ITYP",Y)=""
 I $D(BARY("ITYP")) K DIROUT,DIRUT
 Q
 ;
GROUP ;
 ;group name/number
 W !
 F  D  Q:+$G(Y)<0!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .D ^XBFMK
 .S DIC="^AUTNEGRP("  ;Employer Group Insurance
 .S DIC(0)="QEAM"
 .S DIC("A")="Select Group Name/Number: "_$S(($D(BARY("GRP"))<10):"ALL// ",1:"")
 .D ^DIC
 .Q:+Y<0
 .S BARY("GRP")=""
 .S BARY("GRP",+Y)=""
 I $D(BARY("GRP")) D
 .W !!,"Selected groups:"
 .S BARA=0
 .F  S BARA=$O(BARY("GRP",BARA)) Q:'BARA  W !?3,$P($G(^AUTNEGRP(BARA,0)),U)
 W !
 Q
TRIBE ;
 W !
 F  D  Q:+$G(Y)<0!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .D ^XBFMK
 .S DIC="^AUTTTRI("
 .S DIC(0)="QEAM"
 .S DIC("A")="Select Tribe: "_$S(($D(BARY("TRIBE"))<10):"ALL// ",1:"")
 .D ^DIC
 .Q:+Y<0
 .S BARY("TRIBE")=""
 .S BARY("TRIBE",+Y)=""
 Q
 ;
EMPLOYER ;
 ;Employer
 W !
 F  D  Q:+$G(Y)<0!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .D ^XBFMK
 .S DIC="^AUTNEMPL("
 .S DIC(0)="QEAM"
 .S DIC("A")="Select Employer: "_$S(($D(BARY("EMP"))<10):"ALL// ",1:"")
 .D ^DIC
 .Q:+Y<0
 .S BARY("EMP")=""
 .S BARY("EMP",+Y)=""
 Q
 ;dt range
DT ;
 Q:$D(DIRUT)
 S BARY("DT")="V"
 W !!," ============ Entry of Visit Date Range =============",!
 S DIR("A")="Enter STARTING Visit Date for the Report"
 S DIR(0)="DO^::EP"
 D ^DIR
 G DT:$D(DIRUT)
 S BARY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING DATE for the Report"
 D ^DIR
 K DIR
 G DT:$D(DIRUT)
 S BARY("DT",2)=Y
 I BARY("DT",1)>BARY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DT
 Q
 ;
CLIN ;clinic
 K BARY("CLIN")
 S DIC="^DIC(40.7,"
 S DIC(0)="AEMQ"
 S DIC("A")="Select Clinic: ALL// "
 F  D  Q:+Y<0
 .I $D(BARY("CLIN")) S DIC("A")="Select Another Clinic: "
 .D ^DIC
 .Q:+Y<0
 .S BARY("CLIN",+Y)=""
 I '$D(BARY("CLIN")) D
 .I $D(DUOUT) K BARY("SORT") Q
 .W "ALL"
 K DIC
 Q
 ;
VTYP ;vst type
 K BARY("VTYP")
 S DIC="^ABMDVTYP("
 S DIC(0)="AEMQ"
 S DIC("A")="Select Visit Type: ALL// "
 F  D  Q:+Y<0
 .I $D(BARY("VTYP")) S DIC("A")="Select Another Visit Type: "
 .D ^DIC
 .Q:+Y<0
 .S BARY("VTYP",+Y)=""
 I '$D(BARY("VTYP")) D
 .I $D(DUOUT) K BARY("SORT") Q
 .W "ALL"
 K DIC
 Q
COMPUTE3 ;
 D COMPUTE
 D PRINT^BARTPRP2
 Q
 ;
COMPUTE ;EP - Entry Point for Setting up
 ;Find parent loc
 S BARDISP=0
 S BARPAR=0  ;Parent
 ;check site active at DOS to ensure bill added to correct site
 S DA=0
 F  S DA=$O(^BAR(90052.06,DA)) Q:DA'>0  D  Q:BARPAR
 .Q:'$D(^BAR(90052.06,DA,DA))  ;Pos Parent UNDEF Site Parm
 .Q:'$D(^BAR(90052.05,DA,DUZ(2)))  ;Sat UNDEF Par/Sat
 .Q:+$P($G(^BAR(90052.05,DA,DUZ(2),0)),U,5)  ;Par/Sat not usable
 .;Q if sat NOT active at DOS
 .I BARY("DT",1)<$P($G(^BAR(90052.05,DA,DUZ(2),0)),U,6) Q
 .;Q if sat became NOT active before DOS
 .I $P($G(^BAR(90052.05,DA,DUZ(2),0)),U,7),(BARY("DT",1)>$P($G(^BAR(90052.05,DA,DUZ(2),0)),U,7)) Q
 .S BARPAR=$S(DUZ(2):$P($G(^BAR(90052.05,DA,DUZ(2),0)),U,3),1:"")
 ;
 S BAR("SUBR")="BAR-TP" K ^TMP("BAR-TP",$J)
 I BARY("DT")="T" D  Q
 .S BARCHOLD=DUZ(2)
 .S DUZ(2)=BARPAR
 .S BAR("SD")=BARY("DT",1)-.5
 .S BARY("DT",2)=BARY("DT",2)+.999999
 .D COMPUTE2
 .S DUZ(2)=BARCHOLD
 ;
 S BARY("DT",2)=BARY("DT",2)+.999999
 S BARCHOLD=DUZ(2)
 S BARFLCNT=0
 F  S BARFLCNT=$O(BARFLIST(BARFLCNT)) Q:'BARFLCNT  D
 .S DUZ(2)=$G(BARFLIST(BARFLCNT))
 .S BAR("SD")=BARY("DT",1)-.5
 .D COMPUTE2
 S DUZ(2)=BARCHOLD
 Q
 ;
COMPUTE2 ;
 ;by visit dt
 I BARY("DT")="V" D  Q
 .F  S BAR("SD")=$O(^ABMDBILL(DUZ(2),"AD",BAR("SD"))) Q:'+BAR("SD")!(BAR("SD")>BARY("DT",2))  D
 ..S BAR=""
 ..F  S BAR=$O(^ABMDBILL(DUZ(2),"AD",BAR("SD"),BAR)) Q:'BAR  D DATA(DUZ(2),BAR)
 ;
 ;by approval dt
 I BARY("DT")="A" D  Q
 .F  S BAR("SD")=$O(^ABMDBILL(DUZ(2),"AP",BAR("SD"))) Q:'+BAR("SD")!(BAR("SD")>BARY("DT",2))  D
 ..S BAR=""
 ..F  S BAR=$O(^ABMDBILL(DUZ(2),"AP",BAR("SD"),BAR)) Q:'BAR  D DATA(DUZ(2),BAR)
 ;
 ;by trans dt
 I BARY("DT")="T" D
 .F  S BAR("SD")=$O(^BARTR(DUZ(2),"AG",BAR("SD"))) Q:'+BAR("SD")!(BAR("SD")>BARY("DT",2))  D
 ..S BARTR=0
 ..F  S BARTR=$O(^BARTR(DUZ(2),"AG",BAR("SD"),BARTR)) Q:'BARTR  D
 ...D BARTRNS
 Q
BARTRNS ;
 Q:(+$P($G(^BARTR(DUZ(2),BARTR,0)),U,2)=0&(+$P($G(^BARTR(DUZ(2),BARTR,0)),U,3)=0))
 I $P($G(^BARTR(DUZ(2),BARTR,1)),U,1)=49 Q  ;BILL NEW
 S BARBBILL=$P($G(^BARTR(DUZ(2),BARTR,0)),U,4)
 Q:(+BARBBILL=0)
 S BARDUZ2=$P($G(^BARBL(DUZ(2),BARBBILL,0)),U,22)
 S BARBDFN=$P($G(^BARBL(DUZ(2),BARBBILL,0)),U,17)
 S BAR=BARBDFN
 S BARTRIEN=BARTR
 D DATA(BARDUZ2,BAR)
 D DOTS^BARPG
 Q
 ;
DATA(BARDUZ2,BAR) ;
 S BARHOLD=DUZ(2)
 S DUZ(2)=BARDUZ2
 S BARP("HIT")=0 D BILL Q:'BARP("HIT")
 S BAR("L")=$P(^DIC(4,BAR("L"),0),U)
 S BARINS=BAR("I")
 S BARITYP=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,BAR("I"),".211","I"),1,"I")
 I $D(BARY("ITYP")) D
 .S BAR("I")=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,BAR("I"),".211","I"),1,"I")
 .S BAR("I")=$P($T(@BAR("I")),";;",2)
 I $D(BARY("INS")) S BAR("I")=$P($G(^AUTNINS(BAR("I"),0)),U)
 I +$G(BAR("TRIBE"))'=0 S BAR("TRIBE")=$P($G(^AUTTTRI(BAR("TRIBE"),0)),U)
 I $G(BAR("TRIBE"))="" S BAR("TRIBE")="NO TRIBE OF MEMBERSHIP"
 S BAR("S")=$S(BARY("SORT")="V":BAR("V"),1:BAR("C"))
 S BAR("SORT")=$S($D(BARY("INS")):BAR("I"),$D(BARY("ITYP")):BAR("I"),$D(BARY("GRP")):BARG,$D(BARY("TRIBE")):BAR("TRIBE"),1:BAR("EMP"))
 ;
 I BARY("RTYP")=2 D  ;delimited
 .S BARREC=BAR("L")_U_BAR("BILL")_U_BAR("P")_U_"("_BAR("V")_") "_$P(^ABMDVTYP(BAR("V"),0),U)_U_"("_BAR("C")_") "_$P(^DIC(40.7,BAR("C"),0),U)
 .S BARREC=BARREC_U_BARINS_U_$P($T(@BARITYP),";;",2)_U_BAR("TRIBE")_U_$P(BARG,"/")_U_$P(BARG,"/",2)_U_BAR("EMP")
 .S BARBSTAT=$P($G(^ABMDBILL(DUZ(2),BAR,0)),U,4)
 .S BARBSTAT=$S(BARBSTAT="C":"COMPLETE",BARBSTAT="B":"BILLED",BARBSTAT="X":"CANCELLED",BARBSTAT="A":"APPROVED",1:"")
 .S BARREC=BARREC_U_BAR("D")_U_BARBAMT_U_BARBSTAT
 .I '$D(BARTREC) S ^TMP("BAR-TP",$J,BARREC)=""
 .E  D
 ..S BARTCNT=0
 ..F  S BARTCNT=$O(BARTREC(BARTCNT)) Q:'BARTCNT  D
 ...S ^TMP("BAR-TP",$J,BARREC_U_BARTREC(BARTCNT))=""
 ..K BARTREC
 ;
 I BARY("RTYP")=1 D
 .I BARY("DT")="T" D
 ..S BARPIEN=0
 ..F  S BARPIEN=$O(^ABMDBILL(DUZ(2),BAR,3,BARPIEN)) Q:'BARPIEN  D
 ...;quit if no pymts or pymt adjs
 ...I (+$P($G(^ABMDBILL(DUZ(2),BAR,3,BARPIEN,0)),U,10)=0)&(+$P($G(^ABMDBILL(DUZ(2),BAR,3,BARPIEN,0)),U,14)=0)  Q
 ...;S BAR("PD")=BAR("PD")+$P($G(^ABMDBILL(DUZ(2),BAR,3,BARPIEN,0)),U,10)+$P($G(^ABMDBILL(DUZ(2),BAR,3,BARPIEN,0)),U,14)
 ...S BAR("PD")=BAR("PD")+$P($G(^ABMDBILL(DUZ(2),BAR,3,BARPIEN,0)),U,10)
 .S ^TMP("BAR-TP",$J,BAR("L")_U_BAR("SORT")_U_BAR("S")_U_BAR("P")_U_BAR("D")_U_BAR("BILL")_U_BARBAMT_U_BAR("PD"))=""
 S DUZ(2)=BARHOLD
 Q
 ;
H ;;HMO
M ;;MEDICARE SUPPL.
D ;;MEDICAID FI
R ;;MEDICARE FI
P ;;PRIVATE
W ;;WORKMEN'S COMP
C ;;CHAMPUS
F ;;FRATERNAL ORG
N ;;NON-BENEFICIARY
I ;;BENEFICIARY
K ;;KIDSCARE (CHIP)
T ;;THIRD PARTY LIABILITY
G ;;GUARANTOR
MD ;;MEDICARE PART D
MH ;;MEDICARE HMO
V ;;VETERANS ADMINISTRATION
 ;
BILL ;EP check Bill File data parms
 Q:'$D(^ABMDBILL(DUZ(2),BAR,0))!('$D(^(1)))
 ;Q:$P(^ABMDBILL(DUZ(2),BAR,0),"^",4)="X"  ;skip cancelled bills
 S BAR("BILL")=$P($G(^ABMDBILL(DUZ(2),BAR,0)),U)  ;bill#
 ;BAR("L") is piece 3 of bill file
 S BAR("V")=$P($G(^ABMDBILL(DUZ(2),BAR,0)),U,7)  ;visit type
 S BAR("C")=$P($G(^ABMDBILL(DUZ(2),BAR,0)),U,10)  ;clinic
 Q:($D(BARY("VTYP"))&(BAR("V")=""))
 Q:($D(BARY("CLIN"))&(BAR("C")=""))
 I $D(BARY("CLIN")),'$D(BARY("CLIN",+$P(^ABMDBILL(DUZ(2),BAR,0),U,10))) Q
 I $D(BARY("VTYP")),'$D(BARY("VTYP",+$P(^ABMDBILL(DUZ(2),BAR,0),U,7))) Q
 S BAR("L")=$P($G(^ABMDBILL(DUZ(2),BAR,0)),U,3)  ;visit loc
 S BAR("I")=$P($G(^ABMDBILL(DUZ(2),BAR,0)),U,8)  ;active ins
 S BAR("P")=$P($G(^ABMDBILL(DUZ(2),BAR,0)),U,5)  ;pt
 S BAR("E")=+$P($G(^AUPNPAT(BAR("P"),0)),U,19)  ;employer
 S BAR("TRIBE")=+$P($G(^AUPNPAT(BAR("P"),11)),U,8)  ;tribe of membership
 S BAR("D")=$P($G(^ABMDBILL(DUZ(2),BAR,7)),U)  ;service dt from
 Q:BAR("L")=""!(BAR("I")="")!(BAR("P")="")!(BAR("D")="")
 Q:'$D(^AUTNINS(BAR("I"),0))
 I '$D(BARF(BAR("L"))) Q
 I $D(BARY("INS"))>10,'$D(BARY("INS",BAR("I"))) Q
 I $D(BARY("ITYP"))>10,'$D(BARY("ITYP",$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,BAR("I"),".211","I"),1,"I"))) Q
 I $D(BARY("TRIBE"))>10,'$D(BARY("TRIBE",+BAR("TRIBE"))) Q
 I $D(BARY("EMP"))>10,'$D(BARY("EMP",BAR("E"))) Q
 S BARNG=0
 D GRPCHK^BARTPRP2
 I +$G(BARG)=0 S BARG="NO GROUP"
 I +$G(BAR("E"))'=0 S BAR("EMP")=$P($G(^AUTNEMPL(BAR("E"),0)),U)
 I +$G(BAR("E"))=0 S BAR("EMP")="NO EMPLOYER"
 I +$G(BARG)'=0 S BARG=$P($G(^AUTNEGRP(BARG,0)),U)_"/"_$P($G(^AUTNEGRP(BARG,0)),U,2)
 I $D(BARY("GRP"))>10 I BARNG=0 Q
 S BARBAMT=$P($G(^ABMDBILL(DUZ(2),BAR,2)),U)  ;bill amt
 K BAR("QUIT")
 S BARP("HIT")=1
 S BAR("PD")=0
 I BARY("DT")="T" D BTRNSONE^BARTPRP2(BARPAR) Q  ;do just one trans for delimited, not all of them
 I BARY("RTYP")=2 D BTRNSDTL^BARTPRP2 Q  ;details from A/R Trans for delimited
 I +$O(^ABMDBILL(DUZ(2),BAR,3,0))=0 S:$D(BARY("POST")) BARP("HIT")=0 Q  ;no pymts/adjs
 S BARPIEN=0
 F  S BARPIEN=$O(^ABMDBILL(DUZ(2),BAR,3,BARPIEN)) Q:'BARPIEN  D
 .;quit if no pymts or pymt adjs
 .;I (+$P($G(^ABMDBILL(DUZ(2),BAR,3,BARPIEN,0)),U,10)=0)&(+$P($G(^ABMDBILL(DUZ(2),BAR,3,BARPIEN,0)),U,14)=0) Q
 .I (+$P($G(^ABMDBILL(DUZ(2),BAR,3,BARPIEN,0)),U,10)=0) Q
 .;S BAR("PD")=BAR("PD")+$P($G(^ABMDBILL(DUZ(2),BAR,3,BARPIEN,0)),U,10)+$P($G(^ABMDBILL(DUZ(2),BAR,3,BARPIEN,0)),U,14)
 .S BAR("PD")=BAR("PD")+$P($G(^ABMDBILL(DUZ(2),BAR,3,BARPIEN,0)),U,10)
 ;I +BAR("PD")=0&($D(BARY("POST"))) S BARP("HIT")=0  ;no pymt/pymt credit on bill
 I (+BAR("PD")=0) S BARP("HIT")=0  ;no pymt on bill
 ;I +BAR("PD")=0&('$D(BARY("POST")))&($P($G(^ABMDBILL(DUZ(2),BAR,0)),U,4)="X") S BARP("HIT")=0  ;there's no pymt and bill is cancelled
 I +BAR("PD")=0&($P($G(^ABMDBILL(DUZ(2),BAR,0)),U,4)="X") S BARP("HIT")=0  ;there's no pymt and bill is cancelled
 Q
 ;EOR
