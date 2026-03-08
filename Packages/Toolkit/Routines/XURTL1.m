XURTL1 ;SFISC/HVB,543/REB - RESPONSE TIME LOG GRAPH ;8/21/92  15:43 ; [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**19**;September 6, 2001
 ;
 W !!,"This report will print a System Response Time (RT) bar graph of hourly",!
 W "averages over a selected range of dates.  The data that is displayed in",!
 W "this report is from the data that is stored in the ^%ZRTL(3 global node.",!!
 W "This report should be printed to a 132 column output device.",!
 ;
A N %DT,%H,%T,%Y,BEGDATE,BEGHR,DIRUT,DTOUT,DUOUT,ENDATE,ENDHR,DIR,X,Y
 ;
 S U="^",%DT="AEPX",%DT("A")="Enter Starting Date: "
 D ^%DT Q:Y<1
 S X=Y D H^%DTC S BEGDATE=%H
 S %DT("A")="Ending Date: "
 D ^%DT Q:Y<1
 S X=Y D H^%DTC S ENDATE=%H
 S DIR("A")="Enter Starting Hour",DIR(0)="N^0:23:0",DIR("B")=0
 D ^DIR
 Q:Y'>-1!($D(DTOUT))!($D(DUOUT))
 S BEGHR=Y
 S DIR("A")="Ending Hour",DIR(0)="N^"_BEGHR_":23:0",DIR("B")=23
 D ^DIR
 Q:Y'>-1!($D(DTOUT))!($D(DUOUT))
 S ENDHR=Y
 K IOP S %ZIS="MQ"
 D ^%ZIS G:POP END
 I $D(IO("Q")) K IO("Q") D  G END
 .N ZTDESC,ZTRTN,ZTSAVE
 .S ZTDESC="GRAPHIC RESPONSE TIME REPORT",ZTRTN="DQ^XURTL1"
 .S ZTSAVE("BEGDATE")="",ZTSAVE("ENDATE")="",ZTSAVE("BEGHR")="",ZTSAVE("ENDHR")=""
 .D ^%ZTLOAD
 .;
 D DQ
 Q
 ;
DQ ;
 N %DT,%H,B,C,D,BD,ED,H,H1,HA,HR,I,J,LIM,LN,N,OUT,OVF,ROU,RTN,S,SS,SUM,T,TM,UDF,VAX,VOL,X,Y,Y1
 ;
 U IO
 S $P(SS,"*",81)="",$P(LN,"-",82)="",LIM=60,OUT=0,VOL=""
 S VAX=$S(^%ZOSF("OS")["VAX DSM":1,1:0)
 S %H=BEGDATE D YMD^%DTC S Y=X X ^DD("DD") S BD=Y,%H=ENDATE D YMD^%DTC S Y=X X ^DD("DD") S ED=Y
 F  S VOL=$O(^%ZRTL(3,VOL)) Q:VOL=""!OUT  D ROU I $D(ROU) S RTN="" F  S RTN=$O(ROU(RTN)) Q:RTN=""!OUT  S (OVF,UDF)=0 D CMP
 D ^%ZISC
 I $D(ZTSK) S ZTREQ="@"
 ;
END K BEGDATE,BEGHR,ENDATE,ENDHR
 Q
 ;
ROU K ROU S H=BEGDATE-1
 F  S H=$O(^%ZRTL(3,VOL,H)) Q:H>ENDATE!(H="")  S RTN="" F  S RTN=$O(^%ZRTL(3,VOL,H,RTN)) Q:RTN=""  S:'$D(ROU(RTN)) ROU(RTN)=""
 Q
 ;
CMP F I=BEGHR:1:ENDHR F J="J","N","S","CPU","BIO","DIO" S SUM(I,J)=0,SUM(J)=0
 S HA=BEGDATE-1
 F  S HA=$O(^%ZRTL(3,VOL,HA)) Q:HA>ENDATE!(HA="")  S H1="" F  S H1=$O(^%ZRTL(3,VOL,HA,RTN,H1)) Q:H1=""  S Y1=^(H1) D
 .S HR=H1\3600,HR=$S(HR>23:23,1:HR)
 .Q:HR<BEGHR!(HR>ENDHR)
 .S TM=H1-$P($P(Y1,U),",",2)
 .Q:TM<0
 .G OVF:TM>LIM
 .S:TM=0 UDF=UDF+1
 .S SUM(HR,"N")=SUM(HR,"N")+1,SUM(HR,"J")=SUM(HR,"J")+$P(Y1,U,2),SUM(HR,"S")=SUM(HR,"S")+TM
 .S SUM(HR,"CPU")=SUM(HR,"CPU")+$P(Y1,U,3),SUM(HR,"DIO")=SUM(HR,"DIO")+$P(Y1,U,4)
 .S SUM(HR,"BIO")=SUM(HR,"BIO")+$P(Y1,U,5) Q
OVF .S OVF=OVF+1
 ;
 W @IOF
 S %DT="T",X="N" D ^%DT X ^DD("DD")
 W !,"RESPONSE TIME LOG for VOLUME SET: ",VOL,?86,"PRINTED:  ",Y,!,"ROUTINE: ",RTN,!!
 W " TIME",?9,"N",?15,"SEC",?30,"AVE RESPONSE TIME SECONDS for DATES ",BD," to ",ED
 W:VAX ?105,"CPU",?112,"DIO",?119,"BIO" W !
 W " ----",?9,"--",?16,"---",?21,LN
 W:VAX ?105,"----",?112,"---",?119,"---" W !
 F I=BEGHR:1:ENDHR D  I $Y>(IOSL-3) D RET Q:OUT
 .S N=SUM(I,"N"),J=SUM(I,"J"),S=SUM(I,"S"),C=SUM(I,"CPU"),B=SUM(I,"BIO"),D=SUM(I,"DIO")
 .S SUM("S")=SUM("S")+SUM(I,"S"),SUM("CPU")=SUM("CPU")+SUM(I,"CPU"),SUM("DIO")=SUM("DIO")+SUM(I,"DIO")
 .S SUM("BIO")=SUM("BIO")+SUM(I,"BIO"),SUM("N")=SUM("N")+N
 .S T=$S(N:S/N,1:0),C=$S(N:C/N,1:0),B=$S(N:B/N,1:0),D=$S(N:D/N,1:0)
 .W $S(I<10:"0",1:""),I,":00",?6,$J(N,5),?15,$S(T=0:"    ",1:$J(T,4,1))
 .W ?21,"|",$E(SS,1,$J(T*10,1,0)),?101,"|"
 .W:VAX ?105,$J(C,1,2),?112,$J(D,3,0),?119,$J(B,3,0) W !
 Q:OUT
 W ?16,"---",?21,"|" F I=1:1:8 W "---------|"
 W:VAX ?105,"-----",?112,"---",?119,"---"
 W !,?6,$J(SUM("N"),5,0)
 I +SUM("N") W ?15,$J(SUM("S")/SUM("N"),4,1)
 W ?22 F I=1:1:8 W "         ",I
 I +SUM("N") W:VAX ?105,$J(SUM("CPU")/SUM("N"),1,2),?112,$J(SUM("DIO")/SUM("N"),3,0),?119,$J(SUM("BIO")/SUM("N"),3,0)
 W !
 W:OVF !!!!,?21,"REMARKS:<< "_OVF_" sample(s) greater than "_LIM_" seconds; not included in average >>",!
 W:UDF ?29,"<< "_UDF_" sample(s) equal to 0 seconds >>",!
 D RET
 Q
 ;
RET Q:$D(ZTQUEUED)
 ;
 N X
 W !,"Press RETURN to continue or '^' to exit: "
 R X:DTIME
 I X="^"!('$T) S OUT=1 Q
 W @IOF
 Q
