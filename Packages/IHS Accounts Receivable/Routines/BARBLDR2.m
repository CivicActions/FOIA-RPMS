BARBLDR2 ; IHS/SD/SDR - LOCKED BATCHES WITH BALANCE REPORT - SUMMARY
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35**;OCT 26, 2005;Build 187
 ;IHS/SD/SDR 1.8*35 ADO77760 New routine
 ;
PRINT ;
 I BARY("RTYP")=4 D PRINT2 Q  ;summary delimited
 S BARGITOT=0
 S BARGBALT=0
 S BAR("PG")=0
 D HDB
 S BARCLPT=0
 F  S BARCLPT=$O(^XTMP("BARBLDR",$J,"S",BARCLPT)) Q:'BARCLPT  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S BARCBCNT=0,BARIBCHT=0,BARIBALT=0
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W !," (cont)"
 .W !!?9,"COLLECTION ID: "_$P($G(^BAR(90051.02,DUZ(2),BARCLPT,0)),U)
 .F  S BARCBDFN=$O(^XTMP("BARBLDR",$J,"S",BARCLPT,BARCBDFN)) Q:'BARCBDFN  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ..S BARCBCNT=BARCBCNT+1
 ..I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W !?9,"COLLECTION ID: "_$P($G(^BAR(90051.02,DUZ(2),BARCLPT,0)),U)_" (cont)"
 ..S BARREC=$G(^XTMP("BARBLDR",$J,"S",BARCLPT,BARCBDFN))
 ..;S BARITMC=$P(BARREC,U)    ;item count
 ..S BARLDT=$$GET1^DIQ(90051.01,BARCBDFN,31,"I") ;batch lockdown date
 ..S BARITMT=$P(BARREC,U,2)  ;item total
 ..S BARITMB=$P(BARREC,U,3)  ;item balance
 ..S BARIBCHT=BARIBCHT+BARITMT
 ..S BARIBALT=BARIBALT+BARITMB
 ..S BARCOL=$P($G(^BARCOL(DUZ(2),BARCBDFN,0)),U)
 ..S BARCOL=$P(BARCOL,"-",($L(BARCOL,"-")-1),($L(BARCOL,"-")))  ;use the last two pieces of batch name delimited with '-'
 ..W !,BARCOL_$S($P(BARREC,U,4)="*":"*",1:"")       ;batch name (w/* means at least part is unallocated)
 ..W ?20,$P($G(^BARCOL(DUZ(2),BARCBDFN,0)),U,28)  ;tdn/ipac
 ..;W ?50,$J(BARITMC,4)
 ..W ?42,BARLDT
 ..W ?56,$J($FN(BARITMT,",",2),10)
 ..W ?69,$J($FN(BARITMB,",",2),10)
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .D SUBTOT
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 D GRANDTOT
 W !!,"An '*' after the batch name means at least part of it is in Unallocated Cash"
 W !!,"<END OF REPORT>"
 D PAZ^BARRUTL
 K ^XTMP("BARBLDR",$J)
 Q
HD ;
 D PAZ^BARRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB ;
 S BAR("PG")=BAR("PG")+1 D WHD
HDR ;
 I BARY("RTYP")=4 W !,"COLLECTION ID^LOCATION^ALLOWANCE CATEGORY^COLLECTION BATCH NAME^TDN/IPAC^LOCK DATE^TOTAL ITEM^TOTAL BATCHED^BALANCE" Q
 W !?46,"LOCK",?60,"TOTAL"
 W !,"COLLECTION BATCH NAME",?25,"TDN/IPAC",?46,"DATE",?59,"BATCHED",?71,"BALANCE"
 W !
 F BARI=1:1:80 W "="
 Q
WHD ;EP for writing Report Header
 W $$EN^BARVDF("IOF"),!   ;not a delimited file
 K BAR("LINE")
 S $P(BAR("LINE"),"=",$S($D(BAR(133)):132,$D(BAR(180)):181,1:80))=""
 W BAR("LINE"),!
 I $G(BARTEXT)'=1 W BAR("HD",0),?$S($D(BAR(132)):102,$D(BAR(180)):150,1:51)
 I $G(BARTEXT)=1 W BAR("HD",0),"^^^^"
 D NOW^%DTC
 S Y=%
 X ^DD("DD")
 W $P(Y,":",1,2),"   Page ",BAR("PG")
 I $G(BARTEXT)=1 W "^"
 S BAR("TMPLVL")=0
 F  S BAR("TMPLVL")=$O(BAR("HD",BAR("TMPLVL"))) Q:'BAR("TMPLVL")&(BAR("TMPLVL")'=0)  W:$G(BAR("HD",BAR("TMPLVL")))]"" !,BAR("HD",BAR("TMPLVL"))
 W !,BAR("LINE")
 K BAR("LINE")
 Q
SUBTOT ;
 W !?56,"----------",?69,"----------"
 W !?15,BARCBCNT_" BATCHES",?56,$J($FN(BARIBCHT,",",2),10),?69,$J($FN(BARIBALT,",",2),10)
 S BARGITOT=BARGITOT+BARIBCHT
 S BARGBALT=BARGBALT+BARIBALT
 Q
GRANDTOT ;
 W !?56,"==========",?69,"=========="
 W !?15,"TOTAL",?56,$J($FN(BARGITOT,",",2),10),?69,$J($FN(BARGBALT,",",2),10)
 Q
PRINT2 ;
 S BAR("PG")=0
 D HDB
 S BARCLPT=0
 F  S BARCLPT=$O(^XTMP("BARBLDR",$J,"S",BARCLPT)) Q:'BARCLPT  D
 .F  S BARCBDFN=$O(^XTMP("BARBLDR",$J,"S",BARCLPT,BARCBDFN)) Q:'BARCBDFN  D
 ..I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D HDR W " (cont)"
 ..S BARREC=$G(^XTMP("BARBLDR",$J,"S",BARCLPT,BARCBDFN))
 ..;
 ..S BARITMC=$P(BARREC,U)    ;item count
 ..S BARITMT=$P(BARREC,U,2)  ;item total
 ..S BARITMB=$P(BARREC,U,3)  ;item balance
 ..W !,$P($G(^BAR(90051.02,DUZ(2),BARCLPT,0)),U)  ;collection point
 ..W U_$P($G(^DIC(4,$P($G(^BARCOL(DUZ(2),BARCBDFN,0)),U,8),0)),U)  ;site location name
 ..W U_$$GET1^DIQ(90051.02,BARCLPT,7,"E")  ;allowance category
 ..W U_$P($G(^BARCOL(DUZ(2),BARCBDFN,0)),U)_$S($P(BARREC,U,4)="*":"*",1:"")       ;batch name (w/* if part is unallocated)
 ..W U_$P($G(^BARCOL(DUZ(2),BARCBDFN,0)),U,28)  ;tdn/ipac
 ..W U_$$GET1^DIQ(90051.01,BARCBDFN,31,"I")  ;batch lockdown date
 ..W U_BARITMC  ;item count
 ..W U_BARITMT  ;total batches
 ..W U_BARITMB   ;balance
 W !!,"An '*' after the batch name means at least part of it is in Unallocated Cash"
 W !!,"<END OF REPORT>"
 K ^XTMP("BARBLDR",$J)
 Q
