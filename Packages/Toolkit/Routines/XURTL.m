XURTL ;SFISC/HVB - RESPONSE TIME LOG PRINT ;10/1/91  07:39 ; [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**19**;September 6, 2001
 ;
EN(FORM)        ;
 ;-------------------------------------------------------------------
 ; input: FORM = 0 => short
 ;             = 1 => long
 ;-------------------------------------------------------------------
 ;
 S:'$D(FORM) FORM=0
 ;
 W !!,"This option will print a ",$S(FORM:"long",1:"short")," report which will display the System Response",!
 W "Time (RT) hourly averages over a selected range of dates.  The data that is ",!
 W "displayed in this report is from the data that is stored in the ^%ZRTL(3",!
 W "global node.",!!
 W "This report should be printed to a 132 column output device.",!
EN1 ;
 N %DT,%H,%T,%Y,BEGDATE,ENDATE,X,XF,XL,Y
 ;
 S U="^",%DT="AEPX",%DT("A")="Enter Starting Date: "
 D ^%DT Q:Y<1
 S X=Y D H^%DTC S BEGDATE=%H X ^DD("DD") S XF=Y
 S %DT("A")="Ending Date: "
 D ^%DT Q:Y<1
 S X=Y D H^%DTC S ENDATE=%H X ^DD("DD") S XL=Y
 S %ZIS="MQ"
 D ^%ZIS
 G END:POP
 I $D(IO("Q")) K IO("Q") D  G END
 .N ZTDESC,ZTRTN,ZTSAVE
 .S ZTDESC=FORM_"RESPONSE TIME REPORT",ZTRTN="DQ^XURTL"
 .S ZTSAVE("BEGDATE")="",ZTSAVE("ENDATE")="",ZTSAVE("FORM")="",ZTSAVE("XF")="",ZTSAVE("XL")=""
 .D ^%ZTLOAD
 ;
 D DQ
 Q
 ;
DQ ;
 N %H,DATE,I,MG,MJ,NJ,NMT,OUT,RTN,SJ,T0,T1,TIME,VOL,X,Y
 ;
 U IO
 S (JF,RTN,TIME,VOL)="",OUT=0
 F  S VOL=$O(^%ZRTL(3,VOL)) Q:VOL=""!OUT  S DATE=BEGDATE-1 D D
 D ^%ZISC
 ;
END K BEGDATE,HI,J,JF,ENDATE,FORM,LO,MT,NT,SMT,SSQ,ST,STD,XF,XL
 Q
 ;
D W @IOF,!
 W ?25,"System Response Time Report for ",VOL," for ",XF," to ",XL,!!
 W "HOUR",?12
 F I=0:1:23 D
 .W I,?$X-$L(I+1)+5
 .S SMT(I)=0,NMT(I)=0,SJ(I)=0,NJ(I)=0
 F  S DATE=$O(^%ZRTL(3,VOL,DATE)) Q:DATE=""!(DATE>ENDATE)!OUT  D R
 Q:OUT
 W !!,"MEAN",?9
 F I=0:1:23 D
 .S MG=$S(NMT(I)>0:SMT(I)/NMT(I),1:0)
 .W $S(MG>99.9:$J(MG,5,0),MG>0:$J(MG,5,1),1:"     ")
 I JF W !!,"ACTJ",?9 F I=0:1:23 D
 .S MJ(I)=$S(NJ(I)>0:SJ(I)/NJ(I)*10+.5\1/10,1:"")
 .W $S(MJ(I)>0:$J(MJ(I),5,0),1:"     ")
 W !
 Q
 ;
R ;
 I $Y>(IOSL-3) D RET Q:OUT
 ;
 S %H=DATE D YMD^%DTC S Y=X X ^DD("DD")
 W !!,Y D DW^%DTC W " (",X,")"
 F  S RTN=$O(^%ZRTL(3,VOL,DATE,RTN)) Q:RTN=""!OUT  W !,RTN,?9 D H
 Q
 ;
H ;
 I $Y>(IOSL-3) D RET Q:OUT
 ;
 F I=0:1:23 S (ST(I),NT(I),HI(I))=0,LO(I)=99999,SSQ(I)=0,STD(I)=""
 F  S TIME=$O(^%ZRTL(3,VOL,DATE,RTN,TIME)) Q:TIME=""  D
 .S T0=+$P(^%ZRTL(3,VOL,DATE,RTN,TIME),",",2),T1=TIME
 .I T1'<T0 S I=T1\3600,I=$S(I>23:23,1:I),NT(I)=NT(I)+1,ST(I)=ST(I)+(T1-T0),J=$P(^(TIME),U,2) S:J JF=1,SJ(I)=SJ(I)+J,NJ(I)=NJ(I)+1 D:FORM HL
 F I=0:1:23 D
 .S MT(I)=$S(NT(I)>0:ST(I)/NT(I),1:"")
 .S:MT(I)>0 SMT(I)=SMT(I)+MT(I),NMT(I)=NMT(I)+1
 .W $S(MT(I)>99.9:$J(MT(I),5,0),MT(I)>0:$J(MT(I),5,1),1:"     ")
 .I FORM,NT(I)>0 S X=SSQ(I)/NT(I)-(MT(I)*MT(I)) D SQR S STD(I)=Y
 Q:'FORM!OUT
 W !,"    HIGH",?9 F I=0:1:23 W $S(HI(I)>9999:" ****",HI(I)>99.9:$J(HI(I),5,0),HI(I)>0:$J(HI(I),5,1),1:"     ")
 W !,"     LOW",?9 F I=0:1:23 W $S(LO(I)'=99999:$J(LO(I),5,1),1:"     ")
 W !,"   COUNT",?9 F I=0:1:23 W $S(NT(I)>0:$J(NT(I),5,0),1:"     ")
 W !,"   STDEV",?9 F I=0:1:23 W $S(STD(I)>99.9:$J(STD(I),5,0),STD(I)>0:$J(STD(I),5,1),1:"     ")
 W !
 Q
 ;
HL S:(T1-T0)<LO(I) LO(I)=T1-T0
 S:(T1-T0)>HI(I) HI(I)=T1-T0
 S SSQ(I)=(T1-T0)*(T1-T0)+SSQ(I)
 Q
 ;
SQR ;
 N T
 S Y=0
 Q:X'>0
 S Y=1+X/2
LP S T=Y,Y=X/T+T/2
 G LP:Y<T
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
 ;
LOG ; Insert these in applications
 D:$D(XRTL) T0^%ZOSV ; START
 S:$D(XRT0) XRTN=$T(+0) D:$D(XRT0) T1^%ZOSV ; STOP
