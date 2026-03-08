SDSCP1 ; IHS/ADC/PDW/ENM - ROUTINE TO PRINT CLINIC STOP VISIT LIST 2 NOV 87 14:00 ;  [ 11/14/2002  6:59 AM ]
 ;;5.0;IHS SCHEDULING;**8**;MAR 25, 1999
 ;;MAS VERSION 5.0;
 ;IHS/HQW/KML 2/14/97 replace $N with $O w/o changing functionality
 ; IHS/ITSC/KMS, 13-Nov-2002 - Patch 8 - Clinic Stop Code data type changes.
 ;
 S SDNSC=0,SDS=$P(SDX,U,3) D NOW^%DTC S X1=$P(%,"."),X2=$P(^DPT(K,0),U,3) D ^%DTC S SDA=X\365.25 I I'=SDI D T S SDK=0 D H
 S SDI=I I SDK'=K D T,H:((IOSL-$Y-4)'>(^UTILITY($J,"CT",I,K)+2))&((^(K)+2)'>(IOSL-8)),N S SDK=K,SDNEW=1
 D R:$Y=(IOSL-4),P S (SDNEW,SDNSC)=0 Q
H S SDPG=SDPG+1,SDNSC=1 W @IOF,!?58,"OPC STOP CODE REPORT",?122,"PAGE:",?128,$J(SDPG,4),!!,"PERIOD COVERING: ",SDBEG,"-",SDEND,?46,"FOR DIVISION: ",SDDN,?111,"RUN ON: ",DGNOW
 W !!?34,"SOCIAL",?55,"S",?67,"P",?69,"P",?71,"V",?73,"N",?75,"P",?77,"L",?79,"CLINIC" W:SDPRE ?104,"SPECIAL",?115,"SPECIAL"
 W !,"STOP",?6,"PATIENT",?34,"SECURITY",?46,"VISIT",?55,"E",?61,"ZIP",?67,"O",?69,"O",?71,"E",?73,"O",?75,"O",?77,"O",?79,"STOP" W:SDPRE ?104,"SURVEYS",?115,"SERVICES"
 W !,"CODE",?6,"NAME",?34,"NUMBER",?46,"DATE",?55,"X",?57,"AGE",?61,"CODE",?67,"W",?69,"S",?71,"T",?73,"N",?75,"V",?77,"V",?79,"CODES" W:SDPRE ?104,"BLOCKS",?115,"BLOCKS" W:'SDPRE ?125,"MT",?129,"DEP" Q
N W !! I SDNSC W $J(I,4) S Q1=$O(^DIC(40.7,"C",I,0)) I $D(^DIC(40.7,Q1,0)) W ?6,$P(^(0),"^")
 W !?6,$E(J,1,25),?34,SDS Q
P W:'SDNEW ! W ?46 S Y=L D DT W ?55,$S('$P(SDX,U,6):"M",1:"F"),?57,$J(SDA,3),?61,$P(SDX,U,5),?67,$S($P(SDX,U,7):"N",$P(SDX,U,7)=" ":" ",1:"Y"),?69,$P(SDX,U,8),?71,$P(SDX,U,9)
 W ?73,$P(SDX,U,10),?75,$P(SDX,U,11),?77,$P(SDX,U,12),?79,$P(SDX,U,13) W:SDPRE ?104,$P(SDX,U,14),?115,$P(SDX,U,15) I 'SDPRE W ?126,$P(SDX,U,15),?130,$P(SDX,U,16) I +$P(SDX,U,18) W !?55,"ASSOCIATED STOP CODES FOR SPECIAL SERVICES: ",$P(SDX,U,18)
 Q
T W:SDI&SDK !,?78,"TOTAL NUMBER OF PATIENT VISITS TO THIS STOP CODE: ",?129,$J(^UTILITY($J,"CT",SDI,SDK),3) Q
 Q
R D H,N S SDNEW=1 Q
SH S SDPG=SDPG+1 W @IOF,!?57,"OPC STOP CODE REPORT",!?53,"TOTAL VISITS PER STOP CODE",?120,"PAGE: ",?128,$J(SDPG,4),!?63,"SUMMARY",!!?45,"PERIOD COVERING: ",SDBEG,"-",SDEND,!?48,"FOR DIVISION: ",SDDN,!?54,"RUN ON: ",DGNOW
 W !!,?25,"STOP CODE",?89,"VISITS",?103,"UNIQUE SSNS",! Q
 ; IHS/ITSC/KMS, 13-Nov-2002 - 'I' is a potential bug for new free text Stop Code field.
 ;F I=0:0 S I=$O(^UTILITY($J,"CT",I)) Q:'I  W !,?25,$J(I,3)," - " S Q1=$O(^DIC(40.7,"C",I,0)) W:$D(^DIC(40.7,Q1,0)) $P(^(0),"^",1) W ?90,$J($P(^UTILITY($J,"CT",I),"^"),5),?106,$J($P(^(I),U,2),5) I $Y=(IOSL-4) D SH
S S NULL="" F I=0:0 S I=$O(^UTILITY($J,"CT",I)) Q:I=NULL  W !,?25,$J(I,3)," - " S Q1=$O(^DIC(40.7,"C",I,0)) W:$D(^DIC(40.7,Q1,0)) $P(^(0),"^",1) W ?90,$J($P(^UTILITY($J,"CT",I),"^"),5),?106,$J($P(^(I),U,2),5) I $Y=(IOSL-4) D SH
 ; End code modification.
 Q
E I $Y=(IOSL-4) D SH Q
DT S X=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3) W X Q
DV S DIC("A")="SORT STOP CODES FOR WHICH DIVISION: " W !,DIC("A")," " W:$D(^DG(40.8,1,0)) $P(^DG(40.8,1,0),"^",1),"// " R X:DTIME I (X["^")!('$T)!((X="")&('$D(^DG(40.8,1,0)))) S Y=-1 Q
 G:X="" X S DIC="^DG(40.8,",DIC(0)="EQZMN" D ^DIC G:X["?"!(Y<0) DV S SDD=+Y K DIC Q
X S Y=1,SDD=1 K DIC Q
TEXT F I=2:1:5 W !?25,$P($T(TEXT+I),";;",2)
 Q
 ;;**These totals represent totals for all stop codes combined.  They will not, necessarily,
 ;;  be equal to the sum of visits and unique SSNs for stop codes.  If a patient has four
 ;;  add/edits in one day, he will add one visit and one unique SSN to each individual stop
 ;;  code, but he will only add one visit and unique SSN to these totals.
HELP W !,"Enter: 'Y'es to see report broken down by patient",!?7,"'N' to see just total of visits and unique SSNs per stop code" Q
DATE W !!,"**** Date Range Selection ****"
 W ! S %DT(0)=-DT,%DT="AEP",%DT("A")="   Beginning DATE : " D ^%DT Q:Y<0  S SDB=Y-.1
 W ! S %DT="AEP",%DT("A")="   Ending    DATE : " D ^%DT K %DT Q:Y<0  G CK2:(SDB+.1<SDCON)&(Y'<SDCON),CK3:(Y<SDB) W ! S SDE=Y+.9
 Q
CK3 W "??",!?5,"Ending date must not be before beginning date" G DATE
CK2 W "??",!,"Your MAS Version 4.0 conversion date was " S Y=SDCON X ^DD("DD") W Y,".  Date Range can not overlap this date." G DATE
