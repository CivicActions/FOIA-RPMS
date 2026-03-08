DIP1 ;SFISC/GFT,TKW-PROCESS FROM-TO ;4/11/96  07:59 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**2,9,16,21**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 D DJ Q
DUP D DPQ G DIP1^DIQQQ:$D(A(1))
 I '$D(BY),$D(DPP(2,"T"))!$D(DPP(3))!$D(DXS) S DK=S G S^DIBT
DIP2 S DC=0 D:'$D(DISYS) OS^DII G ^DIP2
 ;
FTEM I $G(DIBT1),$O(^DIBT(DIBT1,2,0)) D
 .I $D(DIBTOLD) D SNEW^DIBT Q
 .D US^DIBT Q
N ;
 S DCC=DI,C="," G DIP2
 ;
DPQ K A F X=1:1 Q:$D(DPP(X))#2=0  S A=$E($P(DPP(X),U,1,3),1,60),Y=$P(DPP(X),U,4),DPP=X S:Y'["'" (A($D(A(A))),A(A))=0 I Y'["@",Y'["'" S DPQ(+DPP(X),$P(Y,"""",2)+$P(DPP(X),U,2))=""
 K DPP(X) Q
 ;
DJ N DIFLD,DIFLDREG D DTYP I $D(DPP(DJ,"F")) D OPT^DIP12 Q
J ;
 S DC=$S($D(^DD(+DPP(DJ),$S(DIFLD:DIFLD,DIFLDREG="":U,1:.001),0)):$P(^(0),U,2,3),1:$P(DPP(DJ),U,7,8)),R=$P(DPP(DJ),U,3)
 K DIC,DIARE,DIARS N DIFRTO
S K DIERR,DPP(DJ,"SRTTXT")
 S DIPR=$P(DPP(DJ),";""",2,99),DIPR=$P(DIPR,"""",1,$L(DIPR,"""")-1),DIPR=$S(DIPR'="":DIPR,1:R),%=$E(DIPR,$L(DIPR)-1,$L(DIPR)),%=$S(%=": ":2,$E(%,2)=":":1,1:0) I % S DIPR=$E(DIPR,1,$L(DIPR)-%)
 S A="FIRST",DIFRTO="?" I 'L I $D(FR)#2!($O(FR(0))) S %="FR" D Z I DIFRTO'="?" G S0
 I $D(DISV) D FROM^DIARCALC
 K DIR S %="",%(1)=$G(DPP(DJ,"TXT")) S:%(1)="" %(1)=$G(DIPP(DIJ,"TXT")) S:%(1)]"" $P(%," ",(DJ+DJ-1))="",DIR("A",1)=%_"* Previous selection: "_%(1) K %
 S DIR(0)="FO^1:245",%="",$P(%," ",(DJ+DJ-1))="",DIR("A")=%_"START WITH "_DIPR,DIR("?")="^D DIP1F^DIQQ" S:A]"" DIR("B")=A
 D ^DIR W:$D(DTOUT) $C(7) G Q:$D(DTOUT)!($D(DUOUT))
 I $G(DIR("B"))="FIRST",X="FIRST" S A="FIRST",X=""
 K DIR,DIRUT,DIROUT,DIERR
S0 I X="",A="FIRST" D:$P(DPP(DJ),U,5)[";TXT" STXT(DJ,"","",DITYP) D OPT^DIP12 Q
 S Y(0)="" D CK^DIP12:X'="" I X'="" I X'?.ANP!($D(DIERR)) G:DIFRTO="?" S G Q
 S M=1 D PAR
 D FRV
 S Y=Y_U_X S:Y(0)]"" Y=Y_U_Y(0) S (B,DPP(DJ,"F"))=Y
T K DIERR S Y="z",A="LAST",DIFRTO="?" I 'L I $D(TO)#2!($O(TO(0))) S %="TO" D Z I DIFRTO'="?" G T0
 I $D(DISV) D TO^DIARCALC
 G T0:$G(DIAR)=4
 K DIR S %="",$P(%," ",(DJ+DJ-1))="",DIR(0)="FO^1:245",DIR("A")=%_"GO TO "_DIPR,DIR("?")="^D DIP1T^DIQQ" S:A]"" DIR("B")=A
 D ^DIR W:$D(DTOUT) $C(7) G Q:$D(DUOUT)!($D(DTOUT))
 I X="LAST",$G(DIR("B"))="LAST" S X="",Y="z"
 K DIR,DIRUT,DIROUT,DIERR
T0 S Y(0)="" I DITYP=1,X]"" D
 . Q:X="@"  I X?1.U,$E(X)'="T" Q
 . N I,D S I=$S(X["@":"@",X[".":".",1:""),D=$G(DITYP("D"))
 . I I]"",$P(X,I,2)]"" Q:D["T"!(D["S")
 . S:I]"" X=$P(X,I) I D'["T",D'["S" Q
 . S X=X_"@2400" Q
 D STXT(DJ,B,"^"_X,DITYP)
 I $D(DPP(DJ,"SRTTXT")) S:$G(DPP(DJ,"F"))]"" B=DPP(DJ,"F")
 D:X]"" CK^DIP12 I $D(DIERR) G:DIFRTO="?" T G Q
 S M=2 D PAR:Y'="z"
 S:$D(DPP(DJ,"SRTTXT")) Y=$P(" ",U,(X'="@"))_Y S Y=Y_U_X S:Y(0)]"" Y=Y_U_Y(0) S DPP(DJ,"T")=Y
 I B["?z"!($P(Y,U)="@") D OPT^DIP12 Q
 I $$BEF^DIU5($P(Y,U),$P(B,U)) D:'$G(DIQUIET) FER1^DIQQ G:DIFRTO="?" T G Q
 D OPT^DIP12 Q
 ;
FRV N M I +$P(Y,"E")=Y S Y=Y-$S(Y:.00001,$P(DPP(DJ),U,2)'=0&$L(DC):1,1:0) Q
 F %=$L($E(Y,1,30)):-1:1 S M=$A(Y,%) I M>32 S Y=$E(Y,1,%-1)_$C(M-1)_$C(122) Q
 Q
 ;
DTYP N S S DIFLDREG=$P(DPP(DJ),U,2),DIFLD=DIFLDREG+$P($P(DPP(DJ),U,4),"""",2) I 'DIFLD,DIFLDREG'="" S DIFLD=.001
 S S=$P(DPP(DJ),U)
D1 K DITYP S DITYP=""
 I S,DIFLD D DTYP^DIOU(S,DIFLD,.DITYP) I $G(^DD(S,DIFLD,2))]"",DITYP'=1 S DITYP=4
 I DITYP=6,$G(DITYP("T"))=1 S DITYP("D")="TS"
 S:$G(DITYP("T")) DITYP=DITYP("T")
 I DITYP="",'DIFLD,$P(DPP(DJ),U,7)]"" D
 . N I,X S X=$P(DPP(DJ),U,7),I=""
 . F  S I=$O(^DI(.81,"C",I)) Q:I=""  I X[I S DITYP=$O(^(I,0)) Q
 . S:DITYP=1 DITYP("D")="TS"
 . Q
 S:'DITYP DITYP=4
DTYPQ S $P(DPP(DJ),U,10)=DITYP Q
 ;
Q K DITYP,DIERR,DIR S:$D(DTOUT) X="^" G Q^DIP
 ;
PAR S M=$P($P($P($P(DPP(DJ),U,5),";P",2),";",1),"-",M)
 I M]"",M?.ANP S DIPA($E(M,1,30))=Y
 Q
 ;
Z I %="FR" S X=$S($D(FR)#2:$P(FR,C,DJ),$D(FR(DJ))#2:FR(DJ),1:"?")
 I %="TO" S X=$S($D(TO)#2:$P(TO,C,DJ),$D(TO(DJ))#2:TO(DJ),1:"?")
 I X'="?" S DIFRTO=""
 Q
 ;
STXT(DJ,F,T,DITYP) ;DETERMINE IF USER WANTS TO SORT FREE-TEXT FIELDS CONTAINING NUMBERS AS TEXT.
 K DPP(DJ,"SRTTXT") Q:"3,4"'[DITYP
 N F2,T2 S F2=$P(F,U,2),T2=$P(T,U,2)
 I F2]"" Q:F2=T2  Q:($E(F2,1)?1A)&($E(T2,1)?1A)  I F2?1.N.1".".N,T2?1.N.1".".N Q:+F2'=F2&(+T2'=T2)
 I $P($G(DPP(DJ)),U,5)[";TXT" S DPP(DJ,"SRTTXT")="SORT" G N2
 Q:+$E(F2,"E")=F2&(+$E(T2,"E")=T2)
 I F2?1.N.1".".N,+F2'=F2 S DPP(DJ,"SRTTXT")="RANGE"
 I T2?1.N.1".".N,+T2'=T2 S DPP(DJ,"SRTTXT")="RANGE"
N2 Q:'$D(DPP(DJ,"SRTTXT"))
 K DPP(DJ,"IX"),DPP(DJ,"PTRIX")
 I F]"",$P(F,U)'="?z",$G(DPP(DJ,"F"))]"" N Y D  S DPP(DJ,"F")=Y_U_$P(F,U,2,3)
 . S Y=$P(F,U) I F2]"" S Y=" "_F2 D FRV
 . Q
 Q:$G(DPP(DJ,"T"))=""!("@"[$P(T,U))
 S DPP(DJ,"T")=$S($P(T,U,2)]"":" "_$P(T,U,2)_U_$P(T,U,2,3),1:T) Q
