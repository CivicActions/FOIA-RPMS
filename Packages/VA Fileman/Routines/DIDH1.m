DIDH1 ;SFISC/XAK-HDR FOR DD LISTS ;12/16/94  14:13 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 S M=1 I DC=1 S (F(1),DA)=DFF,Z=1
 E  I $Y,IOST?1"C".E W $C(7) R M:DTIME I M=U!'$T K DIOEND S M=U,DN=0 Q
 S M1=$S($G(^DD(F(1),0,"VR"))]"":" (VERSION "_$P(^("VR"),U)_")   ",1:"") I IOST?1"C".E S DIFF=1
 W:$D(DIFF)&($Y) @IOF S DIFF=1 W $S(DHIT["DIDX":"BRIEF",DHIT["DIDG":"GLOBAL MAP",$D(DINM):"MODIFIED",1:"STANDARD")
 W " DATA DICTIONARY #"_DFF_" -- "_$O(^DD(DFF,0,"NM",0))_" "_$P("SUB-",U,$D(^DD(DFF,0,"UP")))_"FILE   "
 S DIC=^DIC(DUB,0,"GL"),W=$E(DT,4,5)_"/"_(DT#100)_"/"_$E(DT,2,3)_"  PAGE "_DC W ?(IOM-$L(W)-1),W
 S M=IOM\2,S=" ",W="" I $D(^DD("SITE")) S W="SITE: "_^("SITE")_"   "
 I $D(^%ZOSF("UCI"))#2 X ^("UCI") S W=W_"UCI: "_Y
 W ! I DHIT["DIDX" W W,?(IOM-$L(M1)-1),M1 S W="",$P(W,"-",IOM)="" W !,W S W="" G Q^DIDH
 W "STORED IN ",DIC I $O(@(DIC_"0)"))'>0 W "  *** NO DATA STORED YET ***"
 E  S I=$P(^(0),U,4) W:I "  ("_I_" ENTR"_$S(I=1:"Y)",1:"IES)")
 W "   ",W,?(IOM-$L(M1)-1),M1 G G:DHIT["DIDG"
 W !!,"DATA",?14,"NAME",?36,"GLOBAL",?50,"DATA",!,"ELEMENT",?14,"TITLE",?36,"LOCATION",?50,"TYPE"
G W ! F I=1:1:IOM-1 W "-"
 S W="" Q:DC>1
 S DG=Z,DIWF="W|",DIWL=1,DIWR=IOM D
 .N A,D,X S A=$P($G(^DIC(DA,"%D",0)),U,3) F D=0:0 S D=$O(^DIC(DA,"%D",D)) Q:D'>0  Q:+A&(D>A)  S X=^(D,0) D ^DIWP I $D(DN),'DN S M=U Q
 D ^DIWW S Z=DG Q:'DN  I DHIT["DIDG" D XR^DIDH Q
 Q:DHIT["DIDX"!(M=U)  W !
 F %=1:1:4 S X=$P("SCR^DIC^ACT^DIK",U,%) I $D(^DD(DA,0,X)),^(X)]"" W !,$P("FILE SCREEN (SCR-node) ^SPECIAL LOOKUP ROUTINE ^POST-SELECTION ACTION  ^COMPILED CROSS-REFERENCE ROUTINE",U,%)_": " S W=^(X) D W^DIDH G Q:M=U
 W:$P($G(^DD(DA,0,"DI")),U)["Y" !,"THIS IS AN ARCHIVE FILE."
 W:$P($G(^DD(DA,0,"DI")),U,2)["Y" !,"EDITING OF FILE IS NOT ALLOWED."
 F N="DD","RD","WR","DEL","LAYGO","AUDIT" I $D(^DIC(DA,0,N)) W !?(Z+Z+14-$L(N)),N," ACCESS: ",^(N)
 W ! I $O(^DD(DA,0,"ID",""))]"" W !,"IDENTIFIED BY: "
 S X=0 F  S X=$O(^DD(DA,0,"ID",X)) Q:X=""  Q:'$D(^DD(DA,X,0))  S I1=$P(^(0),U)_" (#"_X_")" W:($L(I1)+$X)+1>IOM ! W ?15,I1 I $O(^DD(DA,0,"ID",X)) W ","
 S:X="" X=-1 D POINT^DIDH Q:M=U  D TRIG^DIDH,XR^DIDH Q:M=U  W !
 I $D(^DIC(DA,"%A")) S N=^("%A"),Y=$P(N,U,2) I Y X ^DD("DD") W !!?3,"CREATED ON: "_Y I $S($D(^DIC(200,0)):1,1:$D(^DIC(3,0))),^(0)["NEW PERSON"!(^(0)["USER")!(^(0)["EMPLOY"),$D(^(+N,0)) W " by "_$P(^(0),U)
Q Q
W W:$X+$L(W)+3>IOM !,?$S(IOM-$L(W)-5<M:IOM-5-$L(W),1:M),S S %Y=$E(W,IOM-$X,999) W $E(W,1,IOM-$X-1),S Q:%Y=""  S W=%Y G W
 Q
WR ;
 S W="TRIGGERED by the "_$P(^(0),U,1)_" field"
UP1 S W=W_" of the "_$O(^DD(%,0,"NM",0))
 I $D(^DD(%,0,"UP")) S %=^("UP") S W=W_" sub-field" G UP1
 S W=W_" File"
W1 S DDV1="" W ?DDL2 F K=1:1 S DDV=$P(W," ",K)_" ",DDV1=DDV1_DDV W:$L(DDV)+$X>IOM !?DDL2 W DDV Q:$L(DDV1)>$L(W)
 I $Y+6>IOSL S DC=DC+1 D DIDH1
 K DDV,DDV1 Q
DE ;
 N X K ^UTILITY($J,"W") S DIWF="W",DIWL=DDL2+1,DIWR=IOM,DIGG=Z
 W !?DDL1,$P("DESCRIPTION:^TECHNICAL DESCR:",U,%Y=23+1) D
 .N A1,D S A1=$P($G(^DD(F(DIGG),DJ(DIGG),%Y,0)),U,3) F D=0:0 S D=$O(^DD(F(DIGG),DJ(DIGG),%Y,D)) Q:D'>0  Q:+A1&(D>A1)  S X=^(D,0) D ^DIWP I $D(DN),'DN S M=U Q
 D ^DIWW I $D(DN),'DN S M=U K DIOEND
 S Z=DIGG K DIGG,DIWF,DIWL,DIWR
 Q
