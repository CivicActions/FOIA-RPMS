PSSDEE ;BIR/WRT-MASTER DRUG ENTER/EDIT ROUTINE ;01/21/00
 ;;1.0;PHARMACY DATA MANAGEMENT;**3,5,15,16,20,22,28,32,34,33**;9/30/97
 ;
 ;Reference to REACT1^PSNOUT supported by DBIA #2080
 ;Reference to $$UP^XLFSTR(X) supported by DBIA #10104
 ;Reference to $$PSJDF^PSNAPIS(P1,P3) supported by DBIA #2531
 ;
BEGIN S PSSFLAG=0 D ^PSSDEE2 S PSSZ=1 F PSSXX=1:1 K DA D ASK Q:PSSFLAG
DONE D ^PSSDEE2 K PSSFLAG Q
ASK S DIC="^PSDRUG(",DIC(0)="QEALMN",DLAYGO=50 D ^DIC K DIC I Y<0 S PSSFLAG=1 Q
 S (FLG1,FLG2,FLG3,FLG4,FLG5,FLG6,FLAG,FLGKY,FLGOI)=0 K ^TMP($J,"ADD"),^TMP($J,"SOL")
 S DA=+Y,DISPDRG=DA L +^PSDRUG(DISPDRG):0 W:'$T !,$C(7),"Another person is editing this one." I $T S:$P(Y,"^",3)=1 PSSNEW=1 D USE,NOPE,COMMON,DEA,ADDMESS^PSSDEE1,ADDMESS1^PSSDEE1,SOLMESS1^PSSDEE1,SOLMESS^PSSDEE1,MF L -^PSDRUG(DISPDRG) K FLG3
 Q
COMMON S DIE="^PSDRUG(",DR="[PSSCOMMON]" D ^DIE Q:$D(Y)!($D(DTOUT))  W:'$D(Y) !,"PRICE PER DISPENSE UNIT: " S:'$D(^PSDRUG(DA,660)) $P(^PSDRUG(DA,660),"^",6)="" W:'$D(Y) $P(^PSDRUG(DA,660),"^",6) D DEA,CK,ASKND,OIKILL^PSSDEE1,ZAPIT,COMMON1
 Q
COMMON1 W !,"Just a reminder...you are editing ",$P(^PSDRUG(DISPDRG,0),"^"),"." D USE,APP,ORDITM^PSSDEE1,PRIMDRG
 Q
CK D DSPY^PSSDEE1 S FLGNDF=0
 Q
ASKND S %=-1 I $D(^XUSEC("PSNMGR",DUZ)) D MESSAGE^PSSDEE1 W !!,"Do you wish to match/rematch to NATIONAL DRUG file? " S %=1 S:FLGMTH=1 %=2 D YN^DICN
 I %=0 W !,"If you answer ""yes"", you will attempt to match to NDF." G ASKND
 I %=2 K X,Y Q
 I %<0 K X,Y Q
 I %=1 D RSET^PSSDEE1,EN1^PSSUTIL(DISPDRG,1) S X="PSNOUT" X ^%ZOSF("TEST") I  D REACT1^PSNOUT S DA=DISPDRG I $D(^PSDRUG(DA,"ND")),$P(^PSDRUG(DA,"ND"),"^",2)]"" D ONE
 Q
ONE S PSNP=$G(^PSDRUG(DA,"I")) I PSNP,PSNP<DT Q
 W !,"You have just VERIFIED this match and MERGED the entry." D CKDF D EN2^PSSUTIL(DISPDRG,1) S:'$D(OLDDF) OLDDF="" I OLDDF'=NEWDF S FLGNDF=1 D WR
 Q
CKDF S NWND=^PSDRUG(DA,"ND"),NWPC1=$P(NWND,"^",1),NWPC3=$P(NWND,"^",3),DA=NWPC1,K=NWPC3 S X=$$PSJDF^PSNAPIS(DA,K) S NEWDF=$P(X,"^",2),DA=DISPDRG
 Q
NOPE S ZAPFLG=0 I '$D(^PSDRUG(DA,"ND")),$D(^PSDRUG(DA,2)),$P(^PSDRUG(DA,2),"^",1)']"" D DFNULL
 I '$D(^PSDRUG(DA,"ND")),'$D(^PSDRUG(DA,2)) D DFNULL
 I $D(^PSDRUG(DA,"ND")),$P(^PSDRUG(DA,"ND"),"^",2)']"",$D(^PSDRUG(DA,2)),$P(^PSDRUG(DA,2),"^",1)']"" D DFNULL
 Q
DFNULL S OLDDF="",ZAPFLG=1
 Q
ZAPIT I $D(ZAPFLG),ZAPFLG=1,FLGNDF=1,OLDDF'=NEWDF D CKIV^PSSDEE1
 Q
APP W !!,"MARK THIS DRUG AND EDIT IT FOR: " D CHOOSE
 Q
CHOOSE I $D(^XUSEC("PSORPH",DUZ))!($D(^XUSEC("PSXCMOPMGR",DUZ))) W !,"O  - Outpatient" S FLG1=1
 I $D(^XUSEC("PSJU MGR",DUZ)) W !,"U  - Unit Dose" S FLG2=1
 I $D(^XUSEC("PSJI MGR",DUZ)) W !,"I  - IV" S FLG3=1
 I $D(^XUSEC("PSGWMGR",DUZ)) W !,"W  - Ward Stock" S FLG4=1
 I $D(^XUSEC("PSAMGR",DUZ))!($D(^XUSEC("PSA ORDERS",DUZ))) W !,"D  - Drug Accountability" S FLG5=1
 I $D(^XUSEC("PSDMGR",DUZ)) W !,"C  - Controlled Substances" S FLG6=1
 I FLG1=1,FLG2=1,FLG3=1,FLG4=1,FLG5=1,FLG6=1 S FLAG=1
 I FLAG=1 W !,"A  - ALL"
 W !
 I FLG1=0,FLG2=0,FLG3=0,FLG4=0,FLG5=0,FLG6=0 W !,"You do not have the proper keys to continue. Sorry, this concludes your editing session.",! S FLGKY=1 K DIRUT,X Q
 I FLGKY'=1 K DIR S DIR(0)="F^1:30",DIR("A")="Enter your choice(s) separated by commas "
 I FLGKY'=1 D ^DIR S PSSANS=X,PSSANS=$$UP^XLFSTR(PSSANS) D BRANCH,BRANCH1
 Q
BRANCH D:PSSANS["O" OP D:PSSANS["U" UD D:PSSANS["I" IV D:PSSANS["W" WS D:PSSANS["D" DACCT D:PSSANS["C" CS
 Q
BRANCH1 I FLAG=1,PSSANS["A" D OP,UD,IV,WS,DACCT,CS
 Q
OP I FLG1=1 W !,"** You are NOW editing OUTPATIENT fields. **",! S PSIUDA=DA,PSIUX="O^Outpatient Pharmacy" D ^PSSGIU I %=1 S DIE="^PSDRUG(",DR="[PSSOP]" D ^DIE K DIR D OPEI,ASKCMOP S X="PSOCLO1" X ^%ZOSF("TEST") I  D ASKCLOZ S FLGOI=1
 I FLG1=1 D CKCMOP
 Q
CKCMOP I $P($G(^PSDRUG(DISPDRG,2)),"^",3)'["O" S:$D(^PSDRUG(DISPDRG,3)) $P(^PSDRUG(DISPDRG,3),"^",1)=0 K:$D(^PSDRUG("AQ",DISPDRG)) ^PSDRUG("AQ",DISPDRG) S DA=DISPDRG D ^PSSREF
 Q
UD I FLG2=1 W !,"** You are NOW editing UNIT DOSE fields. **",! S PSIUDA=DA,PSIUX="U^Unit Dose" D ^PSSGIU I %=1 S DIE="^PSDRUG(",DR="62.05;212.2" D ^DIE S DIE="^PSDRUG(",DR="212",DR(2,50.0212)=".01;1" D ^DIE S FLGOI=1
 Q
IV I FLG3=1 W !,"** You are NOW editing IV fields. **",! S (PSIUDA,PSSDA)=DA,PSIUX="I^IV" D ^PSSGIU I %=1 D ADDMESS2^PSSDEE1,SOLMESS2^PSSDEE1,IV1 S FLGOI=1
 Q
IV1 K PSSIVOUT ;This variable controls the selection process loop.
 W !,"Edit Additives or Solutions: " K DIR S DIR(0)="SO^A:ADDITIVES;S:SOLUTIONS;" D ^DIR Q:$D(DIRUT)  S PSSASK=Y(0) D:PSSASK="ADDITIVES" ENA^PSSVIDRG D:PSSASK="SOLUTIONS" ENS^PSSVIDRG I '$D(PSSIVOUT) G IV1
 K PSSIVOUT
 Q
WS I FLG4=1 W !,"** You are NOW editing WARD STOCK fields. **",! S DIE="^PSDRUG(",DR="300;301;302" D ^DIE
 Q
DACCT I FLG5=1 W !,"** You are NOW editing DRUG ACCOUNTABILITY fields. **",! S DIE="^PSDRUG(",DR="441" D ^DIE S DIE="^PSDRUG(",DR="9",DR(2,50.1)="1;2;400;401;402;403;404;405" D ^DIE
 Q
CS I FLG6=1 W !,"** You are NOW Marking/Unmarking for CONTROLLED SUBS. **",! S PSIUDA=DA,PSIUX="N^Controlled Substances" D ^PSSGIU
 Q
ASKCMOP I $D(^XUSEC("PSXCMOPMGR",DUZ)) W !!,"Do you wish to mark to transmit to CMOP? " K DIR S DIR(0)="Y",DIR("?")="If you answer ""yes"", you will attempt to mark this drug to transmit to CMOP."
 D ^DIR I "Nn"[X K X,Y,DIRUT Q
 I "Yy"[X S PSXFL=0 D TEXT^PSSMARK H 7 N PSXUDA S (PSXUM,PSXUDA)=DA,PSXLOC=$P(^PSDRUG(DA,0),"^"),PSXGOOD=0,PSXF=0,PSXBT=0 D BLD^PSSMARK,PICK2^PSSMARK S DA=PSXUDA
 Q
ASKCLOZ W !!,"Do you wish to mark/unmark as a LAB MONITOR or CLOZAPINE DRUG? " K DIR S DIR(0)="Y",DIR("?")="If you answer ""yes"", you will have the opportunity to edit LAB MONITOR or CLOZAPINE fields."
 D ^DIR I "Nn"[X K X,Y,DIRUT Q
 I "Yy"[X S NFLAG=0 D MONCLOZ
 Q
MONCLOZ K PSSAST D FLASH W !,"Mark/Unmark for Lab Monitor or Clozapine: " K DIR S DIR(0)="S^L:LAB MONITOR;C:CLOZAPINE;" D ^DIR Q:$D(DIRUT)  S PSSAST=Y(0) D:PSSAST="LAB MONITOR" ^PSSLAB D:PSSAST="CLOZAPINE" CLOZ
 Q
FLASH K LMFLAG,CLFALG,WHICH S WHICH=$P($G(^PSDRUG(DISPDRG,"CLOZ1")),"^"),LMFLAG=0,CLFLAG=0
 I WHICH="PSOCLO1" S CLFLAG=1 W !!,"** This drug is marked for Clozapine."
 I WHICH'="PSOCLO1" S:WHICH'="" LMFLAG=1 W !!,"** This drug is marked for Lab Monitor."
 Q
CLOZ Q:NFLAG  Q:$D(DTOUT)  Q:$D(DIRUT)  Q:$D(DUOUT)  W !,"** You are NOW editing CLOZAPINE fields. **" D ^PSSCLDRG
 Q
USE K PACK S PACK="" S:$P($G(^PSDRUG(DISPDRG,"PSG")),"^",2)]"" PACK="W" I $D(^PSDRUG(DISPDRG,2)) S PACK=PACK_$P(^PSDRUG(DISPDRG,2),"^",3)
 I PACK'="" D
 .W $C(7) N XX W !! F XX=1:1:79 W "*"
 .W !,"This entry is marked for the following PHARMACY packages: "
 .D USE1
 Q
USE1 W:PACK["O" !," Outpatient" W:PACK["U" !," Unit Dose" W:PACK["I" !," IV" W:PACK["W" !," Ward Stock" W:PACK["N" !," Controlled Substances" W:'$D(PACK) !," NONE"
 I PACK'["O",PACK'["U",PACK'["I",PACK'["W",PACK'["D",PACK'["N" W !," NONE"
 Q
WR  I ^XMB("NETNAME")'["CMOP-" W:OLDDF'="" !,"The dosage form has changed from "_OLDDF_" to "_NEWDF_" due to",!,"matching/rematching to NDF.",!,"You will need to rematch to Orderable Item.",!
 Q
PRIMDRG I $D(^PS(59.7,1,20)),$P(^PS(59.7,1,20),"^",1)=4!($P(^PS(59.7,1,20),"^",1)=4.5) I $D(^PSDRUG(DISPDRG,2)) S VAR=$P(^PSDRUG(DISPDRG,2),"^",3) I VAR["U"!(VAR["I") D PRIM1
 Q
PRIM1 W !!,"You need to match this drug to ""PRIMARY DRUG"" file as well.",! S DIE="^PSDRUG(",DR="64",DA=DISPDRG D ^DIE K VAR
 Q
MF I $P($G(^PS(59.7,1,80)),"^",2)>1 I $D(^PSDRUG(DISPDRG,2)) S PSSOR=$P(^PSDRUG(DISPDRG,2),"^",1) I PSSOR]"" D EN^PSSPOIDT(PSSOR),EN2^PSSHL1(PSSOR,"MUP") S ^TMP($J,"BILL",PSSOR_" "_$P(^PS(50.7,PSSOR,0),"^"))=""
 Q
MFA I $P($G(^PS(59.7,1,80)),"^",2)>1 S PSSOR=$P(^PS(52.6,ENTRY,0),"^",11),PSSDD=$P(^PS(52.6,ENTRY,0),"^",2) I PSSOR]"" D EN^PSSPOIDT(PSSOR),EN2^PSSHL1(PSSOR,"MUP") D MFDD I PSSOR]"" S ^TMP($J,"BILL",PSSOR_" "_$P(^PS(50.7,PSSOR,0),"^"))=""
 Q
MFS I $P($G(^PS(59.7,1,80)),"^",2)>1 S PSSOR=$P(^PS(52.7,ENTRY,0),"^",11),PSSDD=$P(^PS(52.7,ENTRY,0),"^",2) I PSSOR]"" D EN^PSSPOIDT(PSSOR),EN2^PSSHL1(PSSOR,"MUP") D MFDD I PSSOR]"" S ^TMP($J,"BILL",PSSOR_" "_$P(^PS(50.7,PSSOR,0),"^"))=""
 Q
MFDD I $D(^PSDRUG(PSSDD,2)) S PSSOR=$P(^PSDRUG(PSSDD,2),"^",1) I PSSOR]"" D EN^PSSPOIDT(PSSOR),EN2^PSSHL1(PSSOR,"MUP") S ^TMP($J,"BILL",PSSOR_" "_$P(^PS(50.7,PSSOR,0),"^"))=""
 Q
OPEI I $D(^PSDRUG(DISPDRG,"ND")),$P(^PSDRUG(DISPDRG,"ND"),"^",10)]"" S DIE="^PSDRUG(",DR="28",DA=DISPDRG D ^DIE
 Q
DEA ;
 I $P($G(^PSDRUG(DISPDRG,3)),"^")=1,($P(^PSDRUG(DISPDRG,0),"^",3)[1!($P(^(0),"^",3)[2)) D DSH
 Q
DSH W !!,"****************************************************************************"
 W !,"This entry contains a ""1"" or a ""2"" in the ""DEA, SPECIAL HDLG""",!,"field, therefore this item has been UNMARKED for CMOP transmission."
 W !,"****************************************************************************",! S $P(^PSDRUG(DISPDRG,3),"^")=0 K ^PSDRUG("AQ",DISPDRG) S DA=DISPDRG N % D ^PSSREF
 Q
