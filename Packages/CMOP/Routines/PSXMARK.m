PSXMARK ;BIR/WRT-review single NDF matches for CMOP ;[ 10/19/98  7:30 AM ]
 ;;2.0;CMOP;**18,19**;11 Apr 97
PICK S U="^" S PSXFL=0 D TEXT F PSXMM=1:1 D PICK1 S:'$D(PSXFL) PSXFL=0 Q:PSXFL
DONE K PSXBT,PSXF,PSXFL,PSXVAP,PSXGOOD,PSXVP,PSXGN,PSXUM,PSXDN,PSXDP,PSXCMOP,PSXLOC,PSXZERO,PSXODE,PSXMM,PSXOU,PSXG,X,Y,PSXIDENT,PSXNDF,PSXVAPN,ONCE,PSXNEXT,PSXLAST,RTC,PSXNOW,PSXID
 Q
TEXT W !!,"This option allows you to choose entries from your drug file and helps you",!,"review your NDF matches and mark individual entries to send to CMOP.",!
 W !,"If you mark the entry to transmit to CMOP, it will replace your Dispense Unit",!,"with the VA Dispense Unit. In addition, you may overwrite the local drug name",!,"with the VA Print Name and the entry will remain uneditable.",!
 Q
DISPLAY W @IOF W !!?3,"Local Drug Generic Name: ",PSXLOC W !!,?16,"ORDER UNIT: "
 I $D(^PSDRUG(PSXUM,660)) S PSXODE=^PSDRUG(PSXUM,660) I $P(PSXODE,"^",2) S PSXOU=$P(PSXODE,"^",2) I $D(^DIC(51.5)),$D(^DIC(51.5,PSXOU)) W ?28,$S('$D(PSXOU):"",1:$P(^DIC(51.5,PSXOU,0),"^",1))
 W !,"DISPENSE UNITS/ORDER UNITS: ",$S('$D(PSXODE):"",1:$P(PSXODE,"^",5)),!,?13,"DISPENSE UNIT: ",$S('$D(PSXODE):"",1:$P(PSXODE,"^",8)),!,"   PRICE PER DISPENSE UNIT: ",$S('$D(PSXODE):"",1:$P(PSXODE,"^",6))
 W !!,"VA Print Name: ",PSXVAP,?50,"VA Dispense Unit: ",PSXDP,!,"VA Drug Class: ",$$DCLCODE^PSNAPIS(PSXGN,PSXVP),?50,"CMOP ID: ",PSXID D CHECK
 Q
CHECK I $D(^PSDRUG("AQ",PSXUM)),$P(^PSDRUG(PSXUM,3),"^",1)=1 D UNMARK
 Q:PSXBT=1  I '$D(^PSDRUG("AQ",PSXUM)) D MARK
 Q
MARK Q:PSXBT=1  W !!,"Do you wish to mark this drug to transmit to CMOP? " K DIR S DIR(0)="Y" D ^DIR D OUT I "Nn^"[X K X,Y,DIRUT S PSXBT=1,PSXF=1 Q:PSXF=1  Q:PSXBT=1
 I "Yy"[X S $P(^PSDRUG(PSXUM,660),"^",8)=PSXDP,^PSDRUG(PSXUM,3)=1,^PSDRUG("AQ",PSXUM)="",DA=PSXUM D ^PSXREF,IDENT K DA D QDM,QUEST,QUES2 S PSXF=1
 Q
UNMARK Q:PSXF=1  W !!,"Do you wish to UNmark this drug to transmit to CMOP? " K DIR S DIR(0)="Y" D ^DIR D OUT I "Nn^"[X K X,Y,DIRUT S PSXF=1 Q
 I "Yy"[X S $P(^PSDRUG(PSXUM,3),"^",1)=0 K ^PSDRUG("AQ",PSXUM) S DA=PSXUM D ^PSXREF K DA S PSXF=1,PSXBT=1 Q:PSXBT=1
 Q
QUES2 W !!,"Do you wish to overwrite your local name? " K DIR S DIR(0)="Y",DIR("?")="If you answer ""yes"", you will overwrite GENERIC NAME with the VA Print Name." D ^DIR D OUT I "Nn^"[X D SYN K X,Y,DIRUT S PSXG=1 Q:PSXG=1
 I "Yy"[X D DUP I '$D(^PSDRUG("B",PSXVAP)) S $P(^PSDRUG(PSXUM,0),"^",1)=PSXVAP D XREF,OLDNM S PSXF=1,PSXG=1
 Q
DUP I PSXVAP'=PSXLOC,$D(^PSDRUG("B",PSXVAP)) W !,"You cannot write over the GENERIC NAME because one already has that",!,"VA Print Name. You cannot have duplicate names.",!
 Q
XREF K:PSXLOC'=PSXVAP ^PSDRUG("B",PSXLOC,PSXUM) S:PSXLOC'=PSXVAP ^PSDRUG("B",PSXVAP,PSXUM)="" I $D(^PSNTRAN(PSXUM,"END")) S $P(^PSNTRAN(PSXUM,"END"),"^",3)=PSXVAP,$P(^PSNTRAN("END"),"^",3)=PSXVAP
 Q
BLD I '$D(^PSDRUG(PSXUM,"I")),$D(^PSDRUG(PSXUM,2)),$P(^PSDRUG(PSXUM,2),"^",3)["O",$P(^PSDRUG(PSXUM,0),"^",3)'["C",$D(^PSDRUG(PSXUM,"ND")),$P(^PSDRUG(PSXUM,"ND"),"^",2)]"" D BLD1
 Q
BLD1 S PSXDN=^PSDRUG(PSXUM,"ND"),PSXGN=$P(PSXDN,"^",1),PSXVP=$P(PSXDN,"^",3)
 S PSXCMOP=$$PROD2^PSNAPIS(PSXGN,PSXVP) I $P($G(PSXCMOP),"^",3)="" W !,"This drug is not marked for CMOP in the National Drug File!" Q
 S PSXVAP=$P(PSXCMOP,"^"),PSXDP=$P(PSXCMOP,"^",4) D GOTIT
 Q
PICK1 S DIC="^PSDRUG(",DIC(0)="QEAM" D ^DIC K DIC I Y<0 S PSXFL=1 Q
 S PSXUM=+Y,PSXLOC=$P(Y,"^",2) S PSXGOOD=0,PSXF=0,PSXBT=0 D BLD W:PSXGOOD=0 !,"This drug cannot be marked."
 Q
GOTIT S PSXID=$P(PSXCMOP,"^",2),PSXGOOD=1,PSXZERO=^PSDRUG(PSXUM,0) D DISPLAY Q:PSXF  Q:PSXBT
 Q
OUT I $D(DTOUT),DTOUT=1 S PSXFL=1
 Q
IDENT S PSXNDF=$P(^PSDRUG(PSXUM,"ND"),"^",1),PSXVAPN=$P(^PSDRUG(PSXUM,"ND"),"^",3)
 S ZX=$$PROD2^PSNAPIS(PSXNDF,PSXVAPN),PSXIDENT=$P($G(ZX),"^",2) I $P($G(ZX),"^",3)="" K ZX W !,"This drug is not marked for CMOP in the National Drug File!" Q 
 S $P(^PSDRUG(PSXUM,"ND"),"^",10)=PSXIDENT,^PSDRUG("AQ1",PSXIDENT,PSXUM)="" K ZX
 Q
QUEST I $D(PSXODE),$P(PSXODE,"^",8)'=PSXDP W !!,"Your old Dispense Unit  ",$P(PSXODE,"^",8),"  does not match the new one  ",PSXDP,".",!,"You may wish to edit the Price Per Order Unit and/or The Dispense",!,"Units Per Order Unit.",! D QUESTA
 Q
QUESTA S DIE="^PSDRUG(",DA=PSXUM,DR="13;15",DIE("NO^")="BACK" D ^DIE K DIE("NO^")
 Q
OLDNM D OLD I $D(ONCE) D OLD1
 Q
OLD D NOW^%DTC I $D(^PSDRUG(PSXUM,900,1,0)) S ONCE=0,PSXLAST=0 F RTC=0:0 S RTC=$O(^PSDRUG(PSXUM,900,RTC)) Q:'RTC  S PSXLAST=PSXLAST+1,PSXNEXT=PSXLAST+1
 I '$D(^PSDRUG(PSXUM,900,1,0)) S ^PSDRUG(PSXUM,900,1,0)=PSXLOC_"^"_X
 Q
OLD1 I ONCE=0 S ^PSDRUG(PSXUM,900,PSXNEXT,0)=PSXLOC_"^"_X,ONCE=1
 Q
SYN S:'$D(^PSDRUG(PSXUM,1,0)) ^PSDRUG(PSXUM,1,0)="^50.1A^0^0" I '$D(^PSDRUG("C",PSXVAP,PSXUM)) S PSXNOW=$P(^PSDRUG(PSXUM,1,0),"^",3)+1,^PSDRUG(PSXUM,1,PSXNOW,0)=PSXVAP,^PSDRUG("C",PSXVAP,PSXUM,PSXNOW)="" D SYN1
 Q
SYN1 S $P(^PSDRUG(PSXUM,1,0),"^",3)=PSXNOW,$P(^PSDRUG(PSXUM,1,0),"^",4)=$P(^PSDRUG(PSXUM,1,0),"^",4)+1
 Q
QDM S DIE="^PSDRUG(",DA=PSXUM,DR=215 D ^DIE
 Q
