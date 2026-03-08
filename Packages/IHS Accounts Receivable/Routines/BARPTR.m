BARPTR ; IHS/SD/LSL - TRANSACTION LISTER AND SELECTOR ; 09/12/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,7,20,23,39**;OCT 26, 2005;Build 231
 ;
 ;** transaction lister and selecter
 ;** pass an array that will be used as the display list
 ;** returns the ien of the selected transaction
 ;
 ;IHS/SD/SDR 1.8*6 DD 4.2.1 Updated display to include Trans Dt, Allow.cat, TDN, and status
 ;IHS/SD/SDR 1.8*20 HEAT27205 Display <L> on locked batches
 ;IHS/SD/POT MAR 2013 HEAT77761 ADDED TRANSACTION # TO ERROR MESSAGE
 ;IHS/SD/POT MAR 2013 ADDED NEW VA billing
 ;IHS/SD/SDR 1.8*39 ADO111585 Add option to print PUC listing; Rearranged display and included chk#
 Q
 ;--------------------------------------------------------------
EN(BAR)         ; EP
 ; list details of transactions
 N BARTX,BARTR,BARCNT
 ;start old bar*1.8*39 IHS/SD/SDR ADO111585
 ;D TOP
 ;S DIC=90050.03
 ;S DR=".01;2;3;6;14;15;17"
 ;S (BARTR,BARCNT)=0
 ;F BARC=1:1 S BARTR=$O(^TMP($J,"BARVL",BARTR)) Q:'BARTR  D  Q:$G(BARQUIT)
 ;.D ENP^XBDIQ1(DIC,BARTR,DR,"BARTX(","0I")
 ;.S BARCNT=BARCNT+1
 ;.W !,BARCNT_"."
 ;.W ?3,$J(BARTX(2),8,2)
 ;.W:'$$CKDATE^BARPST($P(^BARTR(DUZ(2),BARTR,0),U,14),0,"COLLECTION") "<L>"
 ;.W ?15,$E(BARTX(6),1,30),?47,BARTX(14)
 ;.W ?76,BARTX(15)  ;coll. item
 ;.S D0=BARTX(6,"I")
 ;.I D0']"" D  Q    ;
 ;..W !,"** ERROR--MISSING ALLOCATION INFO IN TRANSACTION # "_BARTR ;P.OTT
 ;..D EOP^BARUTL(1)
 ;.S BARALLC=$$VALI^BARVPM(8) ;STRING
 ;.W !?13,BARTX(.01),?37,$S(BARALLC'="":$P($T(@BARALLC),";;",2),1:"<NO ALLOW CAT>")
 ;.W ?51
 ;.W $S($G(BARTX(17))'="":BARTX(17),$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",20,"E")'="":$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",20,"E"),1:"<NO TDN>")
 ;.W ?73,$S($O(^BAR(90052,"D",BARTX(14),0))'="":"LETTER",1:"")
 ;.S ^TMP($J,"BARVL","B",BARCNT,BARTR)=BARTX(6)_U_BARTX(6,"I")
 ;.K BARTX
 ;.I '(BARC#10) D
 ;..K DIR
 ;..S DIR(0)="EO"
 ;..D ^DIR
 ;..K DIR
 ;..I X["^" S BARQUIT=1
 ;.Q
 ;end old bar*1.8*39 IHS/SD/SDR ADO111585
 D WRITE  ;bar*1.8*39 IHS/SD/SDR ADO111585
 K BARQUIT,BARC
 W !!
 I 'BARCNT W *7,"No transactions found!",!! D EOP^BARUTL(1) Q 0
 ;start new bar*1.8*39 IHS/SD/SDR ADO111585
 D ^XBFMK
 S DIR(0)="Y"
 S DIR("A")="Would you like to print this list? (Y/N)"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT) Q 0
 I Y=1 D  ;print list
 .S %ZIS="NQ"
 .S %ZIS("A")="Print to Device: "
 .D ^%ZIS
 .Q:POP
 .I IO'=IO(0) D QUE,HOME^%ZIS Q
 .E  D
 ..S IOP=ION
 ..D ^%ZIS
 ..D ^XBFMK
 .D WRITE  ;display list again to choose from
 .U 0
 W !!
 ;end new bar*1.8*39 IHS/SD/SDR ADO111585
 D ^XBFMK
 S DIR(0)="NO^1:"_BARCNT
 D ^DIR
 I $D(DUOUT)!('Y) Q 0
 S BARANS=+Y  ;bar*1.8*39 IHS/SD/SDR ADO111585
 S BARTR=$O(^TMP($J,"BARVL","B",Y,""))
 I BARTR="" W !,"No transactions found! (2)",!! D EOP^BARUTL(1) Q 0 ;P.OTT 77761
 I '$$CKDATE^BARPST($P(^BARTR(DUZ(2),BARTR,0),U,14),1,"SELECT COLLECTION BATCH") Q 0   ;DISALLOW OLD BATCHES; MRS:BAR*1.8*6 DD 4.2.4
 Q BARTR
 ; *********************************************************************
 ;
TOP ; EP
 N J
 D HOME^%ZIS
 ;start old bar*1.8*39 IHS/SD/SDR ADO111585
 ;I $L($G(^TMP($J,"BARVL","HEAD"))) DO
 ;.W $$EN^BARVDF("IOF"),!
 ;.S X=$S($L($G(^TMP($J,"BARVL","HEAD"))):^TMP($J,"BARVL","HEAD"),1:"Transaction List")
 ;.W ?IOM-$L(X)\2,X
 ;.W !?IOM-$L(X)\2
 ;.F J=1:1:$L(X) W "-"
 ;W !!,"#",?5,"Credit",?15,"Account",?47,"Batch",?76,"Item"
 ;W !?13,"TRANS DATE",?37,"ALLOW CAT",?51,"TDN",?73,"STATUS"
 ;end old bar*1.8*39 IHS/SD/SDR ADO111585
 ;start new bar*1.8*39 IHS/SD/SDR ADO111585
 W $$EN^BARVDF("IOF")
 W !,"Post Unallocated Transaction List"
 I $G(BARDEV) D NOW^%DTC W ?55,$$CDT^BARDUTL(%),"  Page ",BARPG
 ;end new bar*1.8*39 IHS/SD/SDR ADO111585
 W !!,"#",?5,"Credit",?15,"Account",?42,"Check#",?75,"Item"
 W !?3,"TRANS DATE",?27,"Batch",?58,"TDN",?73,"STATUS"
 W !
 S BARDSH=""
 S $P(BARDSH,"-",80)="" W BARDSH
 ;W !  IHS/SD/SDR bar*1.8*6 DD 4.2.1
 Q  ;********************************************************************
 ;THIS TABLE REPLICATES ^AUTTINTY INSURER TYPE (21 ENTRIES) P.OTT 4/12/2013
 ;AND MAPS INSURER TYPE CODE TO CATEGORY (IE: W --> OTHER)
H ;;PRIVATE INSURANCE;;HMO
M ;;PRIVATE INSURANCE;;MEDICARE SUPPL.
D ;;MEDICAID;;MEDICAID FI
R ;;MEDICARE;;MEDICARE FI
P ;;PRIVATE INSURANCE;;PRIVATE INSURANCE
W ;;OTHER;;WORKMEN'S COMP
C ;;OTHER;;CHAMPUS
N ;;OTHER;;NON-BENEFICIARY (NON-INDIAN)
I ;;OTHER;;INDIAN PATIENT
K ;;MEDICAID;;CHIP (KIDSCARE)
T ;;OTHER;;THIRD PARTY LIABILITY 
G ;;OTHER;;GUARANTOR
MD ;;MEDICARE;;MCR PART D
MH ;;MEDICARE;;MEDICARE HMO
MMC ;;MEDICARE;;MCR MANAGED CARE
TSI ;;OTHER;;TRIBAL SELF INSURED
SEP ;;OTHER;;STATE EXCHANGE PLAN
FPL ;;MEDICAID;;FPL 133 PERCENT
MC ;;MEDICARE;;MCR PART C
F ;;PRIVATE INSURANCE;;FRATERNAL ORGANIZATION
V ;;VETERAN;;VETERANS MEDICAL BENEFITS
  ;;***END OF TABLE**
 ;start new bar*1.8*39 IHS/SD/SDR ADO111585
WRITE ;
 D TOP
 S DIC=90050.03
 S DR=".01;2;3;6;14;15;17"
 S (BARTR,BARCNT)=0
 F BARC=1:1 S BARTR=$O(^TMP($J,"BARVL",BARTR)) Q:'BARTR  D  Q:$G(BARQUIT)
 .K BARTX
 .D ENP^XBDIQ1(DIC,BARTR,DR,"BARTX(","0I")
 .S BARCNT=BARCNT+1
 .W !,BARCNT_"."
 .W ?3,$J(BARTX(2),8,2)  ;Credit
 .W:'$$CKDATE^BARPST($P(^BARTR(DUZ(2),BARTR,0),U,14),0,"COLLECTION") "LTR"
 .W ?15,$E(BARTX(6),1,25)  ;A/R Acct
 .W ?42,$P($G(^BARCOL(DUZ(2),BARTX(14,"I"),1,BARTX(15,"I"),8)),U)  ;check#
 .W ?77,BARTX(15)  ;item
 .S D0=BARTX(6,"I")
 .I D0']"" D  Q
 ..W !,"** ERROR--MISSING ALLOCATION INFO IN TRANSACTION # "_BARTR
 ..D EOP^BARUTL(1)
 .;
 .W !,BARTX(.01)  ;TRDFN
 .W ?27,BARTX(14)  ;batch
 .;TDN
 .W ?58
 .W $S($G(BARTX(17))'="":BARTX(17),$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",20,"E")'="":$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",20,"E"),1:"<NO TDN>")
 .;
 .W ?76,$S($O(^BAR(90052,"D",BARTX(14),0))'="":"LTR",1:"")
 .S ^TMP($J,"BARVL","B",BARCNT,BARTR)=BARTX(6)_U_BARTX(6,"I")
 .K BARTX
 .I '(BARC#10) D
 ..K DIR
 ..S DIR(0)="EO"
 ..D ^DIR
 ..K DIR
 ..I X["^" S BARQUIT=1
 Q
WRITE2 ;
 K BARVL
 K BARTX
 S BARDEV=1,BARPG=1
 S (BARCNT,BARTX)=0
 S BARTT=$O(^BARTBL("B","UN-ALLOCATED",""))
 F  S BARTX=$O(^BARTR(DUZ(2),"AGL","O",BARTX)) Q:'BARTX  D
 .Q:$$GET1^DIQ(90050.03,BARTX,101,"I")'=BARTT
 .Q:'$$CKDATE^BARPST($P(^BARTR(DUZ(2),BARTX,0),U,14),0,"COLLECTION")
 .S ^TMP($J,"BARVL",BARTX)=""
 ;
 D TOP
 S DIC=90050.03
 S DR=".01;2;3;6;14;15;17"
 S (BARTR,BARCNT)=0
 F BARC=1:1 S BARTR=$O(^TMP($J,"BARVL",BARTR)) Q:'BARTR  D  Q:$G(BARQUIT)
 .I ($Y+5>IOSL) S BARPG=BARPG+1 D TOP W !,"(Cont.)",!
 .D ENP^XBDIQ1(DIC,BARTR,DR,"BARTX(","0I")
 .S BARCNT=BARCNT+1
 .;
 .W !,BARCNT_"."
 .W ?3,$J(BARTX(2),8,2)  ;Credit
 .W ?15,$E(BARTX(6),1,25)  ;A/R Acct
 .W ?42,$P($G(^BARCOL(DUZ(2),BARTX(14,"I"),1,BARTX(15,"I"),8)),U)  ;check#
 .W ?76,BARTX(15)  ;item
 .;
 .W !,BARTX(.01)  ;TRDFN
 .W ?27,BARTX(14)  ;batch
 .;TDN
 .W ?58
 .W $S($G(BARTX(17))'="":BARTX(17),$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",20,"E")'="":$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",20,"E"),1:"<NO TDN>")
 .W ?76,$S($O(^BAR(90052,"D",BARTX(14),0))'="":"LTR",1:"")
 .S ^TMP($J,"BARVL","B",BARCNT,BARTR)=BARTX(6)_U_BARTX(6,"I")
 .K BARTX
 ;
 K BARDEV
 W !!,"E N D  O F  R E P O R T"
 Q
QUE ;QUE
 S ZTSAVE(BARTR)=""
 S ZTRTN="WRITE2^BARPTR"
 S ZTDESC="PUC Listing"
 K ZTSK
 D ^%ZTLOAD
 W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 Q
 ;end new bar*1.8*39 IHS/SD/SDR ADO111585
