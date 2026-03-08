XURTL2 ;SFISC/HVB,543/REB - RESPONSE TIME LOG MULTIDAY SUMMARY ;8/4/90  19:18 ; [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**19**;September 6, 2001
 ;
 W !!,"This report will print a report which will display the System Response",!
 W "Time (RT) multiday hourly averages over a selected range of dates.  The",!
 W "data that is displayed in this report is from the data that is stored in",!
 W "the ^%ZRTL(3 global node.",!!
 W "This report should be printed to a 132 column output device.",!
 ;
A N %DT,%H,BEGDATE,ENDATE,X,Y
 ;
 S U="^",%DT="AEPX",%DT("A")="Enter Starting Date: "
 D ^%DT Q:Y<1
 S X=Y D H^%DTC S BEGDATE=%H
 S %DT("A")="Ending Date: "
 D ^%DT Q:Y<1
 S X=Y D H^%DTC S ENDATE=%H
 S %ZIS="MQ"
 D ^%ZIS G:POP END
 I $D(IO("Q")) K IO("Q") D  G END
 .N ZTDESC,ZTRTN,ZTSAVE
 .S ZTDESC="MULTIDAY RESPONSE TIME REPORT",ZTRTN="DQ^XURTL2"
 .S ZTSAVE("BEGDATE")="",ZTSAVE("ENDATE")=""
 .D ^%ZTLOAD
 .;
 D DQ
 Q
 ;
DQ ;
 N %DT,%H,BD,ED,H,H1,HA,HR,I,J,LIM,LN,N,NOW,OUT,OVF,ROU,RTN,S,SUM,T,TM,UDF,VOL,X,Y,Y1
 ;
 U IO
 S $P(LN,"-",82)="",(VOL,H)="",LIM=300,OUT=0
 S %H=BEGDATE D YMD^%DTC S Y=X X ^DD("DD") S BD=Y,%H=ENDATE D YMD^%DTC S Y=X X ^DD("DD") S ED=Y
 S %DT="T",X="N" D ^%DT X ^DD("DD") S NOW=Y
 F  S VOL=$O(^%ZRTL(3,VOL)) Q:VOL=""!OUT  D
 .D ROU
 .I $D(ROU) D HDR S RTN="" F  S RTN=$O(ROU(RTN)) Q:RTN=""!OUT  D
 ..S (OVF,UDF)=0
 ..I $Y>(IOSL-3) D RET Q:OUT
 ..W !,RTN,?9
 ..D CMP
 D ^%ZISC
 I $D(ZTSK) S ZTREQ="@"
 ;
END K BEGDATE,ENDATE
 Q
 ;
ROU K ROU S H=BEGDATE-1
 F  S H=$O(^%ZRTL(3,VOL,H)) Q:H>ENDATE!(H="")  S RTN="" F  S RTN=$O(^%ZRTL(3,VOL,H,RTN)) Q:RTN=""  S:'$D(ROU(RTN)) ROU(RTN)=""
 Q
 ;
CMP F I=0:1:23 F J="J","N","S" S SUM(I,J)=0
 S HA=BEGDATE-1
 F  S HA=$O(^%ZRTL(3,VOL,HA)) Q:HA>ENDATE!(HA="")  S H1="" F  S H1=$O(^%ZRTL(3,VOL,HA,RTN,H1)) Q:H1=""  S Y1=^(H1) D
 .S HR=H1\3600,HR=$S(HR>23:23,1:HR),TM=H1-$P($P(Y1,U),",",2)
 .Q:TM<0
 .G OVF:TM>LIM
 .S:TM=0 UDF=UDF+1
 .S SUM(HR,"N")=SUM(HR,"N")+1,SUM(HR,"J")=SUM(HR,"J")+$P(Y1,U,2),SUM(HR,"S")=SUM(HR,"S")+TM Q
OVF .S OVF=OVF+1
 ;
 F I=0:1:23 D
 .S N=SUM(I,"N"),J=SUM(I,"J"),S=SUM(I,"S"),T=$S(N:S/N,1:0),J=$S(N:J/N,1:0)
 .W $S(T>99.9:$J(T,5,0),T>0:$J(T,5,1),1:"     ")
 Q
 ;
HDR ;
 N I
 W @IOF,!
 W "Multiday Average Response Time Log for Volume Set ",VOL," for ",BD," to ",ED,?103,"Printed  ",NOW,!!,"HOUR",?12
 F I=0:1:23 W I,?$X-$L(I+1)+5
 W !
 Q
 ;
RET Q:$D(ZTQUEUED)
 ;
 N X
 W !,"Press RETURN to continue or '^' to exit: "
 R X:DTIME
 I X="^"!('$T) S OUT=1 Q
 D HDR
 Q
