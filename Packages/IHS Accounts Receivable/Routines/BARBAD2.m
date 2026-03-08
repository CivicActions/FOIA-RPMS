BARBAD2 ; IHS/SD/LSL - PAYMENT PATIENT SELECTION JAN 15,1997 ; 05/07/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,14,19,30,31,35**;OCT 26, 2005;Build 187
 ;
 ;** patient a/r lookup based on from/thru dos
 ;** called from ^BARBAD
 ;** BARPASS = PATDFN^BEGDOS^ENDDOS
 ;** builds an array that includes all entries from a/r that meet the
 ;   criteria.
 ;    - If Bill was 'CLOSED' then not displayed - not found in 3P system
 ;    - If Bill was 'CANCELED' and current amount due is 0 - not displayes, already worked
 ;IHS/SD/CPC 1.8*30 CR9409 20200518
 ;IHS.OIT.FCJ 1.8*31 11.4.2020 CR#6156 MODIFIED TO SORT/DISPLAY BY CLINIC OR VISIT
 ;IHS/SD/SDR 1.8*35 ADO60910 Updated to display PPN preferred name
 ;
 ; *********************************************************************
 ;
EN(BARPASS)        ; EP
 ; Pat/BIll lookup
 N DIC,DIQ,DR,BARBLV,BARDT,BARPAT,BARBEG,BAREND,BARHIT,BARCNT
 K ^BARTMP($J)
 Q:+BARPASS=0
 S BARPAT=+BARPASS
 S BARBEG=$P(BARPASS,U,2)
 S BAREND=$P(BARPASS,U,3)
 S X1=BARBEG
 S X2=-1
 D C^%DTC
 S BARDT=X
 S DIC="^BARBL(DUZ(2),"
 ;S DR=".01;3;13;15;16"  ;BAR*1.8*31 11.4.2020 IHS.OIT.FCJ CR#6156
 S DR=".01;3;13;15;16;112;114"  ;BAR*1.8*31 11.4.2020 IHS.OIT.FCJ CR#6156
 S DIQ="BARBLV("
 S BARCNT=0
 F  S BARDT=$O(^BARBL(DUZ(2),"ABC",BARPAT,BARDT)) Q:'BARDT!(BARDT>BAREND)  D
 .;S BARBDA=0  ;BAR*1.8*31 IHS.OIT.FCJ CR#6156
 .S BARBDA=0,BARSRT2=""  ;BAR*1.8*31 IHS.OIT.FCJ CR#6156 ADDED BARSRT2
 .F  S BARBDA=$O(^BARBL(DUZ(2),"ABC",BARPAT,BARDT,BARBDA)) Q:'BARBDA  D
 ..S DA=BARBDA
 ..D EN^XBDIQ1
 ..;BAR*1.8*31 11.4.2020 IHS.OIT.FCJ CR#6156 START OF CHANGE
 ..;S BARCNT=BARCNT+1
 ..;I BARBLV(16)'="CLOSED" D
 ..;.S ^BARTMP($J,BARBDA,BARCNT)=BARDT_U_BARBLV(.01)_U_BARBLV(13)_U_BARBLV(3)_U_BARBLV(15)_U_U_U_BARBLV(16)
 ..;.S ^BARTMP($J,"B",BARCNT,BARBDA)=""
 ..;I (BARBLV(16)="3P CANCELLED")&(BARBLV(15)=0) D
 ..;.K ^BARTMP($J,BARBDA,BARCNT)
 ..;.K ^BARTMP($J,"B",BARCNT,BARBDA)
 ..;.S BARCNT=BARCNT-1
 ..;I BARBLV(16)="CLOSED" S BARCNT=BARCNT-1
 ..I (BARBLV(16)'="CLOSED") D
 ...Q:(BARBLV(16)="3P CANCELLED")&(BARBLV(15)=0)
 ...I $D(BARSRT) D  Q
 ....I BARSRT="V",$D(BARSRT("V",BARBLV(114))) S BARSRT2=$P(BARSRT("V",BARBLV(114)),U,2) D SET Q
 ....I BARSRT="C",$D(BARSRT("C",BARBLV(112))) S BARSRT2=$P(BARSRT("C",BARBLV(112)),U,2) D SET Q
 ...D SET
 ..K BARBLV
 Q BARCNT
 ;************************************************
SET ;SET ARRAY IF BILL FOUND
 S BARCNT=BARCNT+1
 S ^BARTMP($J,BARBDA,BARCNT)=BARDT_U_BARBLV(.01)_U_BARBLV(13)_U_BARBLV(3)_U_BARBLV(15)_U_U_U_BARBLV(16)_U_BARSRT2
 S ^BARTMP($J,"B",BARCNT,BARBDA)=""
 Q
 ;BAR*1.8*31 11.4.2020 IHS.OIT.FCJ CR#6156 END OF CHANGE
 ;
HIT(BARPASS) ; EP
 ; ** display a/r bills found
 N BARBDA,BARLIN,BARREC,BARBLO
 S (BARBDA,BARPG,BARSTOP,BARLIN)=0
 D HEAD
 ;BAR*1.8*30 CR9409 IHS/SD/CPC - 20200518  START
 ;F  S BARBDA=$O(^BARTMP($J,BARBDA)) Q:'BARBDA  D  Q:BARSTOP
 ;.S BARLIN=$O(^BARTMP($J,BARBDA,""))
 F  S BARLIN=$O(^BARTMP($J,"B",BARLIN)) Q:'BARLIN  D  Q:BARSTOP
 .S BARBDA=0
 .S BARBDA=$O(^BARTMP($J,"B",BARLIN,BARBDA))
 .S BARREC=^BARTMP($J,BARBDA,BARLIN)
 .S BARBLO=$P(BARREC,U,2)
 .;I $D(^BARTR(DUZ(2),"AM4",+BARBLO)) S BARBLO="m"_BARBLO
 .I $D(^BARTR(DUZ(2),"AM4",+BARBDA)) S BARBLO="m"_BARBLO
 .S BARSTOP=$$CHKLINE(0)
 .Q:BARSTOP
 .S BARCMSG="      "
 .S:$P(BARREC,U,8)="3P CANCELLED" BARCMSG="3P CAN"
 .;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .S BARTPB=$$FIND3PB^BARUTL(DUZ(2),BARBDA)
 .S:$G(BARTPB)'="" BARSTAT=$P($G(^ABMDBILL($P(BARTPB,","),$P(BARTPB,",",2),0)),U,4)
 .;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .;W !,$J(BARLIN,3)
 .;W ?6,$$SDT^BARDUTL($P(BARREC,U,1))
 .;W ?18,BARBLO,?25,BARCMSG  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .;W ?18,BARBLO_$S($G(BARSTAT)="X":"*",1:""),?25,BARCMSG  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .;W ?32,$J($P(BARREC,U,3),8,2)
 .;W ?44,$E($P(BARREC,U,4),1,23)
 .;W ?70,$J($P(BARREC,U,5),8,2)
 .;S:'$G(BARJ) BARJ=1
 .;W:$P($G(BARTR(BARLIN,BARJ)),U,5)="V" ?70,$J($P(BARREC,U,5)+$P(BARREC,U,4),8,2)
 .;W:$P($G(BARTR(BARLIN,BARJ)),U,5)="S" ?70,$J($P(BARREC,U,5)-$P(BARREC,U,4),8,2)
 .;W:'$D(BARTR(BARLIN,BARJ)) ?70,$J($P(BARREC,U,5),8,2)
 .;
 .W !,$J(BARLIN,3)
 .W ?5,$$SHDT^BARDUTL($P(BARREC,U,1))
 .I $L(BARBLO_$S($G(BARSTAT)="X":"*",1:""))>20 W ?14,BARBLO_$S($G(BARSTAT)="X":"*",1:""),!
 .E  W ?14,BARBLO_$S($G(BARSTAT)="X":"*",1:"")
 .W ?36,$J($P(BARREC,U,3),8,2)
 .W ?46,$E($P(BARREC,U,4),1,23)
 .S:'$G(BARJ) BARJ=1
 .W:$P($G(BARTR(BARLIN,BARJ)),U,5)="V" ?70,$J($P(BARREC,U,5)+$P(BARREC,U,4),8,2)
 .W:$P($G(BARTR(BARLIN,BARJ)),U,5)="S" ?70,$J($P(BARREC,U,5)-$P(BARREC,U,4),8,2)
 .W:'$D(BARTR(BARLIN,BARJ)) ?70,$J($P(BARREC,U,5),8,2)
 ;
EXIT ;
 Q
 ;************************************************
 ;
HEAD ;
 W $$EN^BARVDF("IOF"),!
 N BARPTNAM
 S BARPG=BARPG+1
 S BARPTNAM=$P(^DPT(+BARPASS,0),U,1)
 I $D(^BARTR(DUZ(2),"AM5",+BARPASS)) S BARPTNAM="(msg) "_BARPTNAM
 ;W "Claims for "_BARPTNAM_"  from "_$$SDT^BARDUTL($P(BARPASS,U,2))_" to "_$$SDT^BARDUTL($P(BARPASS,U,3))  ;bar*1.8*35 IHS/SD/SDR ADO60910
 ;W ?(IOM-15),"Page: "_BARPG,!!  ;bar*1.8*35 IHS/SD/SDR ADO60910
 ;start new bar*1.8*35 IHS/SD/SDR ADO60910
 W "Claims for "_BARPTNAM
 I $$GETPREF^AUPNSOGI(+BARPASS,"I",1)'="" W " - "_$$GETPREF^AUPNSOGI(+BARPASS,"I",1)_"*" W ?(IOM-15),"Page: "_BARPG
 E  W ?(IOM-15),"Page: "_BARPG
 W !,"  from "_$$SDT^BARDUTL($P(BARPASS,U,2))_" to "_$$SDT^BARDUTL($P(BARPASS,U,3))
 W !!
 ;end new bar*1.8*35 IHS/SD/SDR ADO60910
 ;D SUBHD(.BARCOL,.BARITM,BARPMT)           ;BAR*1.8*4 DD 4.1.7.2
 D SUBHD(.BARCOL,.BARITM,$G(BARPMT))        ;BAR*1.8*4 DD 4.1.7.2
 W !!?38,"Billed",?71,"Current"
 W !,"LN#",?5,"DOS",?14,"Claim #",?38,"Amount",?46,"Billed To",?71,"Balance"
 S BARDSH=""
 S $P(BARDSH,"-",IOM)=""
 W !,BARDSH
 ;
EHEAD ;
 Q
 ;***************************************************
 ;
 ;changes needed for the Collection Batch DD update (triggers)
SUBHD(BARCOL,BARITM,BARPMT) ; EP
 Q:'$D(BARCOL)    ;BAR*1.8*4 DD 4.1.7.2
 ;** display batch and item headers
 K BARCLV,BARITV,BAREOV
 N DA,DIC,DIQ,DR
 S DIC=90051.01
 S DIQ="BARCLV("
 S DR=".01;15:18;21"
 S DA=+BARCOL
 D EN^XBDIQ1
 ;
 S DIC=90051.1101
 S DIQ="BARITV("
 S DR=".01;18;19;101;103;105"
 S DA=+BARITM
 S DA(1)=+BARCOL
 D EN^XBDIQ1
 ;
 I +$G(BAREOB) D
 .S DIC=90051.1101601
 .S DIQ="BAREOV("
 .S DR=".01;2;3;4;5"
 .S DA=+BAREOB
 .S DA(2)=+BARCOL
 .S DA(1)=+BARITM
 .D EN^XBDIQ1
 ;
 W "Batch  : "_$E($P(BARCLV(.01),"-",1),1,19)
 W ?27,"Item   : "_BARITV(.01)
 I +$G(BAREOB) W ?50,"Location: "_BAREOV(.01)
 W !,"Amount : "_$J(BARCLV(15),8,2)
 ; changes needed for the Collection Batch DD update (triggers)
 W ?27,"Amount : "_$J(BARITV(101),8,2)
 I +$G(BAREOB) W ?50,"  Amount : "_$J(BAREOV(2),8,2)
 W !,"Posted : "_$J(BARCLV(16)+BARPMT,8,2)
 ; changes needed for the Collection Batch DD update (triggers)
 W ?27,"Posted : "_$J(BARITV(18)+BARPMT,8,2)
 I +$G(BAREOB) W ?50,"  Posted : "_$J(BAREOV(3)+BARPMT,8,2)
 W !,"Unalloc: "_$J(BARCLV(21),8,2)
 W ?27,"Unalloc: "_$J(BARITV(105),8,2)
 I +$G(BAREOB) W ?50,"  Unalloc: "_$J(BAREOV(5),8,2)
 W !
 ;
B1 ;
 W "Balance: "_$J(BARCLV(17)-BARPMT,8,2)
 W ?27,"Balance: "_$J(BARITV(19)-BARPMT,8,2)
 ;
B2 ;
 I +$G(BAREOB) W ?50,"  Balance: "_$J(BAREOV(4)-BARPMT,8,2)
 Q
 ;**************************************************
 ;
HIT1(BARPASS) ; EP
 ;** display a/r bills found
 N BARHIT,BARLIN,BARREC,BARBLO
 S (BARTPAY,BARTADJ,BARHIT,BARPG,BARSTOP,BARLIN)=0
 D HEAD1
 ;F  S BARHIT=$O(^BARTMP($J,BARHIT)) Q:'BARHIT  DO  Q:BARSTOP
 ;.S BARLIN=$O(^BARTMP($J,BARHIT,""))
 F  S BARLIN=$O(^BARTMP($J,"B",BARLIN)) Q:'BARLIN  D  Q:BARSTOP
 .S BARHIT=0
 .S BARHIT=$O(^BARTMP($J,"B",BARLIN,BARHIT))
 .S BARREC=^BARTMP($J,BARHIT,BARLIN)
 .;S BARBLO=$P(BARREC,U,2) I $D(^BARTR(DUZ(2),"AM4",+BARBLO)) S BARBLO="m"_BARBLO
 .S BARBLO=$P(BARREC,U,2) I $D(^BARTR(DUZ(2),"AM4",+BARHIT)) S BARBLO="m"_BARBLO
 .S BARTPAY=BARTPAY+$P(BARREC,U,6)
 .S BARTADJ=BARTADJ+$P(BARREC,U,7)
 .S BARSTOP=$$CHKLINE(1) Q:BARSTOP
 .S BARCMSG="      "
 .S:$P(BARREC,U,8)="3P CANCELLED" BARCMSG="3P CAN"
 .;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .S BARTPB=$$FIND3PB^BARUTL(DUZ(2),BARHIT)
 .S:$G(BARTPB)'="" BARSTAT=$P($G(^ABMDBILL($P(BARTPB,","),$P(BARTPB,",",2),0)),U,4)
 .;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .;W !,$J(BARLIN,3),?6,$$SDT^BARDUTL($P(BARREC,U,1)),?18,BARBLO
 .;W:($G(BARSTAT)="X") "*"  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .;W ?25,BARCMSG
 .;W ?32,$J($P(BARREC,U,3),8,2)
 .;W ?49,$J($P(BARREC,U,6),8,2)
 .;S:'$G(BARJ) BARJ=1
 .;S:(($G(BARJ)>1)&'$G(BARTR(BARLIN,$G(BARJ)))) BARJ=1
 .;I $D(BARTR(BARLIN,BARJ)) D
 .;.W ?60,$J($P($G(BARTR(BARLIN,BARJ)),U,2),8,2)
 .;.W:$P($G(BARTR(BARLIN,BARJ)),U,5)="V" ?71,$J($P($G(BARTR(BARLIN,BARJ)),U,6)+$P($G(BARTR(BARLIN,BARJ)),U,2),8,2)
 .;.W:$P($G(BARTR(BARLIN,BARJ)),U,5)="S" ?71,$J($P($G(BARTR(BARLIN,BARJ)),U,6)-$P($G(BARTR(BARLIN,BARJ)),U,2),8,2)
 .;.W:'$D(BARTR(BARLIN,BARJ)) ?71,$J($P($G(BARTR(BARLIN,BARJ)),U,6),8,2)
 .;W:'$D(BARTR(BARLIN,BARJ)) ?60,"0.00"
 .;W:'$D(BARTR(BARLIN,BARJ)) ?71,$J($P(BARREC,U,5),8,2)
 .W !,$J(BARLIN,3)
 .;BAR*1.8*31 10.29.2020 IHS.OIT.FCJ CR#6156 START OF CHANGE REFORMAT
 .W ?4,$$SHDT^BARDUTL($P(BARREC,U,1))
 .I $L(BARBLO_$S($G(BARSTAT)="X":"*",1:""))>20 W ?14,BARBLO_$S($G(BARSTAT)="X":"*",1:""),!
 .E  W ?14,BARBLO_$S($G(BARSTAT)="X":"*",1:"")
 .W:$D(BARSRT) ?34,$J($P(BARREC,U,9),3)    ;new line BAR*1.8*31 10.29.2020 IHS.OIT.FCJ CR#6156
 .W ?38,$J($P(BARREC,U,3),8,2)
 .W ?49,$J($P(BARREC,U,6),8,2)
 .;BAR*1.8*31 10.29.2020 IHS.OIT.FCJ CR#6156 START OF CHANGE REFORMAT
 .S:'$G(BARJ) BARJ=1
 .S:(($G(BARJ)>1)&'$G(BARTR(BARLIN,$G(BARJ)))) BARJ=1
 .I $D(BARTR(BARLIN,BARJ)) D
 ..W ?59,$J($P($G(BARTR(BARLIN,BARJ)),U,2),8,2)
 ..W:$P($G(BARTR(BARLIN,BARJ)),U,5)="V" ?70,$J($P($G(BARTR(BARLIN,BARJ)),U,6)+$P($G(BARTR(BARLIN,BARJ)),U,2),8,2)
 ..W:$P($G(BARTR(BARLIN,BARJ)),U,5)="S" ?70,$J($P($G(BARTR(BARLIN,BARJ)),U,6)-$P($G(BARTR(BARLIN,BARJ)),U,2),8,2)
 ..W:'$D(BARTR(BARLIN,BARJ)) ?70,$J($P($G(BARTR(BARLIN,BARJ)),U,6),8,2)
 .W:'$D(BARTR(BARLIN,BARJ)) ?59,$J(0,8,2)
 .W:'$D(BARTR(BARLIN,BARJ)) ?70,$J($P(BARREC,U,5),8,2)
 Q
 ;*****************************************************
 ;
HEAD1 ;
 W $$EN^BARVDF("IOF"),!
 N BARPTNAM
 S BARPG=BARPG+1
 S BARPTNAM=$P(^DPT(+BARPASS,0),U,1)
 I $D(^BARTR(DUZ(2),"AM5",+BARPASS)) S BARPTNAM="(msg) "_BARPTNAM
 ;W "Claims for "_BARPTNAM_"  from "_$$SDT^BARDUTL($P(BARPASS,U,2))_" to "_$$SDT^BARDUTL($P(BARPASS,U,3))  ;bar*1.8*35 IHS/SD/SDR ADO60910
 ;W ?(IOM-15),"Page: "_BARPG,!!  ;bar*1.8*35 IHS/SD/SDR ADO60910
 ;start new bar*1.8*35 IHS/SD/SDR ADO60910
 W "Claims for "_BARPTNAM
 I $$GETPREF^AUPNSOGI(+BARPASS,"I",1)'="" W " - "_$$GETPREF^AUPNSOGI(+BARPASS,"I",1)_"*" W ?(IOM-15),"Page: "_BARPG
 E  W ?(IOM-15),"Page: "_BARPG
 W !,"  from "_$$SDT^BARDUTL($P(BARPASS,U,2))_" to "_$$SDT^BARDUTL($P(BARPASS,U,3))
 W !!
 ;end new bar*1.8*35 IHS/SD/SDR ADO60910
 D SUBHD^BARBAD2(.BARCOL,.BARITM,$G(BARPMT))
 ;BAR*1.8*31 10.29.2020 IHS.OIT.FCJ CR#6156 START OF CHANGE REFORMAT HEADER
 ;W !!?37,"Billed",?48,"Current",?60,"Current",?71,"Current"
 ;W !,"LN#",?5,"DOS",?14,"Claim #",?37,"Amount",?47,"Payments",?61,"Adjust",?71,"Balance"
 I $D(BARSRT) D
 .W !!?34,$S(BARSRT="C":"Cln",BARSRT="V":"Vis",1:""),?39,"Billed",?50,"Current",?60,"Current",?71,"Current"
 .W !,"LN#",?5,"DOS",?14,"Claim #",?34,"Typ",?39,"Amount",?50,"Payments",?60,"Adjust.",?71,"Balance"
 E  D
 .W !!?39,"Billed",?50,"Current",?60,"Current",?71,"Current"
 .W !,"LN#",?5,"DOS",?14,"Claim #",?39,"Amount",?50,"Payments",?60,"Adjust.",?71,"Balance"
 S BARDSH=""
 S $P(BARDSH,"-",IOM)=""
 W !,BARDSH
 I $D(BARSRT) D
 .W !,$S(BARSRT="C":"CLINIC(S): ",BARSRT="V":"VISIT TYPE(S): ",1:"")
 .I $D(BARSRTA) W "ALL" Q
 .S I="",CT=0 F  S I=$O(BARSRT(BARSRT,I)) Q:I=""  S CT=CT+1 W:CT'=1 "," W " "_I,"(",$P(BARSRT(BARSRT,I),U,2),")"
 ;BAR*1.8*31 11.4.2020 IHS.OIT.FCJ CR#6156 END OF CHANGE
 Q
 ;**************************************************
 ;
CHKLINE(BARHD) ;
 ; Q 0 = CONTINUE
 ; Q 1 = STOP
 N X
 I ($Y+5)<IOSL Q 0
 W !?(IOM-15),"continued==>"
 D EOP^BARUTL(0)
 I 'Y Q 1
 I BARHD=0 D HEAD
 I BARHD=1 D HEAD1
 ;
ECHKLINE ;
 Q 0
