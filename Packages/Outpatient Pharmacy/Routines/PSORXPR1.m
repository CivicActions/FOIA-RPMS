PSORXPR1 ;BHAM/ISC/SAB -  CONTINUATION OF VIEW PRESCRIPTION  [ 01/16/2003  10:41 AM ]
 ;;6.0;OUTPATIENT PHARMACY;**3,4**;11/11/2002
 ;;6.0;OUTPATIENT PHARMACY;**71**;09/03/97
 ;ACTUAL ACQUISTION COST ADDED IHS/OKCAO/POC 11/11/2002
RF ;D HEAD F N=0:0 S N=$O(^PSRX(DA,1,N)) Q:'N  S P1=^(N,0) D  Q:ANS="^"
 D HEAD F N=0:0 S N=$O(^PSRX(DA,1,N)) Q:'N  S P1=^(N,0),P9999999=$G(^PSRX(DA,1,N,9999999)) D  Q:ANS="^"  ;IHS/OKCAO/POC 10/27/2002 IMPROVE COST
 .D CON:$Y>20 Q:ANS="^"  D:FFX HEAD W !,N,?3 S DTT=$P(P1,"^",8)\1 D DAT W DAT,?14
 .S DTT=$P(P1,"^") D DAT W DAT,?27,$P(P1,"^",4),?32
 .S PSDIV=$S($D(^PS(59,+$P(P1,"^",9),0)):$P(^(0),"^",6),1:"UNKNOWN"),X=$P(P1,"^",2),X=$F("MWIBD",X)-1 W:X $P("MAIL^WINDOW^INPATIENT","^",X),?40,$P(P1,"^",6),?52,$E($S($D(^VA(200,+$P(P1,"^",5),0)):$P(^(0),"^"),1:""),1,16),?70,PSDIV
 .W !," DISPENSED: "_$S($P(P1,"^",19):$E($P(P1,"^",19),4,5)_"/"_$E($P(P1,"^",19),6,7)_"/"_$E($P(P1,"^",19),2,3),1:"")
 .W ?$X+10,$S($P(P1,"^",16):" RETURNED TO STOCK: "_$E($P(P1,"^",16),4,5)_"/"_$E($P(P1,"^",16),6,7)_"/"_$E($P(P1,"^",16),2,3),1:" RELEASED: "_$S($P(P1,"^",18):$E($P(P1,"^",18),4,5)_"/"_$E($P(P1,"^",18),6,7)_"/"_$E($P(P1,"^",18),2,3),1:""))
 .W:$P(P1,"^",3)'="" !?5,"REMARKS: ",$P(P1,"^",3)
 .W:$P(P1,"^",13)'="" !?5,"NDC: ",$P(P1,"^",13)  ;IHS/OKCAO/POC 5/9/2001 NDC NUMBER
 .W "  ("_$P(P9999999,"^",6)_")  ("_$P(P1,"^",11)_")"  ;IHS/OKCAO/POC 10/27/2002 IMPROVE COST
 Q
HLD ;prints hold info
 S DTT=$P(^PSRX(DA,"H"),"^",3) D DAT S HLDR=$P(^DD(52,99,0),"^",3),HLDR=$S($P(^PSRX(DA,"H"),"^")'>6:$P(HLDR,";",$P(^PSRX(DA,"H"),"^")),1:$P(HLDR,";",7)),HLDR=$P(HLDR,":",2)
 W !!,"HOLD REASON: "_HLDR,?60,"HOLD DATE: "_DAT W:$P(^PSRX(DA,"H"),"^",2)]"" !,"HOLD COMMENTS: "_$P(^PSRX(DA,"H"),"^",2)
 K DAT,DTT,HLDR
 Q
HEAD I FFX W @IOF
 W !,"#",?3,"LOG DATE",?14,"REFILL DATE",?27,"QTY",?32,"ROUTING",?40,"LOT #",?52,"PHARMACIST",?70,"DIVISION",! F I=1:1:79 W "="
 S FFX=0 W ! Q
DAT S DAT="",DTT=DTT\1 Q:DTT'?7N  S DAT=$E(DTT,4,5)_"/"_$E(DTT,6,7)_"/"_$E(DTT,2,3)
 Q
CON K DIR S DIR(0)="FO",DIR("A")="Press RETURN to continue or ""^"" to exit" D ^DIR S:$D(DTOUT)!($D(DUOUT)) ANS="^" S FFX=1 Q
