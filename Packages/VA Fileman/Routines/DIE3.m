DIE3 ;SFISC/XAK-PROCESS SINGLE-VALUED VARIABLE PNTR ;1/18/96  04:47 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**29**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
V ;
 S DIEX=X ;I $D(DNM) S DIDS=D
 G ALL:X'["." S DIVP=$P(X,"."),X=$P(X,".",2,999),Y=-1,A9=1 I X="" G Q
 I DIVP]"",$D(^DD(DP,DIFLD,"V","P",DIVP)) D FND G Q
 I DIVP="" G ALL
 S X="" F %=0:0 S X=$O(^DD(DP,DIFLD,"V","M",X)) Q:X=""  I $P(X,DIVP)="" S DIVP=X,X=$P(DIEX,".",2,999) D FND G Q:Y>0 S X=$P(DIEX,".")
 F DIVP=0:0 S DIVP=$O(^DD(DP,DIFLD,"V",DIVP)) Q:+DIVP'>0  I $D(^(DIVP,0)) S DIVPDIC=^(0) I $D(^DIC(+DIVPDIC,0)) S %=$P(^(0),U) I $P(%,$P(DIEX,"."))="" S X=$P(DIEX,".",2,999) D DIC G Q:Y>0 S X=$P(DIEX,".")
 I A9 S X=DIEX,A9=0 G ALL
 G Q
 ;
ALL F DIVP1=0:0 S DIVP1=$O(^DD(DP,DIFLD,"V","O",DIVP1)) Q:+DIVP1'>0  S DIVP=DIVP1 D FND Q:Y>0  S X=DIEX
 G Q
 ;
FND S DIVP=+$O(^(DIVP,0)) I $D(^DD(DP,DIFLD,"V",DIVP,0)) S DIVPDIC=^(0) D DIC
 I Y>0 S A9=0
 Q
 ;
DIC I '$D(^DIC(+DIVPDIC,0,"GL")) S Y=-1 Q
 I $D(DIC("V")) S Y=DIVP,Y(0)=DIVPDIC X DIC("V") I '$T K Y S Y=-1 Q
 I $D(DIVP1),'$D(DB(DQ)),'$G(DIQUIET) D H1
 S DIC=^DIC(+DIVPDIC,0,"GL"),DIC(0)="MD"_$E("E",'$D(DB(DQ))&'$D(DIR("V")))_$E("L",$P(DIVPDIC,U,6)="y")_$E("Z",$D(DDS)) I $P(DIVPDIC,U,5)="y",$D(^DD(DP,DIFLD,"V",DIVP,1)),^(1)]"" X ^(1)
 I $D(DIR)=10,'$D(DDS) S DIC(0)=$P(DIC(0),"L")_$P(DIC(0),"L",2)
 D ^DIC S X=+Y_";"_$E(DIC,2,99) K:Y<0 X S %=1
 I Y>0,$D(DIVP1),'$D(DB(DQ)),'$P(Y,U,3),$P(^DIC(+DIVPDIC,0),U,2)'["O",'$G(DIQUIET) D S1
 D  Q 
 .N DICV
 .I $D(DIC("V")) S DICV=DIC("V")
 .K DIC S DIC=DIE S:$D(DICV) DIC("V")=DICV
 .Q
 ;
S1 S A1="Q",DST=%_U_"        ...OK" D S S:%'=1 Y=-1 Q
 ;
H S DDH=$S($D(DDH):DDH+1,1:1),DDH(DDH,A1)=DST K DST Q
 ;
H1 ;also called by DICM3
 W:'$D(DDS) !
 S A1="T",DST=$$EZBLD^DIALOG(8070,$P(DIVPDIC,U,2))
S I $D(DDS) D H S DDD=1 D ^DDSU K DDD G QS
 I A1["T" W !,DST G QS
 I A1["Q" S %=+$P(DST,U,1) W !,$P(DST,U,2) D YN^DICN G QS
 I A1["X" X DST
QS K A1,DST Q
 ;
Q K A1,DIVP1,DIVP,DIVPDIC,A9
 I $D(DNM) G:Y>0 @("V^"_DNM) S X=DIEX K DIEX G X^DIE17:'$D(DB(DQ)),B^DIE17
 K DIEX Q:$D(DIR)  G V^DIED:Y>0,X^DIED:'$D(DB(DQ)),B^DIE1
 ;
 ;#8070  Searching for a |filename|
