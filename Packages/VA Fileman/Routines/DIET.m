DIET ;SFISC/XAK-DISPLAY INPUT TEMPLATE ;8/16/95  15:22 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**12**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 I '$D(^DIE(D0,0)) S X="" Q
 S X=^(0),DL=1,DIFILE(DL)=$P(X,U,4),W="FIRST" G Q:'$D(^DD(DIFILE(DL),0))
A S DIPP(DL)=$S($D(^DIE(D0,"DR",DL,DIFILE(DL))):^(DIFILE(DL)),1:"ALL") F %A(DL)=1:1 S X=$P(DIPP(DL),";",%A(DL)) Q:X=""  D DJ
 S %(DL)=0 F  S %(DL)=$O(^DIE(D0,"DR",DL,DIFILE(DL),%(DL))) S:%(DL)="" %(DL)=-1 G UP:%(DL)'>0 S DIPP(DL)=^(%(DL)) F %A(DL)=1:1 S X=$P(DIPP(DL),";",%A(DL)) Q:X=""  D DJ
EXIT K DIFILE,DIPP,%A,% S X="" Q
 ;
DJ S Y=+$P(X,":",1),Z=+$P(X,":",2) I Y,Z S X=Y-.00000001 F  S X=$O(^DD(DIFILE(DL),X)) S:X="" X=-1 Q:X=Z  G Q:X'>0 S %B=X,X=$P(^(X,0),U,1),Y="" D W S X=%B
 I $L(X)<30 S Y=$S($D(^DD(DIFILE(DL),X,0)):^(0),1:""),X=$S(Y]"":$P(Y,U,1),1:X)
W W !?DL*2-2,W," EDIT FIELD: ",X,"//" S W="THEN" Q:'$P(Y,U,2)  S DL=DL+1,DIFILE(DL)=+$P(Y,U,2),%(DL)=0 D A Q
Q Q
 ;
UP S DL=DL-1 G EXIT:'DL Q
 ;
AUD N DP,%,%D,%F,%T,C,DPS,DIEDA,DIEF,DIEX,DIIX,DIANUM,Y
 S DIIX="3^.01^A",DP=+DO(2) D AUDIT:DP>0 Q
AUDIT ;
 I $D(^DD(DP,+$P(DIIX,U,2),"AX")) X ^("AX") Q:'$T
 K % S DIEX=X D @+DIIX
 K DPS,DIEX,DIEDA,DIEF,%T,DIIX,%F,%D,%
 Q
3 ;
 I $D(DG),DG]"",$D(DIANUM(DG)) S Y=X,(DIEX(1),C)=$P(^DD(DP,+$P(DIIX,U,2),0),U,2) D Y^DIQ S @(DIANUM(DG)_"+DIIX)")=Y K DIANUM(DG) G I
2 ;
 S:$D(DP(1)) DPS=DP(1) S DIEDA="",DIEF="",%=1,DP(1)=DP,%F=+DP,X=DA
 F C=1:1 Q:'$D(^DD(DP(1),0,"UP"))  S %F=^("UP"),%=$O(^DD(%F,"SB",DP(1),0)) S:%="" %=-1 S DIEDA=DA(C)_","_DIEDA,DIEF=%_","_DIEF,DP(1)=%F
 D ADD I $D(DG),DG]"" S DIANUM(DG)="^DIA("_%F_","_+Y_","
 S (DIEX(1),C)=$P(^DD(DP,+$P(DIIX,U,2),0),U,2),Y=DIEX D Y^DIQ
 S ^DIA(%F,"B",DIEDA_DA,%D)="",X=DIEX S:$D(DPS) DP(1)=DPS
 S ^DIA(%F,%D,0)=DIEDA_DA_U_%T_U_DIEF_+$P(DIIX,U,2)_U_DUZ_U_$P(DIIX,U,3),^(+DIIX)=Y
I I DIEX(1)["P"!(DIEX(1)["V")!(DIEX(1)["S") S ^(DIIX+.1)=X_U_DIEX(1)
 Q
ADD I '$D(^DIA(%F,0)) S ^DIA(%F,0)=$P(^DIC(%F,0),U,1)_" AUDIT^1.1I"
 F Y=$P(^(0),U,3):1 I '$D(^(Y)) L +^DIA(%F,Y):0 Q:$T
 S $P(^(0),U,3,4)=Y_U_($P(^(0),U,4)+1),^(Y,0)=X L -^DIA(%F,Y)
 S %D=Y,%T=$P($H,",",2),%T=%T#60/100+(%T#3600\60)/100+(%T\3600)/100,%T=DT_%T
 S ^DIA(%F,"C",%T,Y)="",^DIA(%F,"D",DUZ,Y)=""
 Q
